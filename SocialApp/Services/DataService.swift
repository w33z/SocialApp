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
    private var _REF_USER_MESSAGES = DB_BASE.child("user-messages")
    
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
    
    var REF_USER_MESSAGES: DatabaseReference {
        return _REF_USER_MESSAGES
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
    
    func sendMessege(withGroupKey groupKey: String?,messageData: Dictionary<String,AnyObject>, complete: @escaping (_ status: Bool) -> ()) {
    
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(messageData)
            complete(true)
        } else {
            let childByAuto = REF_MESSAGES.childByAutoId()
            childByAuto.updateChildValues(messageData, withCompletionBlock: { (error, ref) in
                if error != nil{
                    complete(false)
                    debugPrint(error!.localizedDescription)
                    return
                }
                
                let fromID = messageData["fromID"] as! String
                let toID = messageData["toID"] as! String
                let messageID = childByAuto.key
                
                self.REF_USER_MESSAGES.child(fromID).child(toID).child(messageID).updateChildValues(["isReaded": true])
                self.REF_USER_MESSAGES.child(toID).child(fromID).child(messageID).updateChildValues(["isReaded": false])
            
                childByAuto.child("seenBy").updateChildValues([fromID: 1])
                
                complete(true)
            })
        }
    }
    
    func fetchMessages(userID tooID: String,handler: @escaping (_ messages: [Message]) -> ()){
        
        var messagesArray = [Message]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_MESSAGES.child(uid).child(tooID).observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            self.REF_MESSAGES.child(messageID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    
                    let text = dictionary["text"] as! String
                    let fromID = dictionary["fromID"] as! String
                    let toID = dictionary["toID"] as! String
                    let timestamp = dictionary["timestamp"] as! NSNumber

                    let status = dictionary["seenBy"] as! Dictionary<String,AnyObject>
                    
                    var messageTemp: Message
                    
                    if let _ = status[toID]{
                        messageTemp = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp, status: true)
                    } else {
                        messageTemp = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp, status: false)
                    }
                    messagesArray.append(messageTemp)
                    
                    self.REF_MESSAGES.child(messageID).child("seenBy").updateChildValues([uid: 1])
                }
                handler(messagesArray)
            }, withCancel: nil)
            
            self.REF_USER_MESSAGES.child(uid).child(tooID).child(messageID).updateChildValues(["isReaded": true])
        }, withCancel: nil)
    }
    
    func fetchUserMessages(handler: @escaping (_ messages: [Message],_ newMessages: Int) -> ()){
        
        var messagesArray = [Message]()
        var messagesDictionary = Dictionary<String,Message>()
        var newMessageArray = [Message]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_MESSAGES.child(uid).observe(.childAdded, with: { (snapshot) in

            let userID = snapshot.key
            
            self.REF_USER_MESSAGES.child(uid).child(userID).observe(.childAdded, with: { (snapshot) in
                
                let messageID = snapshot.key
                
                self.REF_MESSAGES.child(messageID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        
                        let text = dictionary["text"] as! String
                        let fromID = dictionary["fromID"] as! String
                        let toID = dictionary["toID"] as! String
                        let timestamp = dictionary["timestamp"] as! NSNumber

                        let status = dictionary["seenBy"] as! Dictionary<String,AnyObject>
                        
                        var messageTemp: Message
                        
                        if let _ = status[toID]{
                            messageTemp = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp, status: true)
                        } else {
                            messageTemp = Message(text: text, fromID: fromID, toID: toID, timestamp: timestamp, status: false)
                        }
                        
                        if let chatPartnerID = messageTemp.getChatPartnerID() {
                            messagesDictionary.updateValue(messageTemp, forKey: chatPartnerID)
                            messagesArray = Array(messagesDictionary.values)
                        }
                        
                        if uid != fromID {
                            newMessageArray = messagesArray.filter({ $0.status == false })
                        }
                    }
                    handler(messagesArray,newMessageArray.count)
                })
            }, withCancel: nil)
        }, withCancel: nil)
    }
}
