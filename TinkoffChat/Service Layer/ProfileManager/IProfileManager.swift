//
//  IProfileManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 10/30/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import UIKit

protocol IProfileManager: class, IDataManager, IStorageManagerDelegate {
    var image: UIImage? {get}
    var name: String? {get}
    var info: String? {get}
    func update(name: String?, info: String?, image: UIImage?) -> Bool
}
