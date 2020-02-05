//
//  AppDelegate.swift
//  BellTest
//
//  Created by Esteban on 2020-01-15.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var mainWindow: UIWindow!
    
    let appDependencies = AppDependencies()

    func application(_ application: UIApplication,
                        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        

        mainWindow = UIWindow(frame: UIScreen.main.bounds)
        appDependencies.installRootViewControllerIntoWindow(mainWindow)
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }    
}

