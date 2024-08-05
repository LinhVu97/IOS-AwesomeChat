//
//  FirebaseAuthManager.swift
//  AwesomeChat
//
//  Created by Linh Vu on 2/8/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {    
    func createUser(user: User , completion: @escaping(Bool, Error?) -> Void) {
        let username = user.username
        let email = user.email
        let password = user.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            // - MARK: Save user in DB
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData(["username": username,
                         "email": email])
            { error in
                if let error = error {
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let email = email
        let password = password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            } else {
                completion(true, nil)
            }
        }
    }
}
