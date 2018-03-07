//
//  ProFileStruct.swift
//  st_ring
//
//  Created by euisuk_lee on 2017. 11. 2..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KRWordWrapLabel

struct reviewProfile {
    var id : Int?
    var userStatus : Int?
    var profileImg : [String?]?
    var certification : Bool?
    var lock : Bool?
    var height : Int?
    var education : String?
    var departament : String?
    var age : Int?
    var location : String?
    var status: String?
    
    func toImgURL() -> [String] {
        var existImgURL = [String]()
        
        for i in profileImg! {
            if let ImgURL = i {
                let replaced = (ImgURL as NSString).replacingOccurrences(of: "{}", with: "large")
                let fullurl = String.domain! + "profile/" + replaced
                existImgURL.append(fullurl)
            }
        }
        
        return existImgURL
    }
}

struct miniProfile {
    var id : Int?
    var profileImg : String?
    var profileDownloadImg : UIImage?
    var certification : Bool?
    var lock : Bool?
    var age : Int?
    var location : String?
    var status: String?
}

struct bigProfile {
    var id : Int?
    var profileImg : String?
    var certification : Bool?
    var lock : Bool?
    var age : Int?
    var location : String?
    var height : Int?
    var departament : String?
}

struct fullProfile {
    var id : Int?
    var profileImg1 : String?
    var profileImg2 : String?
    var profileImg3 : String?
    var profileImg4 : String?
    var profileImg5 : String?
    var profileImg6 : String?
    var profileImg7 : String?
    var certification : Bool?
    var age : Int?
    var location : String?
    var height : Int?
    var body : String?
    var departament : String?
    var education : String?
    var smoke : Bool?
    var drink : String?
    var religion : String?
    var blood_type : String?
    var QA_type :  String?
    var Answer1 : String?
    var Answer2 : String?
    var Answer3 : String?
    var Answer4 : String?
    
    func toImgURL() -> [String] {
        let ImgURLArray = [profileImg1, profileImg2, profileImg3, profileImg4, profileImg5, profileImg6, profileImg7]
        var existImgURL = [String]()
        
        for i in ImgURLArray {
            if let ImgURL = i {
                existImgURL.append(i!)
            }
        }
        
        return existImgURL
    }
}

struct messageInfo {
    var id: Int?
    var id_image: UIImage?
    var age: Int?
    var location: String?
    var height: Int?
    var departament: String?
    var ProFileURL: String?
    var certification: Bool?
    var contents: String?
    var group_id: Int?
    var create_time: String?
    var opened: Bool?
    var unreadmessages: Int?
}

struct message {
    var text : String?
    var sex : String?
    var create_time : String?
    var group_id : Int?
    var question_id : Int?
}

struct basicInfo {
    var email : String?
    var password : String?
    var login_format : String?
    var birthday : String?
    var military_service_status : String?
    var education : String?
    var department : String?
    var location : String?
    var height : String?
    var body_form : String?
    var smoke : Bool?
    var drink : String?
    var religion : String?
    var blood_type : String?
    var fcm_token : String?
    var sex : String?
    
    func toDictionaryMale() -> [String : Any]? {
        let prams = [
            "email" : self.email! as Any,
            "password" : self.password! as Any,
            "login_format" : self.login_format! as Any,
            "birthday" : self.birthday! as Any,
            "military_service_status" : self.military_service_status! as Any,
            "education" : self.education! as Any,
            "department" : self.department! as Any,
            "location" : self.location! as Any,
            "height" : self.height! as Any,
            "body_form" : self.body_form! as Any,
            "smoke" : self.smoke! as Any,
            "drink" : self.drink! as Any,
            "religion" : self.religion! as Any,
            "blood_type" : self.blood_type! as Any,
            "fcm_token" : self.fcm_token! as Any,
            "sex" : self.sex! as Any
            ] as [String:Any]?
        
        return prams
    }
    
    func toDictionaryFemale() -> [String : Any]? {
        let prams = [
            "email" : self.email! as Any,
            "password" : self.password! as Any,
            "login_format" : self.login_format! as Any,
            "birthday" : self.birthday! as Any,
            "education" : self.education! as Any,
            "department" : self.department! as Any,
            "location" : self.location! as Any,
            "height" : self.height! as Any,
            "body_form" : self.body_form! as Any,
            "smoke" : self.smoke! as Any,
            "drink" : self.drink! as Any,
            "religion" : self.religion! as Any,
            "blood_type" : self.blood_type! as Any,
            "fcm_token" : self.fcm_token! as Any,
            "sex" : self.sex! as Any
            ] as [String:Any]?
        
        return prams
    }
}

struct grColor {
    let gradient : CAGradientLayer = {
        let gr = CAGradientLayer()
        gr.colors = [
            UIColor.gr1.cgColor, // Top
            UIColor.gr2.cgColor, // Middle
//            UIColor.gr3.cgColor // Bottom
        ]
        gr.locations = [0, 1]
        gr.startPoint = CGPoint(x: 0, y: 0)
        gr.endPoint = CGPoint(x: 1, y: 1)
        
        return gr
    }()
    
    let gradientHorizontal : CAGradientLayer = {
        let gr = CAGradientLayer()
        gr.colors = [
            UIColor.gr1.cgColor, // Top
            UIColor.gr2.cgColor, // Middle
//            UIColor.gr3.cgColor // Bottom
        ]
        gr.locations = [0, 1]
        gr.startPoint = CGPoint(x: 0, y: 0.5)
        gr.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gr
    }()
}

extension UIColor {
    @nonobjc class var mainYello: UIColor {
        return UIColor(red: 1.0, green: 0.8, blue: 0.239, alpha: 1.0)
    }
    
    @nonobjc class var gr1: UIColor {
        return UIColor(red: 1.0, green: 0.8, blue: 0.204, alpha: 1.0)
    }
    
    @nonobjc class var gr2: UIColor {
        return UIColor(red: 1, green: 0.478, blue: 0.176, alpha: 1.0)
    }
    
    @nonobjc class var mainGray: UIColor {
        return UIColor(white: 206.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gradientColor: UIColor {
        return UIColor(patternImage: UIImage(named: "gradientColor")!)
    }
}

extension UIFont {
    class func mainFont() -> UIFont? {
        return UIFont(name: "NanumGothicOTF", size: 10.0)
    }
}

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 1
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        viewControllerToPresent.view.layer.add(transition, forKey: "SwitchToView")
        self.view.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 1
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}

extension String {
    static var domain: String? {
        return "이것은 테스트"
    }
    
    static var mySex: String? {
        return UserDefaults.standard.string(forKey: "sex")
    }
    
    static var otherSex: String? {
        let mySex = UserDefaults.standard.string(forKey: "sex")
        var sex = String()
        
        if mySex! == "male" {
            sex = "female"
        } else {
            sex = "male"
        }
        
        return sex
    }
    
    static var myId: String? {
    
        return UserDefaults.standard.string(forKey: "id")
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0.3
        case low     = 0.4
        case medium  = 0.5
        case high    = 0.6
        case highest = 1
    }
    
    func jpeg(_ image: UIImage,_ quality: JPEGQuality) -> Data? {
        let rect = CGRect(x: 0, y: 0, width: (image.size.width * quality.rawValue), height: (image.size.height * quality.rawValue))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, quality.rawValue)
        UIGraphicsEndImageContext()
        
        return imageData
    }
}

extension CGSize {
    static func estimateFrameForText(_ text: String) -> CGSize {
        let tv = KRWordWrapLabel(frame: CGRect(x: 0, y: 0, width: 230, height: 20))
        tv.text = text
        tv.font = UIFont(name: "NanumSquare", size: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.preferredMaxLayoutWidth = 230
        tv.lineBreakMode = .byWordWrapping
        tv.numberOfLines = 0
        tv.textAlignment = .left
        tv.sizeToFit()
        
        return tv.intrinsicContentSize
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
}

extension Notification.Name {
    
    static let fcmMessageNoti = Notification.Name("fcmMessageNoti")
}

class targetTapGestureRecognizer: UITapGestureRecognizer {
    var target: Int?
    var targetGroup: Int?
    var targetView: UIView?
    var opened: Bool?
}

extension UIViewController : UIGestureRecognizerDelegate { public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.mainGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


