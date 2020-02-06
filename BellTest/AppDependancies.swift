//
//  AppDependancies.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class AppDependencies {
    var rootWireframe  = RootWireframe()
    var loginWireframe = LoginWireframe()
    var listsWireframe = ListsWireframe()
    var listDetailWireframe = ListDetailWireframe()
    var searchWireframe = SearchWireframe()
    var playerWireframe = PlayerWireframe()
    var networkService: Networker!
    var sessionManager: SessionManagerType!
    var playlistHandler: PlaylistHandler & PlaylistLoader = InifiniteLoopPlaylistHandler()
    var databaseHandler: DatabaseHandler = DatabaseHandler()
    
    init() {
        let basicNetworker = NetworkService()
        networkService = NetworkServiceNetworkServiceWithCache(decorated: basicNetworker,
                                                               databaseHandler: databaseHandler)
        configureSessionManager()
        configureWireframeDependancies()
        configurePresenterDependancies()
    }
        
    func configureSessionManager() {
        sessionManager = SessionManager(authenticationObserver: networkService)
        GIDSignIn.sharedInstance().clientID = "1009694205174-rdrsndbu0pamvijpqi1eccbff6kcrgr1.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = sessionManager
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeYouTubeReadonly]
    }
    
    // Routing:
    func configureWireframeDependancies() {
        loginWireframe.rootWireframe = rootWireframe
        loginWireframe.listsWireframe = listsWireframe
        
        listsWireframe.rootWireframe = rootWireframe
        listsWireframe.listDetailWireframe = listDetailWireframe
        listsWireframe.searchWireframe = searchWireframe
        
        searchWireframe.playerWireframe = playerWireframe
        
        listDetailWireframe.playerWireframe = playerWireframe
    }

    func configurePresenterDependancies() {        
        // Interactors:
        let listsInteractor = ListsInteractor(logoutAgent: sessionManager,
                                              networkService: networkService,
                                              playlistLoader: playlistHandler)
        let listDetailInteractor = ListDetailInteractor(playlistLoader: playlistHandler)
        let searchInteractor = SearchInteractor(networkService: networkService)
        let playerInteractor = PlayerInteractor(playlistHandler: playlistHandler)
        
        // Presenters:
        let loginPresenter = LoginPresenter(wireFrame: loginWireframe)
        loginWireframe.loginPresenter = loginPresenter
        sessionManager.loginPresenter = loginPresenter
        listsWireframe.listsPresenter = ListsPresenter(wireFrame: listsWireframe,
                                                       interactor: listsInteractor)
        listDetailWireframe.listDetailPresenter = ListDetailPresenter(wireFrame: listDetailWireframe,
                                                                      interactor: listDetailInteractor)
        searchWireframe.searchPresenter = SearchPresenter(wireFrame: searchWireframe,
                                                          interactor: searchInteractor)
        playerWireframe.playerPresenter = PlayerPresenter(wireFrame: playerWireframe,
                                                          interactor: playerInteractor)
    }
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        let checkClosure: UserClosure = { [weak self] (user) in
            guard let googleUser = user else {
                self?.loginWireframe.presentLoginInterfaceFromWindow(window)
                return
            }
            
            let config = ListsViewControllerConfig(user: googleUser)
            self?.listsWireframe.presentPlaylistInterfaceFromWindow(window, with: config)
            //Instantiate a LoginViewController in case you want to logout
            self?.listsWireframe.loginViewController = self?.loginWireframe.instantiateLoginController()
        }
        sessionManager.currentLoggedInUser(completion: checkClosure)
    }
}

