//
//  MyViewControllerExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/7.
//  Copyright © 2015年 东正. All rights reserved.
//

import UIKit

// MARK: - 模态
var commonParametersBind = "commonParametersBind"
extension UIViewController{
    ///是否模态
    public var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
    
    /// 传输的属性
    public var commonParameters:[String:Any] {
        get{
            if(objc_getAssociatedObject(self, &commonParametersBind) == nil){
                objc_setAssociatedObject(self, &commonParametersBind, 0,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return [:]
            }else{
                
                return objc_getAssociatedObject(self,&commonParametersBind) as! [String:Any]
            }
        }
        set{
            
            objc_setAssociatedObject(self, &commonParametersBind, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - RunTime
//extension UIViewController{
//    public override class func initialize(){
//        struct Static{
//            static var token:dispatch_once_t = 0
//        }
//        if self != UIViewController.self{
//            return
//        }
//        dispatch_once(&Static.token, {
//            _ in
//            let viewDidLoad = class_getInstanceMethod(self, Selector("viewDidLoad"))
//            let viewDidLoaded = class_getInstanceMethod(self, Selector("myViewDidLoad"))
//            method_exchangeImplementations(viewDidLoad,viewDidLoaded)
//        })
//    }
//    func myViewDidLoad(){
//        self.myViewDidLoad()
//        print("\(self)在viewDidLoad创建了😄")
//    }
//}

// MARK: - 用block实现RunTime
//typealias _IMP = @convention(c)(id:AnyObject,sel:UnsafeMutablePointer<Selector>)->AnyObject
//typealias _VIMP = @convention(c)(id:AnyObject,sel:UnsafeMutablePointer<Selector>)->Void
//
//extension UIViewController{
//    public override class func initialize(){
//        struct Static{
//            static var token:dispatch_once_t = 0
//        }
//        if self != UIViewController.self{
//            return
//        }
//
//        dispatch_once(&Static.token, {
//            _ in
//            let viewDidLoad:Method = class_getInstanceMethod(self, Selector("viewDidLoad"))
//            let viewDidLoad_VIMP:_VIMP = unsafeBitCast(method_getImplementation(viewDidLoad),_VIMP.self)
//            let block:@convention(block)(UnsafeMutablePointer<AnyObject>,UnsafeMutablePointer<Selector>)->Void = {
//                (id,sel) in
//                viewDidLoad_VIMP(id: id.memory, sel: sel)
//                print("viewDidLoad func execu over id ---> \(id.memory)");
//            }
//            let imp:COpaquePointer = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
//            method_setImplementation(viewDidLoad,imp)
//        })
//    }
//}

