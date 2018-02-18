//
//  RegisterViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import ABSteppedProgressBar
import DLRadioButton
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    var array: [DLRadioButton] = []
    var imagePicker: UIImagePickerController!
    var selectedBirthDayDate: String = ""
    var genderValue: String! = "Male"

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Bg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let registerForm: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    private let avatarChangeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Avatar"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleAvatarPicker), for: .touchUpInside)
        return button
    }()
    
    private let uploadPhotoLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Upload Photo", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM.withSize(18),
            NSAttributedStringKey.underlineColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            ])
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "EMAIL", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM
            ])
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = AVENIR_MEDIUM
        textField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            ])
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "PASSWORD", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM
            ])
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = AVENIR_MEDIUM
        textField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            ])
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "USERNAME", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM
            ])
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.font = AVENIR_MEDIUM
        textField.attributedPlaceholder = NSAttributedString(string: "Username...", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            ])
        return textField
    }()
    
    private let emailSeparationLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private let passwordSeparationLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private let usernameSeparationLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "GENDER", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM
            ])
        return label
    }()
    
    private let checkBoxMale: DLRadioButton = {
        let checkBox = DLRadioButton()
        checkBox.iconColor = #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
        checkBox.indicatorColor = #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
        checkBox.tintColor = #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
        let title = NSAttributedString(string: "Male", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
            ])
        checkBox.setAttributedTitle(title, for: [])
        checkBox.isMultipleSelectionEnabled = true
        checkBox.addTarget(self, action: #selector(checkBoxValueChanged(_:)), for: .touchUpInside)
        checkBox.tag = 0
        checkBox.isSelected = true
        return checkBox
    }()
    
    private let checkBoxFemale: DLRadioButton = {
        let checkBox = DLRadioButton()
        checkBox.iconColor = #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
        checkBox.indicatorColor = #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
        checkBox.tintColor = #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
        let title = NSAttributedString(string: "Female", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
            ])
        checkBox.setAttributedTitle(title, for: [])
        checkBox.isMultipleSelectionEnabled = true
        checkBox.addTarget(self, action: #selector(checkBoxValueChanged(_:)), for: .touchUpInside)
        checkBox.tag = 1
        return checkBox
    }()
    
    private let birthDayLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "BIRTHDAY", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM
            ])
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dp.maximumDate = Date()
        return dp
    }()
    
    private let nextStepButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle("Next Step", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextStepButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.9196777344, blue: 0.2715115017, alpha: 1)
        return button
    }()
    
    private let finishStepButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle("Finish", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(finishStepButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.9196777344, blue: 0.2715115017, alpha: 1)
        return button
    }()
    
    private let progressControl: ABSteppedProgressBar = {
        let pc = ABSteppedProgressBar()
        pc.numberOfPoints = 2
        pc.lineHeight = 3
        pc.radius = 5
        pc.progressRadius = 10
        pc.progressLineHeight = 3
        pc.currentIndex = 0
        pc.backgroundShapeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2479666096)
        pc.selectedBackgoundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5023276969)
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        progressControl.delegate = self

        self.hideKeyboardWhenTappedAround()
        self.moveViewWithKeyboard()
        
        setUpView()
        setUpConstrains()
        
        array.append(checkBoxFemale)
        checkBoxMale.otherButtons = array

        selectedBirthDayDate = self.ownDateFormat(Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setUpConstrains() {
        backgroundImage.addConstraints([
            equal(view, \.topAnchor),
            equal(view, \.bottomAnchor),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor)
            ])
        
        registerForm.addConstraints([
            equal(view, \.topAnchor,\.safeAreaLayoutGuide.topAnchor, constant: 100),
            equal(view, \.leadingAnchor, constant: 25),
            equal(view, \.trailingAnchor, constant: -25),
            equal(view, \.bottomAnchor,\.safeAreaLayoutGuide.bottomAnchor, constant: -88),
            ])
        
        progressControl.addConstraints([
            equal(registerForm, \.leadingAnchor, constant: 100),
            equal(registerForm, \.trailingAnchor, constant: -100),
            equal(registerForm, \.topAnchor, \.bottomAnchor, constant: 20),
            equal(\.heightAnchor, to: 25)
            ])
        
        setUpFirstStepConstraints()
        setUpSecondStepConstraints()
    }
    var firstStep: [UIView] = []
    var secondStep: [UIView] = []
    
    fileprivate func setUpView() {
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.title = "Registration"
        
        view.addSubview(backgroundImage)
        view.addSubview(registerForm)
        
        firstStep = [avatarChangeButton,uploadPhotoLabel,emailLabel,emailTextField,emailSeparationLine,passwordLabel,passwordTextField,passwordSeparationLine,genderLabel,checkBoxMale,checkBoxFemale,nextStepButton]
        firstStep.forEach({ registerForm.addSubview($0)})
        firstStep.forEach({$0.isHidden = false})
        
        secondStep = [birthDayLabel,datePicker,usernameLabel,usernameTextField,usernameSeparationLine,finishStepButton]
        secondStep.forEach({ registerForm.addSubview($0)})
        secondStep.forEach({ $0.isHidden = true})
        
        view.addSubview(progressControl)

    }
    
    fileprivate func setUpFirstStepConstraints() {
        avatarChangeButton.addConstraints([
            equal(registerForm, \.topAnchor, \.topAnchor, constant: 35),
            equal(registerForm, \.leadingAnchor, constant: 35),
            equal(\.heightAnchor, to: 85),
            equal(\.widthAnchor, to: 85)
            ])
        
        uploadPhotoLabel.addConstraints([
            equal(avatarChangeButton, \.centerYAnchor),
            equal(registerForm, \.trailingAnchor, constant: -50),
            equal(\.heightAnchor, to: 30)
            ])
        
        emailLabel.addConstraints([
            equal(avatarChangeButton, \.topAnchor,\.bottomAnchor, constant: 35),
            equal(registerForm, \.leadingAnchor, constant: 40),
            equal(registerForm, \.trailingAnchor, constant: -40),
            ])
        
        emailTextField.addConstraints([
            equal(emailLabel, \.topAnchor,\.bottomAnchor, constant: 10),
            equal(emailLabel, \.leadingAnchor),
            equal(emailLabel, \.trailingAnchor),
            ])
        
        emailSeparationLine.addConstraints([
            equal(emailTextField, \.topAnchor,\.bottomAnchor, constant: 10),
            equal(emailTextField, \.leadingAnchor),
            equal(emailTextField, \.trailingAnchor),
            equal(\.heightAnchor, to: 1)
            ])
        
        passwordLabel.addConstraints([
            equal(emailSeparationLine, \.topAnchor,\.bottomAnchor, constant: 25),
            equal(emailSeparationLine, \.leadingAnchor),
            equal(emailSeparationLine, \.trailingAnchor),
            ])
        
        passwordTextField.addConstraints([
            equal(passwordLabel, \.topAnchor,\.bottomAnchor, constant: 10),
            equal(passwordLabel, \.leadingAnchor),
            equal(passwordLabel, \.trailingAnchor),
            ])
        
        passwordSeparationLine.addConstraints([
            equal(passwordTextField, \.topAnchor,\.bottomAnchor, constant: 10),
            equal(passwordTextField, \.leadingAnchor),
            equal(passwordTextField, \.trailingAnchor),
            equal(\.heightAnchor, to: 1)
            ])
        
        genderLabel.addConstraints([
            equal(passwordSeparationLine, \.topAnchor,\.bottomAnchor, constant: 25),
            equal(passwordSeparationLine, \.leadingAnchor),
            equal(passwordSeparationLine, \.trailingAnchor),
            ])
        
        checkBoxMale.addConstraints([
            equal(genderLabel, \.topAnchor,\.bottomAnchor, constant: 25),
            equal(passwordSeparationLine, \.leadingAnchor, constant: 25),
            equal(\.heightAnchor, to: 25),
            equal(\.widthAnchor, to: 55)
            ])
        
        checkBoxFemale.addConstraints([
            equal(genderLabel, \.topAnchor,\.bottomAnchor, constant: 25),
            equal(passwordSeparationLine, \.trailingAnchor,constant: -25),
            equal(\.heightAnchor, to: 25),
            equal(\.widthAnchor, to: 75)
            ])
        
        nextStepButton.addConstraints([
            equal(registerForm, \.bottomAnchor),
            equal(registerForm, \.leadingAnchor),
            equal(registerForm, \.trailingAnchor),
            equal(\.heightAnchor, to: 65)
            ])
    }
    
    fileprivate func setUpSecondStepConstraints() {
        
        birthDayLabel.addConstraints([
            equal(registerForm, \.topAnchor,\.topAnchor, constant: 35),
            equal(registerForm, \.leadingAnchor, constant: 40),
            equal(registerForm, \.trailingAnchor, constant: -40),
            ])
        
        datePicker.addConstraints([
            equal(birthDayLabel, \.topAnchor,\.topAnchor, constant: 15),
            equal(registerForm, \.leadingAnchor, constant: 20),
            equal(registerForm, \.trailingAnchor, constant: -20),
            ])
        
        usernameLabel.addConstraints([
            equal(datePicker, \.topAnchor,\.bottomAnchor, constant: 15),
            equal(birthDayLabel, \.leadingAnchor),
            equal(birthDayLabel, \.trailingAnchor),
            ])
        
        usernameTextField.addConstraints([
            equal(usernameLabel, \.topAnchor,\.bottomAnchor, constant: 10),
            equal(usernameLabel, \.leadingAnchor),
            equal(usernameLabel, \.trailingAnchor),
            ])
        
        usernameSeparationLine.addConstraints([
            equal(usernameTextField, \.topAnchor,\.bottomAnchor, constant: 10),
            equal(usernameTextField, \.leadingAnchor),
            equal(usernameTextField, \.trailingAnchor),
            equal(\.heightAnchor, to: 1)
            ])
        
        finishStepButton.addConstraints([
            equal(registerForm, \.bottomAnchor),
            equal(registerForm, \.leadingAnchor),
            equal(registerForm, \.trailingAnchor),
            equal(\.heightAnchor, to: 65)
            ])
    }
    
    @objc fileprivate func nextStepButtonAction(_ sender: UIButton){
        
        guard let emailField = emailTextField.text, let passwordField = passwordTextField.text else { return }
        
        if emailField != "" && passwordField != "" {

            progressControl.currentIndex += 1
            
            UIView.transition(with: registerForm, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.firstStep.forEach({$0.isHidden = true})
                self.secondStep.forEach({$0.isHidden = false})
            }, completion: nil)
        }
    }
    
    @objc fileprivate func finishStepButtonAction(_ sender: UIButton){
        guard let emailField = emailTextField.text, let passwordField = passwordTextField.text else { return }
 
        guard let userField = usernameTextField.text else { return }
        
        if userField != "" {
            
            let profileImage: UIImage
            
            if let currentImage = self.avatarChangeButton.currentImage {
                profileImage = currentImage
            } else {
                profileImage = #imageLiteral(resourceName: "Avatar")
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                SVProgressHUD.show()
                DispatchQueue.main.async {
                    AuthService.instance.registerUser(email: emailField, password: passwordField, username: userField, gender: self.genderValue, birthday: self.selectedBirthDayDate, profileImage: profileImage, userCreationComplete: { (success, error) in
                        if success {
                            SVProgressHUD.dismiss()
                            self.present(UINavigationController(rootViewController: HomeViewController()), animated: true, completion: nil)
                        } else {
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler:{ alert in
                                self.firstStep.forEach({$0.isHidden = false})
                                self.secondStep.forEach({$0.isHidden = true})
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }

    @objc fileprivate func checkBoxValueChanged(_ sender: DLRadioButton) {
        if sender.isSelected {
            genderValue = sender.titleLabel!.text!
            sender.deselectOtherButtons()
        } else {
            checkBoxMale.isSelected = true
        }
    }
    
    @objc fileprivate func handleAvatarPicker(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc fileprivate func datePickerValueChanged(_ sender: UIDatePicker) {
         selectedBirthDayDate = self.ownDateFormat(sender.date)
    }
}

extension RegisterViewController: ABSteppedProgressBarDelegate {
    
    func progressBar(_ progressBar: ABSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return false
    }
    
    func progressBar(_ progressBar: ABSteppedProgressBar, textAtIndex index: Int) -> String {
        let text:String
        switch index {
        case 0:
            text = "1"
        case 1:
            text = "2"
        default:
            text = ""
        }
        return text
    }
}

extension RegisterViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage
            ] as? UIImage{
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let selectedImage = selectedImage {
            avatarChangeButton.setImage(selectedImage, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

