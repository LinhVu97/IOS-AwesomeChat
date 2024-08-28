//
//  FriendViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 19/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FriendViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var listFriendButton: UIButton!
    @IBOutlet weak var allFriendButton: UIButton!
    @IBOutlet weak var friendRequestButton: UIButton!
    @IBOutlet weak var listFriendView: UIView!
    @IBOutlet weak var allFriendView: UIView!
    @IBOutlet weak var friendRequestView: UIView!
    @IBOutlet weak var scrollViewFriend: UIScrollView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var searchFriend: UITextField!
    
    let listFriendViewController = ListFriendViewController()
    let allFriendViewController = AllFriendViewController()
    let friendRequestViewController = RequestFriendViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        scrollViewFriend.delegate = self
        
        searchFriend.setupLeftSideImage(imageName: "seach-icon")
        searchFriend.clipsToBounds = true
        searchFriend.layer.cornerRadius = 15
        searchFriend.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        addViewController(listFriendViewController, listFriendView)
        addViewController(allFriendViewController, allFriendView)
        addViewController(friendRequestViewController, friendRequestView)
        
        fetchUser()
    }
    
    private func fetchUser() {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        if let email = data["email"] as? String,
                           let username = data["username"] as? String,
                           let imageProfile = data["profileImageUrl"] as? String {
                            let uid = document.documentID
                            
                            if uid == Auth.auth().currentUser?.uid {
                                continue
                            }
                            
                            let user = UserFriend(uid: uid, username: username, email: email, imageProfile: imageProfile)
                            self.allFriendViewController.usersFriend.append(user)
                        }
                    }
                    self.allFriendViewController.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func listFriendAction(_ sender: Any) {
        scrollViewFriend.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func allFriendAction(_ sender: Any) {
        scrollViewFriend.setContentOffset(CGPoint(x: scrollViewFriend.frame.width, y: scrollViewFriend.contentOffset.y), animated: true)
    }
    
    @IBAction func friendRequestAction(_ sender: Any) {
        scrollViewFriend.setContentOffset(CGPoint(x: scrollViewFriend.frame.width * 2, y: scrollViewFriend.contentOffset.y), animated: true)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        print("Add Friend")
    }
}

extension FriendViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let buttonWidth = listFriendButton.frame.width
        
        let pageWidth = scrollView.frame.width
        let currentPage = scrollView.contentOffset.x / pageWidth
        
        indicatorView.frame.origin.x = currentPage * buttonWidth + 10
        
        let blueColor = UIColor(named: "blueColor")
        let grayColor = UIColor(named: "grayColor")
        
        let offset = scrollView.contentOffset.x / pageWidth
        if offset == 2 {
            listFriendButton.titleLabel?.textColor = grayColor
            allFriendButton.titleLabel?.textColor = grayColor
            friendRequestButton.titleLabel?.textColor = blueColor
        } else if offset == 1 {
            listFriendButton.titleLabel?.textColor = grayColor
            allFriendButton.titleLabel?.textColor = blueColor
            friendRequestButton.titleLabel?.textColor = grayColor
        } else if offset == 0 {
            listFriendButton.titleLabel?.textColor = blueColor
            allFriendButton.titleLabel?.textColor = grayColor
            friendRequestButton.titleLabel?.textColor = grayColor
        }
    }
}
