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
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    var user: User?
    var photos = [Photo]()
    var imagePicker: UIImagePickerController!
    var timer: Timer?
    
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
        view.layer.masksToBounds = true
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
    
    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "addPhoto"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.9196777344, blue: 0.2715115017, alpha: 1)
        button.isHidden = true
        button.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        layout.cellPadding = 3
        layout.numberOfColumns = 2
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(ProfilePhotosCollectionViewCell.self, forCellWithReuseIdentifier: PROFILE_PHOTOS_COLLECTIONVIEW_CELL)
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        addViews()
        addConstraints()
        
        if user?.userID == nil {
            followButton.isHidden = true
            
            guard let uid = Auth.auth().currentUser?.uid else { return }

            UserService.instance.getUser(toID: uid) { (user) in
                self.user = user
                self.configureProfile(user)
            }
            
            downloadPhotos(uid: uid)
            addPhotoButton.isHidden = false
        }else {
            downloadPhotos(uid: user!.userID!)
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
        
        view.addSubview(photosCollectionView)
        backView.addSubview(followButton)
        backView.addSubview(addPhotoButton)
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
        
        addPhotoButton.addConstraints([
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
    
    @objc fileprivate func showImagePicker(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleTimer(){
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
    }
    
    fileprivate func downloadPhotos(uid: String){
        DataService.instance.fetchUserPhotos(uid: uid) { (photos) in
            self.photos = photos.reversed()
            
            //To reduce profile image bugs
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: false)
        }
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
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_PHOTOS_COLLECTIONVIEW_CELL, for: indexPath) as! ProfilePhotosCollectionViewCell
        
        let image = photos[indexPath.item]
        
        cell.configureCell(image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfilePhotosCollectionViewCell
        let selectedImageView = cell.profileImage
        handleZoomInImageView(selectedImageView)
    }
}

extension ProfileViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        
        let imageView = UIImageView()
        
        if let imageURL = photos[indexPath.item].imageURL {
            imageView.loadImageUsingCache(urlString: imageURL)
        }
        
        guard let image = imageView.image else { return 120 }
        return image.height(forWidth: withWidth)
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        
        guard let description = photos[indexPath.item].description else { return 20 }

        return description.heightForWidth(width: withWidth, font: AVENIR_BOOK)
    }
}

extension ProfileViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage
            ] as? UIImage{
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let selectedImage = selectedImage {
//            avatarChangeButton.setImage(selectedImage, for: .normal)
            
            let alert = UIAlertController(title: "New photo!", message: "Add description to your photo", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Description..."
            })
            alert.addAction(UIAlertAction(title: "Upload", style: .default, handler: { (alertAction) in
                guard let description = alert.textFields![0].text else { return }

                DispatchQueue.global(qos: .userInteractive).async {
                    SVProgressHUD.show()
                    DispatchQueue.main.async {
                        DataService.instance.uploadUserPhotos(profileImage: selectedImage,text: description, handler: { (complete) in
                            if complete {
                                SVProgressHUD.dismiss()
                                self.photosCollectionView.reloadData()
                            } else {
                                print("Photo uploading error")
                            }
                        })
                    }
                }
            }))
            picker.dismiss(animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


