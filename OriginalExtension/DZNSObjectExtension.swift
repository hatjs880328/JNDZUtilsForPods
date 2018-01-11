//
//  DZNSObjectExtension.swift
//  OMAPP
//
//  Created by 马耀 on 2017/2/23.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import UIKit

public extension NSObject {
    
    /**
     在延迟后结束. 在 main_queue 调用.
     
     - parameter delay: 延迟的秒数
     */
    func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    /**
     modle 转字典
     
     - returns: model转成的字典
     */
    func toNSDictionary()->NSMutableDictionary{
        let dic = NSMutableDictionary()
        var count:UInt32 = 0
        let ivar = class_copyIvarList(self.classForCoder, &count)
        for index in 0 ... count - 1 {
            let ivarName = ivar_getName( ivar?[ Int(index) ] )
            let valueIndex = self.value(forKey: String(cString: ivarName!))
            guard let value = valueIndex else{ break }
            dic[String(cString: ivarName!)] = checkValueTypeByModelToNSDictionary(value as AnyObject)
        }
        
        return dic
    }
    
    /**
     检查Value的类型 并且把其转换成NS类型
     
     - parameter value: 需要检查转换的Value
     
     - returns: Value对应的NS类型数据
     */
    fileprivate func checkValueTypeByModelToNSDictionary(_ value:AnyObject) -> AnyObject{
        let valueString = NSStringFromClass(value.classForCoder)
        switch valueString.checkObjectType(){
        case .nsObjectType: return value
//        case .unNSObjectType: return value.toNSDictionary()
        case .nsListType: return listOrSetByModelToNSDictionary(value)
        default: return listOrSetByModelToNSDictionary((value as! NSSet).allObjects as AnyObject)
        }
        
    }
    
    /**
     转化数组内的数据
     
     - parameter listOrSet: 待转化的数组
     
     - returns: 转化之后的数组集合
     */
    fileprivate func listOrSetByModelToNSDictionary(_ listOrSet:AnyObject)->NSArray{
        let listArr = NSMutableArray()
        
        
        for(index, _) in  (listOrSet as! [AnyObject]).enumerated() {
            listArr.add(checkValueTypeByModelToNSDictionary((listOrSet as! [AnyObject])[index]))
        }
        
        return listArr
    }
    
    /**
     类名字
     
     - returns: 类名字
     */
    func className()->String{
        
        return NSStringFromClass(self.classForCoder)
    }
}
