//
//  ConversationViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 17/9/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ConversationViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var chooseImageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let conversationCell = ConversationTableViewCell.self
    
    var conversationData: Conversation?
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchMessages()
    }
    
    private func setupView() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor(named: "blueColor")?.cgColor
        
        conversationTableView.regsiterCell(ofType: conversationCell)
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        
        setupData()
    }
    
    private func setupData() {
        guard let conversationData = conversationData else { return }
        
        if let url = URL(string: conversationData.participantImageProfile) {
            profileImage.loadImage(url: url)
        }
        
        username.text = conversationData.participantUsername
    }
    
    private func fetchMessages() {
        guard let conversationData = conversationData else { return }
        
        Firestore.firestore().collection("conversations")
            .document(conversationData.conversationId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self.messages = documents.compactMap({ document -> Message? in
                    let data = document.data()
                    guard let messageId = data["messageId"] as? String,
                          let senderId = data["senderId"] as? String,
                          let recipientId = data["recipientId"] as? String,
                          let content = data["content"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp,
                          let messageTypeString = data["messageType"] as? String,
                          let messageType = MessageType(rawValue: messageTypeString) else {
                        return nil
                    }
                    
                    return Message(messageId: messageId,
                                   senderId: senderId,
                                   recipientId: recipientId,
                                   content: content,
                                   timestamp: timestamp.dateValue(),
                                   messageType: messageType)
                })
                
                self.conversationTableView.reloadData()
                if self.messages.count > 0 {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.conversationTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let messageText = messageTextField.text, !messageText.isEmpty else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let conversationData = conversationData else { return }
        
        let conversationId = conversationData.conversationId
        
        let participants = conversationData.participants
        let recipientId = participants.first(where: { $0 != currentUserId })
        
        let messageID = UUID().uuidString
        let timestamp = Date()
        let messageData: [String: Any] = [
            "messageId": messageID,
            "senderId": currentUserId,
            "recipientId": recipientId,
            "content": messageText,
            "timestamp": Timestamp(date: timestamp),
            "messageType": MessageType.text.rawValue
        ]
        
        Firestore.firestore().collection("conversations")
            .document(conversationId)
            .collection("messages")
            .document(messageID)
            .setData(messageData) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let updateConversation: [String: Any] = [
                        "lastMessage": messageText,
                        "timestamp": Timestamp(date: timestamp)
                    ]
                    
                    Firestore.firestore().collection("conversations")
                        .document(conversationId)
                        .updateData(updateConversation) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                let newMessage = Message(messageId: messageID,
                                                         senderId: currentUserId,
                                                         recipientId: recipientId ?? "",
                                                         content: messageText,
                                                         timestamp: timestamp,
                                                         messageType: .text)
                                self.messages.append(newMessage)
                                
                                self.messageTextField.text = ""
                                self.fetchMessages()
                            }
                        }
                }
            }
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = conversationTableView.dequeueReusableCell(withIdentifier: String.convertToString(conversationCell),
                                                             for: indexPath) as! ConversationTableViewCell
        let message = messages[indexPath.row]
        let isCurrentUser = message.senderId == Auth.auth().currentUser?.uid
        cell.loadImage(url: conversationData?.participantImageProfile ?? "")
        cell.configure(message: message, isCurrentUser: isCurrentUser)
        return cell
    }
}

extension ConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
