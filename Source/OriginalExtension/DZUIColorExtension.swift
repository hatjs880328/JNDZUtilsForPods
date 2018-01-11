//
//  DZUIColorExtension.swift
//  DHBIos
//
//  Created by hanxueshi on 2017/7/14.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    
    ///  获取颜色，通过16进制色值字符串，e.g. #ff0000， ff0000
    ///
    /// - Parameters:
    ///   - color: 16进制字符串
    ///   - aplha: 透明度，默认为1，不透明
    /// - Returns: RGB
    static func colorWithHexString(color:String,aplha:CGFloat = 1) ->UIColor{
        var csString = color.replaceCharacterWith(" ", toSeparator: "")
        if csString.length < 6{
            return UIColor.clear
        }
        if(csString.hasPrefix("0X")){
            csString = color.substringFromIndex(2)
        }
        if(csString.hasPrefix("#")){
            csString = color.substringFromIndex(1)
        }
        if(csString.length != 6){
            return UIColor.clear
        }
        // 红色的色值
        let rString = (csString as NSString).substring(to: 2)
        let gString = ((csString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((csString as NSString).substring(from: 4) as NSString).substring(to: 2)
        // 字符串转换
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: aplha)
    }
    
    
    /// 获取颜色，通过16进制数值
    ///
    /// - Parameters:
    ///   - hex: 16进制数值
    ///   - alpha:  透明度
    /// - Returns: 颜色
    static func withHex(hexInt hex:Int32, alpha:CGFloat = 1) -> UIColor {
        let r = CGFloat((hex & 0xff0000) >> 16) / 255
        let g = CGFloat((hex & 0xff00) >> 8) / 255
        let b = CGFloat(hex & 0xff) / 255
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    
    /// 获取颜色，通过rgb
    ///
    /// - Parameters:
    ///   - red: 红色
    ///   - green: 绿色
    ///   - blue: 蓝色
    ///   - alpha: 透明度
    /// - Returns:
    static func withRGBA(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
}
