//
//  selectTextField.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 9. 24..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit

class selectTextField: UITextField {
        // 8
        override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
        }
        
        override func selectionRects(for range: UITextRange) -> [Any] {
        return []
        }
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
        
        return false
        }
        
        return super.canPerformAction(action, withSender: sender)
        }
}
