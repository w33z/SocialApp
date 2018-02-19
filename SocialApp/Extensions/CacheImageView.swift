//
//  CacheImageView.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 12.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

let imgCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(urlString: String) {
        
        if let cachedImage = imgCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                debugPrint(error!.localizedDescription)
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                
                imgCache.setObject(image!, forKey: urlString as NSString)
                
                self.image = image
            }
        }.resume()
    }
    
}
