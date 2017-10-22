//
//  Message.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation

struct Message: Codable {
    let eventType = "TextMessage"
    let messageId = generateMessageId()
    
    let text: String
    var type: MessageType
    let date: Date
    
    init(text: String, type: MessageType) {
        self.text = text
        self.type = type
        self.date = Date()
    }
    
    private static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}

extension Message {
    // prepare cell
    
    func prepareCell(cell: MessageCell) {
        cell.label.text = text
    }
    
    func layoutCell(cell: MessageCell) {
        switch type {
        case .incoming:
            cell.layoutIncoming()
        case .outgoing:
            cell.layoutOutgoing()
        }
    }
}

enum MessageType: Int, Codable {
    case incoming = 0
    case outgoing = 1
}
