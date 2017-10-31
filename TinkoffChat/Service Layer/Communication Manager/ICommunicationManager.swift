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
    var onlineConversations: [IConversation] {get}
    var historyConversations: [IConversation] {get}
    weak var conversationsDelegate: ICommunicationManagerDelegate? {get set}
    weak var conversationDelegate: ICommunicationManagerDelegate? {get set}
    func sendMessage(in conversation: IConversation, text: String, completion: ((Bool,Error?) -> ())?)
}
