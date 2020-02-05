//
//  PlayerPresenter.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol PlayerEventHandler {
    func didTapOnDismiss()
    func didTapOnPrevious()
    func didTapOnNext()
}

class PlayerPresenter: PlayerEventHandler {
    weak var playerWireFrame: PlayerWireframe?
    var playerInteractor: PlayerInteractor
    
    init(wireFrame: PlayerWireframe, interactor: PlayerInteractor) {
        self.playerWireFrame = wireFrame
        self.playerInteractor = interactor
    }
    
    func didTapOnDismiss() {
        playerWireFrame?.dismissPlayerInterface()
    }
    
    func didTapOnPrevious() {
        let previousItem = playerInteractor.getPrevious()
        playerWireFrame?.play(videoId: previousItem)
    }
    
    func didTapOnNext() {
        let nextItem = playerInteractor.getNext()
        playerWireFrame?.play(videoId: nextItem)
    }
}

