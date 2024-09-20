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
    
    var conversationData: Conversation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor(named: "blueColor")?.cgColor
        
        setupData()
    }
    
    private func setupData() {
        guard let conversationData = conversationData else { return }
        
        if let url = URL(string: conversationData.participantImageProfile) {
            profileImage.loadImage(url: url)
        }
        
        username.text = conversationData.participantUsername
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
