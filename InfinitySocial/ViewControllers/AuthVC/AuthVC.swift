//
//  AuthVC.swift
//  InfinitySocial
//
//  Created by Qaiser on 1/7/19.
//  Copyright © 2019 Infinity Creatives. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
@_exported import MBProgressHUD

class AuthVC: UIViewController {

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Facebook login button action
    @IBAction func fbButtonTap(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        User.signinWithFB(self) { (user, error) in
            if user != nil{
                
            }else{
                
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}
