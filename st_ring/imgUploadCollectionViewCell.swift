//
//  imgUploadCollectionViewCell.swift
//  st_ring
//
//  Created by euisuk_lee on 2017. 9. 25..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class imgUploadCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var CellLabel: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var defualtImg: UIImageView!
    @IBOutlet weak var blurView: UIView!
    
    var value: Int?
}
