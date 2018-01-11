//
//  MyNSArrayExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/7.
//  Copyright © 2015年 东正. All rights reserved.
//

import Foundation
extension NSArray{
    
    ///除去重复
    func removeRepeat()->NSArray{
        
        let newSet = NSMutableSet(array: self as [AnyObject])
        return newSet.allObjects as NSArray
        
    }
    
    /**
     在搜索里面删除重复
     
     - parameter dic: 需要插入
     
     - returns: 无重复数据
     */
    func removeRepeatForSearch(_ dic:NSDictionary)->NSMutableArray{
        let returnArr = NSMutableArray(array: self)
        var content = false
        let RLName = dic["RLName"] as! String
        var indexs = -1
        
        for (index, _) in self.enumerated() {
            let contentDic = self[index] as! NSDictionary
            if ((contentDic["RLName"] as! String) == RLName){
                content = true
                indexs = index
            }
        }
        if(content && indexs != -1){
            returnArr.removeObject(at: indexs)
        }
        returnArr.insert(dic, at: 0)
        
        return returnArr
    }

    
    
}
