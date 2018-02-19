//
//  UserService.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 18.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    static let instance = UserService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createDBUser(uid: String,userData: Dictionary<String,AnyObject>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func fetchDBUsers(handler: @escaping (_ users: [User]) -> ()){
        REF_USERS.observe(.value, with: { (snapshot) in
            
            var userArray = [User]()
            
            guard let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usersSnapshot {
                let userID = user.key
                let username = user.childSnapshot(forPath: "username").value as! String
                let email = user.childSnapshot(forPath: "email").value as! String
                let avatar = user.childSnapshot(forPath: "profileImageURL").value as! String
                let gender = user.childSnapshot(forPath: "gender").value as! String
                let birthday = user.childSnapshot(forPath: "birthday").value as! String
                
                let userTemp = User(userID: userID, username: username, email: email, profileImage: avatar, gender: gender, birthday: birthday)
                
                if userID != Auth.auth().currentUser?.uid {
                    userArray.append(userTemp)
                }
            }
            
            handler(userArray)
        }, withCancel: nil)
    }
    
    
    func getUserData(toID: String, handler: @escaping (_ userData: Dictionary<String,AnyObject>) -> ()){
        REF_USERS.child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? Dictionary<String,AnyObject> {
                handler(dictionary)
            }
            
        }, withCancel: nil)
    }
    
    func getUser(toID: String, handler: @escaping (_ user: User) -> ()){
        REF_USERS.child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userID = snapshot.key
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            let avatar = snapshot.childSnapshot(forPath: "profileImageURL").value as! String
            let gender = snapshot.childSnapshot(forPath: "gender").value as! String
            let birthday = snapshot.childSnapshot(forPath: "birthday").value as! String
            
            let user = User(userID: userID, username: username, email: email, profileImage: avatar, gender: gender, birthday: birthday)
            
            handler(user)
        }, withCancel: nil)
    }
}
