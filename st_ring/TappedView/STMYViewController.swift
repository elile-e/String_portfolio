//
//  STMYViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 18..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import Alamofire
import SwiftyJSON

class STMYViewController: UIViewController, MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate {
    @IBOutlet weak var ProfileCertification: UIView!
    @IBOutlet weak var ProfileIMg: UIImageView!
    @IBOutlet weak var whiteMember: UIImageView!
    @IBOutlet weak var CoinChargeButton: UIImageView!
    @IBOutlet weak var NotiButton: UIImageView!
    @IBOutlet weak var SetPushButton: UIImageView!
    @IBOutlet weak var sendEmailButton: UIImageView!
    @IBOutlet weak var ProfileLabel: UILabel!
    @IBOutlet weak var requestWhiteMemberViewRatio: NSLayoutConstraint!
    
    let isWhiteMember = UserDefaults.standard.bool(forKey: "certification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
        
        // set layout
        let grcolor: grColor = grColor()
        let gr1 = grcolor.gradient
        gr1.frame = CGRect(origin: CGPoint.zero, size: ProfileCertification.bounds.size)
        ProfileCertification.layer.addSublayer(gr1)
        ProfileCertification.layer.cornerRadius = ProfileCertification.frame.width/2
        
        ProfileIMg.layer.cornerRadius = ProfileIMg.frame.width/2
        ProfileIMg.layer.borderColor = UIColor.white.cgColor
        ProfileIMg.layer.borderWidth = 2
        ProfileIMg.clipsToBounds = true
        
        if isWhiteMember {
            self.whiteMember.isHidden = true
            self.requestWhiteMemberViewRatio.constraintWithMultiplier(0.01)
        }
        
        // 앱 이동 설정
        let profileTap = targetTapGestureRecognizer(target: self, action: #selector(goToProfile))
        profileTap.target = UserDefaults.standard.integer(forKey: "id")
        ProfileIMg.addGestureRecognizer(profileTap)
        
        let WhiteMemberTap = UITapGestureRecognizer(target: self, action: #selector(goToWhiteMember))
        whiteMember.addGestureRecognizer(WhiteMemberTap)
        
        let CoinTap = UITapGestureRecognizer(target: self, action: #selector(goToCoin))
        CoinChargeButton.addGestureRecognizer(CoinTap)
        
        let PushTap = UITapGestureRecognizer(target: self, action: #selector(goToSetting))
        SetPushButton.addGestureRecognizer(PushTap)
        
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(goToEmail))
        sendEmailButton.addGestureRecognizer(emailTap)
        
        let notiTap = UITapGestureRecognizer(target: self, action: #selector(goToNoti))
        NotiButton.addGestureRecognizer(notiTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func goToProfile() {
        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "STProfileViewController") as! STProfileViewController
        modalVC.id = UserDefaults.standard.string(forKey: "id")!
        modalVC.sex = UserDefaults.standard.string(forKey: "sex")!
        self.present(modalVC, animated: true, completion: nil)
    }
    
    @IBAction func MyEditButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "STProfileViewController") as! STProfileViewController
        modalVC.id = UserDefaults.standard.string(forKey: "id")!
        modalVC.sex = UserDefaults.standard.string(forKey: "sex")!
        self.present(modalVC, animated: true, completion: nil)
    }
    
    @objc func goToWhiteMember(){
        print("tap")
        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "STWhiteMemberViewController")
        self.present(modalVC, animated: true, completion: nil)
    }
    
    @objc func goToCoin(){
        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "STCoinChargeViewController")
        self.present(modalVC, animated: true, completion: nil)
    }
    
    @objc func goToSetting(){
        print("tap")
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func goToEmail(){
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let systemVersion = UIDevice.current.systemVersion
            let id = UserDefaults.standard.string(forKey: "id")
            let defualtText =
            "문의 할 내용을 적어주세요 \n\n내용: \n \n\n\n\n\n String계정 : \(id!) \n OS version : iOS \(systemVersion)"
            
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["wearecro@gmail.com"])
            composeVC.setSubject("스트링 고객센터에 문의합니다" )
            composeVC.setMessageBody(defualtText, isHTML: false)
            composeVC.navigationBar.isTranslucent = false
            self.present(composeVC, animated: true, completion: nil)
        } else {
            let Alert = UIAlertController(title: "안내", message: "wearecro@gmail.com 으로 문의 메일을 보내주세요", preferredStyle: .alert)
            
            Alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(Alert, animated: true, completion: nil)
        }
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func goToNoti(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "STNotiViewController")
        self.present(controller!, animated: true, completion: nil)
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getProfile(){
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request("\(String.domain!)information/\(String.mySex!)/\(String.myId!)/get/detail/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getMyProfileAPI")
                if let responseData = response.result.value {
                    let resultjson = JSON(responseData)
                    
                    self.ProfileLabel.text = "#\(resultjson["location"].stringValue) #\(resultjson["age"].intValue)세 #\(resultjson["education"].stringValue)  #\(resultjson["height"].stringValue)cm #\(resultjson["department"].stringValue)"
                    if resultjson["authenticated"].boolValue {
                        self.ProfileCertification.isHidden = false
                    } else {
                        self.ProfileCertification.isHidden = true
                        self.ProfileIMg.layer.borderWidth = 0
                    }
                    
                    let imgArray = resultjson["images"]
                    let approved = imgArray["approved"].arrayValue
                    
                    if approved.count > 0 {
                        let myImg = approved[0]["name"].stringValue
                        self.getImg(myImg)
                    }
                }
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    func getImg(_ URL: String) {
        let replaced = (URL as NSString).replacingOccurrences(of: "{}", with: "small")
            
        Alamofire.request("\(String.domain!)profile/"+replaced).responseData { (response) in
            print(response)
                
            if let image = UIImage(data: response.data!) {
                self.ProfileIMg.image = image
            }
        }
    }
}
