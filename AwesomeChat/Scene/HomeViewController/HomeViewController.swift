//
//  HomeViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 2/8/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        authenticateUser()
    }
    
    private func presentSignInViewController() {
        let vc = SignInViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: true)
        self.present(navController, animated: true)
    }
    
    private func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.presentSignInViewController()
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            DispatchQueue.main.async {
                self.presentSignInViewController()
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
