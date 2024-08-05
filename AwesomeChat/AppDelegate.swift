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
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        updateRootViewController()
        
        authStateListenerHandle = Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            self?.updateRootViewController()
        })
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func updateRootViewController() {
        let rootViewController: UIViewController
        
        if Auth.auth().currentUser != nil {
            rootViewController = HomeViewController()
        } else {
            rootViewController = SignInViewController()
        }
        
        window?.rootViewController = rootViewController
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

