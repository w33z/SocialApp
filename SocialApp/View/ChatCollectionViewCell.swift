//
//  ChatCollectionViewCell.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 14.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    lazy var messageBG: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = AVENIR_MEDIUM
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addViews(){
  
        addSubview(messageBG)
        messageBG.addSubview(messageTextView)
        messageBG.addSubview(avatarImage)
    }
    
    var avatarImageLeadingAnchor: NSLayoutConstraint?
    var avatarImageTrailingAnchor: NSLayoutConstraint?
    var messageBGWidthAnchor: NSLayoutConstraint?
    var messageBGLeftRightAnchor: NSLayoutConstraint?
    var messageBGRightLeftAnchor: NSLayoutConstraint?
    var messageTextViewLeftAnchor: NSLayoutConstraint?
    var messageTextViewRightAnchor: NSLayoutConstraint?
    var messageTextViewLeftAnchorConstant: NSLayoutConstraint?
    var messageTextViewRightAnchorConstant: NSLayoutConstraint?
    
    fileprivate func addConstraints(){
        
        avatarImageTrailingAnchor = avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        avatarImageLeadingAnchor = avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25)
    
        avatarImage.addConstraints([
//            equal(contentView, \.trailingAnchor, constant: -25),
//            equal(contentView, \.leadingAnchor, constant: 25),
            equal(contentView, \.topAnchor),
            equal(\.heightAnchor, to: 40),
            equal(\.widthAnchor, to: 40)
            ])
        
        messageBGWidthAnchor = messageBG.widthAnchor.constraint(equalToConstant: 300)
        messageBGWidthAnchor?.isActive = true
        
        messageBGRightLeftAnchor = messageBG.rightAnchor.constraint(equalTo: avatarImage.leftAnchor, constant: 18)
        messageBGLeftRightAnchor = messageBG.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: -18)
        
        messageBG.addConstraints([
//            equal(contentView, \.leadingAnchor, constant: 25),
//            equal(avatarImage, \.rightAnchor, \.leftAnchor, constant: 18),
//            equal(avatarImage, \.leftAnchor, \.rightAnchor, constant: -18),
            equal(contentView, \.topAnchor),
            equal(contentView, \.bottomAnchor)
            ])
        
        messageTextViewLeftAnchor = messageTextView.leftAnchor.constraint(equalTo: messageBG.leftAnchor)
        messageTextViewRightAnchor = messageTextView.rightAnchor.constraint(equalTo: messageBG.rightAnchor)
        messageTextViewLeftAnchorConstant = messageTextView.leftAnchor.constraint(equalTo: messageBG.leftAnchor, constant: 35)
        messageTextViewRightAnchorConstant = messageTextView.rightAnchor.constraint(equalTo: messageBG.rightAnchor, constant: -35)
        
        messageTextView.addConstraints([
//            equal(messageBG,\.leftAnchor, constant: 35),
//            equal(messageBG,\.leftAnchor),
            equal(messageBG,\.topAnchor),
            equal(messageBG,\.bottomAnchor),
//            equal(messageBG, \.rightAnchor, constant: -35)
//            equal(messageBG, \.rightAnchor)
            ])
    } 
    
    func configureCell(_ message: Message,_ userProfileImageURL: String){
        avatarImage.loadImageUsingCache(urlString: userProfileImageURL)
        messageTextView.text = message.text
    }
}
