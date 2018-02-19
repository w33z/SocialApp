//
//  DataService.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let instance = DataService()
    
    private var _REF_STORAGE = STORAGE_REF

    var REF_STORAGE: StorageReference {
        return _REF_STORAGE
    }
    
}
