//
//  MyUISwitchExtension.swift
//  FSZCItem
//  
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

var switchClosure:[Int:((_ ifOpen:Bool)->())] = [:]//这个数组的作用是保存每一个实例化对象的闭包，用哈希确保每一个KEY都是唯一的
extension UISwitch {
    
    public func switchValueChange(_ newAction:@escaping (_ ifOpen:Bool)->Void){
        addClosure(newAction)
        valueChange()
    }
    
    fileprivate func valueChange(){
        self.addTarget(self, action: #selector(UISwitch.selfValueChange), for: UIControlEvents.valueChanged)
    }
    
    func selfValueChange(){
        executeClosure(self.isOn)
    }
    
    fileprivate func addClosure(_ newAction:@escaping (_ ifOpen:Bool)->Void){
        switchClosure[self.hashValue] = newAction
    }
    
    fileprivate func executeClosure(_ ifopen:Bool){
        let closure = switchClosure[self.hashValue]
        closure!(ifopen)
    }
}
