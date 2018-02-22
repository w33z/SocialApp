//
//  Photo.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 22.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class Photo {
    private var _imageURL: String?
    private var _description: String?
    
    var imageURL: String? {
        return _imageURL
    }
    
    var description: String? {
        return _description
    }
    
    init(imageURL: String?, description: String?){
        self._imageURL = imageURL
        self._description = description
    }
}
