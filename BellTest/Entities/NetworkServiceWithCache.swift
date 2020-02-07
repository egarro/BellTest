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

class NetworkServiceNetworkServiceWithCache: Networker {
    let playlistsStorageKey = "playlists.etag"
    let playlistStorageKeyPrefix = "playlist.etag."
    let searchStorageKeyPrefix = "search.etag."
    
    let decorated:Networker
    let db: DatabaseHandler
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let dateHelper = DateHelper()
    
    init(decorated:Networker, databaseHandler: DatabaseHandler) {
        self.decorated = decorated
        self.db = databaseHandler
    }

    func fetchPlaylists(etag: String? = nil, completion: @escaping PlaylistsClosure) {
            let headerValue = checkETagValueForKey(string: playlistsStorageKey)
            self.decorated.fetchPlaylists(etag: headerValue, completion: { [weak self] (result) in
                guard let `self` = self else { return }
                guard case .failure(let error) = result else {
                //Handle success here:
                    _ = result.map({ [weak self] (playlists) in
                            guard let `self` = self else { return }
                            self.createPlaylistsDBRecord(for: playlists, with: self.playlistsStorageKey)
                        })
                    completion(result)
                    return
                }
                // Handle errors here:
                if case error = NetworkError.unchangedRecordUseCache {
                    let query = NSPredicate(format: "key == %@", self.playlistsStorageKey)
                   if let obj = self.db.query(ETag.self, search: query).first,
                      let data = obj.relationship?.data,
                      let playlists = try? self.decoder.decode(Playlists.self, from: data) {
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
        let lastDownloaded = checkETagValueForKey(string: cacheTableID)
        if let lastDate = lastDownloaded,
            !dateHelper.shouldDownloadResource(lastStoredDate: lastDate) {
            //Use the cache:
            let query = NSPredicate(format: "key == %@", cacheTableID)
            if let obj = self.db.query(ETag.self, search: query).first,
               let data = obj.relationship?.data,
               let playlist = try? self.decoder.decode(Playlist.self, from: data) {
                 completion(.success(playlist))
            } else {
                 print("Can't find or decode Playlist even though etag found?!")
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
                self?.updatePlaylistDBRecord(with: playlist, for: cacheTableID)
            } else {
                self?.createPlaylistDBRecord(for: playlist, with: cacheTableID, withEtag: false)
            }
            completion(result)
        })
    }
    
    func searchVideo(etag: String? = nil,
                     queryString: String,
                     pageString: String,
                     completion: @escaping PlaylistClosure) {
        let cacheTableID = searchStorageKeyPrefix + queryString + "." + pageString
        let headerValue = checkETagValueForKey(string: cacheTableID)
        
        self.decorated.searchVideo(etag: headerValue,
                                   queryString: queryString,
                                   pageString: pageString,
                                   completion: { [weak self] (result) in
                        guard let `self` = self else { return }
                        guard case .failure(let error) = result else {
                        //Handle success here:
                            _ = result.map({ [weak self] (playlist) in
                                    guard let `self` = self else { return }
                                    self.createPlaylistDBRecord(for: playlist, with: cacheTableID, withEtag: true)
                                })
                            completion(result)
                            return
                        }
                        // Handle errors here:
                        if case error = NetworkError.unchangedRecordUseCache {
                            let query = NSPredicate(format: "key == %@", cacheTableID)
                           if let obj = self.db.query(ETag.self, search: query).first,
                              let data = obj.relationship?.data,
                              let playlist = try? self.decoder.decode(Playlist.self, from: data) {
                                completion(.success(playlist))
                           } else {
                                print("Can't find or decode search Playlist even though etag found?!")
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
    
    private func checkETagValueForKey(string: String) -> String? {
        let query = NSPredicate(format: "key == %@", string)
        return self.db.query(ETag.self, search: query).first?.headerValue
    }
    
//Cache based on ETags:
    private func createPlaylistsDBRecord(for record: Playlists, with tableId: String) {
        let data = try? encoder.encode(record)
        let blob = db.addRecord(Blob.self)
        blob.data = data
        let new = db.addRecord(ETag.self)
        new.key = tableId
        new.headerValue = record.etag
        new.relationship = blob

        db.saveDatabase()
    }
    
//Cache based on downloaded date:
    private func createPlaylistDBRecord(for record: Playlist, with tableId: String, withEtag: Bool) {
        let data = try? encoder.encode(record)
        let blob = db.addRecord(Blob.self)
        blob.data = data
        let new = db.addRecord(ETag.self)
        new.key = tableId
        new.headerValue = withEtag ? record.etag : dateHelper.dateString()
        new.relationship = blob

        db.saveDatabase()
    }
//Update existing record with new information:
    private func updatePlaylistDBRecord(with newPlaylist: Playlist, for tableId: String) {
        let query = NSPredicate(format: "key == %@", tableId)
        if let obj = db.query(ETag.self, search: query).first,
            let oldBlob = obj.relationship {
                let newData = try? encoder.encode(newPlaylist)
                obj.headerValue = dateHelper.dateString()
                oldBlob.data = newData
            
                db.saveDatabase()
        }
    }
}
