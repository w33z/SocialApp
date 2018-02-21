//
//  ProfileViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 21.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Firebase
import PinterestLayout

class ProfileViewController: UIViewController {
    
    var user: User?
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Bg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 3
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 15
        view.layer.shouldRasterize = true
        return view
    }()
    
    private let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2)
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = AVENIR_MEDIUM.withSize(15)
        return label
    }()
    
    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Infromations"
        label.numberOfLines = 0
        label.font = AVENIR_MEDIUM.withSize(12)
        return label
    }()
    
    private let statsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.3)
        return view
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Likes", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
            ])
        label.textAlignment = .center
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Followers", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
            ])
        label.textAlignment = .center
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Following", attributes: [
            NSAttributedStringKey.font : AVENIR_MEDIUM,
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6926540799, green: 0.6320258247, blue: 0.8690863715, alpha: 1)
            ])
        label.textAlignment = .center
        return label
    }()
    
    private let likesCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = AVENIR_MEDIUM.withSize(16)
        return label
    }()
    
    private let followersCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = AVENIR_MEDIUM.withSize(16)
        return label
    }()
    
    private let followingCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = AVENIR_MEDIUM.withSize(16)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 22, left: 0, bottom: 22, right: 0)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.9196777344, blue: 0.2715115017, alpha: 1)
        return button
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        layout.cellPadding = 5
        layout.numberOfColumns = 2
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: PROFILE_PHOTOS_COLLECTIONVIEW_CELL)
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.layer.borderWidth = 5
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        addViews()
        addConstraints()
        
        if user?.userID == nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }

            UserService.instance.getUser(toID: uid) { (user) in
                self.user = user
                self.configureProfile(user)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavigationBar()
        navigationItem.title = "Profile"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addViews() {
        
        view.addSubview(backgroundImage)
        view.addSubview(backView)
        
        backView.addSubview(userProfileImage)
        backView.addSubview(usernameLabel)
        backView.addSubview(informationLabel)
        backView.addSubview(statsBackgroundView)
        
        statsBackgroundView.addSubview(likesLabel)
        statsBackgroundView.addSubview(followersLabel)
        statsBackgroundView.addSubview(followingLabel)
        statsBackgroundView.addSubview(likesCounterLabel)
        statsBackgroundView.addSubview(followersCounterLabel)
        statsBackgroundView.addSubview(followingCounterLabel)
        
        backView.addSubview(photosCollectionView)
        backView.addSubview(followButton)
    }
    
    fileprivate func addConstraints() {
        
        backgroundImage.addConstraints([
            equal(view, \.topAnchor),
            equal(view, \.bottomAnchor),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor)
            ])
        
        backView.addConstraints([
            equal(view, \.safeAreaLayoutGuide.topAnchor, constant: 45),
            equal(view, \.leadingAnchor, constant: 35),
            equal(view, \.trailingAnchor, constant: -35),
            equal(view, \.safeAreaLayoutGuide.bottomAnchor, constant: -45)
            ])
        
        userProfileImage.addConstraints([
            equal(backView, \.topAnchor, constant: 25),
            equal(backView, \.leadingAnchor, constant: 15),
            equal(\.heightAnchor, to: 100),
            equal(\.widthAnchor, to: 100)
            ])
        
        usernameLabel.addConstraints([
            equal(userProfileImage, \.topAnchor),
            equal(userProfileImage, \.leftAnchor, \.rightAnchor, constant: 15),
            equal(backView, \.trailingAnchor)
            ])
        
        informationLabel.addConstraints([
            equal(usernameLabel, \.topAnchor, \.bottomAnchor, constant: 0),
            equal(usernameLabel, \.leftAnchor),
            equal(usernameLabel, \.trailingAnchor),
            equal(\.heightAnchor, to: 100)
            ])
        
        statsBackgroundView.addConstraints([
            equal(userProfileImage, \.topAnchor, \.bottomAnchor, constant: 35),
            equal(backView, \.leadingAnchor),
            equal(backView, \.trailingAnchor),
            equal(\.heightAnchor, to: 65)
            ])

        let width = (view.frame.width - 70) / 3
        
        likesLabel.addConstraints([
            equal(statsBackgroundView, \.topAnchor, constant: 10),
            equal(statsBackgroundView, \.leadingAnchor),
            equal(\.widthAnchor, to: width),
            ])
        
        followersLabel.addConstraints([
            equal(likesLabel, \.centerYAnchor),
            equal(statsBackgroundView, \.centerXAnchor),
            equal(\.widthAnchor, to: width),
            ])

        followingLabel.addConstraints([
            equal(followersLabel, \.centerYAnchor),
            equal(statsBackgroundView, \.rightAnchor),
            equal(\.widthAnchor, to: width)
            ])
        
        likesCounterLabel.addConstraints([
            equal(likesLabel, \.topAnchor, \.bottomAnchor, constant: 5),
            equal(likesLabel, \.centerXAnchor),
            equal(likesLabel, \.widthAnchor)
            ])
        
        followersCounterLabel.addConstraints([
            equal(followersLabel, \.topAnchor, \.bottomAnchor, constant: 5),
            equal(followersLabel, \.centerXAnchor),
            equal(followersLabel, \.widthAnchor)
            ])
        
        followingCounterLabel.addConstraints([
            equal(followingLabel, \.topAnchor, \.bottomAnchor, constant: 5),
            equal(followingLabel, \.centerXAnchor),
            equal(followingLabel, \.widthAnchor)
            ])
        
        followButton.addConstraints([
            equal(backView, \.bottomAnchor),
            equal(backView, \.leadingAnchor),
            equal(backView, \.trailingAnchor),
            equal(\.heightAnchor, to: 60)
            ])

        photosCollectionView.addConstraints([
            equal(statsBackgroundView, \.topAnchor, \.bottomAnchor, constant: 0),
            equal(view, \.leadingAnchor, constant: 15),
            equal(view, \.trailingAnchor, constant: -15),
            equal(followButton, \.bottomAnchor, \.topAnchor, constant: 0)
            ])
    }
    
    func configureProfile(_ user: User) {
        
        guard let username = user.username, let gender = user.gender, let birthday = user.birthday, let imageprofileURL = user.profileImageURL else { return }
        
        usernameLabel.text = username
        informationLabel.text = """
        Gender: \n\(String(describing: gender))\n
        Birthday: \n\(String(describing: birthday))
        """
        
        userProfileImage.loadImageUsingCache(urlString: imageprofileURL)
    }
}

extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_PHOTOS_COLLECTIONVIEW_CELL, for: indexPath)
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
}

extension ProfileViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 50
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 40
    }
}

