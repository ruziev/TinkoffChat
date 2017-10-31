//
//  IProfileManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 10/30/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import UIKit

protocol IProfileManager: class, NSCoding {
    var image: UIImage? {get set}
    var name: String? {get set}
    var info: String? {get set}
    func update(name: String?, info: String?, image: UIImage?) -> Bool
}
