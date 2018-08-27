//
//  AppDelegate.swift
//  TotoShow
//
//  Created by Davi Cabral on 16/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TotoShowViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

