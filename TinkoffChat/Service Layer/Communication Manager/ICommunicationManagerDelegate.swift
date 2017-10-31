//
//  CommunicationManagerDelegate.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

@objc protocol ICommunicationManagerDelegate: class {
    func shouldReload()
    @objc optional func communicationManagerFailedToStart(_ error: Error)
}
