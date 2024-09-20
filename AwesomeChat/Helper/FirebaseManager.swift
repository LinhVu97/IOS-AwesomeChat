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
    
    func createConservation(participantId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("conversations")
            .whereField("participants", arrayContains: currentUserId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        if let participants = data["participants"] as? [String],
                           participants.contains(participantId) {
                            let conversationId = document.documentID
                            completion(.success(conversationId))
                            return
                        }
                    }
                }
                
                let conversationId = UUID().uuidString
                let participants = [currentUserId, participantId]
                
                let conversationData: [String: Any] = [
                    "conversationId": conversationId,
                    "participants": participants,
                    "lastMessage": "Hello",
                    "timestamp": FieldValue.serverTimestamp()
                ]
                
                db.collection("conversations").document(conversationId).setData(conversationData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(conversationId))
                    }
                }
            }
    }
    
    func fetchConversations(userId: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("conversations")
            .whereField("participants", arrayContains: currentUserId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                var conversations: [Conversation] = []
                let dispatchGroup = DispatchGroup()
                
                for document in documents {
                    let data = document.data()
                    
                    guard
                        let participants = data["participants"] as? [String],
                        let lastMessage = data["lastMessage"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp
                    else { continue }
                    
                    let conversationId = document.documentID
                    var participantUsername: String = ""
                    var participantImageProfile: String = ""
                    
                    // Loop through participants and find the other user (not the current user)
                    for participantId in participants {
                        if participantId == currentUserId {
                            continue
                        }
                        
                        dispatchGroup.enter() // Start waiting for Firestore fetch
                        
                        db.collection("users").document(participantId).getDocument { snapshot, error in
                            defer { dispatchGroup.leave() } // Make sure to leave the group
                            
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            
                            if let data = snapshot?.data() {
                                participantUsername = data["username"] as? String ?? ""
                                participantImageProfile = data["profileImageUrl"] as? String ?? ""
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        let conversation = Conversation(
                            conversationId: conversationId,
                            participants: participants,
                            lastMessage: lastMessage,
                            timestamp: timestamp.dateValue(),
                            participantUsername: participantUsername,
                            participantImageProfile: participantImageProfile
                        )
                        
                        conversations.append(conversation)
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(conversations))
                }
            }
    }
}
