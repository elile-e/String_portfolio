//
//  STNotiViewController.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2018. 1. 8..
//  Copyright © 2018년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class STNotiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
