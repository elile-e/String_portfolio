//
//  STMessengerViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 9..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import KRWordWrapLabel
import Alamofire
import SwiftyJSON


class STMessengerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var ProfileLabel: UILabel!
    @IBOutlet weak var MessageTableView: UITableView!
    @IBOutlet weak var InputBar: UIView!
    @IBOutlet weak var InputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var closeGroupView: UIView!
    @IBOutlet weak var openBtn: UIButton!
    
    let gradientColor : grColor = grColor()
    let mySex = UserDefaults.standard.string(forKey: "sex")
    let id = UserDefaults.standard.string(forKey: "id")
    
    var messageList = [message]()
    var inputBarYLocation : CGFloat?
    var group_id = Int()
    var other_id = Int()
    var opened: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageTableView.delegate = self
        MessageTableView.dataSource = self
        InputTextView.delegate = self
        
        //check opened
        if opened! {
            closeGroupView.isHidden = true
        } else {
            closeGroupView.isHidden = false
        }
        
        //get fcm notification
        NotificationCenter.default.addObserver(self, selector: #selector(loadMessage), name: .fcmMessageNoti, object: nil)
        
        //add tapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        let ProfileTap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        ProfileImg.addGestureRecognizer(ProfileTap)
        self.MessageTableView.isUserInteractionEnabled = true
        self.MessageTableView.addGestureRecognizer(tapGesture)
        
        //add keyboardnotification
        NotificationCenter.default.addObserver(self, selector: #selector(STMessengerViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(STMessengerViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(STMessengerViewController.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(STMessengerViewController.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        inputBarYLocation = self.InputBar.frame.origin.y
        
        // set layout
        ProfileImg.layer.cornerRadius = ProfileImg.frame.width/2
        ProfileImg.layer.borderColor = UIColor.white.cgColor
        ProfileImg.layer.borderWidth = 1.5
        ProfileImg.backgroundColor = UIColor.darkGray
        openBtn.layer.cornerRadius = openBtn.frame.height/2
        
        let gr = gradientColor.gradient
        gr.frame = CGRect(origin: .zero, size: gradientView.bounds.size)
        gradientView.layer.addSublayer(gr)
        gradientView.layer.cornerRadius = gradientView.frame.width/2
        
        InputTextView.layer.borderColor = UIColor.mainGray.cgColor
        InputTextView.layer.borderWidth = 1
        InputTextView.layer.cornerRadius = 15
        
        sendButton.layer.cornerRadius = 6
        sendButton.backgroundColor = .mainGray
        sendButton.isEnabled = false
        
        // load profile
        getProfile()
        loadMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        sendButton.isEnabled = false
        sendButton.backgroundColor = .mainGray
        registMessage(message: self.InputTextView.text!)
        InputTextView.text = ""
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if InputTextView.text! == "" {
            sendButton.isEnabled = false
            sendButton.backgroundColor = .mainGray
        } else {
            sendButton.isEnabled = true
            sendButton.backgroundColor = .mainYello
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        
        let textWidth : CGFloat = estimateFrameForText(messageList[indexPath.row].text!).width
        
        if messageList[indexPath.row].sex == mySex! {
            let cell = MYTableViewCell(style: .default, reuseIdentifier: "MYTableViewCell")
            cell.bubbleWidthAnchor?.constant = textWidth + 35
            cell.textView.text = messageList[indexPath.row].text
            cell.textView.sizeToFit()
            
            return cell
        } else {
            let cell = OtherTableViewCell(style: .default, reuseIdentifier: "OtherTableViewCell")
            cell.bubbleWidthAnchor?.constant = textWidth + 35
            cell.textView.text = messageList[indexPath.row].text
            cell.textView.sizeToFit()
            
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
    
        height = estimateFrameForText(messageList[indexPath.row].text!).height + 25

        
        return height
    }
    
    private func estimateFrameForText(_ text: String) -> CGSize {
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
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue , let window = self.view.window?.frame {
            
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: (window.height - (keyboardSize.height)))
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let widow = self.view.window?.frame
        
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                 y: self.view.frame.origin.y,
                                 width: self.view.frame.width,
                                 height: (widow?.height)!)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        self.scrollToBottom()
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        self.scrollToBottom()
    }
    
    func scrollToBottom(){
        if messageList.count >= 1 {
            let indexPath = IndexPath(row: self.messageList.count-1, section: 0)
            self.MessageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
  
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goToProfile() {
        print("tap")
        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "STProfileViewController") as! STProfileViewController
        
        modalVC.id = String(self.other_id)
        self.present(modalVC, animated: true, completion: nil)
    }
    
    func registMessage(message: String) {
        let header = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token"),
            "account-id" : UserDefaults.standard.string(forKey: "id"),
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let parm = [
            "group_id" : self.group_id as Any,
            "contents" : message as Any
        ]
        
        Alamofire.request(String.domain! + "information/register/message/", method: .post, parameters: parm, encoding: JSONEncoding.default, headers: header as? HTTPHeaders).responseJSON{response in
            switch response.result {
            case .success:
                print(response)
                print("메세지 발송 성공! 룰루랄라")
                self.MessageTableView.reloadData()
                self.loadMessage()
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    @objc func loadMessage() {
        let headers = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request(String.domain! + "information/get/message-list/\(String(self.group_id))/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("메세지 로드 성공! 룰루랄라")
                if let result = response.result.value {
                    let json = JSON(result)
                    print(json)
                    let resultJson = json["messages"].arrayValue
                    var NewList = [message]()
                    for i in resultJson {
                        var newmessage = message()
                        newmessage.text = i["contents"].stringValue
                        newmessage.create_time = i["create_time"].stringValue
                        newmessage.sex = i["sex"].stringValue
                        newmessage.group_id = i["group_id"].intValue
                        
                        NewList.append(newmessage)
                    }
                    self.messageList = NewList
                    self.MessageTableView.reloadData()
                    self.messageRead()
                    self.scrollToBottom()
                }
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    func getProfile() {
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request("\(String.domain!)information/\(String.otherSex!)/\(self.other_id)/get/detail/", method: .get, encoding: JSONEncoding.default, headers: header).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getFullProfileAPI")
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
            if let responseData = response.result.value {
                let resultjson = JSON(responseData)
                print(resultjson)
                let imgArray = resultjson["images"]
                let approved = imgArray["approved"].arrayValue
                let ImgJSON = approved[0]["name"].stringValue
                
                if resultjson["authenticated"].boolValue {
                    self.gradientView.isHidden = false
                } else {
                    self.gradientView.isHidden = true
                    self.ProfileImg.layer.borderWidth = 0
                }
                
                self.ProfileLabel.text = "#\(resultjson["location"].stringValue) #\(resultjson["age"].intValue)세 #\(resultjson["height"].intValue)cm #\(resultjson["department"].stringValue)"
                
                self.getImg(ImgJSON)
            }
        }
    }
    
    func getImg(_ URLArray: String) {
        let replaced = (URLArray as NSString).replacingOccurrences(of: "{}", with: "small")
            
        Alamofire.request("\(String.domain!)profile/"+replaced).responseData { (response) in
            print(response)
                
            if let image = UIImage(data: response.data!) {
                self.ProfileImg.image = image
            }
        }
    }
    
    func messageRead() {
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "group_id" : self.group_id
            ] as [String : Any]
        
        Alamofire.request(String.domain! + "information/register/message-read-time/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON{ response in
            print(response.result)
            switch response.result {
            case .success:
                print("success : postReadMessage")
            case .failure(let error):
                print("이것은 메세지 리드 포스트 에러 삐빅 :" + String(describing: error))
                let json = JSON(response.debugDescription)
                print(json)
            }
        }
    }
    
    @IBAction func openGroupAction(_ sender: Any) {
        let openAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let message = "프로필을 열어보기 위해 \n\n100코인이 필요합니다.\n(화이트 맴버는 50코인)"
        let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        
        openAlert.setValue(mutableMessage, forKey: "attributedMessage")
        
        openAlert.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) in
            self.openChat()
        }))
        openAlert.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
        
        self.present(openAlert, animated: true, completion: nil)
    }
    
    func openRegister() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "group_id" : self.group_id as Any
        ]
        
        Alamofire.request(String.domain! + "information/register/open-group/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            let result = JSON(response)
            switch response.result {
            case .success:
                print("success : open")
                let json = JSON(response.result.value!)
                print(json)
            case .failure(let error):
                print("이것은 open api 에러 :" + String(describing: error))
                let json = JSON(response)
                print(json)
            }
        }
    }
    
    func openChat() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "item_id" : UserDefaults.standard.bool(forKey: "certification") ? 6 : 3
            ] as [String : Any]
        
        Alamofire.request(String.domain! + "information/pay/item/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            let result = JSON(response)
            switch response.result {
            case .success:
                print("success : getItem")
                let json = JSON(response.result.value)
                print(json)
                let returnValue = json["result"].boolValue
                
                if returnValue {
                    self.closeGroupView.isHidden = true
                    self.openRegister()
                } else if !returnValue {
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    let message = "코인이 부족합니다. \n\n충전하러 가시겠어요?"
                    let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
                    
                    alert.setValue(mutableMessage, forKey: "attributedMessage")
                    
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { handler in
                        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
                        let modalCoin = storyboard.instantiateViewController(withIdentifier: "STCoinChargeViewController") as! STCoinChargeViewController
                        
                        self.present(modalCoin, animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print("이것은 상품쪽 에러 :" + String(describing: error))
            }
        }
    }
}
