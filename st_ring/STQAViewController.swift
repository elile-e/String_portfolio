//
//  STQAViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 9. 27..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import KRWordWrapLabel
import SwiftyJSON

class STQAViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    @IBOutlet weak var chatView: UITableView!
    @IBOutlet weak var inputbar: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var donebuttonHeight: NSLayoutConstraint!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadIndicator: UIActivityIndicatorView!
    

    var randQuestion = [String]()
    var QAMessage = [message]()
    var QuestionMessage = [message]()
    var Answer = [String]()
    var currentEditMessage : IndexPath?
    var inputBarYLocation : CGFloat?
    var userBasicInfo : basicInfo?
    var sex : String?
    var otherSex : String?
    var profileImg : [UIImage?]?
    var qnaArray = [qna]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backAction))
        newBackButton.image = UIImage(named: "backbtn")
        newBackButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = newBackButton
        self.getQAList()
        
        if sex == "male" {
            otherSex = "female"
        } else {
            otherSex = "male"
        }
        self.userBasicInfo?.sex = self.sex!
        chatView.delegate = self
        chatView.dataSource = self
        inputTextView.delegate = self
        
        var guideMessage = message()
        guideMessage.text = "안녕하세요! \n회원정보를 입력하시느라 고생많으셨어요~ \n \n이제 마지막 단계인데요! \n제가 하는 질문을 이상형인 사람이 질문한다고생각해주시고 정성스럽게 답장해주세요!"
        guideMessage.sex = otherSex
        QAMessage.append(guideMessage)
        
        NotificationCenter.default.addObserver(self, selector: #selector(STQAViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(STQAViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        inputBarYLocation = self.inputbar.frame.origin.y
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.chatView.isUserInteractionEnabled = true
        self.chatView.addGestureRecognizer(tapGesture)
        self.chatView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        self.inputTextView.layer.borderColor = UIColor.mainGray.cgColor
        self.inputTextView.layer.borderWidth = 1
        self.inputTextView.layer.cornerRadius = 15
        self.sendButton.backgroundColor = .mainGray
        self.sendButton.layer.cornerRadius = 6
        
        if (UIScreen.main.bounds.height == 812) {
            donebuttonHeight.constant += 34
            DoneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 34, 0 )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func questioner() {
        if(QAMessage.count == 3) {
            QAMessage.append(QuestionMessage[1])
        } else if (QAMessage.count == 5) {
            QAMessage.append(QuestionMessage[2])
        } else {
            return
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QAMessage.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textWidth : CGSize = estimateFrameForText(QAMessage[indexPath.row].text!)
        
        if QAMessage[indexPath.row].sex == sex {
            let cell = MYEditTableViewCell(style: .default, reuseIdentifier: "MYEditTableViewCell")
            
            cell.textView.text! = QAMessage[indexPath.row].text!
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(self.editButtonAction), for: .touchUpInside)
            if(textWidth.width > 100){
                cell.bubbleWidthAnchor?.constant = textWidth.width + 35
            } else {
                cell.bubbleWidthAnchor?.constant = 100 + 35
                cell.textView.textAlignment = .center
            }
            
            cell.textView.sizeToFit()
            return cell
        } else {
            let cell = OtherTableViewCell(style: .default, reuseIdentifier: "OtherTableViewCell")
            cell.textView.text! = QAMessage[indexPath.row].text!
            cell.textView.sizeToFit()
            cell.bubbleWidthAnchor?.constant = textWidth.width + 35
            
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        
        if QAMessage[indexPath.row].sex == self.sex{
            height = estimateFrameForText(QAMessage[indexPath.row].text!).height + 50
        } else {
            height = estimateFrameForText(QAMessage[indexPath.row].text!).height + 25
        }
        
        return height
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.inputTextView.text = ""
        self.inputTextView.textColor = .black
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if (self.inputTextView.text == "") {
            self.inputTextView.text = "질문에 응답해주세요! (5자 이상)"
            self.inputTextView.textColor = .lightGray
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if (self.inputTextView.text == "") {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .mainGray
        } else if (self.inputTextView.text == "질문에 응답해주세요! (5자 이상") {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .mainGray
        } else if self.inputTextView.text!.count < 5 {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .mainGray
        } else {
            self.sendButton.isEnabled = true
            self.sendButton.backgroundColor = .mainYello
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if (self.sendButton.titleLabel?.text == "완료") {
            if let i = inputTextView.text {
                self.QAMessage[(currentEditMessage?.row)!].text = i
                self.Answer[((currentEditMessage?.row)! / 2) - 1] = i
                self.inputTextView.text = ""
                self.chatView.reloadData()
                self.sendButton.setTitle("전송", for: .normal)
            }
        } else {
            if let i = inputTextView.text {
                var A = message()
                A.sex = sex
                A.text = i
                self.QAMessage.append(A)
                self.Answer.append(i)
                self.inputTextView.text = ""
            }
            questioner()
            self.chatView.reloadData()
            self.scrollToBottom()
        }
        
        if(QAMessage.count == 7) {
            self.DoneButton.backgroundColor = UIColor.mainYello
            self.DoneButton.isHidden = false
            self.inputTextView.isHidden = true
            self.sendButton.isHidden = true
            self.view.endEditing(true)
        }
        
        self.sendButton.backgroundColor = .mainGray
        self.sendButton.isEnabled = false
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.DoneButton.isEnabled = false
        var headers: HTTPHeaders
        
        uploadView.isHidden = false
        uploadIndicator.startAnimating()
        
        if self.userBasicInfo?.login_format == "EMAIL" {
            headers = ["Content-Type": "application/json"]
        } else {
            headers = [
                "Content-Type": "application/json",
                "access-token" : UserDefaults.standard.string(forKey: "token")!,
                "sex" : self.sex!
            ]
        }
        
        let parm :[String : Any]?
        
        if sex == "male" {
            parm = self.userBasicInfo!.toDictionaryMale()!
        } else {
            parm = self.userBasicInfo!.toDictionaryFemale()!
        }
  
        Alamofire.request(String.domain! + "information/join/", method: HTTPMethod.post, parameters: parm, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("Validation Successful")
                let jsonValue = JSON(response.result.value!)
                print(jsonValue)
                if jsonValue["result"].boolValue == true {
                    UserDefaults.standard.set(jsonValue["account_id"].intValue, forKey: "id")
                    UserDefaults.standard.set(self.sex!, forKey: "sex")
                    
                    if self.userBasicInfo?.login_format == "EMAIL" {
                        UserDefaults.standard.set(jsonValue["token"].stringValue, forKey: "token")
                    }
                    
                    UserDefaults.standard.synchronize()
                    
                    self.uploadImg(account: jsonValue["account_id"].intValue, ImgArray: self.profileImg!)
                    self.uploadQA(account: jsonValue["account_id"].intValue, text: self.Answer)
                }
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    private func estimateFrameForText(_ text: String) -> CGSize {
        let cellsize = KRWordWrapLabel(frame: CGRect(x: 0, y: 0, width: 230, height: 20))
        var estimateSize: CGSize!
        
        cellsize.text = text
        cellsize.numberOfLines = 0
        cellsize.lineBreakMode = .byWordWrapping
        cellsize.font = UIFont(name: "NanumSquare", size: 14)
        cellsize.translatesAutoresizingMaskIntoConstraints = false
        cellsize.preferredMaxLayoutWidth = 230
        cellsize.textAlignment = .left
        cellsize.sizeToFit()
        estimateSize = cellsize.intrinsicContentSize

        return estimateSize
    }
    
    @objc func editButtonAction(sender : UIButton){
        if let cell = sender.superview?.superview as? MYEditTableViewCell {
            self.inputTextView.text = cell.textView.text
            self.currentEditMessage = chatView.indexPath(for: cell)
            self.inputTextView.textColor = UIColor.black
            self.sendButton.setTitle("완료", for: .normal)
            self.DoneButton.isHidden = true
            self.inputTextView.isHidden = false
            self.sendButton.isHidden = false
        }
    }
    
    func scrollToBottom(){
        let indexPath = IndexPath(row: self.QAMessage.count-1, section: 0)
        self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let barSize = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue , let window = self.view.window?.frame {
            
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: self.view.frame.origin.y,
                                         width: self.view.frame.width,
                                         height: (window.height - (barSize + keyboardSize.height)))
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
        self.scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let barSize = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        let widow = self.view.window?.frame
        
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: (widow?.height)! - barSize)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func backAction() {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: "입력하신내용은 저장되지 않습니다. \n 되돌아가시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {action in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadImg(account: Int, ImgArray: [UIImage?]){
        let imgCount = profileImg!.count
        let url = String.domain! + "information/register/image/"
        let headers = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : String(account),
            "account-sex" : sex!
        ]
        
        let URI = try! URLRequest(url: url, method: .post, headers: headers)
        
        for i in 0...imgCount - 1 {
            if ImgArray[i] != nil {
                Alamofire.upload(multipartFormData: {MultipartFormData in
                    self.addImageData(multipartFormData: MultipartFormData, image: ImgArray[i]!, index: i)
                }, with: URI, encodingCompletion: {result in
                    switch result {
                    case .success(let upload, _, _):
                        print("upload success")
                        upload.responseJSON { response in
                            print(response)
                            if let responsevalue = response.value{
                                let json = JSON(responsevalue)
                                if json["result"].boolValue == true {
                                    self.GoToWaitingView()
                                    self.uploadIndicator.stopAnimating()
                                } else {
                                    self.uploadIndicator.stopAnimating()
                                }
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                })
            }
        }
    }
    
    func uploadQA(account: Int, text: [String]){
        var array = [[String : Any]]()
        for (index, i) in text.enumerated() {
            let Answer = ["question_id" : self.qnaArray[index].id!, "answer" : i] as [String : Any]
            
            array.append(Answer)
        }
        let param = ["qna_list" : array] as [String : Any]
        
        let headers = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : String(account),
            "account-sex" : sex!
        ]
        
        Alamofire.request(String.domain! + "information/register/introduction-qna/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers ).responseJSON{response in
            switch response.result {
            case .success:
                print("success: uploadQA")
                print(JSON(response.result.value))
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }

    private func addImageData(multipartFormData: MultipartFormData, image: UIImage, index: Int){
        let lowdata = image.jpeg(image ,.lowest)
        let middledata = image.jpeg(image, .low)
        let highdata = image.jpeg(image, .medium)
        
        print(lowdata!.count)
        print(middledata!.count)
        print(highdata!.count)
        print(index)
        
        multipartFormData.append(lowdata!, withName: "image-small",fileName: "image.jpg", mimeType: "image/jpeg")
        multipartFormData.append(middledata!, withName: "image-medium",fileName: "image.jpg", mimeType: "image/jpeg")
        multipartFormData.append(highdata!, withName: "image-large",fileName: "image.jpg", mimeType: "image/jpeg")
        multipartFormData.append(String(index).data(using: .utf8)!, withName: "image-index")
    }
    
    func GoToWaitingView() {
        let WaitingView = self.storyboard?.instantiateViewController(withIdentifier: "STWaitingReviewViewController") as! STWaitingReviewViewController
        present(WaitingView, animated: true, completion: nil)
        UserDefaults.standard.set("INREVIEW", forKey: "status")
    }
    
    func getQAList() {
        let headers = [
            "Content-Type": "application/json",
        ]
        
        Alamofire.request(String.domain! + "information/get/introduction-questions/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let jsonValue = JSON(response.result.value!)
                let dic = jsonValue["questions"].arrayValue
                
                for (index, i) in dic.enumerated() {
                    var newqna = qna()
                    var newquestion = message()
                    
                    newqna.id = i["id"].intValue
                    newqna.question = i["contents"].stringValue
                    newquestion.sex = self.otherSex!
                    newquestion.text = i["contents"].stringValue
                    
                    self.qnaArray.append(newqna)
                    self.QuestionMessage.append(newquestion)
                    if index == 0{
                        self.QAMessage.append(newquestion)
                        self.chatView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
}

struct qna {
    var question: String?
    var answer: String?
    var id: Int?
}
