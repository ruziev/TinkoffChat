//
//  displayAlert.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 23/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(title: String?, message: String? = nil, actions: [UIAlertAction] = []) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.count == 0 {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
        } else {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
