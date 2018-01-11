//
//  MyNSNumberExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/22.
//  Copyright © 2015年 东正. All rights reserved.
//

import Foundation

public extension NSNumber{
    
    var toInt : Int{
        return self.intValue
    }
    
    var toInt64 : Int64{
        return self.int64Value
    }
    
    var toString : String {
        return self.stringValue
    }
    
    
}

//MARK:TimeInterval

public extension TimeInterval{
    
    var toDouble : Double{
        return Double(self)
    }
    var toInt64 : Int64{
        return Int64(self)
    }
    var toInt : Int{
        return Int(self)
    }
    

    public var second: TimeInterval {
        return self.seconds
    }
    
    public var seconds: TimeInterval {
        return self
    }
    
    public var minute: TimeInterval {
        return self.minutes
    }
    
    public var minutes: TimeInterval {
        let secondsInAMinute = 60 as TimeInterval
        return self * secondsInAMinute
    }
    
    public var day: TimeInterval {
        return self.days
    }
    
    public var days: TimeInterval {
        let secondsInADay = 86_400 as TimeInterval
        return self * secondsInADay
    }
    
    public var before: Foundation.Date {
        let timeInterval = self
        return Foundation.Date().addingTimeInterval(-timeInterval)
    }
    
    public var after : Foundation.Date{
        
        let timeInterval = self
        return Foundation.Date().addingTimeInterval(+timeInterval)
    }
}
