//
//  STRejectReviewViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 23..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class STRejectReviewViewController: UIViewController {
    @IBOutlet weak var goToEdit: UIButton!
    @IBOutlet weak var xButtonHeight: NSLayoutConstraint!
    
    var ProfileQA = [message]()
    var ProfileImgArray = [UIImage]()
    var ProfileQAArray = [String]()
    var ProfileLable = JSON()
    var editImgArray = [editImage]()
    var editQAArray = [message]()
    var ProfileAnswer = [message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFullProfile()
        
        if (UIScreen.main.bounds.height == 812) {
            xButtonHeight.constant += 34
            goToEdit.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 34, 0 )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFullProfile() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        Alamofire.request("\(String.domain!)information/\(String.mySex!)/\(String.myId!)/get/detail/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
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
                let inReview = ImgArrayJSON["in_review"].arrayValue
                var ImgArrayURL = [String]()
                
                let QAArray = resultjson["QA"].arrayValue
                var QAArrayString = [String]()
                
                
                let smoke = resultjson["smoke"].boolValue ? "흡연" : "비흡연"
               
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
                self.getInReview(inReview)
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
        
        Alamofire.request(String.domain! + "information/\(String.mySex!)/\(String.myId!)/get/introduction-qna/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
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
                        let question = message(text: i["question"].stringValue, sex: String.mySex!, create_time: nil, group_id: nil, question_id: nil)
                        self.editQAArray.append(question)
                        let answer = message(text: i["answer"].stringValue, sex: String.otherSex!, create_time: nil, group_id: nil, question_id: i["question_id"].intValue)
                        self.editQAArray.append(answer)
                    }
                }
            case .failure(let error):
                print("get qa error :" + String(describing: error))
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
    
    @IBAction func goToEditView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
        let View = storyboard.instantiateViewController(withIdentifier: "STEditViewController") as! STEditViewController
        View.sex = String.mySex!
        View.QAMessage = self.ProfileQA
        View.profilImg = self.ProfileImgArray
        View.jsonProfile = self.ProfileLable
        View.editImgArray = self.editImgArray
        View.editQAArray = self.editQAArray
        
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
}
