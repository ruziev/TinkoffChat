//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import UIKit

class SaveOperation: AsyncOperation {
    let fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
            var success = false
            let data = NSKeyedArchiver.archivedData(withRootObject: ProfileManager.shared)
            if self.isCancelled {
                state = .finished
                return
            }
            do {
                try data.write(to: self.fileURL)
                success = true
            } catch {
                success = false
            }
            OperationQueue.main.addOperation {
                NotificationCenter.default.post(name: DataManagerDidSaveNotificationName, object: nil, userInfo: ["success": success, "sender": self])
            }
            state = .finished
        }
    }
}

class RestoreOperation: AsyncOperation {
    let fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
            var data: Data
            do {
                data = try Data(contentsOf: self.fileURL)
            } catch {
                return
            }
            if let restored = NSKeyedUnarchiver.unarchiveObject(with: data) as? ProfileManager {
                ProfileManager.shared = restored
                OperationQueue.main.addOperation {
                    NotificationCenter.default.post(name: DataManagerDidRestoreNotificationName, object: nil)
                }
            }
            state = .finished
        }
    }
}

class OperationDataManager: DataManagerProtocol {
    static let shared = OperationDataManager()
    
    let fileURL: URL
    let queue: OperationQueue

    init() {
        if var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path.appendPathComponent(DataManagerDumpFileName)
            fileURL = path
        } else {
            fatalError("OperationDataManager: FileManager.default.urls for .documentDirectory is empty")
        }
        queue = OperationQueue()
        queue.qualityOfService = .userInitiated
    }

    func save() {
        let saveOp = SaveOperation(fileURL: fileURL)
        queue.addOperation(saveOp)
    }

    func restore() {
        let restoreOp = RestoreOperation(fileURL: fileURL)
        queue.addOperation(restoreOp)
    }

}


