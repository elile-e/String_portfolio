//
//  STREST.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2018. 2. 17..
//  Copyright © 2018년 EuiSuk_Lee. All rights reserved.
//

import Foundation
import Alamofire

class STREST {
    private static let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "access-token" : UserDefaults.standard.string(forKey: "token")!,
        "account-id" : UserDefaults.standard.string(forKey: "id")!,
        "account-sex" : UserDefaults.standard.string(forKey: "sex")!
    ]
    
    private static let domain = "이것은 테스트"
    
    class func postPayItem(_ item: Int, completion: @escaping(_ result: String?) -> Void) -> Void {
        
        let url = domain + "information/pay/item/"
        
        let param = [
            "item_id" : UserDefaults.standard.bool(forKey: "certification") ? (item + 3) : item
        ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    completion((result as! String))
                }
            case .failure:
                if let error = response.result.error {
                    print(error)
                }
            }
        }
    }
    
    class func postProfileOpen(_ id: Int, completion: @escaping(_ result: String?) -> Void) -> Void {
        let url = domain + "information/register/open-profile/"
        
        let param = [
            "open_id" : id
        ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    completion((result as! String))
                }
            case .failure:
                if let error = response.result.error {
                    print(error)
                }
            }
        }
    }
    
    class func postProfileLike(_ id: Int, completion: @escaping(_ result: String?) -> Void) -> Void {
        let url = domain + "information/register/like/"
        let param = [
            "to_id" : id
        ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    completion((result as! String))
                }
            case .failure:
                if let error = response.result.error {
                    print(error)
                }
            }
        }
    }
    
    class func postProfileScore(_ id: Int,_ score: Int, completion: @escaping(_ result: String?) -> Void) -> Void {
        let url = domain + "information/register/score/"
        let param = [
            "from_id" : String.myId!,
            "to_id" : id,
            "score" : score
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    completion((result as! String))
                }
            case .failure:
                if let error = response.result.error {
                    print(error)
                }
            }
        }
    }
    
    class func postChargeCoin(_ amount: Int, completion: @escaping(_ result: String?) -> Void) -> Void {
        let url = domain + "information/charge-coin/"
        
        let param = [
            "amount" : amount
        ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    completion((result as! String))
                }
            case .failure:
                if let error = response.result.error {
                    print(error)
                }
            }
        }
    }
}
