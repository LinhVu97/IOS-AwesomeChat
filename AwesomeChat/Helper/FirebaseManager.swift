//
//  FirebaseManager.swift
//  AwesomeChat
//
//  Created by Linh Vu on 22/8/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    
    func updateProfileImageUrl(_ url: String, _ nameData: String) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("users").document(userId ?? "").updateData([nameData: url]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Profile image url updated")
            }
        }
    }
}
