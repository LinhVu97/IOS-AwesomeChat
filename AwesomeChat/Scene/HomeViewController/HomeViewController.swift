//
//  HomeViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 2/8/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var tabbarViewController = TabbarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupView() {
        authenticateUser()
        
        addViewController(tabbarViewController, tabbarView)
        tabbarViewController.tabbarDelegate = self
        
        switchToViewController(tabbarViewController.messageViewControler)
        
        if let personVC = tabbarViewController.personViewController as? PersonViewController {
            personVC.delegate = self
        }
    }
    
    private func switchToViewController(_ vc: UIViewController) {
        for child in children where child != tabbarViewController {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        addViewController(vc, containerView)
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
}

extension HomeViewController: TabbarViewControllerDelegate {
    func didSelectTab(at index: Int) {
        switch index {
        case 0:
            switchToViewController(tabbarViewController.messageViewControler)
        case 1:
            switchToViewController(tabbarViewController.friendViewController)
        case 2:
            switchToViewController(tabbarViewController.personViewController)
        default:
            break
        }
    }
}

extension HomeViewController: PersonViewControllerDelegate {
    func didLogout() {
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
