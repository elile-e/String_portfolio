//
//  STEmailLoginViewController.swift
//  st_ring
//
//  Created by euisuk_lee on 2017. 9. 17..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class STEmailLoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var EmailErrorLabel: UILabel!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var emailCheckImg: UIImageView!
    @IBOutlet weak var pwCheckImg: UIImageView!
    
    var emailCK : Bool!
    var passwordCK : Bool!
    var viewHeight : CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PasswordText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        EmailText.delegate = self
        PasswordText.delegate = self
        
        
        EmailText.setBottomBorder()
        PasswordText.setBottomBorder()
        LoginBtn.isEnabled = false
        LoginBtn.backgroundColor? = UIColor.lightGray
        viewHeight = self.view.frame.height
        LoginBtn.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.EmailText.becomeFirstResponder()
        self.EmailText.layer.shadowColor = UIColor.mainYello.cgColor
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func LoginBtn(_ sender: Any) {
        let email = self.EmailText.text
        let password = self.PasswordText.text
        let login = [
            "email" : email as Any,
            "password" : password as Any,
            "fcm_token" : UserDefaults.standard.string(forKey: "fcm_token") as Any
        ] as [String:Any]?
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(String.domain! + "information/check/login/", method: .post, parameters: login, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("Validation Successful")
                let jsonValue = JSON(response.result.value!)
                
                if jsonValue["result"].boolValue {
                    let token = jsonValue["access_token"].stringValue
                    let id = jsonValue["id"].stringValue
                    let sex = jsonValue["sex"].stringValue
                    
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(id, forKey: "id")
                    UserDefaults.standard.set(sex, forKey: "sex")
                    
                    let storyboard = UIStoryboard(name: "STMainStoryboard", bundle: nil)
                    let rootView = storyboard.instantiateViewController(withIdentifier: "STMainTabBarController")
                    let initialViewController = UINavigationController(rootViewController: rootView)
                    
                    self.present(initialViewController, animated: true, completion: nil)
                } else {
                    self.ErrorLabel.text! = "올바르지 않은 계정정보 입니다. \n이메일과 비밀번호를 다시 한번 확인해주세요."
                }

            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.EmailText && self.EmailText.text! != ""){
            isValidEmail(EmailStr: EmailText.text!)
            self.PasswordText.becomeFirstResponder()
        }else if(textField == self.PasswordText && self.PasswordText.text! != ""){
            isValidPassword(Password:PasswordText.text!)
        }
        
        if(EmailText.text! != "" && PasswordText.text! != ""){
            if(emailCK! == true && passwordCK! == true){
                LoginBtn.isEnabled = true
                LoginBtn.backgroundColor? = UIColor.mainYello
            } else {
                LoginBtn.isEnabled = false
                LoginBtn.backgroundColor? = UIColor.lightGray
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if(textField == self.EmailText && self.EmailText.text! != ""){
            isValidEmail(EmailStr: EmailText.text!)
            self.PasswordText.becomeFirstResponder()
        }else if(textField == self.PasswordText && self.PasswordText.text! != ""){
            isValidPassword(Password:PasswordText.text!)
        }
        
        if(EmailText.text! != "" && PasswordText.text! != ""){
            if(emailCK! == true && passwordCK! == true){
                LoginBtn.isEnabled = true
                LoginBtn.backgroundColor? = UIColor.mainYello
            } else {
                LoginBtn.isEnabled = false
                LoginBtn.backgroundColor? = UIColor.lightGray
            }
        }
    }
    
    @objc func textFieldDidChange (_ textField: UITextField) {
        if textField == PasswordText {
            if PasswordText.text!.count >= 8 {
                self.LoginBtn.isEnabled = true
                self.LoginBtn.backgroundColor = .mainYello
                self.pwCheckImg.isHidden = false
            } else {
                self.LoginBtn.isEnabled = false
                self.LoginBtn.backgroundColor = .mainGray
                self.pwCheckImg.isHidden = true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == EmailText {
            self.EmailText.layer.shadowColor = UIColor.mainYello.cgColor
            self.PasswordText.layer.shadowColor = UIColor.mainGray.cgColor
        } else {
            self.EmailText.layer.shadowColor = UIColor.mainGray.cgColor
            self.PasswordText.layer.shadowColor = UIColor.mainYello.cgColor
        }
    }
    
    func isValidEmail(EmailStr:String) -> Void {
        print("validate emilId: \(EmailStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (emailTest.evaluate(with: EmailStr) == false) {
            EmailErrorLabel.text! = "이메일을 형식이 올바르지 않습니다."
            self.emailCK = false
            self.emailCheckImg.isHidden = true
        } else {
            EmailErrorLabel.text! = ""
            self.emailCK = true
            self.emailCheckImg.isHidden = false
        }
    }
    
    func isValidPassword(Password:String){
        self.passwordCK = true
        self.pwCheckImg.isHidden = false
    }
}
