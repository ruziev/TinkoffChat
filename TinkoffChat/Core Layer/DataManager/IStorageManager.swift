//
//  IStorageManager.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 11/6/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

protocol IStorageManager: class {
    weak var delegate: IStorageManagerDelegate? {get set}
    func save(_ appUser: AppUser)
    func restoreAppUser()
}

protocol IStorageManagerDelegate: class {
    func didSave(_ storageManager: IStorageManager, success: Bool)
    func didRestore(_ storageManager: IStorageManager, restored: AppUser?)
}
