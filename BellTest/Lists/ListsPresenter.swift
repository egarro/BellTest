//
//  ListsPresenter.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol ListsEventHandler {
    func didTapOnLogout()
    func didTapOnDisplayDetail(playListInfo: PlaylistInfo)
    func didTapOnSearch()
    func requestAllPlaylists()
}

class ListsPresenter: ListsEventHandler {
    weak var listsWireFrame: ListsWireframe?
    var listsInteractor: ListsInteractor
    
    init(wireFrame: ListsWireframe,
         interactor: ListsInteractor) {
        self.listsWireFrame = wireFrame
        self.listsInteractor = interactor
    }
    
    func didTapOnLogout() {
        listsInteractor.logout()
        listsWireFrame?.dismissPlaylistsInterface()
    }
    
    func didTapOnDisplayDetail(playListInfo info: PlaylistInfo) {
        listsInteractor.fetchPlaylist(id: info.identifier, completion: { [weak self] (result) in
            self?.listsWireFrame?.listsViewController.stopFetchingResults()
            if case .success(let playlist) = result {
                self?.listsWireFrame?.presentPlaylistDetailInterface(for: playlist, and: info)
            }
        })
    }
    
    func didTapOnSearch() {
        listsWireFrame?.presentSearchInterface()
    }
    
    func requestAllPlaylists() {
        listsInteractor.fetchPlaylists(completion: { [weak self] (result) in
            if case .success(let playlists) = result {
                self?.listsWireFrame?.presentAll(playlists: playlists)
            }
        })
    }
}

