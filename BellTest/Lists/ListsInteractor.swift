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
        networkService.fetchPlaylist(id: id, completion: { [weak self] (playlist) in
            self?.playlistLoader.loadPlaylist(playlist: playlist)
            completion(playlist)
        })
    }
    
    func fetchPlaylists(completion: @escaping PlaylistsClosure) {
        networkService.fetchPlaylists(completion: completion)
    }
}
