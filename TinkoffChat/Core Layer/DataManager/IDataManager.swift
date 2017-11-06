//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import UIKit

protocol IDataManager: class {
    func save(_ profileManager: IProfileManager)
    func restore()
    weak var delegate: IDataManagerDelegate? {get set}
}

