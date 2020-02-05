//
//  SearchWireframe.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class SearchWireframe: NSObject {
    var searchViewController: SearchViewController!
    var searchPresenter: SearchPresenter?
    var presentedViewController : UIViewController?
    
    var playerWireframe: PlayerWireframe?
        
    func presentSearchInterfaceFrom(viewController: UIViewController) {
        searchViewController = SearchViewController()
        searchViewController.eventHandler = searchPresenter
        searchViewController.modalPresentationStyle = .popover
        
        viewController.present(searchViewController, animated: true, completion: nil)
        
        presentedViewController = searchViewController
    }
    
    func presentSearchResults(videos:[Video], nextPageToken: String) {
        searchViewController.update(videos: videos, nextPage: nextPageToken)
    }
    
    func presentPlayerInterface(for videoId:String) {
        playerWireframe?.presentPlayerInterfaceFrom(viewController: searchViewController,
                                                    for: videoId,
                                                    hidingButtons: true)
    }
    
    func dismissSearchInterface() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
