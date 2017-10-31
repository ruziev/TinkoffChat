//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class CommunicationManager: ICommunicationManager, ICommunicatorDelegate {
    var displayedUsername: String {
        didSet {
            communicator.displayedUsername = displayedUsername
        }
    }
    
    private var communicator: ICommunicator = MultipeerCommunicator()
    
    var online: Bool = false {
        didSet {
            communicator.online = online
        }
    }
    weak var conversationsDelegate: ICommunicationManagerDelegate?
    weak var conversationDelegate: ICommunicationManagerDelegate?
    public private(set) var onlineConversations: [IConversation] = []
    public private(set) var historyConversations: [IConversation] = []
    
    
    init() {
        displayedUsername = communicator.displayedUsername
        communicator.delegate = self
    }
    
    func delegateShouldReload() {
        DispatchQueue.main.async {
            self.conversationsDelegate?.shouldReload()
        }
    }
    
    func delegatesShouldReload() {
        DispatchQueue.main.async {
            self.conversationsDelegate?.shouldReload()
            self.conversationDelegate?.shouldReload() // to disable specific chat
        }
    }
    
    fileprivate func sortOnlineConversations() {
        func conversationsComparatorByDateOrName(_ conv1: IConversation, _ conv2: IConversation) -> Bool {
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
        onlineConversations.sort(by: conversationsComparatorByDateOrName)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        for conv in onlineConversations {
            if conv.userID == userID {
                return
            }
        }
        let newConversation: IConversation = Conversation(with: userID, username: userName ?? "Unknown", online: true)
        onlineConversations.append(newConversation)
        sortOnlineConversations()
        delegateShouldReload()
    }
    
    func didLostUser(userID: String) {
        var index: Int?
        for (i,conv) in onlineConversations.enumerated() {
            if conv.userID == userID {
                index = i
                break
            }
        }
        if let index = index {
            onlineConversations[index].online = false
            onlineConversations.remove(at: index) // this object should not dealloc if we are in conversationVC
            delegatesShouldReload()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        DispatchQueue.main.async {
            self.conversationsDelegate?.communicationManagerFailedToStart?(error)
        }
    }
    
    func failedToStartAdvertising(error: Error) {
        DispatchQueue.main.async {
            self.conversationsDelegate?.communicationManagerFailedToStart?(error)
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        // this implementation assumes toUser is current user (owner)
        let newMessage = Message(text: text, type: .incoming)
        var inConversation: IConversation? = nil
        for conv in onlineConversations {
            if conv.userID == fromUser {
                inConversation = conv
                break
            }
        }
        inConversation?.messages.append(newMessage)
        inConversation?.hasUnreadMessages = true
        sortOnlineConversations()
        delegatesShouldReload()
    }
    
    func sendMessage(in conversation: IConversation, text: String, completion: ((Bool,Error?) -> ())?) {
        communicator.sendMessage(string: text, to: conversation.userID, completionHandler: { (success, error) in
            if success {
                conversation.messages.append(Message(text: text, type: .outgoing))
                self.sortOnlineConversations()
            }
            DispatchQueue.main.async {
                completion?(success, error)
                if success {
                    self.conversationDelegate?.shouldReload()
                }
            }
        })
    }
}

//extension CommunicationManager {
//    // Related to conversations list
//
//    func conversationsTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var data_: Conversation?
//        switch indexPath.section {
//        case 0:
//            data_ = onlineConversations[indexPath.row]
//        case 1:
//            data_ = historyConversations[indexPath.row]
//        default:
//            break
//        }
//        guard let data = data_ else {
//            fatalError("Bad indexPath for conversations tableView")
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationsListCell", for: indexPath) as! ConversationListCell
//        data.prepareCell(cell: cell)
//        return cell
//    }
//
//    func conversationsTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return onlineConversations.count
//        case 1:
//            return historyConversations.count
//        default:
//            return 0
//        }
//    }
//
//    func conversationsNumberOfSections(in tableView: UITableView) -> Int {
//        return conversationsHeadersTitle.count
//    }
//
//    func conversationsTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return conversationsHeadersTitle[section]
//    }
//
//    func conversation(for indexPath: IndexPath) -> Conversation {
//        switch indexPath.section {
//        case 0:
//            return onlineConversations[indexPath.row]
//        case 1:
//            return historyConversations[indexPath.row]
//        default:
//            fatalError("Invalid indexPath for \(#function)")
//        }
//    }
//
//}

