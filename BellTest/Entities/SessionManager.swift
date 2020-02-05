//
//  SessionManager.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import GoogleSignIn

typealias VoidClosure = ()->Void
typealias BoolClosure = (Bool)->Void
typealias UserClosure = (User?)->Void
typealias SessionManagerType = GIDSignInDelegate &
                               LoginVerificator &
                               LogoutAgent &
                               LoginPresenterHolder

protocol LoginVerificator {
    func currentLoggedInUser(completion: @escaping UserClosure)
}

protocol LogoutAgent {
    func logoutUser()
}

protocol LoginPresenterHolder {
    var loginPresenter: LoginPresenter? { get set }
}

class SessionManager: NSObject {
    var currentUser: User?
    var loginPresenter: LoginPresenter?
    var observer: AuthenticationReceiver
    
    private var checkClosure: UserClosure?
    private var signOutClosure: VoidClosure?
    
    init(authenticationObserver: AuthenticationReceiver) {
        observer = authenticationObserver
        super.init()
    }
}

extension SessionManager: SessionManagerType {
    func currentLoggedInUser(completion: @escaping UserClosure) {
        checkClosure = completion
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
        
    func logoutUser() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if checkClosure != nil {
                checkClosure?(nil)
                checkClosure = nil
            } else {
                loginPresenter?.loginFailed(with: "\(error.localizedDescription)")
            }
            currentUser = nil
            observer.setAuthorizer(authorizer: nil)
            return
        }
        
        observer.setAuthorizer(authorizer: user.authentication.fetcherAuthorizer())
        
        let localuser = User(id: user.userID,
                             idToken: user.authentication.idToken,
                             name: user.profile.givenName,
                             email: user.profile.email)
        
        if checkClosure != nil {
            checkClosure?(localuser)
            checkClosure = nil
        } else {
            loginPresenter?.loginSucceded(for: localuser)
        }
        currentUser = localuser
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                 withError error: Error!) {
        guard error == nil else {
            print("\(error.localizedDescription)")
            return
        }
        currentUser = nil
    }
}
