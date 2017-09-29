//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/09/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var newImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //print(editButton.frame)
        // editButton == nil на этот момент, так как объект ProfileViewController создавался не с nib файла, а метод loadView() еще не вызван, поэтому self.view == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testEditButtonFrame(from: #function)
        imagePicker.delegate = self
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        testEditButtonFrame(from: #function)
        // в viewDidLoad() и здесь frame кнопки не отличаются
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testEditButtonFrame(from: #function)
        // а вот здесь уже отличается от viewDidLoad() и viewWillAppear()
        // здесь view уже добавилась к ViewController
        // вызвалась функция layoutSubviews()
        // и активиролись constraint
    }
    
    override func viewWillLayoutSubviews() {
        testEditButtonFrame(from: #function)
    }
    
    override func viewDidLayoutSubviews() {
        testEditButtonFrame(from: #function)
    }
    
    func layout() {
        let newImageButtonCornerRadius = newImageButton.frame.height / 2.0
        newImageButton.layer.cornerRadius = newImageButtonCornerRadius
        profileImageView.layer.cornerRadius = newImageButtonCornerRadius
        profileImageView.layer.masksToBounds = true
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 12.0
        
    }
    
    func testEditButtonFrame(from functionName: String) {
        print("\(functionName) Edit Button Frame: \(editButton.frame)")
    }
    
    @IBAction func onNewImageButton(_ sender: UIButton) {
        let optionsAlertVC = UIAlertController(title: "Выбери изображение профиля", message: nil, preferredStyle: .actionSheet)
        
        let fromGallery: (_: UIAlertAction) -> Void = { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        optionsAlertVC.addAction(UIAlertAction(title: "Галерея", style: .default, handler: fromGallery))
        
        let fromCamera: (_: UIAlertAction) -> Void = { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        optionsAlertVC.addAction(UIAlertAction(title: "Новое фото", style: .default, handler: fromCamera))
        // видимо в ios11 баг - иногда не появляется navigation bar при выборе галереи.
        // пока что extension это исправляет (иногда cancel прыгает)
        
        optionsAlertVC.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.show(optionsAlertVC, sender: self)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    
}

