//
//  MYEditTableViewCell.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 10. 17..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import KRWordWrapLabel

class MYEditTableViewCell: UITableViewCell {
    
    let textView : KRWordWrapLabel = {
        let tv = KRWordWrapLabel()
        tv.text = "TEST TEXT"
        tv.font = UIFont(name: "NanumSquare", size: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.lineBreakMode = .byWordWrapping
        tv.numberOfLines = 0
        tv.preferredMaxLayoutWidth = 230
        tv.sizeToFit()
        
        return tv
    }()
    let editButton : UIButton = {
        let eb = UIButton()
        eb.setTitle("수정하기", for: .normal)
        eb.translatesAutoresizingMaskIntoConstraints = false
        eb.isEnabled = true
        eb.titleLabel?.font = UIFont(name: "NanumSquare", size: 12)
        eb.setTitleColor(UIColor.black, for: .normal)
        return eb
    }()
    let bubbleView : MybubbleViwe = {
        let bv = MybubbleViwe()
        bv.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.layer.cornerRadius = 10
        bv.layer.masksToBounds = true
        
        return bv
    }()
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        //addview
        self.contentView.addSubview(bubbleView)
        self.contentView.addSubview(textView)
        self.contentView.addSubview(editButton)
        self.contentView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        //textview constraint set
        textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -22.5).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: editButton.topAnchor).isActive = true
        
        
        //editbutton constraint set
        editButton.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10).isActive = true
        editButton.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -22.5).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        
        //bubbleview constraint set
        bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-5).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
