//
//  IMessageType.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 10/31/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

enum IMessageType: Int, Codable {
    case incoming = 0
    case outgoing = 1
}
