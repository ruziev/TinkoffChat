//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/09/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("ProfileViewController called: \(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        print("ProfileViewController called: \(#function)")
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ProfileViewController called: \(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        print("ProfileViewController called: \(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        print("ProfileViewController called: \(#function)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("ProfileViewController called: \(#function)")
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ProfileViewController called: \(#function)")
    }
}

