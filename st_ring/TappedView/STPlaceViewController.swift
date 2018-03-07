//
//  STPlaceViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 5..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import ImageSlideshow
import SwiftMessages
import Alamofire
import SwiftyJSON

class STPlaceViewController: UIViewController {
    @IBOutlet weak var ProfileSlider: ImageSlideshow!
    
    @IBOutlet weak var Candy1: UIButton!
    @IBOutlet weak var Candy2: UIButton!
    @IBOutlet weak var Candy3: UIButton!
    @IBOutlet weak var Candy4: UIButton!
    @IBOutlet weak var Candy5: UIButton!
    @IBOutlet weak var ProfileLabel: UILabel!
    @IBOutlet weak var DoneView: UIView!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var inreviewLabelView: UIView!
    
    var Candy: [UIButton]?
    var PlaceProfile: [reviewProfile?]?
    var ReviewCounter = 0
    var currentId: Int?
    var errorCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ADD gesture 
        let profileTap = targetTapGestureRecognizer(target: self, action: #selector(goToProfile))
        ProfileSlider.addGestureRecognizer(profileTap)
        
        //Setting View
        Candy = [Candy1, Candy2, Candy3, Candy4, Candy5]
        
        ProfileSlider.backgroundColor = UIColor.white
        ProfileSlider.pageControl.currentPageIndicatorTintColor = UIColor.white
        ProfileSlider.pageControl.pageIndicatorTintColor = UIColor.lightGray
        ProfileSlider.pageControlPosition = .insideScrollView
        ProfileSlider.contentScaleMode = UIViewContentMode.scaleAspectFill
        ProfileSlider.activityIndicator = DefaultActivityIndicator()
        ProfileSlider.circular = false
        
        ProfileSlider.layer.cornerRadius = 10
        ProfileSlider.layer.borderColor = UIColor.mainGray.cgColor
        ProfileSlider.layer.borderWidth = 1
        
        //API
        GetEvalAccounts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OneCandy(_ sender: Any) {
        generator()
        Candy1.setImage(UIImage(named: "Candy"), for: .normal)
        
        if let i = currentId {
            RegisterScore(ToId: currentId!, Score: 1)
        }
    }
    
    @IBAction func TwoCandy(_ sender: Any) {
        generator()
        for i in 0...1 {
            Candy![i].setImage(UIImage(named: "Candy"), for: .normal)
        }
        if let i = currentId {
            RegisterScore(ToId: currentId!, Score: 2)
        }
    }
    
    @IBAction func ThreeCandy(_ sender: Any) {
        generator()
        for i in 0...2 {
            Candy![i].setImage(UIImage(named: "Candy"), for: .normal)
        }
        
        if let i = currentId {
            RegisterScore(ToId: currentId!, Score: 3)
        }
    }
    
    @IBAction func FourCandy(_ sender: Any) {
        generator()
        for i in 0...3 {
            Candy![i].setImage(UIImage(named: "Candy"), for: .normal)
        }
        
        if let i = currentId {
            RegisterScore(ToId: currentId!, Score: 4)
        }
    }
    
    @IBAction func FiveCandy(_ sender: Any) {
        generator()
        for i in 0...4 {
            Candy![i].setImage(UIImage(named: "Candy"), for: .normal)
        }
        
        if let i = currentId {
            RegisterScore(ToId: currentId!, Score: 5)
        }
    }
    
    @objc func goToProfile(gestureRecognizer: targetTapGestureRecognizer) {
        if PlaceProfile![ReviewCounter]?.status! != "INREVIEW" {
            let storyboard = UIStoryboard(name: "CommonStoryboard", bundle: nil)
            let modalVC = storyboard.instantiateViewController(withIdentifier: "STProfileViewController") as! STProfileViewController
            gestureRecognizer.target = currentId
            modalVC.id = String(gestureRecognizer.target!)
            
            self.present(modalVC, animated: true, completion: nil)
        }
    }
    
    func chargeCheese() {
        addCoin()
        
        let toast = MessageView.viewFromNib(layout: .statusLine)
        var config = SwiftMessages.Config()
        toast.configureTheme(backgroundColor: .mainYello, foregroundColor: .black)
        toast.configureContent(body: "1코인을 획득하셨어요!")
        config.preferredStatusBarStyle = .default
        SwiftMessages.show(config: config, view: toast)
    }
    
    func GetEvalAccounts() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request("\(String.domain!)information/\(String.mySex!)/\(String.myId!)/get/eval-account/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getAPI")
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
            if let responseData = response.result.value {
                let json = JSON(responseData)
                let resultjson = json["accounts"].arrayValue
                print(resultjson)
                
                var getProfile = [reviewProfile]()
                for i in resultjson{
                    var Profile = reviewProfile()
                    let allImg = i["images"]
                    var img = [String]()
                    Profile.id = i["id"].intValue
                    Profile.location = i["location"].stringValue
                    Profile.certification = i["certification"].boolValue
                    Profile.age = i["age"].intValue
                    Profile.height = i["height"].intValue
                    Profile.education = i["education"].stringValue
                    Profile.departament = i["department"].stringValue
                    Profile.status = i["status"].stringValue
                    let status = i["status"].stringValue == "INREVIEW" ? "in_review" : "approved"
                    
                    for a in allImg[status].arrayValue {
                        img.append(String(a["name"].stringValue))
                    }
                    Profile.profileImg = img
                    getProfile.append(Profile)
                }
                self.PlaceProfile = getProfile
                self.NextProfile()
            }
        }
    }
    
    func RegisterScore(ToId: Int, Score: Int){
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let params: [String : Any] = [
            "from_id" : String.myId!,
            "to_id" : ToId,
            "score" : Score
        ]
        
        Alamofire.request("\(String.domain!)information/register/score/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getAPI")
                if let responseData = response.result.value {
                    let resultjson = JSON(responseData)
                    let result = resultjson["result"].boolValue
                    print(response)
                    if result {
                        self.NextProfile()
                        self.chargeCheese()
                        if Score >= 4 {
                            self.openRegister(id: ToId)
                        }
                    }
                }
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
    
    func NextProfile() {
        if (PlaceProfile?.count)! > ReviewCounter + 1 {
            let NextProfile = PlaceProfile![ReviewCounter + 1]
            let ImgURL = NextProfile?.toImgURL()
            var ImgSource = [AlamofireSource]()
            currentId = NextProfile?.id
            
            if NextProfile!.status! == "INREVIEW" {
                inreviewLabelView.isHidden = false
            } else {
                inreviewLabelView.isHidden = true
            }
            
            for i in Candy! {
                i.setImage(UIImage(named: "unCandy"), for: .normal)
            }
            
            ProfileLabel.text = "#\(NextProfile!.location!) #\(NextProfile!.age!)세 #\(NextProfile!.height!)cm #\(NextProfile!.education!) #\(NextProfile!.departament!)"
            
            for i in ImgURL! {
                ImgSource.append(AlamofireSource(urlString: i)!)
            }
            
            ProfileSlider.setImageInputs(ImgSource)
            ProfileSlider.setCurrentPage(0, animated: true)
            
            ReviewCounter += 1
        } else {
            DoneView.isHidden = false
            doneLabel.text = "오늘 심사를 모두 진행하셨어요! \n 내일 다시 해주세요"
        }
    }
    
    func addCoin() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "amount" : 1 as Any
        ]
        
        print(param)
        
        Alamofire.request(String.domain! + "information/charge-coin/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value)
                let result = json["result"].boolValue
                if !result {
                    self.errorCount += 1
                    if self.errorCount == 3 {
                        let errorMessage = "불편을 드려 죄송합니다. \n상품 등록중 에러가 발생되었습니다. 고객센터에 문의해주세요."
                        let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.errorCount = 0
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.addCoin()
                    }
                }
                print(json)
                
            case .failure(let error):
                print("post regist like" + String(describing: error))
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
    
    func generator() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}
