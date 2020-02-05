//
//  PlayerWireframe.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class PlayerWireframe: NSObject, UIViewControllerTransitioningDelegate {
    var playerViewController: PlayerViewController!
    var playerPresenter: PlayerPresenter?
    var presentedViewController : UIViewController?
        
    func presentPlayerInterfaceFrom(viewController: UIViewController,
                                    for videoID:String,
                                    hidingButtons: Bool = false) {
        let config = PlayerViewControllerConfig(shouldHidePlaylistControls: hidingButtons,
                                                videoID: videoID)
        playerViewController = PlayerViewController(config: config)
        playerViewController.eventHandler = playerPresenter
        playerViewController.modalPresentationStyle = .custom
        playerViewController.transitioningDelegate = self
        
        viewController.present(playerViewController, animated: true, completion: nil)
        
        presentedViewController = playerViewController
    }
    
    func dismissPlayerInterface() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func play(videoId: String) {
        playerViewController.play(videoId)
    }
        
// MARK: UIViewControllerTransitioningDelegate methods

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePushAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePopAnimator(type: .modal)
    }
}
