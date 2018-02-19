//
//  MessageService.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 18.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation
import Firebase

class MessageService {
    static let instance = MessageService()
    
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_MESSAGES = DB_BASE.child("messages")
    private var _REF_USER_MESSAGES = DB_BASE.child("user-messages")
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_MESSAGES: DatabaseReference {
        return _REF_MESSAGES
    }
    
    var REF_USER_MESSAGES: DatabaseReference {
        return _REF_USER_MESSAGES
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
