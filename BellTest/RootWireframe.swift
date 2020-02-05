//
//  RootWireframe.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class RootWireframe {
    var rootVC: UIViewController!
    var mainWindow: UIWindow?
    
    func makeAndShowRoot(_ viewController: UIViewController, in window: UIWindow) {
        mainWindow = window
        rootVC = viewController
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }
    
    func replaceRootWith(_ viewController: UIViewController) {
        rootVC = viewController
        mainWindow?.rootViewController = rootVC
        mainWindow?.makeKeyAndVisible()
    }
}

