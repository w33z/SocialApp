//
//  ProfilePhotosCollectionViewCell.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 22.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class ProfilePhotosCollectionViewCell: UICollectionViewCell {
    
    private let roundedBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AVENIR_BOOK.withSize(10)
        label.text = "Desctription Text"
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.25)
        label.numberOfLines = 0
        return label
    }()
    
    var imageHeightLayoutConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addViews() {
        addSubview(roundedBackground)
        roundedBackground.addSubview(profileImage)
        roundedBackground.addSubview(descriptionLabel)
    }
    
    var descriptionLabelHeightAnchor: NSLayoutConstraint?
    
    fileprivate func addConstraints() {
        roundedBackground.addConstraints([
            equal(contentView, \.topAnchor),
            equal(contentView, \.leadingAnchor),
            equal(contentView, \.trailingAnchor),
            equal(contentView, \.bottomAnchor)
            ])
        
        descriptionLabel.addConstraints([
            equal(contentView, \.leadingAnchor),
            equal(contentView, \.trailingAnchor),
            equal(contentView, \.bottomAnchor),
//            equal(\.heightAnchor, to: 20)
            ])
        
        descriptionLabelHeightAnchor = descriptionLabel.heightAnchor.constraint(equalToConstant: 20)
        
        profileImage.addConstraints([
            equal(contentView, \.topAnchor),
            equal(contentView, \.leadingAnchor),
            equal(contentView, \.trailingAnchor),
            equal(descriptionLabel, \.bottomAnchor, \.topAnchor, constant: 0)
            ])
    }
    
    func configureCell(_ photo: Photo) {
        guard let imageURL = photo.imageURL, let description = photo.description else { return }
        
        profileImage.loadImageUsingCache(urlString: imageURL)
        descriptionLabel.text = description
    }
}
