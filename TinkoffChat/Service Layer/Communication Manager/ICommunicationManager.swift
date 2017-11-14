//
//  ICommunicationManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 10/31/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

protocol ICommunicationManager {
    var online: Bool {get set}
    var displayedUsername: String {get set}
    func sendMessage(in conversationId: String, text: String, completion: ((Bool,Error?) -> ())?)
    func messagesAreRead(in conversationId: String)
}
