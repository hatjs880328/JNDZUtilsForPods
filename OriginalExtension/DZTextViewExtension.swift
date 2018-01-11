//
//  DZTextViewExtension.swift
//  DHBIos
//
//  Created by 马耀 on 2017/7/18.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 设置光标的位置
    ///
    /// - Parameter range: 位置
    func setSelectedRange(range:NSRange) {
        let startPosition = self.position(from: self.beginningOfDocument, offset: range.location)
        let endPosition = self.position(from: self.beginningOfDocument, offset: range.location + range.length)
        let textRange = self.textRange(from: startPosition!, to: endPosition!)
        
        self.selectedTextRange = textRange
    }
}
