//
//  STLoginViewController.swift
//  st_ring
//
//  Created by euisuk_lee on 2017. 9. 17..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Alamofire
import SwiftyJSON

class STLoginViewController: UIViewController {
    @IBOutlet weak var emailLogin: UIButton!
    @IBOutlet weak var kakaoLogin: UIButton!
    @IBOutlet weak var facebookLogin: UIButton!
    @IBOutlet weak var boxRatio: NSLayoutConstraint!
    @IBOutlet weak var boxView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UIScreen.main.bounds.height == 812 {
            let newRatio = boxRatio.constraintWithMultiplier(100/95)
            boxView.removeConstraint(boxRatio)
            boxView.addConstraint(newRatio)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FBLogin(_ sender: Any) {
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self, completion:  { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let AccessToken):
                print("Logged in!")
                let id = AccessToken.userId!
                let token = AccessToken.authenticationToken
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set("FACEBOOK", forKey: "login_format")
                
                self.checkMember(id, token, "FACEBOOK")
            }
        })
    }
    
    @IBAction func KakaoLogin(_ sender: Any) {
        let session = KOSession.shared()
        
        if let s = session {
            if s.isOpen(){
                s.close()
            }
            s.open(completionHandler: { (error) in
                if error == nil {
                    print("No error")
                    
                    if s.isOpen(){
                        print("Success")
                        KOSessionTask.meTask(completionHandler: {(profile, error) -> Void in
                            if profile != nil {
                                DispatchQueue.main.async(execute: {()-> Void in
                                    let kakao : KOUser = profile as! KOUser
                                    print(kakao)
                                    if let email = kakao.email{
                                        print(email)
                                        let token = KOSession.shared().accessToken!
                                        let id = kakao.id
                                        UserDefaults.standard.set(token, forKey: "token")
                                        UserDefaults.standard.set("KAKAO", forKey: "login_format")
                                        
                                        self.checkMember(String(describing: id!), token, "KAKAO")
                                    }
                                })
                            }
                        })
                    } else {
                        print("Faild")
                    }
                }
                else {
                    print("Error login : \(error!)")
                }
            })
        }
        else {
            print("Something wrong")
        }
    }
    
    @IBAction func EmailLogin(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "STEmailLoginViewController") as! STEmailLoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func backJoin(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func checkMember(_ id: String, _ token: String,_ login_format: String) {
        let header = [
            "Content-Type": "application/json",
            "access-token" : token
        ]
        let loginJSON = [
            "email" : id as Any,
            "password" : "" as Any,
            "fcm_token" : UserDefaults.standard.string(forKey: "fcm_token")! as Any
            ] as [String:Any]?
        
        print(loginJSON!)
        UserDefaults.standard.set(token, forKey: "token")
        
        Alamofire.request(String.domain! + "information/check/login/", method: .post, parameters: loginJSON, encoding: JSONEncoding.default, headers: header).responseJSON{ respones in
            switch respones.result {
            case .success:
                print("success : call SNSLoginAPI")
                if let responseData = respones.result.value {
                    let resultjson = JSON(responseData)
                    print(resultjson)
                    let status = resultjson["status"].stringValue
                    let sex = resultjson["sex"].stringValue
                    let newid = resultjson["id"].stringValue
                    
                    
                    if resultjson["result"].boolValue {
                        UserDefaults.standard.set(newid, forKey: "id")
                        UserDefaults.standard.set(sex, forKey: "sex")
                        
                        switch status{
                        case "ACTIVATE", "EDITING":
                            let storyboard = UIStoryboard(name: "STMainStoryboard", bundle: nil)
                            let rootView = storyboard.instantiateViewController(withIdentifier: "STMainTabBarController")
                            let initialViewController = UINavigationController(rootViewController: rootView)
                            
                            self.present(initialViewController, animated: true, completion: nil)
                            break
                        case "INREVIEW" :
                            let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "STWaitingReviewViewController")
                            
                            self.present(initialViewController, animated: true, completion: nil)
                            break
                        case "REJECTED" :
                            let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "STRejectReviewViewController")
                            
                            self.present(initialViewController, animated: true, completion: nil)
                            break
                        default:
                            return
                        }
                    } else {
                        let STSMSConfirm = self.storyboard?.instantiateViewController(withIdentifier: "STBasicInfoViewController") as? STBasicInfoViewController
                        STSMSConfirm?.email = String(describing: id)
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(login_format, forKey: "login_format")
                        self.navigationController?.pushViewController(STSMSConfirm!, animated: true)
                    }
                }
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
}
