//
//  MessageCellConfiguration.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 08/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import UIKit

struct MessageCellData {
    var messageText: String
}

extension MessageCellData {
    // prepare UITableViewCell
    
    func prepareCell(cell: MessageCell) {
        cell.label.text = messageText
    }
    
    func layoutCell(cell: MessageCell, type: MessageType) {
        switch type {
        case .incoming:
            cell.layoutIncoming()
        case .outgoing:
            cell.layoutOutgoing()
        }
    }
}
