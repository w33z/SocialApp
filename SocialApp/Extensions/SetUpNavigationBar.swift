//
//  SetUpNavigationBar.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 21.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setUpNavigationBar() {
        let menuButton: UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            button.contentMode = .scaleAspectFill
            return button
        }()
        
        menuButton.addConstraints([
            equal(\.heightAnchor, to: 15),
            equal(\.widthAnchor, to: 15)
            ])
        
        let menuButtonNavigation = UIBarButtonItem(customView: menuButton)
        let tap = UITapGestureRecognizer(target: self, action: #selector(menuButtonAction(_:)))
        menuButtonNavigation.customView?.addGestureRecognizer(tap)
        navigationItem.setLeftBarButton(menuButtonNavigation, animated: true)
    }
    
    @objc fileprivate func menuButtonAction(_ gesture: UIGestureRecognizer){
        if let slideMenuController = slideMenuController() {
            slideMenuController.openLeft()
        }
    }
}
