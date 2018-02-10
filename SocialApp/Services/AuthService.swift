//
//  AuthService.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(email: String, password: String,username: String,gender: String,birthday: String,profileImage: UIImage, userCreationComplete: @escaping (_ status: Bool,_ error: Error?) -> ()){
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false,error)
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = DataService.instance.REF_STORAGE.child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(profileImage) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let userData = ["provider": user.providerID, "email": user.email, "username": username,"gender": gender,"birthday": birthday,"profileImageURL":profileImageUrl]
                        DataService.instance.createDBUser(uid: user.uid, userData: userData)
                        userCreationComplete(true,nil)
                    }
                })
            }

        }
    }
    
    func loginUser(email: String,password: String, loginComplete: @escaping (_ success: Bool, _ error: Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                loginComplete(false,error)
                return
            }
            
            loginComplete(true,nil)
        }
    }
    

}
