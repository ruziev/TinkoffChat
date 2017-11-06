//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/09/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    var profileManager: IProfileManager = ProfileManager()
    lazy var dataManager: IDataManager = profileManager
    @IBOutlet weak var newImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let imagePicker = UIImagePickerController()
    
    var inputDataChanged: Bool = false {
        didSet {
            if inputDataChanged && !processingDataManager {
                enableButtons()
            } else {
                disableButtons()
            }
        }
    }
    
    var processingDataManager: Bool = false {
        didSet {
            if inputDataChanged && !processingDataManager {
                enableButtons()
            } else {
                disableButtons()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        imagePicker.delegate = self
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        
        addObserversForKeyboardAppearance()
        
        layout()
    }
    
    // CLOSE THIS MODAL SCREEN
    @IBAction func onCloseScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // NEXT -> UI CHANGES
    func layout() {
        let newImageButtonCornerRadius = newImageButton.frame.height / 2.0
        newImageButton.layer.cornerRadius = newImageButtonCornerRadius
        profileImageView.layer.cornerRadius = newImageButtonCornerRadius
        profileImageView.layer.masksToBounds = true
        disableButtons()
        dataManager.restore()
        activityIndicator.startAnimating()
    }
    
    func enableButtons() {
        saveButton.isEnabled = true
    }
    func disableButtons() {
        saveButton.isEnabled = false
    }
    
}

// SAVING DATA STAFF
extension ProfileVC: IDataManagerDelegate {
    func didRestore(_ dataManager: IDataManager, restored: IProfileManager?) {
        activityIndicator.stopAnimating()
        nameTextField.text = profileManager.name ?? "My name"
        descriptionTextView.text = profileManager.info ?? "About myself"
        profileImageView.image = profileManager.image ?? profileImageView.image
    }
    
    @IBAction func onSaveButtonTap(_ sender: UIButton) {
        let newName = nameTextField.text
        let newInfo = descriptionTextView.text
        let newImage = profileImageView.image
        
        let dataManager = profileManager
        
        if profileManager.update(name: newName, info: newInfo, image: newImage) {
            activityIndicator.startAnimating()
            dataManager.save(profileManager)
            processingDataManager = true
        }
    }
    
    func didSave(_ dataManager: IDataManager, success: Bool) {
        if success {
            activityIndicator.stopAnimating()
            let alertVC = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
            processingDataManager = false
            inputDataChanged = false
        } else {
            let alertVC = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.activityIndicator.stopAnimating()
                self.processingDataManager = false
            }))
            alertVC.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                dataManager.save(self.profileManager)
            }))
        }
    }
}


// IMAGE PICKING STAFF
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = pickedImage
            enableButtons()
        }
        
        dismiss(animated: true, completion: nil)
    }
}


// TEXT INPUT STUFF
extension ProfileVC: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        inputDataChanged = true
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            inputDataChanged = true
            return false
        }
        return true
    }
}
