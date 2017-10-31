//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: IDataManager {
    weak var delegate: IDataManagerDelegate?
    
    let fileURL: URL
    
    init(fileName: String = "ProfileData") {
        if var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            path.appendPathComponent(fileName)
            fileURL = path
        } else {
            fatalError("GCDdataManager: FileManager.default.urls for .documentDirectory is empty")
        }
    }
    
    func save(_ profileManager: IProfileManager) {
        DispatchQueue.global(qos: .userInitiated).async {
            var success = false
            let data = NSKeyedArchiver.archivedData(withRootObject: profileManager)
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
            let data = try? Data(contentsOf: self.fileURL)
            var restored: IProfileManager? = nil
            
            if let data = data {
                restored = NSKeyedUnarchiver.unarchiveObject(with: data) as? IProfileManager
            }
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.delegate?.didRestore(strongSelf, restored: restored)
                }
            }
        }
    }
    
}
