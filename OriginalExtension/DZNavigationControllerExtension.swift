//
//  DZNavigationControllerExtension.swift
//  OMAPP
//
//  Created by 马耀 on 2017/3/7.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import UIKit

var navStackChangeIntervalKey = "navStackChangeIntervalKey"
var navStackLastChangedTimeKey = "navStackLastChangedTimeKey"
var navStackCanHaveTheSameKey = "navStackCanHaveTheSameKey"


extension UINavigationController {
    
    /// 重写导航控制器的pop方法-
    ///
    /// - Parameter animation: 是否需要动画
    open func DZpopViewController(animation:Bool) {
        var _ = self.popViewController(animated: animation)
    }
    
    /// 导航栈顶是否可以存在相同的控制器
    public var navStackCanHaveTheSameVC:Bool {
        get{
            if(objc_getAssociatedObject(self, &navStackCanHaveTheSameKey) == nil){
                objc_setAssociatedObject(self, &navStackCanHaveTheSameKey, true, .OBJC_ASSOCIATION_ASSIGN);
                
                return true
            }else{
                
                return (objc_getAssociatedObject(self,&navStackCanHaveTheSameKey) as AnyObject).boolValue
            }
        }
        set{
            objc_setAssociatedObject(self, &navStackCanHaveTheSameKey, newValue, .OBJC_ASSOCIATION_ASSIGN);

        }
    }
    
    
    // 多长时间不能连续点击push 新页面 默认 0.5
    public var navStackChangeInterval:TimeInterval {
        get{
            if(objc_getAssociatedObject(self, &navStackChangeIntervalKey) == nil){
                objc_setAssociatedObject(self, &navStackChangeIntervalKey, 0.5,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return 0.5
            }else{
                
                return (objc_getAssociatedObject(self,&navStackChangeIntervalKey) as AnyObject).doubleValue
            }
        }
        set{
            objc_setAssociatedObject(self, &navStackChangeIntervalKey, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 仅内部使用 作为时间量 来控制能否push
    private var navStackLastChangedTime:TimeInterval {
        get{
            if(objc_getAssociatedObject(self, &navStackLastChangedTimeKey) == nil){
                objc_setAssociatedObject(self, &navStackLastChangedTimeKey, 0,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return 0
            }else{
                
                return (objc_getAssociatedObject(self,&navStackLastChangedTimeKey) as AnyObject).doubleValue
            }
        }
        set{
            objc_setAssociatedObject(self, &navStackLastChangedTimeKey, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 防止外部调用
    @objc private func DZ_pushViewController(_ viewController:UIViewController,animated:Bool){
        //基本没什么作用
//        if viewController == self.topViewController {
//            
//            print("尝试push 一个已经存在的控制器")
//            return
//        }

        //不允许两个相同的控制器在栈顶,子类可以
        if self.topViewController != nil &&  viewController.isMember(of: self.topViewController!.classForCoder) && !navStackCanHaveTheSameVC{
            print("尝试push 一个已经存在的控制器")
            
            return
        }
        // 如果push 相同的 控制器 默认0.5 秒之后才能push
        let now = CACurrentMediaTime();
        if (now - self.navStackLastChangedTime < self.navStackChangeInterval){
        
            print("\(#function) 尝试push \(now - self.navStackLastChangedTime) 秒 ，请在秒结束后再进行push\(self)")
            
            return;
        }

        self.navStackLastChangedTime = now;
        
        pushViewControllerInMainQueue(viewController: viewController, animated: animated)
    }
    
    private func pushViewControllerInMainQueue(viewController:UIViewController,animated:Bool) {
        self.DZ_pushViewController(viewController, animated: animated)
    }
    
    /// load方法
    open override class func initialize(){
        struct Static{
            static var token = NSUUID().uuidString
        }
        DispatchQueue.once(name: Static.token, action: {
           swizzlePushViewController()
        })
    }
    
    /// 交换setNeedsLayout
   class func swizzlePushViewController(){
        let selfClass = self.classForCoder()
        let originalSelector = class_getInstanceMethod(selfClass, #selector(UINavigationController.pushViewController(_:animated:)))
        let swizzledSelector = class_getInstanceMethod(selfClass, #selector(UINavigationController.DZ_pushViewController(_:animated:)))
        let didAddMethod = class_addMethod(selfClass,#selector(UINavigationController.pushViewController(_:animated:)),method_getImplementation(swizzledSelector),method_getTypeEncoding(swizzledSelector));
        if didAddMethod {
            class_replaceMethod(selfClass, #selector(UINavigationController.DZ_pushViewController(_:animated:)), method_getImplementation(originalSelector), method_getTypeEncoding(originalSelector))
        }else{
            method_exchangeImplementations(originalSelector,swizzledSelector)
        }
    }
    
}
