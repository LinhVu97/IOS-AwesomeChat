//
//  Conversation.swift
//  AwesomeChat
//
//  Created by Linh Vu on 13/9/24.
//

import Foundation
import UIKit

struct Conversation {
    var conversationId: String
    var participants: [String]
    var lastMessage: String
    var timestamp: Date
    var participantUsername: String
    var participantImageProfile: String
}

struct Message {
    var messageId: String
    var senderId: String
    var recipientId: String
    var content: String
    var timestamp: Date
    var messageType: MessageType
}

enum MessageType: String {
    case text
    case video
    case image
}
