//
//  DataManagerDelegate.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 19/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

protocol IDataManagerDelegate: class {
    func didSave(_ dataManager: IDataManager, success: Bool)
    func didRestore(_ dataManager: IDataManager, restored: IProfileManager?)
}


