//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import UIKit

class SaveOperation: Operation {
    weak var dataManager: DataManager?
    let fileURL: URL
    init(fileURL: URL, dataManager: DataManager?) {
        self.fileURL = fileURL
        self.dataManager = dataManager
    }

    override func main() {
        var success = false
        let data = NSKeyedArchiver.archivedData(withRootObject: ProfileManager.shared)
        do {
            try data.write(to: self.fileURL)
            success = true
        } catch {
            success = false
        }
        OperationQueue.main.addOperation {
            if let dataManager = self.dataManager {
                dataManager.delegate?.didSave(dataManager, success: success)
            }
        }
    }
}

class RestoreOperation: Operation {
    weak var dataManager: DataManager?
    let fileURL: URL
    init(fileURL: URL, dataManager: DataManager?) {
        self.fileURL = fileURL
        self.dataManager = dataManager
    }

    override func main() {
        var success: Bool = false
        let data: Data? = try? Data(contentsOf: self.fileURL)
        if let data = data, let restored = NSKeyedUnarchiver.unarchiveObject(with: data) as? ProfileManager {
            ProfileManager.shared = restored
            success = true
        }
        OperationQueue.main.addOperation {
            if let dataManager = self.dataManager {
                dataManager.delegate?.didRestore(dataManager, success: success)
            }
        }
    }
}

class OperationDataManager: DataManager {
    weak var delegate: DataManagerDelegate?
    
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
        let saveOp = SaveOperation(fileURL: fileURL, dataManager: self)
        queue.addOperation(saveOp)
    }

    func restore() {
        let restoreOp = RestoreOperation(fileURL: fileURL, dataManager: self)
        queue.addOperation(restoreOp)
    }

}


