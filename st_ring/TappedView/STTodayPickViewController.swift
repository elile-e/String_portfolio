//
//  STTodayPickViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 1..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class STTodayPickViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var todayProfile1: UIView!
    @IBOutlet weak var todayProfile2: UIView!
    @IBOutlet weak var lastProfileCollectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var WhiteMemberView: UIImageView!
    @IBOutlet weak var LastProfileAspect: NSLayoutConstraint!
    @IBOutlet weak var noneLastPick: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var requestWhiteMemberViewRatio: NSLayoutConstraint!
    
    var todayView1 = bigProFileView.instanceFromNib()
    var todayView2 = bigProFileView.instanceFromNib()
    var lastProfile = [miniProfile]()
    var todayProfile = [bigProfile]()
    var checkTodayOpen = true
    let isWhiteMember = UserDefaults.standard.bool(forKey: "certification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        self.lastProfileCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        self.lastProfileCollectionView.register(UINib(nibName: "miniProFileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "miniProFileCollectionViewCell")
        
        
        self.lastProfileCollectionView.delegate = self
        self.lastProfileCollectionView.dataSource = self
        
        
        //set layout
        self.todayProfile1.layer.shadowColor = UIColor.lightGray.cgColor
        self.todayProfile1.layer.shadowOffset = CGSize(width: 15, height: 15)
        self.todayProfile1.layer.shadowRadius = 10
        self.todayProfile1.layer.shadowOpacity = 0.2
        
        
        self.todayProfile2.layer.shadowColor = UIColor.lightGray.cgColor
        self.todayProfile2.layer.shadowOffset = CGSize(width: 15, height: 15)
        self.todayProfile2.layer.shadowRadius = 10
        self.todayProfile2.layer.shadowOpacity = 0.2
        
        let WhiteMember = UITapGestureRecognizer(target: self, action: #selector(goToWhiteMember))
        self.WhiteMemberView.addGestureRecognizer(WhiteMember)
        
        if (UIScreen.main.bounds.height == 568) {
            self.todayView1.profileLabel.font = UIFont(name: "NanumSquare", size: 8)
            self.todayView2.profileLabel.font = UIFont(name: "NanumSquare", size: 8)
        }
        
        if isWhiteMember {
            self.WhiteMemberView.isHidden = true
            self.requestWhiteMemberViewRatio.constraintWithMultiplier(0.01)
        }
        
        getTodayProfile()
        getLastProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //API
        getLastProfile()
        getTodayProfile()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniProFileCollectionViewCell", for: indexPath) as! miniProFileCollectionViewCell
        cell.layer.layoutIfNeeded()
        let indexProfile = self.lastProfile[indexPath.row]
        let cellTap = targetTapGestureRecognizer(target: self, action: #selector(goToProfile))
        cellTap.target = indexProfile.id
        cell.addGestureRecognizer(cellTap)
        
        let colorclass = grColor()
        let color = colorclass.gradientHorizontal
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = cell.profileImg.frame
//        rectShape.position = cell.profileImg.center
//        rectShape.path = UIBezierPath(roundedRect: cell.profileImg.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
//        
//        cell.profileImg.layer.mask = rectShape
        cell.profileImg.layer.backgroundColor = UIColor.clear.cgColor
        cell.profileImg?.image = indexProfile.profileDownloadImg
        cell.profileLabel?.text = "#\(String(describing: indexProfile.location!)) #\(String(describing: indexProfile.age!))"
        cell.profileImg.clipsToBounds = true
        
        cell.layer.cornerRadius = 8
        
        color.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.certificationImg.frame.height)
        cell.certificationImg.backgroundColor = .clear
        cell.certificationImg.layer.addSublayer(color)
        
        if indexProfile.certification! {
            cell.certificationImg?.isHidden = false
            cell.certificationLabel?.isHidden = false
        } else {
            cell.certificationImg?.isHidden = true
            cell.certificationLabel?.isHidden = true
        }
        
        if indexProfile.lock! {
            cell.blurImg?.isHidden = true
            cell.lockImg?.isHidden = true
            cellTap.opened = true
        } else {
            cell.lockImg.isHidden = false
            cellTap.opened = false
        }
        
        if (UIScreen.main.bounds.height == 568) {
            cell.profileLabel.font = UIFont(name: "NanumSquare", size: 7)
            cell.certificationLabel.font = UIFont(name: "NanumSquare", size: 7)
            
        }
        
        cell.addGestureRecognizer(cellTap)
 
        
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.lastProfileCollectionView.frame.width/3
        return CGSize(width: cellWidth - 10, height: (cellWidth * 1.3) - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    @IBAction func moreAction(_ sender: Any) {
        var collectionLineNumber : Int?
        let widthRatio = 155.0
        let heightRatio = 67.5
        
        if(lastProfile.count%3 != 0) {
            collectionLineNumber = lastProfile.count/3 + 1
        } else {
            collectionLineNumber = lastProfile.count/3
        }
        
        
        let newRatio = self.LastProfileAspect.constraintWithMultiplier(CGFloat(widthRatio/(heightRatio * Double(collectionLineNumber!))))
        self.view!.removeConstraint(self.LastProfileAspect)
        self.view!.addConstraint(newRatio)
        self.moreButton.removeFromSuperview()
        self.view!.layoutIfNeeded()
        print("action")
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
    
    @objc func goToProfile(gestureRecognizer: targetTapGestureRecognizer) {
        if gestureRecognizer.opened! {
            let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
            let modalVC = storyboard.instantiateViewController(withIdentifier: "STProfileViewController") as! STProfileViewController
            modalVC.id = String(gestureRecognizer.target!)
            openRegister(id: gestureRecognizer.target!)
            
            self.present(modalVC, animated: true, completion: nil)
        } else {
            let openAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let message = "프로필을 열어보기 위해 \n\n20코인이 필요합니다.\n(화이트 맴버는 10코인)"
            let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
            
            openAlert.setValue(mutableMessage, forKey: "attributedMessage")
            
            openAlert.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) in
                self.checkItem(id: gestureRecognizer.target!)
            }))
            openAlert.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
            
            self.present(openAlert, animated: true, completion: nil)
        }
    }
    
    @objc func goToWhiteMember(){
        print("tap")
        let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "STWhiteMemberViewController")
        self.present(modalVC, animated: true, completion: nil)
    }
    
    func getLastProfile() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request("\(String.domain!)information/\(String.mySex!)/\(String.myId!)/get/last-5day-matched-account/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getLastAPI")
                if let responseData = response.result.value {
                    let result = JSON(responseData)
                    let resultjson = result["accounts"].arrayValue
                    print(resultjson)
                    
                    var getProfile = [miniProfile]()
                    for i in resultjson{
                        var Profile = miniProfile()
                        let imgArray = i["images"]
                        let approved = imgArray["approved"].arrayValue
                        
                        Profile.id = i["id"].intValue
                        Profile.location = i["location"].stringValue
                        Profile.certification = i["authenticated"].boolValue
                        Profile.age = i["age"].intValue
                        Profile.profileImg = approved[0]["name"].stringValue
                        Profile.lock = i["opened"].boolValue
                        getProfile.append(Profile)
                    }
                    
                    if getProfile.count < 4 {
                        self.moreButton?.removeFromSuperview()
                        if getProfile.count == 0 {
                            self.noneLastPick.isHidden = false
                        }
                    }
                    self.getlastimg(getProfile)
                }
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    func getlastimg(_ profileArray: [miniProfile]) {
        var setProfileArray = [miniProfile](repeating: miniProfile(), count: profileArray.count)
        var counter = 0
        
        for (index, i) in profileArray.enumerated() {
            var mini = i
            let string = mini.profileImg
            let replaced = (string! as NSString).replacingOccurrences(of: "{}", with: "small")
            
            Alamofire.request("\(String.domain!)profile/"+replaced).responseData { (response) in
                print(response)
                mini.profileDownloadImg = UIImage(data: response.data!)
                setProfileArray[index] = mini
                counter += 1
                
                if counter == profileArray.count {
                    self.lastProfile = setProfileArray
                    self.lastProfileCollectionView.reloadData()
                }
            }
        }
    }
    
    func getTodayProfile() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        var todayProfiles = [bigProfile(), bigProfile()]
        let myId = UserDefaults.standard.integer(forKey: "id")
        
        Alamofire.request("\(String.domain!)information/\(String.mySex!)/\(myId)/get/today-introduction/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getAPI")
                if let responseData = response.result.value {
                    let result = JSON(responseData)
                    print(result)
                    let resultjson = result["accounts"].arrayValue
                    
                    if resultjson.count == 2 {
                        for (index, i) in resultjson.enumerated(){
                            var Profile = bigProfile()
                            let imgArray = i["images"]
                            let approved = imgArray["approved"].arrayValue
                            Profile.id = i["id"].intValue
                            Profile.location = i["location"].stringValue
                            Profile.certification = i["authenticated"].boolValue
                            Profile.age = i["age"].intValue
                            Profile.height = i["height"].intValue
                            Profile.departament = i["department"].stringValue
                            Profile.profileImg = approved[0]["name"].stringValue
                            Profile.lock = i["opened"].boolValue
                            todayProfiles[index] = Profile
                        }
                        if let _ = todayProfiles[0].lock {
                            if (todayProfiles[0].lock! == false) && (todayProfiles[1].lock! == false) {
                                self.checkTodayOpen = false
                            }
                        }
                        self.SetTodayProfile(profile: todayProfiles)
                    }
                }
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    func SetTodayProfile(profile : [bigProfile]) {
        let todayProfilesView =  [self.todayProfile1, self.todayProfile2]
        let todayView = [self.todayView1, self.todayView2]
        
        for (index, i) in todayProfilesView.enumerated() {
            let profiles = todayView[index]
            let colorclass = grColor()
            let profileContents = profile[index]
            
            if let id = profileContents.id {
                let ProfileTap = targetTapGestureRecognizer(target: self, action: #selector(checkOpen))
                ProfileTap.target = id
                ProfileTap.opened = profileContents.lock!
                todayView[index].addGestureRecognizer(ProfileTap)
                todayView[index].profileLabel.text = "#\(profileContents.location!) #\(profileContents.age!)세 #\(profileContents.height!)cm \n#\(profileContents.departament!)"
                if profileContents.certification! == false{
                    profiles.certificationImg.isHidden = true
                } else {
                    profiles.certificationImg.isHidden = false
                }
                if profileContents.lock! {
                    profiles.lockImg.isHidden = true
                } else {
                    profiles.lockImg.isHidden = false
                }
                self.setImage(url: profileContents.profileImg!, view: todayView[index])
            }
            
            i?.addSubview(profiles)
            
            profiles.frame = i!.bounds
            profiles.layer.cornerRadius = 8
            profiles.clipsToBounds = true
            let color = colorclass.gradientHorizontal
            color.frame = CGRect(x: 0, y: 0, width: profiles.frame.width, height: profiles.frame.width/10)
            profiles.certificationImg.backgroundColor = .clear
            profiles.certificationImg.layer.addSublayer(color)
        }
        if let _ = profile[0].lock {
            if (profile[0].lock! == false) && (profile[1].lock! == false) {
                self.todayView1.lockImg.isHidden = true
                self.todayView2.lockImg.isHidden = true
            }
        }
    }
    
    func setImage(url: String, view: bigProFileView) {
        let string = url
        let replaced = (string as NSString).replacingOccurrences(of: "{}", with: "medium")
        Alamofire.request("\(String.domain!)profile/"+replaced).responseData { (response) in
            print(response.result)
            view.ProfileImg.image = UIImage(data: response.data!)
        }
    }
    
    @objc func checkOpen(gestureRecognizer: targetTapGestureRecognizer) {
        if (self.todayView1.lockImg.isHidden == true) && (self.todayView1.lockImg.isHidden == true) && !self.checkTodayOpen {
            let openAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let message = "오늘의 카드를 픽 하시겠습니까?"
            let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
            
            openAlert.setValue(mutableMessage, forKey: "attributedMessage")
            
            gestureRecognizer.opened = true
            
            openAlert.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) in
                self.goToProfile(gestureRecognizer: gestureRecognizer)
                self.checkTodayOpen = true
                }))
            openAlert.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
            
            self.present(openAlert, animated: true, completion: nil)
        } else {
            goToProfile(gestureRecognizer: gestureRecognizer)
        }
    }
    
    func checkItem(id: Int){
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "item_id" : UserDefaults.standard.bool(forKey: "certification") ? 4 : 1
            ] as [String : Any]
        
        var returnValue = false
    
        Alamofire.request(String.domain! + "information/pay/item/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getItem")
                let json = JSON(response.result.value)
                print(json)
                returnValue = json["result"].boolValue
                
                if returnValue {
                    let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
                    let modalVC = storyboard.instantiateViewController(withIdentifier: "STProfileViewController") as! STProfileViewController
                    modalVC.id = String(id)
                    self.openRegister(id: id)
                    
                    self.present(modalVC, animated: true, completion: nil)
                } else {
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
    
    func openRegister(id: Int) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "open_id" : id as Any
        ]
        
        Alamofire.request(String.domain! + "information/register/open-profile/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
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
}
