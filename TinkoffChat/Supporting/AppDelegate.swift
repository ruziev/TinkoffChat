//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/09/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coreDataStack = CoreDataStack()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initConversationsOffline()
        // MARK: - Inject Dependencies
        guard let navVC = window?.rootViewController as? UINavigationController,
            let convsVC = navVC.viewControllers.first as? ConversationsVC else {
                print("No root view controller")
                return false
        }
        let comManager = CommunicationManager()
        comManager.coreDataStack = coreDataStack
        convsVC.communicationManager = comManager
        
        let profManager = ProfileManager()
        let storManager = StorageManager()
        storManager.coreDataStack = coreDataStack
        profManager.storageManager = storManager
        convsVC.profileManager = profManager
        
        let dataProvider = ConversationsDataProvider()
        dataProvider.context = coreDataStack.mainContext
        convsVC.dataProvider = dataProvider
        
        return true
    }
    
    func initConversationsOffline() {
        let batchUpdate = NSBatchUpdateRequest(entityName: "Conversation")
        batchUpdate.propertiesToUpdate = ["online": false]
        batchUpdate.resultType = .updatedObjectsCountResultType
        do {
            let result = try coreDataStack.saveContext?.execute(batchUpdate) as? NSBatchUpdateResult
            print("Successfull batch update: updated \(result?.result as? Int)")
        } catch let error as NSError {
            print("Error performing batch update: \(error), \(error.userInfo)")
        }
    }
}

