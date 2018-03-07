//
//  STMessengerListViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 5..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class STMessengerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var MessageListTableView: UITableView!
    let yesterday = Date().yesterday
    var messageList: [messageInfo] = []
    @IBOutlet weak var noneMatchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMatched()
        MessageListTableView.delegate = self
        MessageListTableView.dataSource = self
        
        let nib = UINib.init(nibName: "STMessengerTableViewCell", bundle: Bundle.main)
        self.MessageListTableView.register(nib, forCellReuseIdentifier: "STMessengerTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMatched()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "STMessengerTableViewCell", for: indexPath) as! STMessengerTableViewCell
        let cellTap = targetTapGestureRecognizer(target: self, action: #selector(goToMessenger))
        let matchData = messageList[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cellTap.target = matchData.id
        cellTap.targetGroup = matchData.group_id
        cellTap.opened = matchData.opened
        cell.addGestureRecognizer(cellTap)
        

        cell.ProfileImg.layer.cornerRadius = (cell.frame.height - 20)/2
        cell.ProfileImg.image = matchData.id_image
        cell.certificationView.layer.cornerRadius = (cell.frame.height - 16)/2
        cell.unreadMessageView.layer.cornerRadius = cell.unreadMessageView.frame.size.width/5
        cell.unreadMessageView.backgroundColor = UIColor.mainYello

        
        if let i = matchData.certification {
            if !i {
                cell.certificationView.isHidden = true
                cell.ProfileImg.layer.borderWidth = 0
            } else {
                cell.ProfileImg.layer.borderWidth = 1.5
                cell.ProfileImg.layer.borderColor = UIColor.white.cgColor
                cell.certificationView.isHidden = false
            }
            cell.ProfileLabel!.text = "#\(matchData.location!) #\(String(describing: matchData.age!))세 #\(String(describing: matchData.height!))cm #\(matchData.departament!)"
            if let i = matchData.contents {
                cell.recentMessage!.text = i
                cell.recentTime.isHidden = false
            } else {
                cell.recentMessage!.text = "대화방을 열어 메세지를 보내보세요!"
                cell.recentTime.isHidden = true
            }
            
            if let i = matchData.create_time {
                let date = dateFormatter.date(from: i)
                
                if NSCalendar.current.isDateInToday(date!) {
                    let todaydateFormatter = DateFormatter()
                    todaydateFormatter.dateFormat = "a h : mm"
                    todaydateFormatter.amSymbol = "오전"
                    todaydateFormatter.pmSymbol = "오후"
                    cell.recentTime.text = todaydateFormatter.string(from: date!)
                } else {
                    let yestereaydateFormatter = DateFormatter()
                    yestereaydateFormatter.dateFormat = "MM/dd"
                    cell.recentTime.text = yestereaydateFormatter.string(from: date!)
                }
            }
            
            if matchData.unreadmessages! > 0 {
                cell.unreadMessageCountLabel.text = String(matchData.unreadmessages!)
            } else {
                cell.unreadMessageView.isHidden = true
            }
        }
        
        if (UIScreen.main.bounds.height == 568) {
            cell.unreadMessageCountLabel.font = UIFont(name: "NanumSquare", size: 9)
            cell.ProfileLabel.font = UIFont(name: "NanumSquare", size: 11)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.width/4.8
    }
    
    @objc func goToMessenger(gestureRecognizer: targetTapGestureRecognizer){
        if let _ = gestureRecognizer.targetGroup {
            let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
            let modalVC = storyboard.instantiateViewController(withIdentifier: "STMessengerViewController") as! STMessengerViewController
            
            modalVC.other_id = gestureRecognizer.target!
            modalVC.group_id = gestureRecognizer.targetGroup!
            modalVC.opened = gestureRecognizer.opened!
            self.navigationController?.pushViewController(modalVC, animated: true)
        }
    }
    
    func getMatched() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request("\(String.domain!)information/\(String.mySex!)/\(String.myId!)/get/matched-account/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{(response) in
            switch response.result {
            case .success:
                print("success : getMatchedAccount")
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
            if let responseData = response.result.value {
                let json = JSON(responseData)
                let data = json["accounts"].arrayValue
                print(json)
                var getMessage: [messageInfo] = []
                if data.count == 0 {
                    self.noneMatchView.isHidden = false
                } else {
                    
                }
                
                for i in data {
                    var matchData = messageInfo()
                    matchData.opened = i["opened"].boolValue
                    matchData.group_id = i["group_id"].intValue
                    
                    let account = i["account"].dictionary!
                    let imgArray = account["images"]!
                    let approved = imgArray["approved"].arrayValue
                    matchData.unreadmessages = i["unread_messages"].intValue
                    matchData.id = account["id"]?.intValue
                    matchData.age = account["age"]?.intValue
                    matchData.departament = account["department"]?.stringValue
                    matchData.location = account["location"]?.stringValue
                    matchData.height = account["height"]?.intValue
                    matchData.ProFileURL = approved[0]["name"].stringValue
                    matchData.certification = account["authenticated"]?.boolValue
                    
                    let last_message = i["last_message"].dictionary!
                    print(last_message)
                    matchData.contents = last_message["contents"]?.stringValue
                    matchData.create_time = last_message["create_time"]?.stringValue
                    
                    
                    getMessage.append(matchData)
                }
                self.getMessageimg(getMessage)
            }
        }
    }
    
    func getMessageimg(_ messageArray: [messageInfo]) {
        var setProfileArray = [messageInfo]()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        for (index, i) in messageArray.enumerated() {
            var message = i
            let string = message.ProFileURL
            let replaced = (string! as NSString).replacingOccurrences(of: "{}", with: "small")

            Alamofire.request("\(String.domain!)profile/"+replaced, headers: headers).responseData { (response) in
                print(response)
                if let responseData = response.result.value {
                    print(JSON(responseData).stringValue)
                    message.id_image = UIImage(data: response.data!)
                    setProfileArray.append(message)
                    
                    if(messageArray.count == setProfileArray.count) {
                        self.messageList = setProfileArray
                        self.sortingMessage()
                    }
                }
            }
        }
    }
    
    func sortingMessage() {
        self.messageList.sort { (a, b) -> Bool in
            var aDate = Date()
            var bDate = Date()
            let Formatter = DateFormatter()
            Formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let i = a.create_time {
                aDate = Formatter.date(from: i)!
            } else {
                aDate = Formatter.date(from: "1970-01-01 01:00:00")!
            }
            if let i = b.create_time {
                bDate = Formatter.date(from: i)!
            } else {
                aDate = Formatter.date(from: "1970-01-01 01:00:00")!
            }
            
            let aInt = Int(aDate.timeIntervalSince1970)
            let bInt = Int(bDate.timeIntervalSince1970)
            
            return bInt > aInt
        }
        self.MessageListTableView.reloadData()
    }
}
