//
//  SearchPresenter.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol SearchEventHandler {
    func didTapOnBack()
    func didTapOnPlay(for videoID: String)
    func didUpdateSearchTerm(query: String, pageToken: String)
}

class SearchPresenter: SearchEventHandler {
    weak var searchWireFrame: SearchWireframe?
    var searchInteractor: SearchInteractor
    var converter = PlaylistConverter()
    
    init(wireFrame: SearchWireframe, interactor: SearchInteractor) {
        self.searchWireFrame = wireFrame
        self.searchInteractor = interactor
    }
    
    func didTapOnBack() {
        searchWireFrame?.dismissSearchInterface()
    }
    
    func didTapOnPlay(for videoID: String) {
        searchWireFrame?.presentPlayerInterface(for: videoID)
    }
    
    func didUpdateSearchTerm(query: String, pageToken: String) {
        searchInteractor.searchVideo(queryString: query, pageString: pageToken, completion: { [weak self] (result) in
            if case .success(let playlist) = result {
                let videos = self?.converter.convert(playlist: playlist) ?? []
                self?.searchWireFrame?.presentSearchResults(videos: videos, nextPageToken: playlist.nextPage)
            }
        })
    }
}

