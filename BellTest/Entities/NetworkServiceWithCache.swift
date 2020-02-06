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
    
    let decorated:Networker
    let db: DatabaseHandler
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
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
                            self?.createDBRecordFor(playlists)
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
                        print("Can't find or decode Playlists eventhough etag found?!")
                        completion(.failure(.undecodableETag))
                   }
                   return
                }
                completion(result)
            })
    }
    
    func fetchPlaylist(id: String, completion: @escaping PlaylistClosure) {
        self.decorated.fetchPlaylist(id: id, completion: completion)
    }
    
    func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol?) {
        self.decorated.setAuthorizer(authorizer: authorizer)
    }
    
    func searchVideo(queryString: String, pageString: String, completion: @escaping PlaylistClosure) {
        self.decorated.searchVideo(queryString: queryString, pageString: pageString, completion: completion)
    }
    
    private func checkETagValueForKey(string: String) -> String? {
        let query = NSPredicate(format: "key == %@", string)
        return self.db.query(ETag.self, search: query).first?.headerValue
    }
    
    private func createDBRecordFor(_ playlists: Playlists) {
        let data = try? self.encoder.encode(playlists)
        let blob = self.db.addRecord(Blob.self)
        blob.data = data
        let new = self.db.addRecord(ETag.self)
        new.key = playlistsStorageKey
        new.headerValue = playlists.etag
        new.relationship = blob
    }
}
