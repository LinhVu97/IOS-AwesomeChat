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
