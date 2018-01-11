//
//  MyTextFieldExtension.swift
//  FSZCItem
//  closure
//  Created by mrshan on 16/1/13.
//  Copyright © 2016年 Mrshan. All rights reserved.
//
//	        =       =         =====    =          =      =    =
//         = =     = =        =        =        =   =    ==   =
//        =   =   =   =       =====    =====    =====    =  = =
//       =     = =     =          =    =   =    =   =    =   ==
//      =       =       =     =====    =   =    =   =    =    =
//
//   GithubAddress:https://github.com/hatjs880328/…
//   connectMe:shanwenzheng@qq.com
//   corporation:JiNanDongzheng Information&Technology Co.,Ltd
//
import UIKit
import Foundation

var textfieldClouser:[Int:((_ index:Int)->())] = [:]
extension UITextField:UITextFieldDelegate {
    
//    /**
//    给这个特定的textfield添加需要执行的方法（闭包）
//    
//    - parameter newAction:
//    */
//    public func textFieldTextShouldChange(textfieldComeMrshan newAction:(index:Int)->Void){
//        self.addClosure(newAction)
//        self.delegate = self
//    }
//    
//    /**
//    添加唯一的闭包，根据特定的当前类的实例
//    
//    - parameter newAction:
//    */
//    private func addClosure(newAction:(index:Int)->Void){
//        textfieldClouser[self.hashValue] = newAction
//    }
//    
//    /**
//    return 时候执行的方法，闭包中参数变化
//    */
//    private func executeClosureWhenReturn(){
//        let closure = textfieldClouser[self.hashValue]
//        closure!(index: 1)
//    }
//    
//    /**
//    will start  时候执行的方法，闭包中参数变化
//    */
//    private func executeClosureWillBegin(){
//        let closure = textfieldClouser[self.hashValue]
//        closure!(index: 0)
//    }
//    
//    /**
//    当前控件的代理方法
//    
//    - parameter textField:
//    
//    - returns:
//    */
//    public func textFieldShouldReturn(textField: UITextField) -> Bool {
//        executeClosureWhenReturn()
//        return true
//    }
//    
//    /**
//    用完控件执行的方法
//    
//    - parameter textField:
//    */
//    public func textFieldDidEndEditing(textField: UITextField) {
//        executeClosureWhenReturn()
//    }
//    
//    /**
//    dangq当前控件的代理方法
//    
//    - parameter textField:
//    
//    - returns:
//    */
//    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        executeClosureWillBegin()
//        return true
//    }
    
    
}

private var __UITextFieldExtensionAttributeKey  = "__UITextFieldExtensionAttributeKey"

extension UITextField{
    
    /// 延展属性 记录一些东西
    public var extensionAttribute: String? {
        get {
            let lastView = objc_getAssociatedObject(self, &__UITextFieldExtensionAttributeKey);
            return lastView as? String
        }
        
        set {
            objc_setAssociatedObject(self,
                                     &__UITextFieldExtensionAttributeKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 获取光标位置 UITextField光标位置是不可set的
    ///
    /// - Returns: 位置
    func selectedRange() -> NSRange {
        if self.selectedTextRange == nil {
            
            return NSMakeRange(self.text!.length , 1)
        }
        let location = self.offset(from: self.beginningOfDocument, to: self.selectedTextRange!.end)
        let length = self.offset(from: self.selectedTextRange!.start, to: self.selectedTextRange!.end)
        
        return NSMakeRange(location, length)
    }

}

