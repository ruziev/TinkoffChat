//
//  ConversationListCell.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 07/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {
    var data: ConversationCellConfiguration!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func prepare() {
        nameLabel.text = data.name!
        if let message = data.message {
            messageLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            messageLabel.text = message
        } else {
            messageLabel.font = UIFont(name: "Courier", size: 14.0)
            messageLabel.text = "No messages yet"
            // why font change won't apply ?
        }
        if let date = data.date {
            if date.timeIntervalSinceNow > -3600*24.0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                dateLabel.text = dateFormatter.string(from: date)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM"
                dateLabel.text = dateFormatter.string(from: date)
            }
        } else {
            dateLabel.text = "A long time ago"
        }
        if data.online {
            self.backgroundColor = UIColor(rgb: 0xf1c40f, alpha: 0.2)
            
        } else {
            self.backgroundColor = UIColor.white
        }
        if data.hasUnreadMessages {
            messageLabel.font = UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)
            messageLabel.textColor = UIColor(white: 0, alpha: 0.9)
        } else {
            messageLabel.font = UIFont.systemFont(ofSize: messageLabel.font.pointSize)
            messageLabel.textColor = UIColor.darkGray
        }
    }
}
