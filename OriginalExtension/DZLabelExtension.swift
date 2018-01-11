//
//  MyLabelExtension.swift
//  FSZCItem
//
//  Created by 马耀 on 16/8/22.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     文字两边对齐
     未考虑换行，未考虑设置颜色等其他东西
     
     - parameter text: 需要设置的文字
     */
    func attributedTextFullJustified(_ text:String){
        let rectStr = (text as NSString).substring(to: 1) as NSString
        let rect = rectStr.boundingRect(with: CGSize(width: self.frame.size.width,height: self.frame.size.height), options: [.usesLineFragmentOrigin,.usesFontLeading] , attributes: [NSFontAttributeName:self.font], context: nil)
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSKernAttributeName, value: ((self.frame.size.width / rect.size.width - CGFloat((text as NSString).length)) * rect.size.width)/(CGFloat((text as NSString).length) - 1), range: NSMakeRange(0, (text as NSString).length - 1))
        self.attributedText = attrString
    }

}
