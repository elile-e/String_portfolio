//
//  STMessengerTableViewCell.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 9..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class STMessengerTableViewCell: UITableViewCell {
    @IBOutlet weak var ProfileImg: UIImageView!
    @IBOutlet weak var ProfileLabel: UILabel!
    @IBOutlet weak var recentMessage: UILabel!
    @IBOutlet weak var recentTime: UILabel!
    @IBOutlet weak var unreadMessageView: UIView!
    @IBOutlet weak var unreadMessageCountLabel: UILabel!
    @IBOutlet weak var certificationView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
