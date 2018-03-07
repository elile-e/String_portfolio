//
//  STEmailJoinViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 9. 14..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class STEmailJoinViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var PWCheckText: UITextField!
    @IBOutlet weak var JoinBtn: UIButton!
    @IBOutlet weak var EmailErrorLabel: UILabel!
    @IBOutlet weak var PWErrorLabel: UILabel!
    @IBOutlet weak var emailCheckImg: UIImageView!
    @IBOutlet weak var passwordCheckImg: UIImageView!
    @IBOutlet weak var pwcCheckImg: UIImageView!
    
    var emailCK : Bool!
    var passwordCK : Bool!
    var PWequalCK : Bool!
    var viewheight : CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PWCheckText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        EmailText.delegate = self
        PasswordText.delegate = self
        PWCheckText.delegate = self
        
        //set layout
        EmailText.setBottomBorder()
        PasswordText.setBottomBorder()
        PWCheckText.setBottomBorder()
        
        self.JoinBtn.isEnabled = false
        self.JoinBtn.backgroundColor = .lightGray
        self.viewheight = self.view.frame.height
        self.JoinBtn.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.EmailText.becomeFirstResponder()
        self.EmailText.layer.shadowColor = UIColor.mainYello.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.EmailText && self.EmailText.text! != ""){
            self.PasswordText.becomeFirstResponder()
        }else if(textField == self.PasswordText && self.PasswordText.text! != ""){
            isValidPassword(Password: PasswordText.text!, CKPassword: PWCheckText.text!)
            self.PWCheckText.becomeFirstResponder()
        }else if(textField == self.PWCheckText && self.PWCheckText.text! != ""){
            isValidPassword(Password: PasswordText.text!, CKPassword: PWCheckText.text!)
        }

        if(EmailText.text! != "" && PasswordText.text! != "" && PWCheckText.text! != ""){
            if(emailCK! == true && passwordCK! == true && PWequalCK! ==  true){
                self.JoinBtn.isEnabled = true
                self.JoinBtn.backgroundColor = UIColor.mainYello
            } else {
                self.JoinBtn.isEnabled = false
                self.JoinBtn.backgroundColor = UIColor.lightGray
            }
        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if(textField == self.EmailText && self.EmailText.text! != ""){
            isValidEmail(EmailStr: EmailText.text!)
            self.PasswordText.becomeFirstResponder()
            
        }else if(textField == self.PasswordText && self.PasswordText.text! != ""){
            isValidPassword(Password: PasswordText.text!, CKPassword: PWCheckText.text!)
            
            self.PWCheckText.becomeFirstResponder()
            
        }else if(textField == self.PWCheckText && self.PWCheckText.text! != ""){
            isValidPassword(Password: PasswordText.text!, CKPassword: PWCheckText.text!)
        }
        
        if(EmailText.text! != "" && PasswordText.text! != "" && PWCheckText.text! != ""){
            if(emailCK! == true && passwordCK! == true && PWequalCK! ==  true){
                self.JoinBtn.isEnabled = true
                self.JoinBtn.backgroundColor = UIColor.mainYello
            } else {
                self.JoinBtn.isEnabled = false
                self.JoinBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @objc func textFieldDidChange (_ textField: UITextField) {
        if (self.PWCheckText.text != PasswordText.text){
            self.PWequalCK = false
            PWErrorLabel.text! = "비밀번호가 일치하지 않습니다."
            pwcCheckImg.isHidden = true
        } else {
            PWErrorLabel.text! = ""
            pwcCheckImg.isHidden = false
            self.passwordCK = true
            self.PWequalCK = true
        }
        
        isValidPassword(Password: PasswordText.text!, CKPassword: PWCheckText.text!)
            
        if(EmailText.text! != "" && PasswordText.text! != "" && PWCheckText.text! != ""){
            if(emailCK! == true && passwordCK! == true && PWequalCK! ==  true){
                self.JoinBtn.isEnabled = true
                self.JoinBtn.backgroundColor = UIColor.mainYello
            } else {
                self.JoinBtn.isEnabled = false
                self.JoinBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == PWCheckText {
            self.JoinBtn.isEnabled = false
            self.JoinBtn.backgroundColor = UIColor.lightGray
            
            self.PasswordText.layer.shadowColor = UIColor.mainGray.cgColor
            self.EmailText.layer.shadowColor = UIColor.mainGray.cgColor
            self.PWCheckText.layer.shadowColor = UIColor.mainYello.cgColor
        } else if textField == PasswordText {
            self.PasswordText.layer.shadowColor = UIColor.mainYello.cgColor
            self.EmailText.layer.shadowColor = UIColor.mainGray.cgColor
            self.PWCheckText.layer.shadowColor = UIColor.mainGray.cgColor
        } else if textField == EmailText {
            self.PasswordText.layer.shadowColor = UIColor.mainGray.cgColor
            self.EmailText.layer.shadowColor = UIColor.mainYello.cgColor
            self.PWCheckText.layer.shadowColor = UIColor.mainGray.cgColor
        }
    }
    
    func isValidEmail(EmailStr:String) -> Void {
        print("validate emilId: \(EmailStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailJSON = ["email" : EmailStr as Any] as [String:Any]?
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let headers = [
            "Content-Type": "application/json"
        ]
        
        if (emailTest.evaluate(with: EmailStr) == false) {
            EmailErrorLabel.text! = "이메일을 형식이 올바르지 않습니다."
            self.emailCheckImg.isHidden = true
            self.emailCK = false
            self.JoinBtn.backgroundColor = UIColor.mainGray
            self.JoinBtn.isEnabled = false
        } else {
            EmailErrorLabel.text! = ""
            self.emailCheckImg.isHidden = false
            self.emailCK = true
            
            Alamofire.request(String.domain! + "information/check/email/", method: .post, parameters: emailJSON, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
                switch response.result {
                case .success:
                    print("success : call check/email")
                    if let responseData = response.result.value {
                        var resultjson = JSON(responseData)
                        
                        if resultjson["result"].boolValue == false {
                            self.EmailErrorLabel.text! = "이미 가입되어 있는 이메일입니다."
                            self.emailCheckImg.isHidden = true
                            self.JoinBtn.backgroundColor = UIColor.mainGray
                            self.JoinBtn.isEnabled = false
                        } else if resultjson["result"].boolValue == true {
                            self.EmailErrorLabel.text! = ""
                            self.emailCheckImg.isHidden = false
                            self.JoinBtn.backgroundColor = UIColor.mainYello
                            self.JoinBtn.isEnabled = true
                        }
                    }
                case .failure(let error):
                    print("이것은 에러입니다 삐빅 :" + String(describing: error))
                }
            }
        }
    }
    
    func isValidPassword(Password : String, CKPassword : String) -> Void {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?_~&])[A-Za-z\\d$@$#!%*?_~&]{8,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        if (passwordTest.evaluate(with: Password) == false) {
            PWErrorLabel.text! = "비밀번호는 영대/소문자, 숫자, 특수기호 \n혼합 8자리이상을 입력해주세요."
            self.passwordCK = false
            self.passwordCheckImg.isHidden = true
        } else if (CKPassword != "" && Password != CKPassword){
            self.PWequalCK = false
            PWErrorLabel.text! = "비밀번호가 일치하지 않습니다."
            self.pwcCheckImg.isHidden = true
        } else {
            PWErrorLabel.text! = ""
            self.passwordCK = true
            self.PWequalCK = true
            self.passwordCheckImg.isHidden = false
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.view.endEditing(true)
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func JoinAction(_ sender: Any) {
        isValidEmail(EmailStr: EmailText.text!)
        isValidPassword(Password: PasswordText.text!, CKPassword: PWCheckText.text!)
        
        if(emailCK! == true && passwordCK! == true && PWequalCK! ==  true) {
            self.view.endEditing(true)
            let STBasicInfo = storyboard?.instantiateViewController(withIdentifier: "STBasicInfoViewController") as! STBasicInfoViewController
            STBasicInfo.email = self.EmailText.text!
            STBasicInfo.pw = self.PasswordText.text!
            UserDefaults.standard.set("EMAIL", forKey: "login_format")
            
            self.navigationController?.pushViewController(STBasicInfo, animated: true)
            print("run")
        }
    }
}
