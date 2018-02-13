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
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_MESSAGES = DB_BASE.child("messages")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_STORAGE: StorageReference {
        return _REF_STORAGE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_MESSAGES: DatabaseReference {
        return _REF_MESSAGES
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
    
    func sendMessege(withGroupKey groupKey: String?,messageData: Dictionary<String,AnyObject>, complete: @escaping (_ status: Bool) -> ()) {
    
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(messageData)
            complete(true)
        } else {
            REF_MESSAGES.childByAutoId().updateChildValues(messageData)
            complete(false)
        }
    }
    
    func fetchMessages(handler: @escaping (_ messages: [Message]?,_ messagesDictionary: [Message]?) -> ()){
        REF_MESSAGES.observe(.value, with: { (snapshot) in
            
            var messagesArray = [Message]()
            var messagesDictionary = Dictionary<String,Message>()
            var messagesNotRepeated = [Message]()
            
            guard let messageSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in messageSnapshot {
                let text = message.childSnapshot(forPath: "text").value as! String
                let fromID = message.childSnapshot(forPath: "fromID").value as! String
                let toID = message.childSnapshot(forPath: "toID").value as! String
                let timestamp = message.childSnapshot(forPath: "timestamp").value as! NSNumber

                let messageTemp = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp, isReaded: nil)
                
                if let toID = messageTemp.toID {
                    messagesDictionary[toID] = messageTemp
                    messagesNotRepeated = Array(messagesDictionary.values)  
                }
                
                messagesArray.append(messageTemp)
            }
            
            handler(messagesArray,messagesNotRepeated)
            
        }, withCancel: nil)
    }
}
