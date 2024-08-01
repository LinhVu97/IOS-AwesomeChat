//
//  AppDelegate.swift
//  AwesomeChat
//
//  Created by Linh Vu on 31/7/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = SignInViewController()
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
        
        return true
    }

}

