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
    weak var dataManager: IDataManager?
    weak var profileManager: IProfileManager?
    let fileURL: URL
    init(fileURL: URL, dataManager: IDataManager?, profileManager: IProfileManager?) {
        self.fileURL = fileURL
        self.dataManager = dataManager
        self.profileManager = profileManager
    }

    override func main() {
        guard let profileManager = profileManager else {
            fatalError("Should provide instance of IProfileManager")
        }
        var success = false
        let data = NSKeyedArchiver.archivedData(withRootObject: profileManager)
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
    weak var dataManager: IDataManager?
    let fileURL: URL
    init(fileURL: URL, dataManager: IDataManager?) {
        self.fileURL = fileURL
        self.dataManager = dataManager
    }

    override func main() {
        let data: Data? = try? Data(contentsOf: self.fileURL)
        var restored: IProfileManager? = nil
        if let data = data {
            restored = NSKeyedUnarchiver.unarchiveObject(with: data) as? IProfileManager
        }
        OperationQueue.main.addOperation {
            if let dataManager = self.dataManager {
                dataManager.delegate?.didRestore(dataManager, restored: restored)
            }
        }
    }
}

class OperationDataManager: IDataManager {
    weak var delegate: IDataManagerDelegate?
    
    let fileURL: URL
    let queue: OperationQueue

    init(fileName: String = "ProfileData") {
        if var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path.appendPathComponent(fileName)
            fileURL = path
        } else {
            fatalError("OperationDataManager: FileManager.default.urls for .documentDirectory is empty")
        }
        queue = OperationQueue()
        queue.qualityOfService = .userInitiated
    }

    func save(_ profileManager: IProfileManager) {
        let saveOp = SaveOperation(fileURL: fileURL, dataManager: self, profileManager: profileManager)
        queue.addOperation(saveOp)
    }

    func restore() {
        let restoreOp = RestoreOperation(fileURL: fileURL, dataManager: self)
        queue.addOperation(restoreOp)
    }

}


