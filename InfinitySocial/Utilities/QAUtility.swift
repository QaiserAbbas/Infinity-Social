//
//  QAUtility.swift
//  InfinitySocial
//
//  Created by Qaiser on 1/6/19.
//  Copyright © 2019 Infinity Creatives. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import AVFoundation

class QAUtility: NSObject {
    static let defaults = UserDefaults.standard
    static let dateFormatConstant = "MMM dd YYYY hh:mm a"
    
    //Save and Retrive Is Login
    class func setIsLogin(_ isLogin: Bool){
        defaults.set(isLogin, forKey: "IsLogin")
    }
    
    class func getIsLogin() -> Bool!{
        return defaults.bool(forKey: "IsLogin")
    }
    
    //Save and Retrive Access Token
    class func setAccessToken(_ accessToken: String){
        defaults.set(accessToken, forKey: "AccessToken")
    }
    
    class func getAccessToken() -> String!{
        if let accessToken = defaults.object(forKey: "AccessToken"){
            return accessToken as? String
        }else{
            return ""
        }
    }
    
    //Save and Retrive Token Store For Push
    class func setPushToken(_ pushToken: String){
        defaults.set(pushToken, forKey: "push_token")
    }
    
    class func getPushToken() -> String!{
        if let pushToken = defaults.object(forKey: "push_token"){
            return pushToken as? String
        }else{
            return ""
        }
    }
    
    
    //Save and Retrive Lat
    class func setLat(_ Lat: String){
        defaults.set(Lat, forKey: "Lat")
    }
    
    class func getLat() -> String!{
        if let Lat = defaults.object(forKey: "Lat"){
            return Lat as? String
        }else{
            return "0.0"
        }
    }
    
    //Save and Retrive Long
    class func setLong(_ Long: String){
        defaults.set(Long, forKey: "Long")
    }
    
    class func getLong() -> String!{
        if let Long = defaults.object(forKey: "Long"){
            return Long as? String
        }else{
            return "0.0"
        }
    }
    
    
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    class func checkAlphaNumeric(string : String) -> Bool{
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        
        var letterCount : Int = 0
        var digitCount : Int = 0
        
        for uni in string.unicodeScalars {
            if letters.contains(uni) {
                letterCount += 1
            } else if digits.contains(uni) {
                digitCount += 1
            }
        }
        if letterCount > 0 && digitCount > 0{
            return false
        }else{
            return true
        }
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

// MARK: - Device Extension
extension UIScreen {
    
    enum SizeType: CGFloat {
        case unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 2208.0
        case iPhoneX = 2436.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .unknown }
        return sizeType
    }
}

// MARK:- Dictionary Extension
// Merge two Dictionaries
extension Dictionary {
    mutating func merge<K, V>(_ dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
    
    func urlEncodedString() -> String {
        // Converting the dictionary with parameters to url encoded string.
        var parts: Array = [String]()
        for (key, value) in self {
            parts.append("\(key)=\(value)")
        }
        let partString: String = parts.joined(separator: "&")
        return partString
    }
}

extension String {
    // Has Numbers Only
    func hasOnlyNumbers() -> Bool! {
        // Check for Numbers
        let aSet = CharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return self == numberFiltered
    }
    var localized:String{
        return NSLocalizedString(self as String, comment: "")
    }
}

extension Dictionary where Key: Hashable, Value: Any {
    func getValue(forKeyPath components : Array<Any>) -> Any? {
        var comps = components;
        let key = comps.remove(at: 0)
        if let k = key as? Key {
            if(comps.count == 0) {
                return self[k]
            }
            if let v = self[k] as? Dictionary<AnyHashable,Any> {
                return v.getValue(forKeyPath : comps)
            }
        }
        return nil
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

extension Int{
    func toString() -> String{
        let myString = String(self)
        return myString
    }
    
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}
extension UIView {
    func dropShadow(color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.open(URL(string: url)!, options: [:], completionHandler: nil)
                return
            }
        }
    }
}

extension UINavigationController{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension UIImageView
{
    func addBlurEffect()
    {
        var darkBlur:UIBlurEffect = UIBlurEffect()
        
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffect.Style.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark) //extraLight, light, dark
        }
        
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.bounds //your view that have any objects
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
    }
}
@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
extension UILabel {
    @IBInspectable
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000.0 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.1),
                let imageData = resizedImage.pngData()
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        return resizingImage
    }
}

extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? " \(year)" + " " + "year ago" :
                " \(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? " \(month)" + " " + "month ago" :
                " \(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? " \(day)" + " " + "day ago" :
                " \(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? " \(hour)" + " " + "hour ago" :
                " \(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? " \(minute)" + " " + "minute ago" :
                " \(minute)" + " " + "minutes ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? " \(second)" + " " + "second ago" :
                " \(second)" + " " + "seconds ago"
        } else {
            return " a moment ago"
        }
        
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIActivityIndicatorView {
    func dismissLoader() {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
extension UITextView {
    func detectRightToLeft() {
        if let text = self.text, !text.isEmpty {
            let tagschemes = NSArray(objects: NSLinguisticTagScheme.language)
            let tagger = NSLinguisticTagger(tagSchemes: tagschemes as! [NSLinguisticTagScheme], options: 0)
            tagger.string = text
            
            let language = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language, tokenRange: nil, sentenceRange: nil)
            if language?.rawValue.range(of: "he") != nil || language?.rawValue.range(of: "ar") != nil || language?.rawValue.range(of: "fa") != nil {
                self.text = text.replacingOccurrences(of: "\n", with: "\n")
                self.textAlignment = .right
                self.makeTextWritingDirectionRightToLeft(nil)
            }else{
                self.textAlignment = .left
                self.makeTextWritingDirectionLeftToRight(nil)
            }
        }
    }
}

