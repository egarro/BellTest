//
//  ListDetailInteractor.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol ListDetailInteractorInput {
    func moveListTo(videoID: String)
}

class ListDetailInteractor: ListDetailInteractorInput {
    var playlistLoader: PlaylistLoader
    
    init(playlistLoader: PlaylistLoader) {
        self.playlistLoader = playlistLoader
    }
       
    func moveListTo(videoID: String) {
        self.playlistLoader.setCurrentVideo(id: videoID)
    }
}
