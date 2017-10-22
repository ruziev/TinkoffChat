//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: DataManager {
    weak var delegate: DataManagerDelegate?
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
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.delegate?.didSave(strongSelf, success: success)
                }
            }
        }
    }
    
    func restore() {
        DispatchQueue.global(qos: .userInitiated).async {
            var success = false
            let data = try? Data(contentsOf: self.fileURL)
            
            if let data = data, let restored = NSKeyedUnarchiver.unarchiveObject(with: data) as? ProfileManager {
                ProfileManager.shared = restored
                success = true
            }
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.delegate?.didRestore(strongSelf, success: success)
                }
            }
        }
    }
    
}
