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
        listsInteractor.fetchPlaylist(id: info.identifier, completion: { [weak self] (playlist) in
            self?.listsWireFrame?.listsViewController.stopFetchingResults()
            self?.listsWireFrame?.presentPlaylistDetailInterface(for: playlist, and: info)
        })
    }
    
    func didTapOnSearch() {
        listsWireFrame?.presentSearchInterface()
    }
    
    func requestAllPlaylists() {
        listsInteractor.fetchPlaylists(completion: { [weak self] (playlists) in
            self?.listsWireFrame?.presentAll(playlists: playlists)
        })
    }
}

