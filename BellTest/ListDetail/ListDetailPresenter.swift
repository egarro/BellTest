//
//  ListDetailPresenter.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol ListDetailEventHandler {
    func didTapOnBack()
    func didTapOnPlay(for videoID:String)
}

class ListDetailPresenter: ListDetailEventHandler {
    weak var listDetailWireFrame: ListDetailWireframe?
    var listDetailInteractor: ListDetailInteractor
    
    init(wireFrame: ListDetailWireframe,
         interactor: ListDetailInteractor) {
        self.listDetailWireFrame = wireFrame
        self.listDetailInteractor = interactor
    }
    
    func didTapOnBack() {
        listDetailWireFrame?.dismissPlaylistDetailInterface()
    }
    
    func didTapOnPlay(for videoID:String) {
        listDetailInteractor.moveListTo(videoID: videoID)
        listDetailWireFrame?.presentPlayerInterface(for: videoID)
    }
}
