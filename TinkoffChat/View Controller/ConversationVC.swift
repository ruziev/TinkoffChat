//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 08/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {
    @IBOutlet weak var messagesTableView: UITableView!
    var communicationManager: CommunicationManager!
    var conversation: Conversation!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = conversation.username
        
        communicationManager.conversationDelegate = self
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        messagesTableView.scrollToBottom(animated: false)
        conversation.hasUnreadMessages = false
    }
    
    @IBAction func onSendButtonTap(_ sender: UIButton) {
        let text = textView.text!
        /// validating message
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            // string contains only whitespace characters
            return
        }
        ///
        communicationManager.sendMessage(in: conversation, text: text, completion: { [weak self] (success, error) in
            if success {
                self?.textView.text = ""
                self?.textView.resignFirstResponder()
                self?.messagesTableView.scrollToBottom(animated: false)
            } else if let error = error {
                let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alertVC, animated: true, completion: nil)
            }
        })
    }
}

extension ConversationVC: CommunicationManagerDelegate {
    func shouldReload() {
        messagesTableView.reloadData()
        messagesTableView.scrollToBottom(animated: false)
        conversation.hasUnreadMessages = false
        if !conversation.online {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}

extension ConversationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = conversation.messages[indexPath.row]
        switch message.type {
        case .incoming:
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomingMessageCell", for: indexPath) as! MessageCell
            message.prepareCell(cell: cell)
            return cell
        case .outgoing:
            let cell = tableView.dequeueReusableCell(withIdentifier: "outgoingMessageCell", for: indexPath) as! MessageCell
            message.prepareCell(cell: cell)
            return cell
        }
    }
}

extension ConversationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let messageCell = cell as! MessageCell
        let message = conversation.messages[indexPath.row]
        messageCell.layoutIfNeeded()
        message.layoutCell(cell: messageCell)
    }
}

extension ConversationVC {
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide {
            bottomConstraint.constant -= keyboardViewEndFrame.height
        } else {
            bottomConstraint.constant += keyboardViewEndFrame.height
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.messagesTableView.scrollToBottom(animated: false)
        }
    }
}