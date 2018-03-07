//
//  STMYPickViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 5..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class STMYPickViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var likeMeCardCollectionView: UICollectionView!
    @IBOutlet weak var interestMeCardCollectionView: UICollectionView!
    @IBOutlet weak var iLikeCardCollectionView: UICollectionView!
    @IBOutlet weak var iInterestCardCollectionView: UICollectionView!
    @IBOutlet weak var noneLikeMeView: UIView!
    @IBOutlet weak var noneInterestMeView: UIView!
    @IBOutlet weak var noneILikeView: UIView!
    @IBOutlet weak var noneIInterestView: UIView!
    
    @IBOutlet weak var likeMeMoreButton: UIButton!
    @IBOutlet weak var interestMeMoreButton: UIButton!
    @IBOutlet weak var iLikeMoreButton: UIButton!
    @IBOutlet weak var iInterestMoreButton: UIButton!
    @IBOutlet weak var likeMeAspect: NSLayoutConstraint!
    @IBOutlet weak var interestMeAspect: NSLayoutConstraint!
    @IBOutlet weak var iLikeAspect: NSLayoutConstraint!
    @IBOutlet weak var iInterestAspect: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var likeMeProfile = [miniProfile]()
    var interestMeProfile = [miniProfile]()
    var iLikeProfile = [miniProfile]()
    var iInteresteProfile = [miniProfile]()
    let widthRatio = 155.0
    let heightRatio = 67.5
    
    var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.mainYello
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeMeCardCollectionView.delegate = self
        likeMeCardCollectionView.dataSource = self
        interestMeCardCollectionView.delegate = self
        interestMeCardCollectionView.dataSource = self
        iLikeCardCollectionView.delegate = self
        iLikeCardCollectionView.dataSource = self
        iInterestCardCollectionView.delegate = self
        iInterestCardCollectionView.dataSource = self
        
        self.likeMeCardCollectionView.register(UINib(nibName: "miniProFileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "miniProFileCollectionViewCell")
        self.interestMeCardCollectionView.register(UINib(nibName: "miniProFileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "miniProFileCollectionViewCell")
        self.iLikeCardCollectionView.register(UINib(nibName: "miniProFileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "miniProFileCollectionViewCell")
        self.iInterestCardCollectionView.register(UINib(nibName: "miniProFileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "miniProFileCollectionViewCell")
        
        let likeMeLayout = UICollectionViewFlowLayout()
        let interesteMeLayout = UICollectionViewFlowLayout()
        let iInterestLayout = UICollectionViewFlowLayout()
        let iLikeLayout = UICollectionViewFlowLayout()
        self.likeMeCardCollectionView.setCollectionViewLayout(likeMeLayout, animated: true)
        self.interestMeCardCollectionView.setCollectionViewLayout(interesteMeLayout, animated: true)
        self.iInterestCardCollectionView.setCollectionViewLayout(iInterestLayout, animated: true)
        self.iLikeCardCollectionView.setCollectionViewLayout(iLikeLayout, animated: true)
        
       scrollView.addSubview(refreshController)
        
       getMyPick()
    }
    
    override func viewDidAppear(_ animated: Bool) {
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case likeMeCardCollectionView:
            return likeMeProfile.count
        case interestMeCardCollectionView:
            return interestMeProfile.count
        case iLikeCardCollectionView:
            return iLikeProfile.count
        case iInterestCardCollectionView:
            return iInteresteProfile.count
        default:
            return 0
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->  UICollectionViewCell {
        var ProfileArray: [miniProfile]?
        switch collectionView {
        case likeMeCardCollectionView:
            ProfileArray = likeMeProfile
            break
        case interestMeCardCollectionView:
            ProfileArray = interestMeProfile
            break
        case iLikeCardCollectionView:
            ProfileArray = iLikeProfile
            break
        case iInterestCardCollectionView:
            ProfileArray = iInteresteProfile
            break
        default:
            break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniProFileCollectionViewCell", for: indexPath) as! miniProFileCollectionViewCell
        let cellTap = targetTapGestureRecognizer(target: self, action: #selector(goToProfile))
        let indexProfile = ProfileArray![indexPath.row]
        cellTap.target = indexProfile.id!
        cellTap.opened = indexProfile.lock!
        
        let colorclass = grColor()
        let color = colorclass.gradientHorizontal

        
        cell.profileImg.layer.backgroundColor = UIColor.clear.cgColor
        cell.profileLabel?.text = "#\(String(describing: indexProfile.location!)) #\(String(describing: indexProfile.age!))"
        cell.profileImg.image = indexProfile.profileDownloadImg
        
        color.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.width / 10)
        cell.certificationImg.backgroundColor = .clear
        cell.certificationImg.layer.addSublayer(color)
        
        cell.layer.cornerRadius = 8
        
        if indexProfile.certification! {
            cell.certificationImg?.isHidden = false
            cell.certificationLabel?.isHidden = false
        } else {
            cell.certificationImg?.isHidden = true
            cell.certificationLabel?.isHidden = true
        }
        
        if indexProfile.lock! {
            cell.lockImg?.isHidden = true
        } else {
            cell.lockImg?.isHidden = false
        }
        
        if indexProfile.status == "INREVIEW" {
            cell.blurImg.isHidden = false
        } else {
            cell.blurImg.isHidden = true
            cell.addGestureRecognizer(cellTap)
        }
        
        if (UIScreen.main.bounds.height == 568) {
            cell.profileLabel.font = UIFont(name: "NanumSquare", size: 7)
            cell.certificationLabel.font = UIFont(name: "NanumSquare", size: 7)
            
        }
        
        return  cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.likeMeCardCollectionView.frame.width/3
        return CGSize(width: cellWidth - 10, height: (cellWidth * 1.3) - 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func LikeMeMoreAction(_ sender: Any) {
        var collectionLineNumber : Int?
        
        if(likeMeProfile.count%3 != 0) {
            collectionLineNumber = likeMeProfile.count/3 + 1
        } else {
            collectionLineNumber = likeMeProfile.count/3
        }
        
        let newRatio = self.likeMeAspect.constraintWithMultiplier(CGFloat(widthRatio/(heightRatio * Double(collectionLineNumber!))))
        self.view!.removeConstraint(self.likeMeAspect)
        self.view!.addConstraint(newRatio)
        if let _ = self.likeMeMoreButton {
            self.likeMeMoreButton.removeFromSuperview()
            self.likeMeMoreButton = nil
        }
        self.view!.layoutIfNeeded()
    }
    
    @IBAction func IntrestMeMoreAction(_ sender: Any) {
        var collectionLineNumber : Int?
        
        if(interestMeProfile.count%3 != 0) {
            collectionLineNumber = interestMeProfile.count/3 + 1
        } else {
            collectionLineNumber = interestMeProfile.count/3
        }
        let newRatio = self.interestMeAspect.constraintWithMultiplier(CGFloat(widthRatio/(heightRatio * Double(collectionLineNumber!))))
        self.view!.removeConstraint(self.interestMeAspect)
        self.view!.addConstraint(newRatio)
        if let _ = self.interestMeMoreButton {
            self.interestMeMoreButton.removeFromSuperview()
            self.interestMeMoreButton = nil
        }
        self.view!.layoutIfNeeded()
    }
    
    @IBAction func ILikeMoreAction(_ sender: Any) {
        var collectionLineNumber : Int?
        
        if(iLikeProfile.count%3 != 0) {
            collectionLineNumber = iLikeProfile.count/3 + 1
        } else {
            collectionLineNumber = iLikeProfile.count/3
        }
        let newRatio = self.iLikeAspect.constraintWithMultiplier(CGFloat(widthRatio/(heightRatio * Double(collectionLineNumber!))))
        self.view!.removeConstraint(self.iLikeAspect)
        self.view!.addConstraint(newRatio)
        if let _ = self.iLikeMoreButton {
            self.iLikeMoreButton.removeFromSuperview()
            self.iLikeMoreButton = nil
        }
        self.view!.layoutIfNeeded()
    }
    
    @IBAction func IIntrestMoreAction(_ sender: Any) {
        var collectionLineNumber : Int?
        
        if(iInteresteProfile.count%3 != 0) {
            collectionLineNumber = iInteresteProfile.count/3 + 1
        } else {
            collectionLineNumber = iInteresteProfile.count/3
        }
        
        let newRatio = self.iInterestAspect.constraintWithMultiplier(CGFloat(widthRatio/(heightRatio * Double(collectionLineNumber!))))
        self.view!.removeConstraint(self.iInterestAspect)
        self.view!.addConstraint(newRatio)
        if let _ = self.iInterestMoreButton {
            self.iInterestMoreButton.removeFromSuperview()
            self.iInterestMoreButton = nil
        }
        self.view!.layoutIfNeeded()
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
            let message = "프로필을 열어보기 위해 \n\n20코인이 필요합니다. \n(화이트 맴버는 10코인)"
            let mutableMessage = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
            
            openAlert.setValue(mutableMessage, forKey: "attributedMessage")
            openAlert.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) in
                self.checkItem(id: gestureRecognizer.target!)
            }))
            openAlert.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
            
            self.present(openAlert, animated: true, completion: nil)
        }
    }
    
    func getMyPick() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request(String.domain! + "information/\(String.mySex!)/\(String.myId!)/get/my-pick-list/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result {
            case .success:
                print("success : open")
                let json = JSON(response.result.value!)
                let likeMe = json["receive_like_list"].arrayValue
                let interestMe = json["receive_high_score_list"].arrayValue
                let iLike = json["send_like_list"].arrayValue
                let iInterest = json["give_high_score_list"].arrayValue
                print(json)
                
                for (index, i) in [likeMe, interestMe, iLike, iInterest].enumerated() {
                    var list = [miniProfile]()
                    for a in i {
                        var Profile = miniProfile()
                        let imgArray = a["images"]
                        Profile.id = a["id"].intValue
                        Profile.status = a["status"].stringValue
                        
                        let profileImg = Profile.status! == "INREVIEW" ? imgArray["in_review"].arrayValue : imgArray["approved"].arrayValue
                        
                        
                        Profile.age = a["age"].intValue
                        Profile.location = a["location"].stringValue
                        
                        if profileImg.count > 0 {
                            Profile.profileImg = profileImg[0]["name"].stringValue
                        }
                        
                        Profile.lock = a["opened"].boolValue
                        Profile.certification = a["authenticated"].boolValue
                        
                        list.append(Profile)
                    }
                    
                    if i.count == list.count {
                        switch index {
                        case 0:
                            self.getimg(list, "likeMe")
                            if list.count < 4{
                                if let _ = self.likeMeMoreButton {
                                    self.likeMeMoreButton.removeFromSuperview()
                                    self.likeMeMoreButton = nil
                                }
                                
                                if list.count == 0 {
                                    self.noneLikeMeView.isHidden = false
                                }
                            }
                            break
                        case 1:
                            self.getimg(list, "interestMe")
                            if list.count < 4{
                                if let _ = self.interestMeMoreButton {
                                    self.interestMeMoreButton.removeFromSuperview()
                                    self.interestMeMoreButton = nil
                                }
                                
                                if list.count == 0 {
                                    self.noneInterestMeView.isHidden = false
                                }
                            }
                            break
                        case 2:
                            self.getimg(list, "iLike")
                            if list.count < 4{
                                if let _ = self.iLikeMoreButton {
                                self.iLikeMoreButton.removeFromSuperview()
                                self.iLikeMoreButton = nil
                                }
                                if list.count == 0 {
                                    self.noneILikeView.isHidden = false
                                }
                            }
                            break
                        case 3:
                            self.getimg(list, "iInterest")
                            if list.count < 4{
                                if let _ = self.iInterestMoreButton {
                                self.iInterestMoreButton.removeFromSuperview()
                                self.iInterestMoreButton = nil
                                }
                                
                                if list.count == 0 {
                                    self.noneIInterestView.isHidden = false
                                }
                            }
                            break
                        default:
                            break
                        }
                    }
                }
            case .failure(let error):
                print("이것은 open api 에러 :" + String(describing: error))
                let json = JSON(response)
                print(json)
            }
        }
    }
    
    func getimg(_ profileArray: [miniProfile],_ type: String) {
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
                    switch type {
                    case "likeMe":
                        self.likeMeProfile = setProfileArray
                        self.likeMeCardCollectionView.reloadData()
                        break
                    case "interestMe":
                        self.interestMeProfile = setProfileArray
                        self.interestMeCardCollectionView.reloadData()
                        break
                    case "iLike":
                        self.iLikeProfile = setProfileArray
                        self.iLikeCardCollectionView.reloadData()
                        break
                    case "iInterest":
                        self.iInteresteProfile = setProfileArray
                        self.iInterestCardCollectionView.reloadData()
                    default:
                        break
                    }
                }
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
                    let alert = UIAlertController(title: nil, message: "코인이 부족합니다. \n충전하러 가시겠어요?", preferredStyle: .alert)
                    
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getMyPick()
        refreshController.endRefreshing()
    }
}
