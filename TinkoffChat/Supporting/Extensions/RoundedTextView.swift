//
//  RoundedTextView.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 22/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedTextView: UITextView {
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
