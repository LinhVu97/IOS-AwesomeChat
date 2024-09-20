//
//  AddMessageViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 13/9/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AddMessageViewControllerDelegate {
    func didCreateConversation()
}

class AddMessageViewController: UIViewController {
    @IBOutlet weak var searchFriendTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let cell = AddMessageTableViewCell.self
    var friends: [UserFriend] = []
    var delegate: AddMessageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        searchFriendTextField.setupLeftSideImage(imageName: "seach-icon")
        searchFriendTextField.clipsToBounds = true
        searchFriendTextField.layer.cornerRadius = 15
        searchFriendTextField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 30
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.regsiterCell(ofType: cell)
        
        parseUser()
    }
    
    private func parseUser() {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        if let imageProfile = data["profileImageUrl"] as? String,
                           let username = data["username"] as? String,
                           let email = data["email"] as? String {
                            let uid = document.documentID
                            
                            if uid == Auth.auth().currentUser?.uid {
                                continue
                            }
                            
                            let user = UserFriend(uid: uid, username: username, email: email, imageProfile: imageProfile)
                            self.friends.append(user)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    @IBAction func backViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddMessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.convertToString(cell), for: indexPath) as! AddMessageTableViewCell
        let friend = friends[indexPath.row]
        cell.bindingData(userFriend: friend)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List Friend"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = friends[indexPath.row]
        
        FirebaseManager.shared.createConservation(participantId: selectedFriend.uid) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let conversationId):
                AlertManager.shared.baseAlert(vc: self, title: "Conversation Created", message: "Conversation created Successfully", buttonTitle: "OK") {
                    self.delegate?.didCreateConversation()
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
