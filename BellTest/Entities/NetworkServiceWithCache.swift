//
//  NetworkServiceWithCache.swift
//  BellTest
//
//  Created by Esteban on 2020-02-05.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import CoreData
import GoogleAPIClientForREST

typealias Networker = NSObject & PlaylistsFetcher & PlaylistFetcher & AuthenticationReceiver & VideoSearcher

let playlistsStorageKey = "playlists.etag"
let playlistStorageKeyPrefix = "playlist.etag."
let searchStorageKeyPrefix = "search.etag."

class NetworkServiceWithCache: Networker {    
    let decorated:Networker
    let db: DataBaseHandler
    let decoder = JSONDecoder()
    let dateHelper: DateAndDownloadChecker
    
    init(decorated:Networker,
         databaseHandler: DataBaseHandler,
         dateHelper: DateAndDownloadChecker = DateHelper.defaultHelper) {
        self.decorated = decorated
        self.db = databaseHandler
        self.dateHelper = dateHelper
    }

    func fetchPlaylists(etag: String? = nil, completion: @escaping PlaylistsClosure) {
            let headerValue = db.getValue(for: playlistsStorageKey)
            self.decorated.fetchPlaylists(etag: headerValue, completion: { [weak self] (result) in
                guard let `self` = self else { return }
                guard case .failure(let error) = result else {
                //Handle success here:
                    _ = result.map({ [weak self] (playlists) in
                            guard let `self` = self else { return }
                            self.db.createPlaylistsDBRecord(for: playlists, with: playlistsStorageKey)
                        })
                    completion(result)
                    return
                }
                // Handle errors here:
                if case error = NetworkError.unchangedRecordUseCache {
                    if let playlists = self.db.findPlaylists(with: playlistsStorageKey) {
                        completion(.success(playlists))
                    } else {
                        print("Can't find or decode Playlists even though etag found?!")
                        completion(.failure(.undecodableETag))
                    }
                   return
                }
                completion(result)
            })
    }
    
    func fetchPlaylist(id: String, completion: @escaping PlaylistClosure) {
        let cacheTableID = playlistStorageKeyPrefix + id
        let lastDownloaded = db.getValue(for: cacheTableID)
        if let lastDate = lastDownloaded,
            !dateHelper.shouldDownloadResource(lastStoredDate: lastDate) {
                //Use the cache:
                if let playlist = self.db.findPlaylist(with: cacheTableID) {
                    completion(.success(playlist))
                } else {
                    print("Can't find or decode Playlists even though etag found?!")
                    completion(.failure(.undecodableETag))
                }
                return
        }
        
        //Download and store:
        self.decorated.fetchPlaylist(id: id, completion: { [weak self] (result) in
            guard case .success(let playlist) = result else {
                //Propagate errors here:
                print("Error fetching playlist")
                completion(result)
                return
            }
            //Handle success here:
            if lastDownloaded != nil {
                self?.db.updatePlaylistDBRecord(with: playlist, for: cacheTableID)
            } else {
                self?.db.createPlaylistDBRecord(for: playlist, with: cacheTableID, withEtag: false)
            }
            completion(result)
        })
    }
    
    func searchVideo(etag: String? = nil,
                     queryString: String,
                     pageString: String,
                     completion: @escaping PlaylistClosure) {
        let cacheTableID = searchStorageKeyPrefix + queryString + "." + pageString
        let headerValue = db.getValue(for: cacheTableID)
        
        self.decorated.searchVideo(etag: headerValue,
                                   queryString: queryString,
                                   pageString: pageString,
                                   completion: { [weak self] (result) in
                        guard let `self` = self else { return }
                        guard case .failure(let error) = result else {
                        //Handle success here:
                            _ = result.map({ [weak self] (playlist) in
                                    guard let `self` = self else { return }
                                    self.db.createPlaylistDBRecord(for: playlist, with: cacheTableID, withEtag: true)
                                })
                            completion(result)
                            return
                        }
                        // Handle errors here:
                        if case error = NetworkError.unchangedRecordUseCache {
                            if let playlist = self.db.findPlaylist(with: cacheTableID) {
                                completion(.success(playlist))
                            } else {
                                print("Can't find or decode Playlists even though etag found?!")
                                completion(.failure(.undecodableETag))
                            }
                           return
                        }
                        completion(result)
        })
    }
    
    func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol?) {
        self.decorated.setAuthorizer(authorizer: authorizer)
    }
}
