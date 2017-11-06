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
    var communicationManager: ICommunicationManager = CommunicationManager()
    var profileManager: IProfileManager = ProfileManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileManager.delegate = self
        profileManager.restore()
        
        communicationManager.conversationsDelegate = self
        
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        conversationsTableView.reloadData()
    }
    @IBAction func toProfileButtonTap(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVCID") as! ProfileVC
        profileVC.profileManager = profileManager
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController.pushViewController(profileVC, animated: false)
        present(navigationController, animated: true, completion: nil)
    }
}

extension ConversationsVC: IDataManagerDelegate {
    func didRestore(_ dataManager: IDataManager, restored: IProfileManager?) {
        if let restored = restored {
            profileManager = restored
            if let username = profileManager.name {
                communicationManager.displayedUsername = username
            }
        }
        communicationManager.online = true
    }
    
    func didSave(_ dataManager: IDataManager, success: Bool) {
        
    }
}

extension ConversationsVC: UITableViewDataSource {    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Online","History"][section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return communicationManager.onlineConversations.count
        case 1:
            return communicationManager.historyConversations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conv = communicationManager.onlineConversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationsListCell", for: indexPath) as! ConversationCell
        conv.prepareCell(cell: cell)
        return cell
    }
}

extension ConversationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "fromConversationsListToConversation", sender: indexPath)
            let selectedCell = tableView.cellForRow(at: indexPath)
            selectedCell?.isSelected = false
        default:
            return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromConversationsListToConversation" {
            let destinationVC = segue.destination as! ConversationVC
            destinationVC.conversationID = sender as! IndexPath
            destinationVC.communicationManager = communicationManager
        }
    }
}

extension ConversationsVC: ICommunicationManagerDelegate {
    func shouldReload() {
        conversationsTableView.reloadData()
    }
    
    func communicationManagerFailedToStart(_ error: Error) {
        displayAlert(title: "Error", message: error.localizedDescription)
    }
    
}
