//
//  DZMutableAttributedStringExtension.swift
//  OMAPP
//
//  Created by 马耀 on 2017/5/8.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import Foundation

extension NSMutableAttributedString{

    /// 增加富文本样式 不会闪退
    ///
    /// - Parameters:
    ///   - name: key
    ///   - value: value
    ///   - range: 范围
    func addAttributeNoCatch(_ name: String, value: Any, range: NSRange){
        if self.length < range.location + range.length {
            self.addAttribute(name, value: value, range: NSMakeRange(0, 0))
        }else{
            self.addAttribute(name, value: value, range: range)
        }
    }
    
    
    /// 增加富文本样式 不会闪退
    ///
    /// - Parameters:
    ///   - attrs: 富文本样式 [key:value]
    ///   - range: 返回
    func addAttributesNoCatch(attrs: [String : Any], range: NSRange){
        if self.length < range.location + range.length {
            self.addAttributes(attrs, range: NSMakeRange(0, 0))
        }else{
            self.addAttributes(attrs, range: range)
        }
    }

}


