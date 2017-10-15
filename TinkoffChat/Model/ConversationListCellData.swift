//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 07/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import Foundation
import UIKit

struct ConversationListCellData {
    var name: String
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
}

extension ConversationListCellData {
    // prepare UITableViewCell
    
    func prepareCell(cell: ConversationListCell) {
        cell.nameLabel.text = name
        if let message = message {
            cell.messageLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            cell.messageLabel.text = message
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
