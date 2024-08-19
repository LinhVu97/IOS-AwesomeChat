//
//  TabbarViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 19/8/24.
//

import UIKit

protocol TabbarViewControllerDelegate: AnyObject {
    func didSelectTab(at index: Int)
}

class TabbarViewController: UIViewController {
    @IBOutlet weak var tabbar: UITabBar!
    
    var tabbarDelegate: TabbarViewControllerDelegate?
    
    var messageViewControler = MessageViewController()
    var friendViewController = FriendViewController()
    var personViewController = PersonViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        tabbar.clipsToBounds = true
        tabbar.delegate = self
        tabbar.layer.masksToBounds = true
        tabbar.layer.cornerRadius = 12
        tabbar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        if let firstVC = tabbar.items?.first {
            tabbar.selectedItem = firstVC
        }
    }
}

extension TabbarViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabbarDelegate?.didSelectTab(at: item.tag)
    }
}
