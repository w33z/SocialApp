//
//  NewMessageCollectionViewCell.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 11.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class NewMessageCollectionViewCell: UICollectionViewCell {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM.withSize(16)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Title"
        label.numberOfLines = 2
        return label
    }()
    
    private let cellSeparationLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private let avatarPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2027771832)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let senderLabel: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Name Surname"
        return label
    }()
    
    private let timeDeliveryLabel: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM
        label.textColor = #colorLiteral(red: 0.7531887889, green: 0.6876951456, blue: 0.9077157378, alpha: 1)
        label.text = "Just Now"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func addViews(){
        configureCornerRadius()
        
        addSubview(headerLabel)
        addSubview(cellSeparationLine)
        addSubview(avatarPicture)
        addSubview(senderLabel)
        addSubview(timeDeliveryLabel)
    }
    
    fileprivate func setUpConstraints(){
        
        headerLabel.addConstraints([
            equal(contentView, \.topAnchor, constant: 15),
            equal(contentView, \.leadingAnchor, constant: 35),
            equal(contentView, \.trailingAnchor, constant: -35),
            equal(\.heightAnchor, to: 50)
            ])
        
        cellSeparationLine.addConstraints([
            equal(headerLabel, \.topAnchor, \.bottomAnchor, constant: 5),
            equal(contentView, \.leadingAnchor, constant: 35),
            equal(contentView, \.trailingAnchor, constant: -35),
            equal(\.heightAnchor, to: 1)
            ])
        
        avatarPicture.addConstraints([
            equal(cellSeparationLine, \.topAnchor, \.bottomAnchor, constant: 15),
            equal(cellSeparationLine, \.leadingAnchor, constant: -10),
            equal(\.heightAnchor, to: 60),
            equal(\.widthAnchor, to: 60)
            ])
        
        senderLabel.addConstraints([
            equal(avatarPicture, \.topAnchor, \.topAnchor, constant: 10),
            equal(avatarPicture, \.leftAnchor, \.rightAnchor, constant: 20),
            equal(\.heightAnchor, to: 20),
            equal(\.widthAnchor, to: 150)
            ])
        
        timeDeliveryLabel.addConstraints([
            equal(senderLabel, \.topAnchor, \.bottomAnchor, constant: 5),
            equal(avatarPicture, \.leftAnchor, \.rightAnchor, constant: 20),
            equal(\.heightAnchor, to: 20),
            equal(\.widthAnchor, to: 150)
            ])
    }
    
    fileprivate func configureCornerRadius() {
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        layer.masksToBounds = true
    }
    
    func configureCell(_ message: Message){
        
        if let id = message.getChatPartnerID() {
            UserService.instance.getUserData(toID: id, handler: { (userData) in
                self.senderLabel.text = userData["username"] as? String
                if let url = userData["profileImageURL"] as? String {
                    self.avatarPicture.loadImageUsingCache(urlString: url)
                }
            })
        }
        
        timeDeliveryLabel.text = messageDataFormat(message.timestamp!)
        headerLabel.text = message.text
    }
}
