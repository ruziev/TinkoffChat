//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 15/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import UIKit

protocol DataManagerProtocol {
    func save()
    func restore()
}

let DataManagerDidSaveNotificationName = Notification.Name("com.ruziev.DataManagerDidSaveNotificationName")
let DataManagerDidRestoreNotificationName = Notification.Name("com.ruziev.DataManagerDidRestoreNotificationName")
let DataManagerDumpFileName = "profile"
