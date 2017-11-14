//
//  Message.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 11/10/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    static func insertMessage(in context: NSManagedObjectContext) -> Message? {
        if let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message {
            return message
        }
        return nil
    }
    
    
}
