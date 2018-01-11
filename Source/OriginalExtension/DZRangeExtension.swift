//
//  MyRangeExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/16.
//  Copyright © 2015年 东正. All rights reserved.
//

import Foundation

public extension Range {
    
    /// For each index in the range invoke the callback by passing the item in range
    ///
    /// :param callback The callback function to invoke that take an element
    func eachWithIndex(_ callback:(Int)->Void) {
        let lower : Int = self.lowerBound as! Int
        let upper : Int = self.upperBound as! Int
        for eachItem in lower ... upper {
            callback(eachItem)
        }
    }
    
    /// For each index in the range invoke the callback
    ///
    /// :param callback The callback function to invoke
    func each(_ callback: @escaping () -> ()) {
        self.eachWithIndex { (T) -> () in
            callback()
        }
    }
    
}

public func ==<T: Comparable>(left: Range<T>, right: Range<T>) -> Bool {
    return left.lowerBound == right.lowerBound && left.upperBound == right.upperBound
}
