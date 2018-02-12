//
//  DataService.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_STORAGE = STORAGE_REF
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_STORAGE: StorageReference {
        return _REF_STORAGE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createDBUser(uid: String,userData: Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func fetchDBUsers(handler: @escaping (_ users: [User]) -> ()){
        REF_USERS.observe(.value, with: { (snapshot) in
            
            var userArray = [User]()
            
            guard let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usersSnapshot {
                let username = user.childSnapshot(forPath: "username").value as! String
                let email = user.childSnapshot(forPath: "email").value as! String
                let avatar = user.childSnapshot(forPath: "profileImageURL").value as! String
                let gender = user.childSnapshot(forPath: "gender").value as! String
                let birthday = user.childSnapshot(forPath: "birthday").value as! String
                
                let userTemp = User(username: username, email: email, profileImage: avatar, gender: gender, birthday: birthday)
                userArray.append(userTemp)
            }
            
            handler(userArray)

        }, withCancel: nil)
    }
    
    
    
}
