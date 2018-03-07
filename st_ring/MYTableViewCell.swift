//
//  MYTableViewCell.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 11. 9..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import KRWordWrapLabel

class MYTableViewCell: UITableViewCell {
    let textView : KRWordWrapLabel = {
        let tv = KRWordWrapLabel()
        tv.text = "TEST TEXT"
        tv.font = UIFont(name: "NanumSquare", size: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.lineBreakMode = .byWordWrapping
        tv.numberOfLines = 0
        tv.textAlignment = .left
        tv.preferredMaxLayoutWidth = 230
        tv.sizeToFit()
        
        return tv
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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.isUserInteractionEnabled = false
        
        //addview
        self.contentView.addSubview(bubbleView)
        self.contentView.addSubview(textView)
        self.contentView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        //bubbleview constraint set
        bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        //textview constraint set
        textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 7.5).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
        textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -22.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class MybubbleViwe: UIView {
    override func draw(_ rect: CGRect) {
        let bubbleSpace = CGRect(x: 0, y: 1, width: self.frame.width - 15, height: self.frame.height - 2)
        _ = UIBezierPath(roundedRect: bubbleSpace, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        let bubblePath2 = UIBezierPath(roundedRect: bubbleSpace, cornerRadius: 15)
        
        UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).setStroke()
        UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).setFill()
        bubblePath2.lineWidth = 1
        bubblePath2.stroke()
        bubblePath2.fill()
        
        let bubbleTailPath = UIBezierPath()
        let startPoint = CGPoint(x: self.frame.width - 15, y: self.frame.height - 21)
        let toTipCurvepoint = CGPoint(x: self.frame.width - 13, y: self.frame.height - 2)
        let tipPoint = CGPoint(x: self.frame.width - 5, y: self.frame.height)
        let toEndCurvepoint = CGPoint(x: self.frame.width - 15, y: self.frame.height - 2)
        let endPoint = CGPoint(x: self.frame.width - 19, y: self.frame.height - 7)
        bubbleTailPath.move(to: startPoint)
        bubbleTailPath.addQuadCurve(to: tipPoint, controlPoint: toTipCurvepoint)
        bubbleTailPath.addQuadCurve(to: endPoint, controlPoint: toEndCurvepoint)
        bubbleTailPath.close()
        
        UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).setStroke()
        UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).setFill()
        bubbleTailPath.lineWidth = 1
        bubbleTailPath.stroke()
        bubbleTailPath.fill()
    }
}
