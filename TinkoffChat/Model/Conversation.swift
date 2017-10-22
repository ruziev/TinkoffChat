//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 07/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import Foundation
import UIKit

class Conversation {
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
    
    static func comparator(_ conv1: Conversation, _ conv2: Conversation) -> Bool {
        if conv1.date == nil && conv2.date == nil {
            return conv1.username.lowercased() < conv2.username.lowercased()
        }
        guard let date1 = conv1.date else {
            return false
        }
        guard let date2 = conv2.date else {
            return true
        }
        if date1 != date2 {
            return date1.compare(date2).rawValue == 1 ? true : false
        } else {
            return conv1.username.lowercased() < conv2.username.lowercased()
        }
    }
}

extension Conversation {
    // prepare cell
    
    func prepareCell(cell: ConversationListCell) {
        cell.nameLabel.text = username
        if let lastMessage = lastMessage {
            cell.messageLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            cell.messageLabel.text = lastMessage
        } else {
            cell.messageLabel.font = UIFont(name: "Courier", size: 14.0)
            cell.messageLabel.text = "No messages yet"
            // why font change won't apply ?
        }
        if let date = date {
            if date.timeIntervalSinceNow > -3600*24.0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                cell.dateLabel.text = dateFormatter.string(from: date)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM"
                cell.dateLabel.text = dateFormatter.string(from: date)
            }
        } else {
            cell.dateLabel.text = ""
        }
        if online {
            cell.backgroundColor = UIColor(rgb: 0xf1c40f, alpha: 0.2)
        } else {
            cell.backgroundColor = UIColor.white
        }
        if hasUnreadMessages {
            cell.messageLabel.font = UIFont.boldSystemFont(ofSize: cell.messageLabel.font.pointSize)
            cell.messageLabel.textColor = UIColor(white: 0, alpha: 0.9)
        } else {
            cell.messageLabel.font = UIFont.systemFont(ofSize: cell.messageLabel.font.pointSize)
            cell.messageLabel.textColor = UIColor.darkGray
        }
    }
}
