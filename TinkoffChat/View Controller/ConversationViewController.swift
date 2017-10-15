//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 08/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    var senderCellData: ConversationListCellData!
    @IBOutlet weak var messagesTableView: UITableView!
    
    var messages: [(MessageType, MessageCellData)] = []
    
    func generateRandomMessages() {
        func randomString(length: Int) -> String {
            let letters : NSString = "abcdefghijklmnopqrstuvwxyz      "
            let len = UInt32(letters.length)
            var string = ""
            for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                string += NSString(characters: &nextChar, length: 1) as String
            }
            return string != " " ? string : randomString(length: length)
        }
        
        for messageLength in [1,30,300,30,60,50] {
            messages.append((.incoming,
                             MessageCellData(messageText: randomString(length: messageLength))))
        }
        for messageLength in [1,30,300,30,60,50] {
            messages.append((.outgoing,
                             MessageCellData(messageText: randomString(length: messageLength))))
        }
        messages.shuffle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = senderCellData.name
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 300
        
        generateRandomMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        var cell: MessageCell
        switch message.0 {
        case .incoming:
            cell = tableView.dequeueReusableCell(withIdentifier: "incomingMessageCell", for: indexPath) as! MessageCell
            message.1.prepareCell(cell: cell)
        case .outgoing:
            cell = tableView.dequeueReusableCell(withIdentifier: "outgoingMessageCell", for: indexPath) as! MessageCell
            message.1.prepareCell(cell: cell)
        }
        return cell
    }
}

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let messageCell = cell as! MessageCell
        let data = messages[indexPath.row]
        messageCell.layoutIfNeeded()
        data.1.layoutCell(cell: messageCell, type: data.0)
    }
}
