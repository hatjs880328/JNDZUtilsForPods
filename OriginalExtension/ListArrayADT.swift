////
////  LinkedArray.swift
////  LinkedArray
////
////  Created by mrshan on 16/5/4.
////  Copyright © 2016年 Mrshan. All rights reserved.
////
//
//import Foundation
//
//@objc protocol Iterator:NSObjectProtocol {
//    @objc optional func sort(_ array:[AnyObject])
//    @objc optional func sortNow()
//}
//
//protocol IteratorNow:NSObjectProtocol {
//    func sort<T>(_ array:[T])
//}
//
///// 链式ADT
//class LinkedArray: NSObject,Iterator,IteratorNow {
//
//    //列表的容量
//    var nodeSize: Int = 0
//    //数据
//    var content: LinkedNode?
//    //链表的头
//    var linkedHead: LinkedNode? = nil
//    //链表的尾巴
//    var linkedTail: LinkedNode? = nil
//    
//    /**
//     构造链列表
//     
//     - parameter nodefirst: 第一个节点，可为nil
//     
//     - returns: 链式列表
//     */
//    init(nodefirst:LinkedNode?){
//        super.init()
//        if nodefirst == nil {
//            
//        }else{
//            self.content = nodefirst
//            self.appendNode(nodefirst!)
//        }
//    }
//    
//    /**
//     添加一个NODE的方法(在最后直接加上一个node)
//     
//     - parameter node: 添加一个NODE
//     */
//    func appendNode(_ node:LinkedNode){
//        if nodeSize == 0 {
//            self.linkedHead = node
//            self.linkedTail = node
//            nodeSize += 1
//        }else{
//            self.linkedTail?.afterNode = node
//            node.beforeNode = self.linkedTail
//            self.linkedTail = node
//            self.nodeSize += 1
//        }
//    }
//    
//    /**
//     删除所有节点
//     */
//    func removeAllobject(){
//        self.nodeSize = 0
//        self.linkedTail = nil
//        self.linkedHead = nil
//    }
//    
//    /**
//     在某个index处添加一个节点
//     
//     - parameter index: index
//     - parameter node:  节点
//     */
//    func addBefore(_ index:Int,node:LinkedNode){
//        if index > self.nodeSize {
//            return
//        }
//        if index == self.nodeSize {
//            //在最后面添加即可
//            self.appendNode(node)
//            return
//        }
//        //在某个点后面加上node,首先获取这个INDEX上的节点
//        let nodeItem = self.getNodewithIndex(index)
//        nodeItem?.afterNode?.beforeNode = node
//        node.afterNode = nodeItem?.afterNode
//        node.beforeNode = nodeItem
//        nodeItem?.afterNode = node
//        self.nodeSize += 1
//    }
//    
//    /**
//     根据INDEX删除一个节点
//     
//     - parameter index: index
//     */
//    func removeNodewithIndex(_ index:Int){
//        if index > self.nodeSize {
//            return
//        }
//        if self.nodeSize == 1 {
//            self.linkedTail = nil
//            self.linkedHead = nil
//            self.nodeSize = 0
//            return
//        }
//        let node = getNodewithIndex(index)
//        node?.beforeNode?.afterNode = node?.afterNode
//        node?.afterNode?.beforeNode = node?.beforeNode
//        self.nodeSize -= 1
//    }
//    
//    /**
//     获取某个index下的节点
//     
//     - parameter index: index
//     
//     - returns: 节点
//     */
//    func getNodewithIndex(_ index:Int)->LinkedNode?{
//        if  index > self.nodeSize {
//            return nil
//        }
//        //这里需要 hasNext方法的支持(节点的方法)
//        if self.nodeSize == 0 {
//            return nil
//        }
//        if index == 1 {
//            return self.linkedHead
//        }
//        if index == self.nodeSize {
//            return self.linkedTail
//        }
//        //这里可以用二分法查找
//        var itemNode: LinkedNode? = content
//        
//        if index > self.nodeSize/2 {
//            //在后半区
//            itemNode = self.linkedTail
//            for i in ((index + 1)...self.nodeSize).reversed() {
//                itemNode = itemNode?.beforeNode
//            }
//        }else{
//            //在前半区
//            itemNode = self.linkedHead
//            for i in 1  ..< index {
//                itemNode = itemNode?.afterNode
//            }
//        }
//        
//        return itemNode
//    }
//    
//    
//}
//
///// 节点类
//class LinkedNode: NSObject {
//    //首先是他自己的内容
//    var content: AnyObject {
//        get{
//            return self.content
//        }
//        set{
//            
//        }
//    }
//    
//    //然后是他前面节点的内容
//    var beforeNode: LinkedNode?
//    //再试他后面节点的内容
//    var afterNode: LinkedNode?
//    
//    /**
//     构造方法
//     
//     - parameter data: 节点数据
//     - parameter prev: 头
//     - parameter next: 尾巴
//     
//     - returns: 节点对象
//     */
//    init(data:AnyObject,prev:LinkedNode?,next:LinkedNode?){
//        super.init()
//        self.content = data
//        self.beforeNode = prev
//        self.afterNode = next
//    }
//    
//    /**
//     当前节点是否有下一个节点
//     
//     - returns: 是否有
//     */
//    func hasNext()->Bool{
//        return afterNode == nil
//    }
//}
