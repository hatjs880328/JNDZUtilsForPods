//
//  MyButtonExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/10.
//  Copyright © 2015年 东正. All rights reserved.
//

import UIKit

var buttonClouser:[String : (() -> Void)] = [:]//存储每一个BUTTON实例所对应的闭包
var buttonTwoClouser:[String : (() -> ())] = [:]//存储第二个点击事件的闭包
extension UIButton{
    /**
    设置图片和标题垂直放置 标题在下
    必须设定：标题
    图片 非背景图，图片必须以UIImage(named: )方式设定 否则将找不到
    图片大小与真实比例相同，非压缩 若图片太大则不可以
    
    - parameter imgTextDistance: 图片和文字的间距
    */
    public func setVerticalLabelBottom(_ imgTextDistance:CGFloat){
        let imgWidth = self.imageView?.image?.size.width ?? 0
        let imgHeight = self.imageView?.image?.size.height ?? 0
        let textSize = NSString(string: self.titleLabel!.text!).size(attributes: [NSFontAttributeName : self.titleLabel!.font])
        
//        let textWitdh = textSize.width
        let textHeight = textSize.height
        var interval:CGFloat! // distance between the whole image title part and button
        
        var titleOffsetX:CGFloat! // horizontal offset of title
        var titleOffsetY:CGFloat! // vertical offset of title
        
        self.imageView?.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalTo(self.snp.centerY).offset(-(textHeight+imgTextDistance)/2);
            make.centerX.equalTo(self.snp.centerX).offset(0);
            make.width.equalTo(imgWidth);
            make.height.equalTo(imgHeight);
        })
        interval = CGFloat(imgHeight) + CGFloat(imgTextDistance)
        titleOffsetX = CGFloat(-imgWidth)
        titleOffsetY = interval;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetY, titleOffsetX, 0, 0)
        
    }
    
    /**
    设置图片和标题垂直放置 标题在上
    必须设定：标题
            图片 非背景图，图片必须以UIImage(named: )方式设定 否则将找不到
    图片大小与真实比例相同，非压缩 若图片太大则不可以
    
    - parameter imgTextDistance: 图片和文字的间距
    */
    public func setVerticalLabelTop(_ imgTextDistance:CGFloat){
        let imgWidth = self.imageView?.image?.size.width ?? 0
        let imgHeight = self.imageView?.image?.size.height ?? 0
        let textSize = NSString(string: self.titleLabel!.text!).size(attributes: [NSFontAttributeName : self.titleLabel!.font])
        
//        let textWitdh = textSize.width
        let textHeight = textSize.height
        var interval:CGFloat! // distance between the whole image title part and button

        var titleOffsetX:CGFloat! // horizontal offset of title
        var titleOffsetY:CGFloat! // vertical offset of title
        
        self.imageView?.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalTo(self.snp.centerY).offset((textHeight+imgTextDistance)/2);
            make.centerX.equalTo(self.snp.centerX).offset(0);
            make.width.equalTo(imgWidth);
            make.height.equalTo(imgHeight);
        })
        interval = CGFloat(-imgHeight) - CGFloat(imgTextDistance)
        titleOffsetX = CGFloat(-imgWidth)
        titleOffsetY = interval;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetY, titleOffsetX, 0, 0)
        
    }

    /**
    设置图片和标题水平放置 标题在左
    必须设定：标题
    图片 非背景图，图片必须以UIImage(named: )方式设定 否则将找不到
    图片大小与真实比例相同，非压缩 若图片太大则不可以
    
    - parameter imgTextDistance: 图片和文字的间距
    */
    public func setHorizontalLabelLeft(_ imgTextDistance:CGFloat){
        
        let imgWidth = self.imageView?.image?.size.width ?? 0
        let imgHeight = self.imageView?.image?.size.height ?? 0
        let textSize = NSString(string: self.titleLabel!.text!).size(attributes: [NSFontAttributeName : self.titleLabel!.font])
        let textWitdh = textSize.width
//        let textHeight = textSize.height
        var interval:CGFloat! // distance between the whole image title part and button
        var titleOffsetX:CGFloat! // horizontal offset of title
        var titleOffsetY:CGFloat! // vertical offset of title
        
        self.imageView?.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalTo(self.snp.centerY).offset(0);
            make.centerX.equalTo(self.snp.centerX).offset((textWitdh + imgTextDistance)/2);
            make.width.equalTo(imgWidth);
            make.height.equalTo(imgHeight);
        })
        interval = self.imageView!.frame.origin.x - imgTextDistance-textWitdh - imgWidth * 2;
        titleOffsetX = interval
        titleOffsetY = 0;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetY, titleOffsetX, 0, 0)
    }
    
    /**
    ====================================================
    mrshan-------2016.1.13,给button添加修改事件
    ====================================================
    */
    /**
    给按钮添加单击事件，隐藏target
    */
    fileprivate func whenTap(){
        self.addTarget(self, action: #selector(UIButton.customButtonPressOnce), for: UIControlEvents.touchUpInside)
    }
    
    /**
    单击事件是执行闭包，嘻嘻
    */
    func customButtonPressOnce(){
        exeFunc()
    }
    
    /**
    当执行这个方法的时候，给每一个BUTTON的实例添加一个唯一的闭包，放在  buttonclouser 字典中，
    字典的key是这个实例的hashValue,因为父类是NSOBJECT 所以他们的hashvalue都已经实现了。
    
    - parameter newaction: 穿件来一个闭包
    */
    func buttonTapOnce(_ newaction:@escaping ()->Void){
        addCloser(newaction)//添加方法
        self.whenTap()
    }
    
    /**
    添加闭包。
    这里面的这个key是与这个实例化对象息息相关的，也可以是他的hashValue，
    这个buttoncluser的key也可以直接是 Int,原因很简单，因为Swift中Int 和 String 都已经实现了 Equatable（哈希）
    
    - parameter newaction: 执行方法闭包
    */
    fileprivate func addCloser(_ newaction:@escaping ()->Void){
        buttonClouser[String(self.hashValue)] = newaction
    }
    
    /**
    执行闭包，只有执行的时候，引用那边的闭包才会执行
    */
    fileprivate func exeFunc(){
        let closuer = buttonClouser[String(self.hashValue)]
        closuer!()
    }
    
    /**
    ============================================
    ============================================
    这里是给button添加两个闭包。分别放在两个不同的字典中，为了能让buton执行两个不同的代码块，为了提示框所以才如此设计==mrshan-2016.1.14
    ============================================
    ============================================
    - parameter antion:
    - parameter newaction:
    */
    
    func buttonTapOnceTwoClosure(_ antion:@escaping ()->(),newaction:@escaping ()->Void){
        addCloser2(antion)//添加方法
        addCloser(newaction)//添加方法
        self.whenTap2()
    }
    
    /**
    添加闭包。
    这里面的这个key是与这个实例化对象息息相关的，也可以是他的hashValue，
    这个buttoncluser的key也可以直接是 Int,原因很简单，因为Swift中Int 和 String 都已经实现了 Equatable（哈希）
    
    - parameter newaction: 执行方法闭包
    */
    fileprivate func addCloser2(_ newaction:@escaping ()->Void){
        buttonTwoClouser[String(self.hashValue)] = newaction
    }
    
    fileprivate func whenTap2(){
        self.addTarget(self, action: #selector(UIButton.customButtonPressOnce2), for: UIControlEvents.touchUpInside)
    }
    
    /**
    单击事件是执行闭包，嘻嘻
    */
    func customButtonPressOnce2(){
        exeFunc2()
        exeFunc()
    }
    
    /**
    执行闭包，只有执行的时候，引用那边的闭包才会执行
    */
    fileprivate func exeFunc2(){
        let closuer = buttonTwoClouser[String(self.hashValue)]
        closuer!()
    }

}

//MARK:卖报的小画家
func getName() {
    
}

//TODO:heheh
func getName1() {
    
}

//MARK:点击延时拓展
/// 默认时间间隔
var defaultIntervalL:Double = 0.25

/// 延时时间key
private var  buttonDelayedTime = "buttonDelayedTime"
/// 是否可以点击key
private var  buttonIsIgnoreEvent = "buttonIsIgnoreEvent"
extension UIButton{
   
    /// 延时时间
    public var timeInterval:TimeInterval {
        get{
            if(objc_getAssociatedObject(self, &buttonDelayedTime) == nil){
                objc_setAssociatedObject(self, &buttonDelayedTime, 0,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return 0
            }else{
                
                return (objc_getAssociatedObject(self,&buttonDelayedTime) as AnyObject).doubleValue
            }
        }
        set{
            
            objc_setAssociatedObject(self, &buttonDelayedTime, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否可以点击 禁止调用
    private var isIgnoreEvent:Bool {
        get{
            if(objc_getAssociatedObject(self, &buttonIsIgnoreEvent) == nil){
                objc_setAssociatedObject(self, &buttonIsIgnoreEvent, true,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return false
            }else{
                
                return (objc_getAssociatedObject(self, &buttonIsIgnoreEvent) as AnyObject).boolValue
            }
        }
        
        set{
            objc_setAssociatedObject(self, &buttonIsIgnoreEvent, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override class func initialize(){
        struct Static{
            static var token = NSUUID().uuidString
        }
        
            DispatchQueue.once(name: Static.token, action: {
                if self != UIButton.self{
                
                return
            }
            
            let selA = #selector(UIButton.sendAction(_:to:for:))
            let selB = #selector(UIButton.mySendAction(action:target:event:))
            let methodA = class_getInstanceMethod(self,selA);
            let methodB = class_getInstanceMethod(self,selB);
            let isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
            if (isAdd) {
                class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
                
            }else{
                
                method_exchangeImplementations(methodA, methodB);
            }
        })
    }
    
    // 交换sender 实现
    public func mySendAction(action:Selector,target:NSObject,event:UIEvent){
        // 只处理UIButton 不处理子类
        if(NSStringFromClass(self.classForCoder) == "UIButton"){
            if (self.isIgnoreEvent){
                
                return
            }else{
                self.isIgnoreEvent = true
            }
            self.mySendAction(action: action, target: target, event: event)
            if (self.timeInterval == 0)
            {
                self.delay(defaultIntervalL) { () -> () in
                    self.isIgnoreEvent = false
                }
            }else{
                self.delay(timeInterval) { () -> () in
                    self.isIgnoreEvent = false
                }
            }
        }else{
            self.mySendAction(action: action, target: target, event: event)
        }
   }
}
