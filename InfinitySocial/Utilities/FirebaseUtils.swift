//
//  FirebaseUtils.swift
//  InfinitySocial
//
//  Created by Qaiser on 1/6/19.
//  Copyright © 2019 Infinity Creatives. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVKit

struct CategoriesList {
    static var listOfCategories = [Category]()
    static var eventSponsorList = [Category]()
}
struct AdminSettings {
    static var adminNumber = String()
    static var activationNumber = String()
    static var adminMessage = String()
    static var aboutUsMessage = String()
    static var customerSupportMessage = String()
}

class FirebaseUtils: NSObject {
    
    // MARK: Admin
    static func getAdminSettings(_ callback:@escaping () -> Void) {
        
        Database.database().reference().child("admin").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let info = snap.value as! NSDictionary
                
                AdminSettings.adminMessage = info["message"] as? String ?? ""
                AdminSettings.adminNumber = info["number"] as? String ?? ""
                AdminSettings.activationNumber = info["activation-number"] as? String ?? ""
            }
        }
        Database.database().reference().child("admin").observe(.childChanged) { (snapshot) in
            let info = snapshot.value as! NSDictionary
            AdminSettings.adminMessage = info["message"] as? String ?? ""
            AdminSettings.adminNumber = info["number"] as? String ?? ""
            AdminSettings.activationNumber = info["activation-number"] as? String ?? ""
        }
        self.getAdminAboutUs {
        }
        self.getAdminContactUs {
        }
    }
    static func getAdminAboutUs(_ callback:@escaping () -> Void) {
        
        Database.database().reference().child("about-us").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let info = snap.value as! NSDictionary
                
                AdminSettings.aboutUsMessage = info["description"] as? String ?? ""
            }
        }
        Database.database().reference().child("about-us").observe(.childChanged) { (snapshot) in
            let info = snapshot.value as! NSDictionary
            AdminSettings.aboutUsMessage = info["description"] as? String ?? ""
        }
    }
    static func getAdminContactUs(_ callback:@escaping () -> Void) {
        
        Database.database().reference().child("contact-us").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let info = snap.value as! NSDictionary
                
                AdminSettings.customerSupportMessage = info["description"] as? String ?? ""
            }
        }
        Database.database().reference().child("contact-us").observe(.childChanged) { (snapshot) in
            let info = snapshot.value as! NSDictionary
            AdminSettings.customerSupportMessage = info["description"] as? String ?? ""
        }
    }
}
