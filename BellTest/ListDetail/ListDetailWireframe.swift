//
//  ListDetailWireframe.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

protocol ListDetailWireframeInterface: class {
    func dismissPlaylistDetailInterface()
    func presentPlayerInterface(for: String)
}

class ListDetailWireframe: NSObject, ListDetailWireframeInterface {
    var listDetailViewController: ListDetailViewController!
    var listDetailPresenter: ListDetailPresenter?
    var presentedViewController : UIViewController?
    
    var playerWireframe: PlayerWireframe?
    
    func presentPlaylistDetailInterfaceFrom(viewController: UIViewController,
                                            for playlist:Playlist,
                                            and info:PlaylistInfo) {
        let config = ListDetailViewControllerConfig(playlist: playlist, info: info)
        listDetailViewController = ListDetailViewController(config: config)
        listDetailViewController.eventHandler = listDetailPresenter
        listDetailViewController.modalPresentationStyle = .popover
        
        viewController.present(listDetailViewController, animated: true, completion: nil)
        
        presentedViewController = listDetailViewController
    }
    
    func presentPlayerInterface(for videoID:String) {
        playerWireframe?.presentPlayerInterfaceFrom(viewController: listDetailViewController,
                                                    for: videoID,
                                                    hidingButtons: false)
    }
    
    func dismissPlaylistDetailInterface() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }    
}


