//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: DataManagerProtocol {
    static let shared = GCDDataManager()
    
    let fileURL: URL
    
    init() {
        if var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path.appendPathComponent(DataManagerDumpFileName)
            fileURL = path
        } else {
            fatalError("GCDdataManager: FileManager.default.urls for .documentDirectory is empty")
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .userInitiated).async {
            var success = false
            let data = NSKeyedArchiver.archivedData(withRootObject: ProfileManager.shared)
            do {
                try data.write(to: self.fileURL)
                success = true
            } catch {
                success = false
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: DataManagerDidSaveNotificationName, object: nil, userInfo: ["success": success, "sender": self])
            }
        }
    }
    
    func restore() {
        DispatchQueue.global(qos: .userInitiated).async {
            var data: Data
            do {
                data = try Data(contentsOf: self.fileURL)
            } catch {
                return
            }
            if let restored = NSKeyedUnarchiver.unarchiveObject(with: data) as? ProfileManager {
                ProfileManager.shared = restored
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: DataManagerDidRestoreNotificationName, object: nil)
                }
            }
        }
    }
    
}
