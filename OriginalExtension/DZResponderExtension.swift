//
//  DZResponderExtension.swift
//  OMAPP
//
//  Created by 马耀 on 2017/2/23.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import UIKit

// MARK: - 崩溃到mian 函数里面
extension UIResponder {
    
    //    public override func forwardingTargetForSelector(aSelector: Selector) -> AnyObject? {
    //        let selectorStr: String = NSStringFromSelector(aSelector)
    //        if self.isKindOfClass(NSClassFromString("UIResponder")!) || self.isKindOfClass(NSClassFromString("MainMapViewController")!) {
    //            var protectorCls: AnyClass? = NSClassFromString("FSZCItem.Protector")
    //            if protectorCls != nil {
    //                protectorCls = objc_allocateClassPair(NSObject.self, "FSZCItem.Protector", 0)
    //                objc_registerClassPair(protectorCls)
    //            }
    //
    //            class_addMethod(protectorCls, aSelector,dosome(aSelector)!, UnsafeMutablePointer<Int8>((selectorStr as NSString).UTF8String))
    //            let Protector: AnyClass? = protectorCls.self
    //            let instance: AnyObject? = Protector
    //
    //            return instance
    //        }else{
    //            return nil
    //        }
    //    }
    //
    //    func dosome(aSelector:Selector)->IMP?{
    //
    //        let block = {()->() in
    //
    //            print("没有闪退" + NSStringFromSelector(aSelector))
    //        }
    //        let castedBlock: AnyObject = unsafeBitCast(block as @convention(block) () -> Void, AnyObject.self)
    //
    //        let swizzledImplementation = imp_implementationWithBlock(castedBlock)
    //        
    //        return swizzledImplementation
    //    }
    
    
}
