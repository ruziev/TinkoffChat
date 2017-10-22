//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import UIKit

protocol DataManager: class {
    func save()
    func restore()
    weak var delegate: DataManagerDelegate? {get set}
}

let DataManagerDumpFileName = "profile_data"
