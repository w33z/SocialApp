//
//  ChooseUserTableViewCell.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 12.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class ChooseUserTableViewCell: UITableViewCell {
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2027771832)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addView()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addView() {
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.1)
        
        addSubview(avatarImage)
        addSubview(usernameLabel)
    }
    
    fileprivate func addConstraints() {
        
        avatarImage.addConstraints([
            equal(contentView, \.topAnchor, \.topAnchor, constant: 10),
            equal(contentView, \.leadingAnchor, constant: 35),
            equal(\.heightAnchor, to: 50),
            equal(\.widthAnchor, to: 50)
            ])
        
        usernameLabel.addConstraints([
            equal(avatarImage, \.centerYAnchor),
            equal(avatarImage, \.leftAnchor, \.rightAnchor, constant: 35),
            equal(contentView, \.trailingAnchor)
            ])
    }
    
    func configureCell(_ user: User) {
        usernameLabel.text = user.username
        avatarImage.loadImageUsingCache(urlString: user.profileImageURL!)
    }
    
}
