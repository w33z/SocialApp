//
//  Image.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 22.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class Image {
    private var _image: UIImage
    private var _description: String
    
    var image: UIImage {
        return _image
    }
    
    var description: String {
        return _description
    }
    
    init(image: UIImage, description: String){
        self._image = image
        self._description = description
    }
}
