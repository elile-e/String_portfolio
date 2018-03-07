//
//  STAGREEViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 12. 26..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class STAGREEViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var urlString: NSString = NSString()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: self.urlString as String)
        let request = NSURLRequest(url: url as! URL)
        
        self.webView.loadRequest(request as URLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     @IBAction func CloseAction(_ sender: Any) {
         self.presentingViewController?.dismiss(animated: true, completion: nil)
     }
}
