//
//  MenuViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 19.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Firebase

class MenuViewController: UIViewController {
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let menuButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundColor(#colorLiteral(red: 0.7058823529, green: 0.6431372549, blue: 0.8509803922, alpha: 1), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(homeButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let messagesButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Messages"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundColor(#colorLiteral(red: 0.7058823529, green: 0.6431372549, blue: 0.8509803922, alpha: 1), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(messagesButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Profile"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundColor(#colorLiteral(red: 0.7058823529, green: 0.6431372549, blue: 0.8509803922, alpha: 1), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(profileButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let captureButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Capture"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundColor(#colorLiteral(red: 0.7058823529, green: 0.6431372549, blue: 0.8509803922, alpha: 1), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(captureButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundColor(#colorLiteral(red: 0.7058823529, green: 0.6431372549, blue: 0.8509803922, alpha: 1), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        button.addTarget(self, action: #selector(settingButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        let attributedText = NSAttributedString(string: "Logout", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.5376499891, green: 0.9457976222, blue: 0.8239424825, alpha: 1),
            NSAttributedStringKey.font : AVENIR_MEDIUM
            ])
    
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        addConstrains()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addViews(){
        view.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.9450980392, blue: 0.8235294118, alpha: 1)
        
        view.addSubview(dismissButton)
        
        menuButtonStackView.addArrangedSubview(homeButton)
        menuButtonStackView.addArrangedSubview(messagesButton)
        menuButtonStackView.addArrangedSubview(profileButton)
        menuButtonStackView.addArrangedSubview(captureButton)
        menuButtonStackView.addArrangedSubview(settingsButton)
        
        view.addSubview(menuButtonStackView)
        view.addSubview(logoutButton)
    }
    
    fileprivate func addConstrains(){
        
        dismissButton.addConstraints([
            equal(view, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 15),
            equal(view, \.leadingAnchor, constant: 35),
            equal(\.heightAnchor, to: 20),
            equal(\.widthAnchor, to: 20)
            ])
        
        logoutButton.addConstraints([
            equal(view, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            equal(view, \.leadingAnchor, constant: 35),
            equal(view, \.trailingAnchor, constant: -35),
            equal(\.heightAnchor, to: 50)
            ])
        
        menuButtonStackView.addConstraints([
            equal(dismissButton, \.topAnchor,\.bottomAnchor, constant: 50),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor),
            equal(logoutButton, \.bottomAnchor, \.topAnchor, constant: -50)
            ])
    }

    @objc fileprivate func dismissButtonAction(_ sender: UIButton) {
        if let slideMenuController = slideMenuController() {
            slideMenuController.closeLeft()
        }
    }
    
    @objc fileprivate func homeButtonAction(_ sender: UIButton){
        let homeVC = HomeCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navHomeVC = UINavigationController(rootViewController: homeVC)
        slideMenuController()?.changeMainViewController(navHomeVC, close: true)
    }
    
    @objc fileprivate func messagesButtonAction(_ sender: UIButton){
        let messageVC = MessageViewController()
        let navMessageVC = UINavigationController(rootViewController: messageVC)
        slideMenuController()?.changeMainViewController(navMessageVC, close: true)
    }
    
    @objc fileprivate func profileButtonAction(_ sender: UIButton){
        let profileVC = ProfileViewController()
        let navProfileVC = UINavigationController(rootViewController: profileVC)
        slideMenuController()?.changeMainViewController(navProfileVC, close: true)
    }
    
    @objc fileprivate func captureButtonAction(_ sender: UIButton){
        print("captur")
    }
    
    @objc fileprivate func settingButtonAction(_ sender: UIButton){
        print("sett")
        
        //testing profileVC
        UserService.instance.getUser(toID: "avLjQ8VGqFX9J9tge3CEYZcfyoE2") { (user) in
            let profileVC = ProfileViewController()
            profileVC.user = user
            profileVC.configureProfile(user)
            let navProfileVC = UINavigationController(rootViewController: profileVC)
            self.slideMenuController()?.changeMainViewController(navProfileVC, close: true)
        }
        
    }
    
    @objc fileprivate func logoutButtonAction(_ sender: UIButton){
        do {
            try Auth.auth().signOut()
            let authVC = AuthViewController()
            present(authVC, animated: true, completion: nil)
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
