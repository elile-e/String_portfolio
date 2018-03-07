//
//  bigProFileView.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 1..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class bigProFileView: UIView {
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var certificationImg: UIImageView!
    @IBOutlet weak var blurImg: UIView!
    @IBOutlet weak var lockImg: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    class func instanceFromNib() -> bigProFileView {
        let view = Bundle.main.loadNibNamed("bigProFileView", owner: self, options: nil)?.first as! bigProFileView
        
        return view
    }
}
