//
//  ListsInteractor.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

typealias ListsInteractorService = PlaylistsFetcher & PlaylistFetcher

class ListsInteractor: ListsInteractorService {
    var logoutAgent: LogoutAgent
    var networkService: ListsInteractorService
    var playlistLoader: PlaylistLoader
    
    init(logoutAgent: LogoutAgent,
         networkService: ListsInteractorService,
         playlistLoader: PlaylistLoader) {
        self.logoutAgent = logoutAgent
        self.networkService = networkService
        self.playlistLoader = playlistLoader
    }
    
    func logout() {
        logoutAgent.logoutUser()
    }
    
    func fetchPlaylist(id: String, completion: @escaping PlaylistClosure) {
        networkService.fetchPlaylist(id: id, completion: { [weak self] (result) in
            if case .success(let playlist) = result {
                self?.playlistLoader.loadPlaylist(playlist: playlist)
            }
            completion(result)
        })
    }
    
    func fetchPlaylists(etag: String? = nil, completion: @escaping PlaylistsClosure) {
        networkService.fetchPlaylists(etag: etag, completion: completion)
    }
}
