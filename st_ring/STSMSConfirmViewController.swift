//
//  STSMSConfirmViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 12. 19..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class STSMSConfirmViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var certificationWebView: UIWebView!
    var urlString: NSString = "이것은 테스트=\(String.myId!)" as NSString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        certificationWebView.scrollView.isScrollEnabled = false
        
        let url = NSURL(string: self.urlString as String)
        let request = NSURLRequest(url: url as! URL)
        
        self.certificationWebView.delegate = self
        self.certificationWebView.loadRequest(request as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        print(self.certificationWebView.request!.url!.absoluteString)
        print()
        if self.certificationWebView.request!.url!.absoluteString == "이것은 테스트/auth_success.php" {
            let view = self.presentingViewController as! STWhiteMemberViewController
            view.SMSButton.imageView?.image = UIImage(named: "certificationDoneButton")
            view.isSMS = true
            view.checkInvaild()
            
            view.dismiss(animated: true, completion: nil)
        } else if self.certificationWebView.request!.url!.absoluteString == "이것은 테스트/auth_fail.php" {
            
        }
    }
}
