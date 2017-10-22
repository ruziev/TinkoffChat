//
//  DataManagerDelegate.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 19/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

protocol DataManagerDelegate: class {    
    func didSave(_ dataManager: DataManager, success: Bool)
    func didRestore(_ dataManager: DataManager, success: Bool)
}

