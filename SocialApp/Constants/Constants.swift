//
//  Constants.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Firebase

// Firebase References
let STORAGE_REF = Storage.storage().reference()
let DB_BASE = Database.database().reference()

//Fonts
let AVENIR_MEDIUM = UIFont(name: "Avenir-Medium", size: 14)!
let AVENIR_BLACK = UIFont(name: "Avenir-Black", size: 14)!

// cells Reuse Identifiers
let ALL_CHAT_MESSAGES_CELL_TABLEVIEW = "allChatMessagesCell"
let CHOOSEUSER_CELL_TABLEVIEW = "userChooseCell"
let CHAT_COLLECTIONVIEW_CELL = "chatCell"
let PROFILE_PHOTOS_COLLECTIONVIEW_CELL = "profilePhotosCell"
