//
//  STProfileViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 11..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRWordWrapLabel

struct editImage {
    var index: Int?
    var image: UIImage?
}

class STProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var ProfileLabel: UILabel!
    @IBOutlet weak var MyProfileImg: UIImageView!
    @IBOutlet weak var ProfileCollectionView: UICollectionView!
    @IBOutlet weak var talkTableView: UITableView!
    @IBOutlet weak var ProfileBackImg: UIImageView!
    @IBOutlet weak var myProfilebackImg: UIView!
    @IBOutlet weak var backColorView: UIView!
    @IBOutlet weak var xButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var reportBtn: UIBarButtonItem!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    let color1 : grColor = grColor()
    let color2 : grColor = grColor()
    var id = String()
    var sex = String.otherSex!
    
    var ProfileImgArray = [UIImage]()
    var ProfileQAArray = [String]()
    var ProfileAnswer = [message]()
    var ProfileQA = [message]()
    var ProfileLable = JSON()
    var editImgArray = [editImage]()
    var editQAArray = [message]()
    var approvedImageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.ProfileCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        self.talkTableView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        ProfileImg.layer.cornerRadius = ProfileImg.frame.width/2
        ProfileImg.layer.borderColor = UIColor.white.cgColor
        ProfileImg.layer.borderWidth = 2
        MyProfileImg.layer.cornerRadius = MyProfileImg.frame.width/2
        MyProfileImg.layer.borderWidth = 2
        MyProfileImg.layer.borderColor = UIColor.white.cgColor
        
        let gr1 = color1.gradient
        gr1.frame = CGRect(origin: CGPoint.zero, size: myProfilebackImg.bounds.size)
        myProfilebackImg.layer.addSublayer(gr1)
        myProfilebackImg.layer.cornerRadius = myProfilebackImg.frame.width/2
        
        let gr2 = color2.gradient
        gr2.frame = CGRect(origin: CGPoint.zero, size: ProfileBackImg.bounds.size)
        ProfileBackImg.layer.addSublayer(gr2)
        ProfileBackImg.layer.cornerRadius = ProfileBackImg.frame.width/2
        
        ProfileCollectionView.dataSource = self
        ProfileCollectionView.delegate = self
        talkTableView.dataSource = self
        talkTableView.delegate = self
        
        self.talkTableView.register(MYTableViewCell.self, forCellReuseIdentifier: "MYTableViewCell")
        self.talkTableView.register(OtherTableViewCell.self, forCellReuseIdentifier: "OtherTableViewCell")
        self.ProfileCollectionView.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        self.talkTableView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        self.backColorView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        getFullProfile()
        getMy()
        
        if (UIScreen.main.bounds.height == 812) {
            xButtonHeight.constant += 34
            likeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 34, 0 )
        } else if (UIScreen.main.bounds.height == 568) {
            ProfileLabel.font = UIFont(name: "NanumSquare", size: 10)
            myLabel.font = UIFont(name: "NanumSquare", size: 11)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ProfileQA.count > 5 {
            let textWidth : CGFloat = estimateFrameForText(ProfileQA[indexPath.row].text!).width
            let message = self.ProfileQA[indexPath.row]
            
            if message.sex! == String.otherSex!{
                let cell = OtherTableViewCell(style: .default, reuseIdentifier: "OtherTableViewCell")
                cell.bubbleWidthAnchor?.constant = textWidth + 35
                cell.textView.text = ProfileQA[indexPath.row].text
                cell.textView.sizeToFit()
                
                return cell
            } else {
                let cell = MYTableViewCell(style: .default, reuseIdentifier: "MYTableViewCell")
                cell.bubbleWidthAnchor?.constant = textWidth + 35
                cell.textView.text = ProfileQA[indexPath.row].text
                cell.textView.sizeToFit()
                
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if ProfileQA.count > 5{
            height = estimateFrameForText(ProfileQA[indexPath.row].text!).height + 25
        }
    
        return height
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileImgArray.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        let shadowLayer = CAShapeLayer()
        
        cell.ProfileImg.image = ProfileImgArray[indexPath.row]
        
        cell.ProfileImg?.layer.cornerRadius = 15
        cell.ProfileImg?.clipsToBounds = true
        cell.ShadowView?.layer.shadowColor = UIColor.lightGray.cgColor
        cell.ShadowView?.layer.shadowOpacity = 0.30
        cell.ShadowView?.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.ShadowView?.layer.shadowRadius = 5
        
        cell.ProfileImg?.layer.addSublayer(shadowLayer)
        
        
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return(CGSize(width: (self.ProfileCollectionView.frame.height/4)*3 + 82, height: self.ProfileCollectionView.frame.size.height))
        } else {
            return CGSize(width: (self.ProfileCollectionView.frame.height/4)*3 + 5, height: self.ProfileCollectionView.frame.size.height)
        }
    }
    
    func makeGradientColor(size: CGSize) -> UIColor{
        let gradientImage = UIImage(named:"gradientColor")
        
        UIGraphicsBeginImageContext(size)
        gradientImage?.draw(in: CGRect(origin: .zero, size: size))
        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // update text color
        return UIColor(patternImage: myGradient!)
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let message = "상대방을 신고 할 경우, \n상대방은 계정 삭제, 이용 정지 등의 불이익을 받을 수 있어요! \n \n 이 사람을 신고할까요?"
        let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        
        alert.setValue(mutableMessage, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getFullProfile() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request("\(String.domain!)information/\(self.sex)/\(self.id)/get/detail/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getFullProfileAPI")
            case .failure(let error):
                print("get full profile error" + String(describing: error))
            }
            if let responseData = response.result.value {
                let resultjson = JSON(responseData)
                self.ProfileLable = resultjson
                print(resultjson)
                let ImgArrayJSON = resultjson["images"]
                let approved = ImgArrayJSON["approved"].arrayValue
                self.approvedImageCount = approved.count
                let inReview = ImgArrayJSON["in_review"].arrayValue
                var ImgArrayURL = [String]()
                
                let QAArray = resultjson["QA"].arrayValue
                var QAArrayString = [String]()
                
                let smoke = resultjson["smoke"].boolValue ? "흡연" : "비흡연"
                
                if resultjson["authenticated"].boolValue {
                    self.ProfileBackImg.isHidden = false
                } else {
                    self.ProfileBackImg.isHidden = true
                    self.ProfileImg.layer.borderWidth = 0
                }
                
                if resultjson["like_from"].boolValue && !resultjson["like_to"].boolValue {
                    self.setLikeButton("like_from")
                } else if !resultjson["like_from"].boolValue && resultjson["like_to"].boolValue {
                    self.setLikeButton("like_to")
                } else if resultjson["like_from"].boolValue && resultjson["like_to"].boolValue {
                    self.setLikeButton("matched")
                } else if (self.sex == String.mySex!) && (self.id == String.myId!) {
                    self.setLikeButton("MY")
                    self.getInReview(inReview)
                }
                
                self.ProfileLabel.text = "#\(resultjson["location"].stringValue) #\(resultjson["age"].intValue)세 #\(resultjson["height"].intValue)cm #\(resultjson["department"].stringValue) #\(resultjson["body_form"].stringValue)\n#\(resultjson["education"].stringValue) #\(smoke) #\(resultjson["drink"].stringValue) #\(resultjson["religion"].stringValue) #\(resultjson["blood_type"].stringValue)형"
                    
                    
                for i in approved{
                    let image = i["name"].stringValue
                    print(image)
                    ImgArrayURL.append(image)
                }
                    
                for i in QAArray {
                    QAArrayString.append(i.stringValue)
                }
                    
                self.getFullImg(ImgArrayURL)
                self.getQA(QAArrayString)
            }
        }
    }
    
    func getFullImg(_ URLArray: [String]) {
        var imageArray = [UIImage](repeating: UIImage(), count: URLArray.count)
        var counter = 0
        
        for (index, i) in URLArray.enumerated() {
            let string = i
            let replaced = (string as NSString).replacingOccurrences(of: "{}", with: "large")
            
            Alamofire.request("\(String.domain!)profile/"+replaced).responseData { (response) in
                print(response)
                
                if let image = UIImage(data: response.data!) {
                    imageArray[index] = image
                    counter += 1
                    
                    if (URLArray.count >= 2) && (counter == URLArray.count) {
                        self.ProfileImgArray = imageArray
                        self.ProfileCollectionView.reloadData()
                        
                        self.ProfileImg.image = imageArray[1]
                    }
                }
            }
        }
    }
    
    func getInReview(_ URLArray: [JSON]) {
        var imageArray = [editImage]()
        
        for i in URLArray {
            let name = i["name"].stringValue
            let index = i["index"].intValue
            
            let replaced = (name as NSString).replacingOccurrences(of: "{}", with: "small")
            
            Alamofire.request("\(String.domain!)profile/"+replaced).responseData { (response) in
                print(response)
                
                if let image = UIImage(data: response.data!) {
                    
                    imageArray.append(editImage(index: index, image: image))
                }
                
                if imageArray.count == URLArray.count {
                    self.editImgArray = imageArray
                }
            }
        }
    }
    
    func getQA(_ QAArray: [String]) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request(String.domain! + "information/\(self.sex)/\(self.id)/get/introduction-qna/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getQA")
                if let JSONData = response.result.value {
                    var json = JSON(JSONData)
                    var result = json["qna_list"]
                    var QA = result["approved"].arrayValue
                    let editQA = result["in_review"].arrayValue
                    print(json)
                    for i in 0...2 {
                        if QA.count > 2 {
                            let question = message(text: QA[i]["question"].stringValue, sex: String.mySex!, create_time: nil, group_id: nil, question_id: nil)
                            self.ProfileQA.append(question)
                            let answer = message(text: QA[i]["answer"].stringValue, sex: String.otherSex!, create_time: nil, group_id: nil, question_id: QA[i]["question_id"].intValue)
                            self.ProfileQA.append(answer)
                        }
                    }
                    
                    for i in editQA {
                        let answer = message(text: i["answer"].stringValue, sex: String.otherSex!, create_time: nil, group_id: nil, question_id: i["question_id"].intValue)
                        self.editQAArray.append(answer)
                    }
                    self.tableViewHeight.constant = CGFloat(self.estimateTableViewHeight())
                    self.talkTableView.layoutIfNeeded()
                    self.talkTableView.reloadData()
                }
            case .failure(let error):
                print("get qa error :" + String(describing: error))
            }
        }
    }
    
    func getMy(){
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
                    let imgArray = resultjson["images"]
                    let approved = imgArray["approved"].arrayValue
                    
                    if resultjson["authenticated"].boolValue {
                        self.myProfilebackImg.isHidden = false
                    } else {
                        self.myProfilebackImg.isHidden = true
                        self.MyProfileImg.layer.borderWidth = 0
                    }
                    
                    let myImg = approved[0]["name"].stringValue
                    self.getMyImg(myImg)
                }
            case .failure(let error):
                print("get my data error :" + String(describing: error))
                print(response.debugDescription)
                let json = JSON(response)
                print(json)
            }
        }
    }
    
    func getMyImg(_ URL: String) {
        let replaced = (URL as NSString).replacingOccurrences(of: "{}", with: "small")
        
        Alamofire.request("\(String.domain!)profile/"+replaced).responseData { (response) in
            print(response)
            
            if let image = UIImage(data: response.data!) {
                self.MyProfileImg.image = image
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
    
    func resgistLike() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "to_id" : self.id as Any
        ]
        
        Alamofire.request(String.domain! + "information/register/like/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                print("좋아요 성공!")
                let json = JSON(response.result.value)
                print(json)
                if json["result"].boolValue {
                    self.likeBtn.setTitle("이미 좋아요를 발송하셨어요!", for: .normal)
                    self.likeBtn.backgroundColor = UIColor.mainGray
                    self.likeBtn.isEnabled = false
                }
                
            case .failure(let error):
                print("post regist like" + String(describing: error))
            }
        }
    }
    
    @IBAction func sendLike(_ sender: Any) {
        switch self.likeBtn.titleLabel!.text! {
        case "대화해보고 싶어요!":
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let message = "좋아요를 보내시겠어요? \n\n20코인이 사용됩니다.\n(화이트 맴버는 10코인)"
            let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
            
            alert.setValue(mutableMessage, forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "네", style: .default, handler: { handler in
                self.checkItem()
            }))
            alert.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            break
        case "상대방이 좋아요를 보내셨어요!":
            self.resgistLike()
            break
        case "수정하기":
            self.goToEditView()
        default:
            break
        }
    }
  
    func setLikeButton(_ status: String) {
        switch status {
        case "MY":
            self.likeBtn.setTitle("수정하기", for: UIControlState.normal)
            self.reportBtn.title! = ""
            self.reportBtn.isEnabled = false
            break
        case "like_from":
            self.likeBtn.setTitle("상대방이 좋아요를 보내셨어요!", for: .normal)
            break
        case "like_to":
            self.likeBtn.setTitle("이미 좋아요를 발송하셨어요!", for: .normal)
            self.likeBtn.backgroundColor = UIColor.mainGray
            self.likeBtn.setTitleColor(UIColor.darkGray, for: .normal)
            self.likeBtn.isEnabled = false
            break
        case "matched":
            self.likeBtn.setTitle("서로 좋아요! 먼저 메세지 해보세요!", for: .normal)
            self.likeBtn.backgroundColor = UIColor.mainGray
            self.likeBtn.setTitleColor(UIColor.darkGray, for: .normal)
            self.likeBtn.isEnabled = false
            break
        default:
            self.likeBtn.setTitle("대화해보고 싶어요!", for: .normal)
            self.likeBtn.isEnabled = true
            break
        }
    }
    
    func checkItem() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "item_id" : UserDefaults.standard.bool(forKey: "certification") ? 5 : 2
            ]
        
        Alamofire.request(String.domain! + "information/pay/item/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : checkItem")
                let json = JSON(response.result.value)
                print(json)
                if json["result"].boolValue {
                    
                    self.resgistLike()
                } else {
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    let message = "코인이 부족합니다. \n\n충전하러 가시겠어요?"
                    let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
                    
                    alert.setValue(mutableMessage, forKey: "attributedMessage")
                    
                    alert.setValue(UIFont.systemFont(ofSize: 15), forKey: "message")
                    alert.addAction(UIAlertAction(title: "네", style: .default, handler: { handler in
                        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
                        let modalCoin = storyboard.instantiateViewController(withIdentifier: "STCoinChargeViewController") as! STCoinChargeViewController
                        
                        self.present(modalCoin, animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print("이것은 상품쪽 에러 :" + String(describing: error))
            }
        }
    }
    
    func goToEditView() {
        let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
        let View = storyboard.instantiateViewController(withIdentifier: "STEditViewController") as! STEditViewController
        View.sex = String.mySex!
        View.QAMessage = self.ProfileQA
        View.profilImg = self.ProfileImgArray
        View.jsonProfile = self.ProfileLable
        View.editImgArray = self.editImgArray
        View.editQAArray = self.editQAArray
        View.approvedImgCount = self.approvedImageCount
        
        for _ in 0...(5 - ProfileImgArray.count) {
            View.profilImg.append(nil)
        }
        
        for i in ProfileAnswer {
            for a in editQAArray {
                if i.question_id == a.question_id {
                    var answertext = i
                    answertext.text = a.text
                    break
                }
            }
        }
        
        self.present(View, animated: true, completion: nil)
    }
    
    func estimateTableViewHeight() -> Int{
        var height = 0
        
        for i in self.ProfileQA {
            height += Int(self.estimateFrameForText(i.text!).height)
        }
        for i in self.ProfileAnswer {
            height += Int(self.estimateFrameForText(i.text!).height)
        }
        
        height += 155
        
        print(height)
        return height
    }
}
