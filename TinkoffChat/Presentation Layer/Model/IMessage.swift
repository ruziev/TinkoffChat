//
//  IMessage.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 10/31/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

protocol IMessage {
    var messageId: String {get}
    var text: String {get}
    var date: Date {get}
    var type: IMessageType {get}
    func prepareCell(cell: IMessageCell)
    func layoutCell(cell: IMessageCell)
}

extension IMessage {
    // IMessageCell
    func prepareCell(cell: IMessageCell) {
        cell.label.text = text
    }
    
    func layoutCell(cell: IMessageCell) {
        switch type {
        case .incoming:
            cell.layoutIncoming()
        case .outgoing:
            cell.layoutOutgoing()
        }
    }
}
