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
    private var _REF_USER_PHOTOS = DB_BASE.child("user_profile_photos")

    var REF_STORAGE: StorageReference {
        return _REF_STORAGE
    }
    
    var REF_USER_PHOTOS: DatabaseReference {
        return _REF_USER_PHOTOS
    }
    
    func uploadUserProfileImage(profileImage: UIImage, handler: @escaping (_ profileImageURL: String?, _ complete: Bool) -> ()) {
        let imageName = NSUUID().uuidString
        let storageRef = DataService.instance.REF_STORAGE.child("profile_images").child("\(imageName).png")
        
        if let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                    handler(nil, false)
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    handler(profileImageUrl, true)
                }
            })
        }
    }
    
    func uploadUserPhotos(profileImage: UIImage,text description: String, handler: @escaping (_ complete: Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageName = NSUUID().uuidString
        let storageRef = DataService.instance.REF_STORAGE.child("user_profile_photos").child(uid).child("\(imageName).png")
        
        if let uploadData = UIImageJPEGRepresentation(profileImage, 0.3) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                    handler(false)
                }
                
                if let photoURL = metadata?.downloadURL()?.absoluteString {
                    
                    let data = ["photoURL": photoURL,"text": description]
                    DB_BASE.child("user_profile_photos").child(uid).childByAutoId().updateChildValues(data)
                    
                    handler(true)
                }
            })
        }
    }
    
    func fetchUserPhotos(uid: String, handler: @escaping (_ photos: [Photo]) -> ()) {
        
        var photosArray = [Photo]()

        REF_USER_PHOTOS.child(uid).observe(.childAdded, with: { (snapshot) in
            let photoID = snapshot.key
            self.REF_USER_PHOTOS.child(uid).child(photoID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let photoURL = dictionary["photoURL"] as! String
                    let description = dictionary["text"] as! String
                    
                    let tempPhoto = Photo(imageURL: photoURL, description: description)
                    photosArray.append(tempPhoto)
                }
                handler(photosArray)
            })
        }, withCancel: nil)
    }
}
