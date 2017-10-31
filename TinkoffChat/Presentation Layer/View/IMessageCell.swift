//
//  IMessageCell.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 10/31/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//
import UIKit
protocol IMessageCell: class {
    var label: UILabel! {get set}
    func layoutIncoming()
    func layoutOutgoing()
}
