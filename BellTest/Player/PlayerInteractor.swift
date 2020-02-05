//
//  PlayerInteractor.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol PlaylistHandler {
    func getPrevious() -> String
    func getNext() -> String
}

class PlayerInteractor {
    var playlistHandler: PlaylistHandler
    
    init(playlistHandler: PlaylistHandler) {
        self.playlistHandler = playlistHandler
    }
    
    func getPrevious() -> String {
        return playlistHandler.getPrevious()
    }
    
    func getNext() -> String {
        return playlistHandler.getNext()
    }
}
