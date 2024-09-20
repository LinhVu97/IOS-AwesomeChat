//
//  MessageViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 19/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class MessageViewController: UIViewController {
    @IBOutlet weak var searchMessage: UITextField!
    @IBOutlet weak var allMessage: UITableView!
    
    let cell = AllMessageTableViewCell.self
    var conversations: [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchConversations()
    }
    
    private func setupView() {
        searchMessage.setupLeftSideImage(imageName: "seach-icon")
        searchMessage.clipsToBounds = true
        searchMessage.layer.cornerRadius = 15
        searchMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        allMessage.clipsToBounds = true
        allMessage.layer.cornerRadius = 30
        allMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        allMessage.delegate = self
        allMessage.dataSource = self
        allMessage.regsiterCell(ofType: cell)
    }
    
    private func fetchConversations() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        FirebaseManager.shared.fetchConversations(userId: currentUserId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let conversations):
                self.conversations = conversations
                self.allMessage.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addMessage(_ sender: Any) {
        let vc = AddMessageViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allMessage.dequeueReusableCell(withIdentifier: String.convertToString(cell), for: indexPath) as! AllMessageTableViewCell
        let conversation = conversations[indexPath.row]
        cell.bindingData(conversation: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = conversations[indexPath.row]
        let vc = ConversationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessageViewController: AddMessageViewControllerDelegate {
    func didCreateConversation() {
        fetchConversations()
    }
}
