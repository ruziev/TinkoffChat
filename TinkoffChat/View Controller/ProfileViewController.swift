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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        layout()
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
        present(optionsAlertVC, animated: true, completion: nil)
    }
    
    @IBAction func onCloseScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

