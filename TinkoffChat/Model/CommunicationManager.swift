//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class CommunicationManager: CommunicatorDelegate {
    private var communicator: Communicator = MultipeerCommunicator()
    var online: Bool = false {
        didSet {
            if online {
                communicator.online = true
            } else {
                communicator.online = false
            }
        }
    }
    weak var conversationsDelegate: CommunicationManagerDelegate?
    weak var conversationDelegate: CommunicationManagerDelegate?
    public private(set) var onlineConversations: [Conversation] = []
    public private(set) var historyConversations: [Conversation] = []
    public let conversationsHeadersTitle = ["Online", "History"]
    
    
    init() {
        communicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        for conv in onlineConversations {
            if conv.userID == userID {
                return
            }
        }
        let newConversation = Conversation(with: userID, username: userName ?? "Unknown", online: true)
        onlineConversations.append(newConversation)
        onlineConversations.sort(by: Conversation.comparator)
        DispatchQueue.main.async {
            self.conversationsDelegate?.shouldReload()
        }
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
            DispatchQueue.main.async {
                self.conversationsDelegate?.shouldReload()
                self.conversationDelegate?.shouldReload() // to disable specific chat
            }
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
        var inConversation: Conversation? = nil
        for conv in onlineConversations {
            if conv.userID == fromUser {
                inConversation = conv
                break
            }
        }
        inConversation?.messages.append(newMessage)
        inConversation?.hasUnreadMessages = true
        onlineConversations.sort(by: Conversation.comparator)
        DispatchQueue.main.async {
            self.conversationDelegate?.shouldReload()
            self.conversationsDelegate?.shouldReload()
        }
    }
    
    func sendMessage(in conversation: Conversation, text: String, completion: ((Bool,Error?) -> ())?) {
        communicator.sendMessage(string: text, to: conversation.userID, completionHandler: { (success, error) in
            if success {
                conversation.messages.append(Message(text: text, type: .outgoing))
                self.onlineConversations.sort(by: Conversation.comparator)
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

extension CommunicationManager {
    // Related to conversations list
    
    func conversationsTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data_: Conversation?
        switch indexPath.section {
        case 0:
            data_ = onlineConversations[indexPath.row]
        case 1:
            data_ = historyConversations[indexPath.row]
        default:
            break
        }
        guard let data = data_ else {
            fatalError("Bad indexPath for conversations tableView")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationsListCell", for: indexPath) as! ConversationListCell
        data.prepareCell(cell: cell)
        return cell
    }
    
    func conversationsTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConversations.count
        case 1:
            return historyConversations.count
        default:
            return 0
        }
    }
    
    func conversationsNumberOfSections(in tableView: UITableView) -> Int {
        return conversationsHeadersTitle.count
    }
    
    func conversationsTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return conversationsHeadersTitle[section]
    }
    
    func conversation(for indexPath: IndexPath) -> Conversation {
        switch indexPath.section {
        case 0:
            return onlineConversations[indexPath.row]
        case 1:
            return historyConversations[indexPath.row]
        default:
            fatalError("Invalid indexPath for \(#function)")
        }
    }
    
}

