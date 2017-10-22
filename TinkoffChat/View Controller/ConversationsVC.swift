//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 07/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ConversationsVC: UIViewController {
    @IBOutlet weak var conversationsTableView: UITableView!
    var communicationManager = CommunicationManager()
    private let _dataManager: DataManager = GCDDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _dataManager.delegate = self
        _dataManager.restore()
        
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        conversationsTableView.reloadData()
    }
}

extension ConversationsVC: DataManagerDelegate {
    func didSave(_ dataManager: DataManager, success: Bool) {
        
    }
    
    func didRestore(_ dataManager: DataManager, success: Bool) {
        communicationManager = CommunicationManager()
        communicationManager.conversationsDelegate = self
        communicationManager.online = true
    }
    
    
}

extension ConversationsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return communicationManager.conversationsNumberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return communicationManager.conversationsTableView(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communicationManager.conversationsTableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return communicationManager.conversationsTableView(tableView, cellForRowAt: indexPath)
    }
}

extension ConversationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = communicationManager.conversation(for: indexPath)
        performSegue(withIdentifier: "fromConversationsListToConversation", sender: conversation)
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromConversationsListToConversation" {
            let destinationVC = segue.destination as! ConversationVC
            destinationVC.conversation = sender as! Conversation
            destinationVC.communicationManager = communicationManager
        }
    }
}

extension ConversationsVC: CommunicationManagerDelegate {
    func shouldReload() {
        conversationsTableView.reloadData()
    }
    
    func communicationManagerFailedToStart(_ error: Error) {
        
    }
    
}
