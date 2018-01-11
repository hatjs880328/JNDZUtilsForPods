//
//  GCDUtils.swift
//  FSZCItem
//  线程的封桩，简单的多线程，延迟执行，多线程的串并行
//  Created by mrshan on 16/1/15.
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

///对线程做拓展加一个只执行一次的方法，用name来记录只执行一次的方法，<这个方式最简单，但是再编程的时候却要注意。不能重复。>
public extension DispatchQueue {
     public static func once(name:String,action:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
//        if APPConfigNoCache.getInstance().taskIDs.contains(name) {return}
//        APPConfigNoCache.getInstance().taskIDs.append(name)
        action()
    }
}

public class GCDUtils {
    
    /**
     延时执行的方法封桩（切记执行的事件方法已经放到主线程） Mrshan
     
     - parameter delayTime:   延时时间
     - parameter yourFuncton: 需要做的事情
     */
    class func delayProgress(delayTime:Int,yourFuncton:@escaping ()->()){
        let delay = DispatchTime.now() + DispatchTimeInterval.seconds(delayTime)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            yourFuncton()
        }
    }
    
    /// 延时执行的方法-毫秒为单位
    ///
    /// - Parameters:
    ///   - milliseconds: 毫秒  1s = 1000ms
    ///   - yourFunc: func
    class func delayProgerssWithFloatSec(milliseconds:Int,yourFunc:@escaping ()->()) {
        let delay = DispatchTime.now() + DispatchTimeInterval.milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            yourFunc()
        }
    }
    
    /**
     跳转到主线程执行事件
     
     - parameter youraction: 事件
     */
    class func toMianThreadProgressSome(youraction:@escaping ()->Void) {
        DispatchQueue.main.async {
            youraction()
        }
    }
    
    /**
     创建队列，执行方法，中间闭包是后台执行的事件，最后是回到主线程执行的事情
     
     - parameter dispatchLevel:       线程执行等级,1,2,3,others....
     - parameter asyncDispathchFunc:  异步执行的事件
     - parameter endMainDispatchFunc: 回到主线程执行的事件
     */
    class func asyncProgress(dispatchLevel:Int,asyncDispathchFunc:@escaping ()->(),endMainDispatchFunc:@escaping ()->()){
        var level:DispatchQoS.QoSClass?
        if(dispatchLevel == 1){
            level = DispatchQoS.QoSClass.userInteractive
        }else if(dispatchLevel == 2){
            level = DispatchQoS.QoSClass.userInitiated
        }else if(dispatchLevel == 3){
            level = DispatchQoS.QoSClass.utility
        }else{
            level = DispatchQoS.QoSClass.background
        }
        DispatchQueue.global(qos: level!).async {
            asyncDispathchFunc()
            DispatchQueue.main.async {
                endMainDispatchFunc()
            }
        }
    }
    
    /**
     多个线程同时执行，当都执行完毕的时候,去主线程执行一个任务
     
     - parameter endMainDispatchFunc: 主线程执行的闭包
     - parameter asyncDispicth:       全局线程们
     */
    class func asyncSomeProgressThenDeelInmainqueue(endMainDispatchFunc:@escaping ()->(),asyfuncOne:@escaping ()->(),asyfuncTwo:@escaping (_ actionone:()->Void)->Void){
        var flagOne = 0
        var flagTwo = 0
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            asyfuncOne()
            flagOne = 1
            if flagOne == flagTwo {
                endMainDispatchFunc()
                return
            }
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            asyfuncTwo({ () -> Void in
                flagTwo = 1
                if flagOne == flagTwo {
                    endMainDispatchFunc()
                    return
                }
            })
        }
    }
    
    /**
     多线程的串行,目前是将所有线程放到主线程去执行，实现的方法 MRSHAN
     方法：将多线程对到一个线程去执行
     
     - parameter firstDispatch:  第一段需要执行的方法
     - parameter secondDispatch: 第二段需要执行的方法
     - parameter thirdDispatch:  第三段需要执行的方法
     - parameter others:         其他，不限制
     */
    class func dispatchAsyncChuan(firstDispatch:@escaping ()->(),secondDispatch:@escaping ()->(),thirdDispatch:@escaping ()->(),others:()->()...){
        let groupDispatch: DispatchGroup = DispatchGroup()
        let dispatchAsy = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        groupDispatch.enter()
        dispatchAsy.sync {
            firstDispatch()
        }
        dispatchAsy.sync {
            secondDispatch()
        }
        dispatchAsy.sync {
            thirdDispatch()
        }
        dispatchAsy.sync {
            for eachItem in others.enumerated() {
                eachItem.element()
            }
        }
        groupDispatch.leave()
    }
    
    /**
     多线程的并行 MRSHAN
     
     - parameter firstDispatch:  第一段需要执行的方法
     - parameter secondDispatch: 第二段需要执行的方法
     - parameter thirdDispatch:  第三段需要执行的方法
     - parameter others:         其他，不限制
     */
    class func dispatchAsyncBing(firstDispatch:@escaping ()->(),secondDispatch:@escaping ()->(),thirdDispatch:@escaping ()->(),others:()->()...){
        let groupDispatch:DispatchGroup = DispatchGroup()
        let dispatchAsy = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        //线程的并行
        groupDispatch.enter()
        dispatchAsy.async {
            firstDispatch()
        }
        dispatchAsy.async {
            secondDispatch()
        }
        dispatchAsy.async {
            thirdDispatch()
        }
        dispatchAsy.async {
            firstDispatch()
        }
        for eachitem in others.enumerated() {
            dispatchAsy.async {
                eachitem.element()
            }
        }
    }
    
    /// 线程组-实现同步锁的处理方法
    ///
    /// - Parameters:
    ///   - actionOne: 第一个方法
    ///   - actionTwo: 第二个方法
    ///   - endAction: 都结束的方法
    class func someFuncitonEndTogether(actionOne:@escaping ()->Void,actionTwo:@escaping ()->Void,endAction:()->Void) {
        let disGp = DispatchGroup()
        let disOne = DispatchQueue(label: "one")
        let itemOne = DispatchWorkItem(block: actionOne)
        disOne.async(group: disGp, execute: itemOne)
        
        let disTwo = DispatchQueue(label: "two")
        let itemTwo = DispatchWorkItem(block: actionTwo)
        disTwo.async(group: disGp, execute: itemTwo)
        
        disGp.wait()
        endAction()
    }
}
