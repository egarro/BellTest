//
//  LoginWireframe.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class LoginWireframe {
    var rootWireframe: RootWireframe?
    var loginViewController: LoginViewController?
    var loginPresenter: LoginPresenter?
    
    var listsWireframe: ListsWireframe?
    
    func presentLoginInterfaceFromWindow(_ window: UIWindow) {
        let loginVC = instantiateLoginController()
        rootWireframe?.makeAndShowRoot(loginVC, in: window)
    }
    
    func instantiateLoginController() -> LoginViewController {
        loginViewController = LoginViewController()
        return loginViewController!
    }
    
    func presentPlaylistsInterface(with configuration: ListsViewControllerConfig) {
        listsWireframe?.presentPlaylistInterfaceFrom(viewController: loginViewController!, with: configuration)
    }
    
    func displayLoginError(message: String) {
        loginViewController?.displayError(message: "Cannot login: \(message)")
    }
}
