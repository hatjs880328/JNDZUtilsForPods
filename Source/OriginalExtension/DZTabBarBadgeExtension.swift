//
//  DZTabBarBadgeExtension.swift
//  DHBIos
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import UIKit

extension UITabBar {
    /**
     添加小红点
     
     - parameter index: index
     */
    func showBadgeOnItemIndex(index : Int){
        // 移除之前的小红点
        removeBadgeOnItemIndex(index: index)
        // 新建小红点
        let badgeView = UIView()
        badgeView.tag = 888 + index
        badgeView.layer.cornerRadius = 5
        badgeView.backgroundColor = UIColor.red
        let tabFrame = self.frame
        // 确定小红点的位置
        let percentX = (Double(index) + 0.6) / 4
        let x = ceilf(Float(percentX) * Float(tabFrame.size.width))
        let y = ceilf(0.1 * Float(tabFrame.size.height))
        badgeView.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: 10, height: 10)
        self.addSubview(badgeView)
    }
    
    func hideBadgeOnItemIndex(index : Int){
        // 移除小红点
        removeBadgeOnItemIndex(index: index)
    }
    func removeBadgeOnItemIndex(index : Int){
        // 按照tag值进行移除
        for itemView in self.subviews {
            if(itemView.tag == 888 + index){
                itemView.removeFromSuperview()
            }
        }
    }
}
