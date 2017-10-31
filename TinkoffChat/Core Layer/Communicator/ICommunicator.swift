//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 19/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation

protocol ICommunicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: ICommunicatorDelegate? {get set}
    var online: Bool {get set}
    var displayedUsername: String {get set}
}
