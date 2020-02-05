//
//  LoginPresenter.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation

protocol LoginEventHandler {
    func loginSucceded(for user:User)
    func loginFailed(with error:String)
}

class LoginPresenter: LoginEventHandler {
    weak var loginWireFrame: LoginWireframe?
    
    init(wireFrame: LoginWireframe) {
        self.loginWireFrame = wireFrame
    }
    
    func loginSucceded(for user:User) {
        let config = ListsViewControllerConfig(user: user)
        loginWireFrame?.presentPlaylistsInterface(with: config)
    }
    
    func loginFailed(with error:String) {
        loginWireFrame?.displayLoginError(message: error)
    }
}
