//
//  STWaitingReviewViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 23..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class STWaitingReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getStatus), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStatus()
    }
    
    @objc func getStatus() {
        print(UserDefaults.standard.string(forKey: "token")!)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        let url = String.domain! + "information/\(String.mySex!)/\(String.myId!)/get/status/"
        
        Alamofire.request(url, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result {
            case .success:
                let jsonValue = JSON(response.result.value)
                print(jsonValue)
                let status = jsonValue["status"].stringValue
                UserDefaults.standard.set(status, forKey: "status")
                
                var initialViewController = UIViewController()
                
                if status != "INREVIEW" {
                    switch status{
                    case "ACTIVATE", "EDITING":
                        let storyboard = UIStoryboard(name: "STMainStoryboard", bundle: nil)
                        let rootView = storyboard.instantiateViewController(withIdentifier: "STMainTabBarController")
                        initialViewController = UINavigationController(rootViewController: rootView)
                        break
                    case "BEFOREJOIN":
                        let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                        let rootView = storyboard.instantiateViewController(withIdentifier: "STStartViewController")
                        initialViewController = UINavigationController(rootViewController: rootView)
                        break
                    case "REJECTED":
                        let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                        initialViewController = storyboard.instantiateViewController(withIdentifier: "STRejectReviewViewController")
                        break
                    default:
                        let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                        let rootView = storyboard.instantiateViewController(withIdentifier: "STStartViewController")
                        initialViewController = UINavigationController(rootViewController: rootView)
                    }
                    self.present(initialViewController, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
                
                break
            }
        }
    }
}
