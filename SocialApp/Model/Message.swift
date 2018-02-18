//
//  Message.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 11.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation
import Firebase

class  Message {
    private var _text: String?
    private var _fromID: String?
    private var _toID: String?
    private var _timestamp: NSNumber?
    private var _status: Bool?
    
    var text: String? {
        return _text
    }
    
    var fromID: String? {
        return _fromID
    }
    
    var toID: String? {
        return _toID
    }
    
    var timestamp: NSNumber? {
        return _timestamp
    }
    
    var status: Bool? {
        return _status
    }
    
    init(text: String?, fromID: String?, toID: String?, timestamp: NSNumber?, status: Bool?) {
        self._text = text
        self._fromID = fromID
        self._toID = toID
        self._timestamp = timestamp
        self._status = status
    }
    
    func getChatPartnerID() -> String?{
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}
