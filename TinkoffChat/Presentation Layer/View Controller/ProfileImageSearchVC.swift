//
//  ProfileImageSearchVC.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 11/19/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

protocol ImageSearchVCDelegate : class {
    func didPick(image: UIImage)
}

class ProfileImageSearchVC: UIViewController {
    
    // MARK: - Delegate
    weak var delegate: ImageSearchVCDelegate?
    
    // MARK: - Properties
    let requestSender: IRequestSender = RequestSender(async: true)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = RequestsFactory.PixabayRequests.imageInfosConfig(keywords: ["dachshund"])
        requestSender.send(config: config) { (result) in
            switch result {
            case .success(let imageInfos):
                print(imageInfos)
            case .error(let description):
                print(description)
            }
        }
    }

}
