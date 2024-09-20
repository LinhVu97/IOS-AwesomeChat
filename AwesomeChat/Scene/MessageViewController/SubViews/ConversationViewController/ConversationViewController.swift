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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor(named: "blueColor")?.cgColor
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
