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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var wrapperTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var wrapperBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        notificationCenter.addObserver(self, selector: #selector(dataManagerSavedObserver), name: DataManagerDidSaveNotificationName, object: nil)
        notificationCenter.addObserver(self, selector: #selector(dataManagerRestoredObserver), name: DataManagerDidRestoreNotificationName, object: nil)
        layout()
    }
    
    func layout() {
        let newImageButtonCornerRadius = newImageButton.frame.height / 2.0
        newImageButton.layer.cornerRadius = newImageButtonCornerRadius
        profileImageView.layer.cornerRadius = newImageButtonCornerRadius
        profileImageView.layer.masksToBounds = true
        gcdButton.layer.borderWidth = 1.0
        gcdButton.layer.borderColor = UIColor.black.cgColor
        gcdButton.layer.cornerRadius = 12.0
        operationButton.layer.borderWidth = 1.0
        operationButton.layer.borderColor = UIColor.black.cgColor
        operationButton.layer.cornerRadius = 12.0
        
        GCDDataManager.shared.restore()
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
    
    
    @IBAction func onSaveButtonTap(_ sender: UIButton) {
        let dataManagerOptions: [Int: DataManagerProtocol] = [
            1: GCDDataManager.shared,
            2: OperationDataManager.shared
        ]
        
        let newName = nameTextField.text
        let newInfo = descriptionTextView.text
        let newImage = profileImageView.image
        
        guard let dataManager = dataManagerOptions[sender.tag] else { fatalError("unknown data manager button tag") }
        
        if ProfileManager.shared.update(name: newName, info: newInfo, image: newImage) {
            dataManager.save()
        }
    }
    
    @objc func dataManagerSavedObserver(notification: Notification) {
        let success = notification.userInfo?["success"] as? Bool
        if let success = success, success {
            let alertVC = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                if let sender = notification.userInfo?["sender"] as? DataManagerProtocol {
                    sender.save()
                }
            }))
        }
    }
    
    @objc func dataManagerRestoredObserver(notification: Notification) {
        nameTextField.text = ProfileManager.shared.name ?? "My name"
        descriptionTextView.text = ProfileManager.shared.info ?? "About myself"
        profileImageView.image = ProfileManager.shared.image ?? profileImageView.image
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

extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            wrapperTopConstraint.constant = 0
            wrapperBottomConstraint.constant = 0
            bottomView.isHidden = false
        } else {
            wrapperTopConstraint.constant -= keyboardViewEndFrame.height
            wrapperBottomConstraint.constant += keyboardViewEndFrame.height
            bottomView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}
