//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 07/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import Foundation
import UIKit

class Conversation: IConversation {
    let userID: String
    var username: String
    var lastMessage: String? {
        return messages.last?.text
    }
    var date: Date? {
        return messages.last?.date
    }
    var online: Bool
    var hasUnreadMessages: Bool
    var messages: [Message]
    
    init(with userID: String, username: String, online: Bool = false, hasUnreadMessages: Bool = false, messages: [Message] = []) {
        self.userID = userID
        self.username = username
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.messages = messages
    }
}
