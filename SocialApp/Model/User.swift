//
//  User.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 12.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation

class User {
    private var _userID: String!
    private var _username: String!
    private var _email: String!
    private var _profileImageURL: String!
    private var _gender: String!
    private var _birthday: String!
    
    var userID: String! {
        return _userID
    }
    
    var username: String! {
        return _username
    }
    
    var email: String! {
        return _email
    }
    
    var profileImageURL: String! {
        return _profileImageURL
    }
    
    var gender: String! {
        return _gender
    }
    
    var birthday: String! {
        return _birthday
    }
    
    init(userID: String, username: String, email: String, profileImage: String, gender: String,birthday: String) {
        self._userID = userID
        self._username = username
        self._email = email
        self._profileImageURL = profileImage
        self._gender = gender
        self._birthday = birthday
    }
    
}
