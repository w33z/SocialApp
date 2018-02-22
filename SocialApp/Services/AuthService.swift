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
            
            DataService.instance.uploadUserProfileImage(profileImage: profileImage, handler: { (profileImageURL, complete) in
                
                if complete {
                    let userData = ["provider": user.providerID, "email": user.email, "username": username,"gender": gender,"birthday": birthday,"profileImageURL":profileImageURL]
                    UserService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, AnyObject>)
                    userCreationComplete(true,nil)
                } else {
                    print(String(describing: error?.localizedDescription))
                }
            })
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
