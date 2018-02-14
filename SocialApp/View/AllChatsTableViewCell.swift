//
//  AllChatsTableViewCell.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 11.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Firebase

class AllChatsTableViewCell: UITableViewCell {
    
    private let avatarPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2027771832)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let senderTitle: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM
        label.textColor = #colorLiteral(red: 0.7531887889, green: 0.6876951456, blue: 0.9077157378, alpha: 1)
        label.text = "Username"
        return label
    }()
    
    private let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM.withSize(10)
        label.textColor = #colorLiteral(red: 0.7531887889, green: 0.6876951456, blue: 0.9077157378, alpha: 1)
        label.text = "2 days ago"
        label.textAlignment = .right
        return label
    }()
    
    private let messageText: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Text"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func addViews(){
        backgroundColor = UIColor.clear
        
        addSubview(avatarPicture)
        addSubview(senderTitle)
        addSubview(timeAgoLabel)
        addSubview(messageText)
    }
    
    fileprivate func setUpConstraints(){
        
        avatarPicture.addConstraints([
            equal(contentView, \.topAnchor, \.bottomAnchor, constant: 10),
            equal(contentView, \.leadingAnchor, constant: 35),
            equal(\.heightAnchor, to: 50),
            equal(\.widthAnchor, to: 50)
            ])
        
        senderTitle.addConstraints([
            equal(contentView, \.topAnchor, \.bottomAnchor, constant: 15),
            equal(avatarPicture, \.leftAnchor, \.rightAnchor, constant: 15),
            equal(\.heightAnchor, to: 20),
            equal(\.widthAnchor, to: 120)
            ])

        timeAgoLabel.addConstraints([
            equal(senderTitle, \.centerYAnchor),
            equal(senderTitle, \.leftAnchor, \.rightAnchor, constant: 15),
            equal(\.heightAnchor, to: 20),
            equal(\.widthAnchor, to: 100)
            ])
        
        messageText.addConstraints([
            equal(senderTitle, \.topAnchor, \.bottomAnchor, constant: 10),
            equal(avatarPicture, \.leftAnchor, \.rightAnchor, constant: 15),
            equal(\.heightAnchor, to: 20),
            equal(\.widthAnchor, to: 220)
            ])
    }
    
    func configureCell(_ message: Message){
        
        if let id = message.getChatPartnerID() {
            DataService.instance.getUserData(toID: id, handler: { (userData) in
                self.senderTitle.text = userData["username"] as? String
                if let url = userData["profileImageURL"] as? String {
                    self.avatarPicture.loadImageUsingCache(urlString: url)
                }
            })
            
        }

        timeAgoLabel.text = messageDataFormat(message.timestamp!)
        messageText.text = message.text
    }
    

}
