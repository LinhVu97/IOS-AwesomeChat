//
//  AppDelegate.swift
//  AwesomeChat
//
//  Created by Linh Vu on 31/7/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navController = UINavigationController(rootViewController: HomeViewController())
        navController.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = navController
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

