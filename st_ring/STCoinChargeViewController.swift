//
//  STCoinChargeViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 11..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import StoreKit
import Alamofire
import SwiftyJSON

struct CoinProduct {
    var id: Int?
    var name: String?
    var value: Float?
    var skproduct: SKProduct?
}

class productTapGesture: UITapGestureRecognizer {
    var targetProduct: CoinProduct?
}

class STCoinChargeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var MyCoinImg: UIImageView!
    @IBOutlet weak var CoinGoodsTableView: UITableView!
    @IBOutlet weak var myCoinLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let white = UserDefaults.standard.bool(forKey: "certification")
    var items = [CoinProduct]()
    var coin = ["100Coin", "220Coin", "360Coin", "500Coin", "1001Coin", "3000Coin"]
    var errorCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "CoinTableViewCell", bundle: Bundle.main)
        self.CoinGoodsTableView.register(nib, forCellReuseIdentifier: "CoinTableViewCell")
        self.CoinGoodsTableView.delegate = self
        self.CoinGoodsTableView.dataSource = self
        
        self.activityIndicator.startAnimating()
        
        SKPaymentQueue.default().add(self)
        getProductInfo()
        getMyCoin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SKPaymentQueue.default().remove(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count > 0 {
            return items.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.items.sort { (a, b) -> Bool in
            return b.value! as Float > a.value! as Float
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell") as! CoinTableViewCell
        let gesture = productTapGesture(target: self, action: #selector(requestPay))
        let cellItem = items[indexPath.row]
        let itemString = cellItem.name!
        let replaced = (itemString as NSString).replacingOccurrences(of: "Coin", with: "")
        
        gesture.targetProduct = cellItem
        
        cell.addGestureRecognizer(gesture)
        cell.CoinValue.text = replaced
        cell.DallorValue.text = "$" + String(cellItem.value!)
        cell.DallorView.layer.cornerRadius = 8
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        
        height = self.CoinGoodsTableView.frame.height/CGFloat((items.count))
        
        return height
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        
        if products.count > 0 {
            for i in 0 ... products.count - 1 {
                let product = products[i]
                let Coin = CoinProduct(id: Int(product.localizedTitle), name: product.localizedTitle, value: product.price as! Float, skproduct: product)
                print(Coin)
                
                self.items.append(Coin)
                
                if self.items.count == self.coin.count {
                    self.CoinGoodsTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                }
            }
        } else {
            print("알 수 없는 상품정보입니다.")
        }
        
        let productList = response.invalidProductIdentifiers
        
        for i in productList {
            print("get product error: \(i)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as[SKPaymentTransaction]{
            switch transaction.transactionState {
            case .purchased:
                let Amount = transaction.payment.productIdentifier
                let replaced = (Amount as NSString).replacingOccurrences(of: "Coin", with: "")
                self.addCoin(value: Int(replaced)!)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                print("결제 실패")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            default:
                break
            }
        }
    }
    
    func getProductInfo() {
        for i in self.coin {
            if SKPaymentQueue.canMakePayments() {
                let request = SKProductsRequest(productIdentifiers: NSSet(object: i) as! Set<String>)
                request.delegate = self
                request.start()
            }
        }
    }
    
    func addCoin(value: Int) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]
        
        let param = [
            "amount" : value as Any
        ]
        
        print(param)
        
        Alamofire.request(String.domain! + "information/charge-coin/", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                print("좋아요 성공!")
                let json = JSON(response.result.value)
                let result = json["result"].boolValue
                if result {
                    self.getMyCoin()
                } else {
                    self.errorCount += 1
                    if self.errorCount == 3 {
                        let errorMessage = "불편을 드려 죄송합니다. \n상품 등록중 에러가 발생되었습니다. 고객센터에 문의해주세요."
                        let alert = UIAlertController(title: "에러", message: "상품 등록중 에러가 발생되었습니다. 고객센터에 문의해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.addCoin(value: value)
                    }
                }
                print(json)
                
            case .failure(let error):
                print("post regist like" + String(describing: error))
            }
        }
    }
    
    @objc func requestPay(gestureRecognizer: productTapGesture) {
        let item = gestureRecognizer.targetProduct?.skproduct
        let payment = SKPayment(product: item!)
        
        SKPaymentQueue.default().add(payment)
    }
    
    func getMyCoin() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : UserDefaults.standard.string(forKey: "id")!,
            "account-sex" : UserDefaults.standard.string(forKey: "sex")!
        ]

        Alamofire.request("\(String.domain!)information/\(String.mySex!)/\(String.myId!)/get/coin-amount/", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result {
            case .success:
                print("success : getLastAPI")
                if let responseData = response.result.value {
                    let result = JSON(responseData)
                    let resultjson = result["amount"].stringValue

                    
                    self.myCoinLabel.text = resultjson
                }
                
            case .failure(let error):
                print("이것은 에러입니다 삐빅 :" + String(describing: error))
            }
        }
    }
}
