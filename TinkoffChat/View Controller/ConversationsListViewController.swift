//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 07/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    @IBOutlet weak var conversationsTableView: UITableView!
    let sectionsHeaderTitleText = ["Online", "History"]
    let conversationsList = [
        [
            ("Francisco", "Hey there! Whatsup?", Date.init(timeIntervalSinceNow: -3600) , true, true),
            ("Bueratotti", "Asshole! he didnt let me go, you understand, Johny?!", Date.init(timeIntervalSinceNow: -7280), false, true),
            ("Johny from Winterfold really annoying dude that comes with stupid offers everyday", "No apologies", Date.init(timeIntervalSinceNow: -360000), true, false),
            ("Alice in Wonderland", "😂😂😂😂", Date.init(timeIntervalSinceNow: -9834), false, false),
            ("VR🙏🏻CO", "LMAO", Date.init(timeIntervalSinceNow: -15000), true, false),
            ("Mike", nil, nil, true, false),
            ("Boss", nil, nil, false, false),
            ("Candid Towel", nil, nil, false, false),
            ("Anastasia", nil, nil, false, false),
            ("Maria", nil, nil, false, false),
        ],
        [
            ("Joni", "Yo", Date.init(timeIntervalSinceNow: -748248), false, true),
            ("Aza", "По кд минус моралич", Date.init(timeIntervalSinceNow: -88294), false, true),
            ("Beka", "Где пара?", Date.init(timeIntervalSinceNow: -9999), false, false),
            ("Misha", "ок", Date.init(timeIntervalSinceNow: -9124812), false, false),
            ("Sasha", "cool :))", Date.init(timeIntervalSinceNow: -123433), false, false),
            ("Ez Katka - Ez Life", "Каеф", Date.init(timeIntervalSinceNow: -999999), false, false),
            ("Skyrim Fans", "Шестая часть трешак, ребята!", Date.init(timeIntervalSinceNow: -21213), false, true),
            ("JunkMan", "ладно", Date.init(timeIntervalSinceNow: -8484849), false, false),
            ("Kseniya", "Вообще лекция была норм)", Date.init(timeIntervalSinceNow: -21213), false, false),
            ("Gregory", "нормас", Date.init(timeIntervalSinceNow: -8484849), false, false),
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromConversationsListToConversation" {
            let destinationVC = segue.destination as! ConversationViewController
            destinationVC.senderCellData = sender as! ConversationListCellData
        }
    }

}

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsHeaderTitleText.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsHeaderTitleText[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = conversationsList[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationsListCell", for: indexPath) as! ConversationListCell
        let cellData = ConversationListCellData(name: data.0, message: data.1, date: data.2, online: data.3, hasUnreadMessages: data.4)
        cellData.prepareCell(cell: cell)
        return cell
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = conversationsList[indexPath.section][indexPath.row]
        let cellData = ConversationListCellData(name: data.0, message: data.1, date: data.2, online: data.3, hasUnreadMessages: data.4)
        performSegue(withIdentifier: "fromConversationsListToConversation", sender: cellData)
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
    }
}
