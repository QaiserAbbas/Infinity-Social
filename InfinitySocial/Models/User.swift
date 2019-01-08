//
//  User.swift
//  InfinitySocial
//
//  Created by Qaiser on 1/7/19.
//  Copyright © 2019 Infinity Creatives. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class User: NSObject {
    //MARK: Properties
    let name: String
    let email: String
    let bio: String
    let uid: String
    var profilePic: String
    var device_token: String
    
    //MARK: Regiter with Email
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (User?,Error?) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authDataResult, error) in
            if error == nil {
                let device_token = QAUtility.getPushToken()
                let values = ["name": withName, "email":email,"bio":"Hi there I'm using \(AppName) App.","device_token": device_token, "profilePic": "default"]
                Database.database().reference().child("users").child(authDataResult!.user.uid).updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["email" : email, "password" : password]
                        UserDefaults.standard.set(userInfo, forKey: "userInformation")
                        let userInner = User.init(name: withName, email: email, uid: authDataResult!.user.uid, profilePic:"" , bio: "",device_token: device_token!)
                        completion(userInner, nil)
                    }
                })
            } else {
                completion(nil, error!)
            }
        })
    }
    
    //MARK: Regiter with Facebook
    static func signinWithFB (_ controller: UIViewController, callback:@escaping (User?, Error?)->()) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if FBSDKAccessToken.current() != nil {
            fbLoginManager.logOut()
        }

        if UIApplication.shared.canOpenURL(URL(string: "fb://")!){
            fbLoginManager.loginBehavior = FBSDKLoginBehavior.native
        }
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: controller) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if((FBSDKAccessToken.current()) != nil){
                        //token_for_business
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                let fbDetails = result as! NSDictionary
                                let fbAccessToken = FBSDKAccessToken.current().tokenString
                                
                                var profilePic = ""
                                if let imageURL = ((fbDetails["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                    print(imageURL)
                                    profilePic = imageURL
                                }
                                
                                let first_name = fbDetails.value(forKey: "first_name") as? String
                                let last_name = fbDetails.value(forKey: "last_name") as? String
                                let email = fbDetails.value(forKey: "email") as? String
                                
                                let credential = FacebookAuthProvider.credential(withAccessToken: fbAccessToken!)
                                
                                // Perform login by calling Firebase APIs
                                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                                    if let error = error {
                                        print(error)
                                        callback(nil, error)
                                    } else{
                                        let device_token = QAUtility.getPushToken()
                                        let values = ["name": first_name! + last_name!, "email":email,"bio":"Hi there I'm using \(AppName) App.","device_token": device_token, "profilePic": profilePic]
                                        
                                        Database.database().reference().child("users").child(authResult!.user.uid).updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (errr, _) in
                                            print(errr ?? "nil")
                                            if errr == nil {
                                                self.info(forUserID: authResult!.user.uid, completion: { (innerUser) in
                                                    if innerUser != nil{
                                                        callback(innerUser, nil)
                                                    }else{
                                                        callback(nil, nil)
                                                    }
                                                })
                                            }else{
                                                callback(nil, errr!)
                                            }
                                        })
                                    }
                                }
                            }else{
                                callback(nil, error!)
                            }
                        })
                    }else{
                        callback(nil, error!)
                    }
                }else{
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Please try again"])
                    callback(nil, error)
                }
            }else{
                callback(nil, error!)
            }
        }
    }
    
    //MARK: get User info by UID
    class func info(forUserID: String, completion: @escaping (User?) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                
                let uid = snapshot.key
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let bio = data["bio"] as? String ?? ""
                let profilePic = data["profilePic"] as? String ?? ""
                let device_token = data["device_token"] as? String ?? ""

                let user = User.init(name: name, email: email, uid: uid, profilePic: profilePic , bio: bio, device_token: device_token)

                completion(user)
            }else{
                completion(nil)
            }
            
        }, withCancel: { (error) in
            completion(nil)
        })
    }

    //MARK: Inits
    init(name: String, email: String, uid: String, profilePic: String, bio: String, device_token:String) {
        self.name = name
        self.email = email
        self.uid = uid
        self.profilePic = profilePic
        self.bio = bio
        self.device_token = device_token
    }
}
