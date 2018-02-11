//
//  Message.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 11.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation

class Message {
    private var _content: String
    private var _senderId: String
    private var _timeDelivery: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderId
    }
    
    var timeDelivery: String {
        return _timeDelivery
    }
    
    init(content: String, senderId: String,timeDelivery: String) {
        self._content = content
        self._senderId = senderId
        self._timeDelivery = timeDelivery
    }
}
