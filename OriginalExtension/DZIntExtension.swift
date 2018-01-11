//
//  MyIntExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/16.
//  Copyright © 2015年 东正. All rights reserved.
//

import Foundation

public extension Int {
    
    /// 检查是不是偶数
    ///
    /// :return 偶数 true
    public var isEven: Bool {
        get {
            return self % 2 == 0
        }
    }
    
    /// 检查是不是奇数
    ///
    /// :return 奇数 true
    public var isOdd: Bool {
        get {
            return self % 2 == 1
        }
    }
    
    /// 根据ASCII获取对应的字符，注意不要越界
    ///
    /// :return ASCII字符
    public var char: Character {
        get {
            return Character(UnicodeScalar(self)!)
        }
    }
    
    /// 分开int值成一个数组
    ///
    /// :return Bool whether int is odd
    public func digits() -> [Int] {
        var digits: [Int] = []
        var selfCopy = self
        while selfCopy > 0 {
            digits << (selfCopy % 10)
            selfCopy = (selfCopy / 10)
        }
        return Array(digits.reversed())
    }
    
    /// 返回下一个值
    ///
    /// :return next
    public func next() -> Int {
        return self + 1
    }
    
    /// 返回前一个值
    ///
    /// :return before int
    public func before() -> Int {
        return self - 1
    }
    
    var toNumber_64Bit : NSNumber{
        let self64 = Int64(self)
        return NSNumber(value: self64 as Int64)
    }
    
    var toString : String{
        return String(self)
    }
    ///0为假 1为真
    func toBool () ->Bool? {
        switch self {
        case 0:
            return false
        case 1:
            return true
        default:
            return nil
        }
    }
    
    
    
    
    fileprivate func mathForUnit(_ unit: NSCalendar.Unit) -> CalendarMath {
        return CalendarMath(unit: unit, value: self)
    }
    
    var seconds: CalendarMath {
        return mathForUnit(.second)
    }
    
    var second: CalendarMath {
        return seconds
    }
    
    var minutes: CalendarMath {
        return mathForUnit(.minute)
    }
    
    var minute: CalendarMath {
        return minutes
    }
    
    var hours: CalendarMath {
        return mathForUnit(.hour)
    }
    
    var hour: CalendarMath {
        return hours
    }
    
    var days: CalendarMath {
        return mathForUnit(.day)
    }
    
    var day: CalendarMath {
        return days
    }
    
    var weeks: CalendarMath {
        return mathForUnit(.weekOfYear)
    }
    
    var week: CalendarMath {
        return weeks
    }
    
    var months: CalendarMath {
        return mathForUnit(.month)
    }
    
    var month: CalendarMath {
        return months
    }
    
    var years: CalendarMath {
        return mathForUnit(.year)
    }
    
    var year: CalendarMath {
        return years
    }
    
    struct CalendarMath {
        fileprivate let unit: NSCalendar.Unit
        fileprivate let value: Int
        fileprivate var calendar: Calendar {
            return Calendar.autoupdatingCurrent
        }
        
        fileprivate init(unit: NSCalendar.Unit, value: Int) {
            self.unit = unit
            self.value = value
        }
        
        fileprivate func generateComponents(_ modifer: (Int) -> (Int) = (+)) -> DateComponents {
            let components = DateComponents()
            (components as NSDateComponents).setValue(modifer(value), forComponent: unit)
            return components
        }
        
        public func from(_ date: Foundation.Date) -> Foundation.Date? {
            return (calendar as NSCalendar).date(byAdding: generateComponents(), to: date, options: [])
        }
        
        public var fromNow: Foundation.Date? {
            return from(Foundation.Date())
        }
        
        public func before(_ date: Foundation.Date) -> Foundation.Date? {
            return (calendar as NSCalendar).date(byAdding: generateComponents(-), to: date, options: [])
        }
        
        public var ago: Foundation.Date? {
            return before(Foundation.Date())
        }
    }
    
    /// Invoke a callback n times
    ///
    /// :param callback The function to invoke that accepts the index
    public func times(_ callback: @escaping (Int) -> ()) {
        (0..<self).eachWithIndex { callback($0) }
    }
    
    /// Invoke a callback n times
    ///
    /// :param callback The function to invoke
    public func times(_ function: @escaping () -> ()) {
        self.times { (index: Int) -> () in
            function()
        }
    }
    
    /// Invoke the callback from int up to and including limit
    ///
    /// :params limit the max value to iterate upto
    /// :params callback to invoke
    public func upTo(_ limit: Int, callback: @escaping () -> ()) {
        
        (self ..< limit).each { callback() }
    }
    
    /// Invoke the callback from int up to and including limit passing the index
    ///
    /// :params limit the max value to iterate upto
    /// :params callback to invoke
    public func upTo(_ limit: Int, callback: @escaping (Int) -> ()) {
        (self ..< limit).eachWithIndex { callback($0) }
    }
    
    /// Invoke the callback from int down to and including limit
    ///
    /// :params limit the min value to iterate upto
    /// :params callback to invoke
    public func downTo(_ limit: Int, callback: () -> ()) {
        var selfCopy = self
        while selfCopy >= limit {
            selfCopy = selfCopy - 1
            callback()
        }
    }
    
    /// Invoke the callback from int down to and including limit passing the index
    ///
    /// :params limit the min value to iterate upto
    /// :params callback to invoke
    public func downTo(_ limit: Int, callback: (Int) -> ()) {
        var selfCopy = self
        while selfCopy >= limit {
            callback(selfCopy)
            selfCopy = selfCopy - 1
        }
    }
    
    /// GCD metod return greatest common denominator with number passed
    ///
    /// :param number
    /// :return Greatest common denominator
    public func gcd(_ n: Int) -> Int {
        return $.gcd(self, n)
    }
    
    /// LCM method return least common multiple with number passed
    ///
    /// :param number
    /// :return Least common multiple
    public func lcm(_ n: Int) -> Int {
        return $.lcm(self, n)
    }
    
    /// Returns random number from 0 upto but not including value of integer
    ///
    /// :return Random number
    public func random() -> Int {
        return $.random(self)
    }
    
    /// Returns Factorial of integer
    ///
    /// :return factorial
    public func factorial() -> Int {
        return $.factorial(self)
    }
    
    /// Returns true if i is in closed interval
    ///
    /// :param i to check if it is in interval
    /// :param interval to check in
    /// :return true if it is in interval otherwise false
    public func isIn(_ interval: ClosedRange<Int>) -> Bool {
        return $.it(self, isIn: Range(interval))
    }
    
    /// Returns true if i is in half open interval
    ///
    /// :param i to check if it is in interval
    /// :param interval to check in
    /// :return true if it is in interval otherwise false
    public func isIn(_ interval: Range<Int>) -> Bool {
        return $.it(self, isIn: interval)
    }
    
//    /// Returns true if i is in range
//    ///
//    /// :param i to check if it is in range
//    /// :param interval to check in
//    /// :return true if it is in interval otherwise false
//    public func isIn(_ interval: Range<Int>) -> Bool {
//        return $.it(self, isIn: interval)
//    }
    
}

public extension Int64{
    
    var toNumber_64Bit : NSNumber{
        return NSNumber(value: self as Int64)
    }
    
    var toString : String{
        return String(self)
    }
    
    var toDate : Foundation.Date{
        let interval : TimeInterval = Double(self) / 1000
        return Foundation.Date(timeIntervalSince1970:interval)
    }
}
