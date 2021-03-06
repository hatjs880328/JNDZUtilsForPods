//
//  MyViewExtension.swift
//  OMAPP
//
//  Created by 马耀 on 2017/2/23.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import UIKit

var blockActionDict : [String : ( () -> () )] = [:]
extension UIView{
    /// 返回所在控制器
    /// :returns: 所在控制器
    func ViewController() -> UIViewController? {
        var next = self.next
        while((next) != nil){
            if(next!.isKind(of: UIViewController.self)){
                
                let rootVc = next as! UIViewController
                return rootVc
                
            }
            next = next?.next
        }
        return nil
    }
    
    /**
     view以及其子类的block点击方法
     - parameter action: 单击时执行的block
     */
    func tapActionsGesture(_ action:@escaping ( () -> Void )){
        self.isUserInteractionEnabled = true
        addBlock(action)//添加点击block
        whenTouchOne()//点击block
    }
    
    fileprivate func addBlock(_ block:@escaping ()->()){
        //创建唯一标示  方便在点击的时候取出
        //        blockActionDict[String(NSValue(nonretainedObject: self))] = block
        blockActionDict[String(self.hashValue)] = block
    }
    
    fileprivate func whenTouchOne(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(UIView.tapActions))
        self.addGestureRecognizer(tapGesture)
    }
    
    /**
     私有方法，禁止调用
     */
    func tapActions(){
        //取出唯一标示 并执行block里面的方法
        //        blockActionDict[String(NSValue(nonretainedObject:self))]!()
        blockActionDict[String(self.hashValue)]!()
    }
}


/// 全局变量 for Xib相关拓展属性
var defaultCornerRadius = "defaultCornerRadius"
var defaultBorderColor = "defaultBorderColor"
var defaultBorderWidth = "defaultBorderWidth"

var defaultShadowColor = "defaultShadowColor"
var defaultShadowOffset = "defaultShadowOffset"
var defaultShadowRadius = "defaultShadowRadius"
var defaultShadowOpacity = "defaultShadowOpacity"

// MARK: - Xib相关拓展属性
extension UIView{
    
    //MARK:圆角相关
    /// 圆角
    @IBInspectable var cornerRadiu: CGFloat{
        get{
            if(objc_getAssociatedObject(self, &defaultCornerRadius) == nil){
                objc_setAssociatedObject(self, &defaultCornerRadius, 0,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return 0
            }else{
                
                return objc_getAssociatedObject(self,&defaultCornerRadius) as! CGFloat
            }
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = true
            objc_setAssociatedObject(self, &defaultCornerRadius, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    /// 边框颜色
    @IBInspectable var borderColor: UIColor{
        get{
            if(objc_getAssociatedObject(self, &defaultBorderColor) == nil){
                objc_setAssociatedObject(self, &defaultBorderColor, UIColor(),.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return UIColor()
            }else{
                
                return objc_getAssociatedObject(self,&defaultBorderColor) as! UIColor
            }
        }
        set{
            layer.borderColor = newValue.cgColor
            objc_setAssociatedObject(self, &defaultBorderColor, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    /// 边框宽度
    @IBInspectable var borderWidth: CGFloat{
        get{
            if(objc_getAssociatedObject(self, &defaultBorderWidth) == nil){
                objc_setAssociatedObject(self, &defaultBorderWidth, 0,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return 0
            }else{
                
                return objc_getAssociatedObject(self,&defaultBorderWidth) as! CGFloat
            }
        }
        set{
            
            layer.borderWidth = newValue
            objc_setAssociatedObject(self, &defaultBorderWidth, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    //MARK:阴影相关
    
    /// 阴影颜色
    @IBInspectable var shadowColor: UIColor{
        get{
            if(objc_getAssociatedObject(self, &defaultShadowColor) == nil){
                objc_setAssociatedObject(self, &defaultShadowColor, UIColor(),.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return UIColor()
            }else{
                
                return objc_getAssociatedObject(self,&defaultShadowColor) as! UIColor
            }
        }
        set{
            layer.shadowColor = newValue.cgColor
            objc_setAssociatedObject(self, &defaultShadowColor, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    /// 阴影圆角
    @IBInspectable var shadowRadius: CGFloat{
        get{
            if(objc_getAssociatedObject(self, &defaultShadowRadius) == nil){
                objc_setAssociatedObject(self, &defaultShadowRadius, 0,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return 0
            }else{
                
                return objc_getAssociatedObject(self,&defaultShadowRadius) as! CGFloat
            }
        }
        set{
            layer.shadowRadius = newValue
            objc_setAssociatedObject(self, &defaultShadowRadius, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    /// 阴影偏移量 x为正向右，y为正向下 这个方法无法获取属性
    @IBInspectable var shadowOffset: CGSize{
        get{
            
            return CGSize()
        }
        set{
            
            layer.shadowOffset = newValue
        }
    }
    
    /// 阴影透明度
    @IBInspectable var shadowOpacity: Float{
        get{
            if(objc_getAssociatedObject(self, &defaultShadowOpacity) == nil){
                objc_setAssociatedObject(self, &defaultShadowOpacity, 0,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return 0
            }else{
                
                return objc_getAssociatedObject(self,&defaultShadowOpacity) as! Float
            }
        }
        set{
            layer.shadowOpacity = newValue
            objc_setAssociatedObject(self, &defaultShadowOpacity, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
}


// MARK: - 延展 禁止非主线程刷新UI ，非主线程刷新UI 调试时候可能不闪退 ，但加上此延展之后 由于加了断言，必然闪退！！！！！
extension UIView{
    
    /// load方法
    open override class func initialize(){
        struct Static{
            static var token = NSUUID().uuidString
        }
//            DispatchQueue.once(name: Static.token, action: {
//                swizzleSetNeedsLayout()
//                swizzleSetNeedsDisplay()
//                swizzleSetNeedsDisplayInRect()
//                swizzleSetNeedsUpdateConstraints()
//            })
    }
    
    
   /// 交换setNeedsUpdateConstraints
   class func swizzleSetNeedsUpdateConstraints(){
        let selfClass = self.classForCoder()
        let originalSelector = class_getInstanceMethod(selfClass, #selector(UIView.setNeedsUpdateConstraints))
        let swizzledSelector = class_getInstanceMethod(selfClass, #selector(UIView.DZ_setNeedsUpdateConstraints))
        let didAddMethod = class_addMethod(selfClass,#selector(UIView.setNeedsUpdateConstraints) ,method_getImplementation(swizzledSelector),method_getTypeEncoding(swizzledSelector));
        if didAddMethod {
            class_replaceMethod(selfClass, #selector(UIView.DZ_setNeedsUpdateConstraints), method_getImplementation(originalSelector), method_getTypeEncoding(originalSelector))
        }else{
            method_exchangeImplementations(originalSelector,swizzledSelector)
        }
    }
    
    /// 交换setNeedsDisplayInRect
    class func swizzleSetNeedsDisplayInRect(){
        let selfClass = self.classForCoder()
        let originalSelector = class_getInstanceMethod(selfClass, #selector(UIView.setNeedsDisplay(_:)))
        let swizzledSelector = class_getInstanceMethod(selfClass, #selector(UIView.DZ_setNeedsDisplayInRect(_:)))
        let didAddMethod = class_addMethod(selfClass,#selector(UIView.setNeedsDisplay(_:)) ,method_getImplementation(swizzledSelector),method_getTypeEncoding(swizzledSelector));
        if didAddMethod {
            class_replaceMethod(selfClass, #selector(UIView.DZ_setNeedsDisplayInRect(_:)), method_getImplementation(originalSelector), method_getTypeEncoding(originalSelector))
        }else{
            method_exchangeImplementations(originalSelector,swizzledSelector)
        }
    }
    
    /// 交换setNeedsDisplay
    class func swizzleSetNeedsDisplay(){
        let selfClass = self.classForCoder()
        let originalSelector = class_getInstanceMethod(selfClass, #selector(CALayer.setNeedsDisplay))
        let swizzledSelector = class_getInstanceMethod(selfClass, #selector(UIView.DZ_setNeedsDisplay))
        let didAddMethod = class_addMethod(selfClass,#selector(CALayer.setNeedsDisplay) ,method_getImplementation(swizzledSelector),method_getTypeEncoding(swizzledSelector));
        if didAddMethod {
            class_replaceMethod(selfClass, #selector(UIView.DZ_setNeedsDisplay), method_getImplementation(originalSelector), method_getTypeEncoding(originalSelector))
        }else{
            method_exchangeImplementations(originalSelector,swizzledSelector)
        }
    }
    
    /// 交换setNeedsLayout
    class func swizzleSetNeedsLayout(){
        let selfClass = self.classForCoder()
        let originalSelector = class_getInstanceMethod(selfClass, #selector(UIView.setNeedsLayout))
        let swizzledSelector = class_getInstanceMethod(selfClass, #selector(UIView.DZ_setNeedsLayout))
        let didAddMethod = class_addMethod(selfClass,#selector(UIView.setNeedsLayout) ,method_getImplementation(swizzledSelector),method_getTypeEncoding(swizzledSelector));
        if didAddMethod {
            class_replaceMethod(selfClass, #selector(UIView.DZ_setNeedsLayout), method_getImplementation(originalSelector), method_getTypeEncoding(originalSelector))
        }else{
            method_exchangeImplementations(originalSelector,swizzledSelector)
        }
    }
    
    func DZ_setNeedsLayout() {
        if Thread.isMainThread {
            //running on main thread
            self.DZ_setNeedsLayout()
        }else {
//            assert(false, "\(#function) ******* 尝试刷新UI 但是并没有在主线程中 \(self) ")
            DispatchQueue.main.async(execute: {
                self.DZ_setNeedsLayout()
            })
        }
    }
    
    func DZ_setNeedsDisplay() {
        if Thread.isMainThread {
            //running on main thread
            self.DZ_setNeedsDisplay()
        }else {
            assert(false, "\(#function) ******* 尝试刷新UI 但是并没有在主线程中 \(self) ")
            DispatchQueue.main.async(execute: {
                self.DZ_setNeedsDisplay()
            })
        }
    }
    
    func DZ_setNeedsDisplayInRect(_ rect:CGRect) {
        if Thread.isMainThread {
            //running on main thread
            self.DZ_setNeedsDisplayInRect(rect)
        }else {
            assert(false, "\(#function) ******* 尝试刷新UI 但是并没有在主线程中 \(self) ")
            DispatchQueue.main.async(execute: {
                self.DZ_setNeedsDisplayInRect(rect)
            })
        }
    }
    
    func DZ_setNeedsUpdateConstraints() {
        if Thread.isMainThread {
            //running on main thread
            self.DZ_setNeedsUpdateConstraints()
        }else {
            assert(false, "\(#function) ******* 尝试刷新UI 但是并没有在主线程中 \(self) ")
            DispatchQueue.main.async(execute: {
                self.DZ_setNeedsUpdateConstraints()
            })
        }
    }
}
