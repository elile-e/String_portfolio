//
//  STTabBARViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 14..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class STTabBARViewController: UITabBarController {
    @IBOutlet weak var STTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarItems()
        STTabBar.tintColor = UIColor.mainYello
        STTabBar.layer.borderColor = UIColor(red: 206, green: 206, blue: 206, alpha: 1).cgColor
        STTabBar.layer.borderWidth = 0.2
        getCertification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTabBarItems(){

        let TodayPick = (self.tabBar.items?[0])! as UITabBarItem
        TodayPick.title = "오늘의 픽"
        TodayPick.titlePositionAdjustment = UIOffsetMake(0.0, -2)
        TodayPick.image = UIImage(named: "grayToday")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        TodayPick.selectedImage = UIImage(named: "pinkToday")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let Place = (self.tabBar.items?[1])! as UITabBarItem
        Place.image = UIImage(named: "grayPlace")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        Place.selectedImage = UIImage(named: "pinkPlace")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        Place.title = "플레이스"
        Place.titlePositionAdjustment = UIOffsetMake(0.0, -3)
        
        let MyPick = (self.tabBar.items?[2])! as UITabBarItem
        MyPick.image = UIImage(named: "grayMypick")?.withRenderingMode(.alwaysTemplate)
        MyPick.selectedImage = UIImage(named: "pinkMypick")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        MyPick.title = "나의 픽"
        MyPick.titlePositionAdjustment = UIOffsetMake(0.0, -3)
        
        let Message = (self.tabBar.items?[3])! as UITabBarItem
        Message.image = UIImage(named: "grayChat")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        Message.selectedImage = UIImage(named: "pinkChat")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        Message.title = "메세지"
        Message.titlePositionAdjustment = UIOffsetMake(0.0, -3)
        
        let My = (self.tabBar.items?[4])! as UITabBarItem
        My.image = UIImage(named: "grayMY")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        My.selectedImage = UIImage(named: "pinkMY")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        My.title = "마이"
        My.titlePositionAdjustment = UIOffsetMake(0.0, -3)
    }
    
    func getCertification() {
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
                    
                    if resultjson["authenticated"].boolValue {
                        UserDefaults.standard.set(true, forKey: "certification")
                    } else {
                        UserDefaults.standard.set(false, forKey: "certification")
                    }
                }
            case .failure(let error):
                print("get my data error :" + String(describing: error))
                print(response.debugDescription)
                let json = JSON(response)
                print(json)
            }
        }
    }
}
