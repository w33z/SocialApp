//
//  AuthViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AuthViewController: UIViewController {
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Bg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginForm: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "EMAIL", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM
        ])
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.font = AVENIR_MEDIUM
        textField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        ])
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
    
    private let usernameSeparationLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private let passwordSeparationLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        let attributtedTitle = NSAttributedString(string: "Get Started", attributes: [
            NSAttributedStringKey.foregroundColor : UIColor.black,
            ])
        button.setAttributedTitle(attributtedTitle, for: .normal)
        button.addTarget(self, action: #selector(loginButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.9196777344, blue: 0.2715115017, alpha: 1)
        return button
    }()

    private let registrationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        let attributtedTitle = NSAttributedString(string: "Create Account", attributes: [
            NSAttributedStringKey.foregroundColor : UIColor.black,
        ])
        button.setAttributedTitle(attributtedTitle, for: .normal)
        button.addTarget(self, action: #selector(registrationButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
        
        self.moveViewWithKeyboard()
        setUpView()
        setUpConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        
        logoImage.addConstraints([
            equal(view, \.topAnchor,\.topAnchor, constant: 50),
            equal(\.heightAnchor, to: 200),
            equal(view, \.leadingAnchor, constant: 50),
            equal(view, \.trailingAnchor, constant: -50)
            ])
        
        loginForm.addConstraints([
            equal(logoImage, \.topAnchor,\.bottomAnchor, constant: 30),
            equal(view, \.leadingAnchor, constant: 25),
            equal(view, \.trailingAnchor, constant: -25),
            equal(\.heightAnchor, to: 300)
            ])
        
        usernameLabel.addConstraints([
            equal(loginForm, \.topAnchor,\.topAnchor, constant: 35),
            equal(loginForm, \.leadingAnchor, constant: 40),
            equal(loginForm, \.trailingAnchor, constant: -40),
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
        
        passwordLabel.addConstraints([
            equal(usernameSeparationLine, \.topAnchor,\.bottomAnchor, constant: 35),
            equal(usernameSeparationLine, \.leadingAnchor),
            equal(usernameSeparationLine, \.trailingAnchor),
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
        
        loginButton.addConstraints([
            equal(loginForm, \.bottomAnchor),
            equal(loginForm, \.leadingAnchor),
            equal(loginForm, \.trailingAnchor),
            equal(\.heightAnchor, to: 65)
            ])
        
        registrationButton.addConstraints([
            equal(loginForm, \.topAnchor,\.bottomAnchor, constant: 15),
            equal(view, \.leadingAnchor, constant: 50),
            equal(view, \.trailingAnchor, constant: -50),
            equal(\.heightAnchor, to: 50)
            ])
    }

    fileprivate func setUpView() {
        view.addSubview(backgroundImage)
        view.addSubview(logoImage)
        view.addSubview(loginForm)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(usernameSeparationLine)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordSeparationLine)
        view.addSubview(loginButton)
        view.addSubview(registrationButton)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc fileprivate func loginButtonAction(_ sender: UIButton) {
        
        guard let usernameField = usernameTextField.text,let passwordField = passwordTextField.text else { return }
        
        if usernameField != "" && passwordField != "" {
            DispatchQueue.global(qos: .userInitiated).async {
//                SVProgressHUD.show()
                DispatchQueue.main.async {
                    SVProgressHUD.show()

                    AuthService.instance.loginUser(email: usernameField, password: passwordField, loginComplete: { (success, error) in
                        if success {
                            SVProgressHUD.dismiss()
                            self.present(UINavigationController(rootViewController: HomeViewController()), animated: true, completion: nil)
                        } else {
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    
    
    @objc fileprivate func registrationButtonAction(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
