//
//  CoinTableViewCell.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 11..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    @IBOutlet weak var CoinImg: UIImageView!
    @IBOutlet weak var CoinValue: UILabel!
    @IBOutlet weak var DallorValue: UILabel!
    @IBOutlet weak var DallorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
