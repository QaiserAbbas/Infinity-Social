//
//  ConfigFile.swift
//  InfinitySocial
//
//  Created by Qaiser on 1/6/19.
//  Copyright © 2019 Infinity Creatives. All rights reserved.
//

import Foundation
import UIKit

// Configuration

// To Enable or Disable Admob (true or false)
let admobEnable = false
// Admob App ID (Example: "ca-app-pub-3940256099942544~2934735716")
let admobAppId = "ca-app-pub-3940256099942544~2934735716"
// Admob banner Ad Unit (Example: "ca-app-pub-3940256099942544/2934735716")
let admobAdUnit = "ca-app-pub-3940256099942544/2934735716"

// Base Color (Example : UIColor(netHex: 0x4D73EC) )
let baseColor = UIColor(netHex: 0x6B5B95)

// Done & TODO Status Color
let todoColor = UIColor(netHex: 0x6B5B95)
let doneColor = UIColor(netHex: 0x00743F)

// Navigation Bar Color
let navigationBarTintColor = UIColor.white

// TabBar Tint Color
let tabBarTintColor = baseColor

// Category TODO
let categoryList = ["Home","Work","Personel","Others"]

// font medium
let font18base = UIFont(name: "SFUIText-Medium", size: 18)
let font34base = UIFont(name: "SFUIText-Medium", size: 34)

// font regular
let font16regular = UIFont(name: "SFUIText-Regular", size: 16)
let font18regular = UIFont(name: "SFUIText-Regular", size: 18)
let font34regular = UIFont(name: "SFUIText-Regular", size: 34)





extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

