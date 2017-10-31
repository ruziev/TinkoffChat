//
//  IConversationCell.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 10/31/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

protocol IConversationCell: class {
    var nameLabel: UILabel! {get}
    var dateLabel: UILabel! {get}
    var messageLabel: UILabel! {get}
    var backgroundColor: UIColor? {get set}
}
