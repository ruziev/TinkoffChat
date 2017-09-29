//
//  UIImagePickerController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 29/09/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.blue
        self.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
    }
}
