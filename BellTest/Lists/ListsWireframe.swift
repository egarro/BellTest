//
//  ListsWireframe.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class ListsWireframe: NSObject, UIViewControllerTransitioningDelegate {
    var rootWireframe: RootWireframe?
    var listsViewController: ListsViewController!
    
    var loginViewController: LoginViewController!
    var listsPresenter: ListsPresenter?
    var presentedViewController : UIViewController?
    
    var listDetailWireframe: ListDetailWireframe?
    var searchWireframe: SearchWireframe?
    
    func presentPlaylistInterfaceFromWindow(_ window: UIWindow, with configuration: ListsViewControllerConfig) {
        listsViewController = ListsViewController(config: configuration)
        listsViewController?.eventHandler = listsPresenter
        rootWireframe?.makeAndShowRoot(listsViewController!, in: window)
    }
    
    func presentPlaylistInterfaceFrom(viewController: UIViewController, with configuration: ListsViewControllerConfig) {
        listsViewController = ListsViewController(config: configuration)
        listsViewController.eventHandler = listsPresenter
        listsViewController.modalPresentationStyle = .custom
        listsViewController.transitioningDelegate = self
        
        viewController.present(listsViewController, animated: true, completion: nil)
        
        presentedViewController = listsViewController
    }
    
    func presentAll(playlists: Playlists) {
        listsViewController.update(with: playlists)
    }
    
    func presentSearchInterface() {
        searchWireframe?.presentSearchInterfaceFrom(viewController: listsViewController!)
    }
        
    func presentPlaylistDetailInterface(for playlist:Playlist, and info: PlaylistInfo) {
        listDetailWireframe?.presentPlaylistDetailInterfaceFrom(viewController: listsViewController!,
                                                                for: playlist,
                                                                and: info)
    }
        
    func dismissPlaylistsInterface() {
        //No presented controller. Requires Login root:
        guard let presentedController = presentedViewController else {
            rootWireframe?.replaceRootWith(loginViewController)
            return
        }
        presentedController.dismiss(animated: true, completion: nil)
    }
    
// MARK: UIViewControllerTransitioningDelegate methods

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePushAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePopAnimator(type: .modal)
    }
}
