//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 08/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

enum MessageType {
    case incoming
    case outgoing
}

class MessageCell: UITableViewCell, MessageCellConfiguration {
    var type: MessageType!
    var messageText: String?
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var label: UILabel!
    
    func prepareData() {
        label.text = messageText!
    }
    
    func prepareForShow() {
        switch type {
        case .incoming:
            layoutIncoming()
        case .outgoing:
            layoutOutgoing()
        default: break
        }
    }
    
    func layoutIncoming() {
        let rectShape = CAShapeLayer()
        rectShape.bounds = wrapperView.frame
        rectShape.position = wrapperView.center
        rectShape.path = UIBezierPath(roundedRect: wrapperView.bounds, byRoundingCorners: [.bottomRight , .topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        wrapperView.layer.mask = rectShape
    }
    
    func layoutOutgoing() {
        let rectShape = CAShapeLayer()
        rectShape.bounds = wrapperView.frame
        rectShape.position = wrapperView.center
        rectShape.path = UIBezierPath(roundedRect: wrapperView.bounds, byRoundingCorners: [.bottomLeft , .topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        wrapperView.layer.mask = rectShape
    }
}
