//
//  Message.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation

struct Message: Codable, IMessage {
    let eventType = "TextMessage"
    let messageId = generateMessageId()
    
    let text: String
    var type: IMessageType
    let date: Date
    
    init(text: String, type: IMessageType) {
        self.text = text
        self.type = type
        self.date = Date()
    }
    
    private static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
