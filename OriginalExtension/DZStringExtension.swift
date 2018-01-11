//
//  MyStringExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/7.
//  Copyright © 2015年 东正. All rights reserved.
//

import UIKit

import CryptoSwift

/**
 数据类型
 
 - NSListType:     顺序集合结构
 - NSSetType:      无顺序集合结构
 - NSObjectType:   系统非集合类型
 - UnNSObjectType: 自定义类型
 */
public enum ObjectType{
    case nsListType
    case nsSetType
    case nsObjectType
    case unNSObjectType
}

public extension String{
    
    /// 将字符串前面的0去掉，后边的0去掉
    ///
    /// - Returns: st
    func progressZeroStr()->String {
        var result = ""
        result = self.removeRightSpaces("0").removeLeftSpaces("0")
        // .5 -> 0.5
        if result.characters.first == "." {
            result = "0" + result
        }
        // 10. -> 10.00
        if result.characters.last == "." {
            result += "00"
        }
        // 10 -> 10.00
        if !result.contains(".") {
            result += ".00"
        }
        //  0.1 -> 0.10
        if result.substringFromIndex(result.indexOf(".")).characters.count == 2 {
            result += "0"
        }
        return result
    }
    
    /**
     将字符串按字母排序升序(不考虑大小写)
     
     - returns:
     */
    func sortAsc() -> String {
        var chars = [Character](self.characters)
        chars.sort(by: {$0 < $1})
        
        return String(chars)
    }
    
    /**
     将字符串按字母排序降序(不考虑大小写)
     
     - returns:
     */
    func sortDesc() -> String {
        var chars = [Character](self.characters)
        chars.sort(by: {$0 > $1})
        
        return String(chars)
    }
    
    /**
     转化成base64
     
     - returns: base64
     */
    func toBase64String()->String?{
       let data =  self.data(using: String.Encoding.ascii)
        return data?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
    }
    
    /**
    格式化手机号码
    
    - parameter phonenumber: 原来手机号
    */
    func formatPhoneNumber(_ phonenumber:String)->String{
        //to index  to 这个字母不包含，from index 是包含 INDEX这个数组的
        return phonenumber.substringToIndex(3) + "-" + phonenumber.substringWithRange(NSMakeRange(3, 4)) + "-" + phonenumber.substringFromIndex(7)
    }
    
    /**
    拼接url
     */
    func appendUrl(_ nextUrl:String)->String{
        if(self.contains("?")){
            return self + "&" + nextUrl
        }else{
            return self + "?" + nextUrl
        }
    }
    
    /**
     版本号比较
     
     - parameter : true 表示输入参数比当前大   false 表示输入参数比当前小
     */
    func isCheckVersion(_ version:String)->Bool{
        //数据可能为空
        if(version == "" || self == ""){
            
            return false
        }
        
        //如果特殊情况不包含。分隔符
        if !version.contains(".") ||  !self.contains(".") {
            
            return false
        }
        
        let versionArr =  version.components(separatedBy: ".")
        let selfArr =  self.components(separatedBy: ".")
        
        //如果分隔符数量不足
        if selfArr.count != 3 || versionArr.count != 3 {
            
            return false
        }
        
        //比较第一位
        if versionArr[0].toDouble()! > selfArr[0].toDouble()! {
            
            return true
        }else if versionArr[0].toDouble()! == selfArr[0].toDouble()! {
            //比较第二位
            if versionArr[1].toDouble()! > selfArr[1].toDouble()! {
                
                return true
            }else if versionArr[1].toDouble()! == selfArr[1].toDouble()! {
                //比较第三位
                if versionArr[2].toDouble()! > selfArr[2].toDouble()! {
                    
                    return true
                }else {
                    
                    return false
                }
                
            }else {
                
                return false
            }
        }else {
            
            return false
        }
        
    }
    
    func aesEncrypt(_ key: String, iv: String) throws -> String{
        let data = self.data(using: String.Encoding.utf8)
//        let enc = try AES(key: key, iv: iv, blockMode:.ECB).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let enc = try AES(key: key, iv: iv, blockMode:.ECB).encrypt(data!.bytes)
        
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result!
    }
    
    /**
     这个方法传入的KEY是[byte]
     
     - parameter key:
     
     - throws:
     
     - returns:     
     */
    func aesEncryptmrshan(_ key:[UInt8]) throws ->String {
        let data = self.data(using: String.Encoding.utf8)
//        let enc = try AES(key: key, iv: [], blockMode: .ECB).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let enc1 = try AES(key: key, iv: [], blockMode: .ECB)
        let enc = try enc1.encrypt(data!.bytes)
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result!
    }

    
    func aesDecryptmrshan(_ key:[UInt8]) throws ->String {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
//        let dec = try AES(key: key, iv: [], blockMode:.ECB).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let dec = try AES(key: key, iv: [], blockMode:.ECB).decrypt(data!.bytes)

        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
        return String(result!)
    }
    
    func aesDecrypt(_ key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
//        let dec = try AES(key: key, iv: iv, blockMode:.ECB).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let dec = try AES(key: key, iv: iv, blockMode:.ECB).decrypt(data!.bytes)

        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
        return String(result!)
    }
    
    func substringWithRange(_ range:NSRange)->String{
        let str = self as NSString
        return str.substring(with: range)
    }
    
    func substringFromIndex(_ from:Int)->String{
        let str = self as NSString
        return str.substring(from: from)
    }
    
    func substringToIndex(_ to:Int)->String{
        let str = self as NSString
        return str.substring(to: to)
    }
    
    /// 返回时间
    ///
    /// :param format: yyyy-MM-dd HH:mm:ss / yyyy-MM-dd / yyyyMMddHHmmss / MMddHHmmss
    ///
    /// returns: 时间
    func dateValue(_ format:String)->Foundation.Date?{
        let formats = DateFormatter()
        formats.dateFormat = format
        formats.timeZone = TimeZone(identifier: "GMT")
        return formats.date(from: self)
    }
    
    func pathComponents()->[String]{
        
        let newNstr = self as NSString
        return newNstr.pathComponents
        
    }
    func absolutePath()->Bool{
        
        let newNstr = self as NSString
        return newNstr.isAbsolutePath
    }
    
    func lastPathComponent()->String{
        
        let newNstr = self as NSString
        return newNstr.lastPathComponent
    }
    
    
    func stringByDeletingLastPathComponent()->String{
        
        let newNstr = self as NSString
        return newNstr.deletingLastPathComponent
    }
    
    func stringByAppendingPathComponent(_ str: String)->String{
        
        let newNstr = self as NSString
        return newNstr.appendingPathComponent(str)
    }
    
    func stringByDeletingPathExtension()->String{
        
        let newNstr = self as NSString
        return newNstr.deletingPathExtension
    }
    func stringByAppendingPathExtension(_ str: String)->String?{
        
        let newNstr = self as NSString
        return newNstr.appendingPathExtension(str)
    }
    
    func stringByAbbreviatingWithTildeInPath()->String{
        
        let newNstr = self as NSString
        return newNstr.abbreviatingWithTildeInPath
    }
    
    func stringByExpandingTildeInPath()->String{
        
        let newNstr = self as NSString
        return newNstr.expandingTildeInPath
    }
    
    func stringByStandardizingPath()->String{
        
        let newNstr = self as NSString
        return newNstr.standardizingPath
    }
    func stringByResolvingSymlinksInPath()->String{
        
        let newNstr = self as NSString
        return newNstr.resolvingSymlinksInPath
    }
    func stringsByAppendingPaths(_ paths: [String])->[String]{
        
        let newNstr = self as NSString
        return newNstr.strings(byAppendingPaths: paths)
    }
    
    /**
     格式化金额
     
     - returns: string
     */
    func stringFormatterCurrency()->String{
        
        if(self != "0" && self != ""){
            
            let stringArr = self.components(separatedBy: ".")
            
            let firstString = stringArr.first
            
            let lastString = stringArr.last
            
            if firstString!.length <= 3 {
                
                return self
                
            }else{
                
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal
                
                let s = firstString!.toDouble()
                let newAmount = formatter .string(from: NSNumber(value: s! as Double))
                if stringArr.count == 1{
                    return newAmount!
                }else{
                    return newAmount! + "." + lastString!
                }
            }
        }
        
        return self
        
    }

    
    
    /// 返回扩展名
    /// :returns: 扩展名
    func pathExtension()->String{
        let newNstr = self as NSString
        return newNstr.pathExtension
    }
    
    
    func integerValue()->Int{
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.integerValue
    }
    
    func longLongValue()->Int64{
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.longLongValue
    }
    
    func intValue()->Int32{
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.intValue
        
    }
    
    func floatValue()->Float{
    
        let newNstr = self.removeSpaces() as NSString
        return newNstr.floatValue
    
    }
    
    func doubleValue()->Double{
    
        let newNstr = self.removeSpaces() as NSString
        return newNstr.doubleValue
    
    }
    
    func boolValue()->Bool?{
        let text = self.removeSpaces().lowercased()
        if(text == "true" || text == "false" || text == "yes" || text == "no" || text == "YES" || text == "NO"){
            let newNstr = self as NSString
            return newNstr.boolValue
            
        }else{
            
            return nil
        }
        
    }
    
    /// 返回长度
    /// :returns: 字符串长度
    public var length: Int {
        get {
            return self.characters.count
        }
    }
    
    /// 返回首字母
    ///
    /// :param: string 需要转换的字符串
    /// :param: allFirst 是否需要所有的字符 false不需要(只要第一个字的首字母) true需要
    /// :returns: 首字母
    func GetTheFirstLetter(_ string:String?, allFirst:Bool=false)->String{
        var py="#"
        if let s = string {
            if s == "" {
                return py
            }
            let str = CFStringCreateMutableCopy(nil, 0, s as CFString!)
            CFStringTransform(str, nil, kCFStringTransformToLatin, Bool(0))
            CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, Bool(0))
            
            py = ""
            
            if allFirst { for x in str.debugDescription.components(separatedBy: " ") {
                
                py += GetTheFirstLetter(x)
                
                }
            }
            else {
                py = (str.debugDescription as NSString).substring(to: 1).uppercased()
            }
        }
        return py
        
    }
    
    
    /// 返回拼音
    ///
    /// :param: string 需要转换的字符串
    /// :param: allFirst 是否需要所有的字符 false不需要(只要第一个字的拼音) true需要
    /// :returns: 首字母
    func GetTheSpelling(_ string:String?, allFirst:Bool=false)->String{
        var py="#"
        if let s = string {
            if s == "" {
                return py
            }
            let str = CFStringCreateMutableCopy(nil, 0, s as CFString!)
            CFStringTransform(str, nil, kCFStringTransformToLatin, Bool(0))
            CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, Bool(0))
            
            py = ""
            if allFirst { for x in str.debugDescription.components(separatedBy: " ") {
                
                py += GetTheSpelling(x)
                
                }
            }
            else {
                py = (str! as NSString).uppercased
            }
        }
        return py
        
    }
    
    /**
    return Double
    */
    func toDouble() -> Double? {
        
        let scanner = Scanner(string: self)
        var double: Double = 0
        if scanner.scanDouble(&double) {
            return double
        }
        
        return nil
        
    }
    
    /// string  2   double 精度异常问题
    ///
    /// - Parameters:
    ///   - lastValue: 后面的数字
    ///   - operater: 操作符 (+ - * / 其他有用自己添加)
    /// - Returns: doublevalue
    func string2doubleOperate(lastValue:String,operater:String)->String {
        switch operater {
            case "+":return NSDecimalNumber(string: self).adding(NSDecimalNumber(string: lastValue)).toString
            case "-":return NSDecimalNumber(string: self).subtracting(NSDecimalNumber(string: lastValue)).toString
            case "*":return NSDecimalNumber(string: self).multiplying(by: NSDecimalNumber(string: lastValue)).toString
            default :return NSDecimalNumber(string: self).dividing(by: NSDecimalNumber(string: lastValue)).toString
        }
    }
    
    /// 改变小数点后两位字体大小
    ///
    /// - Parameters:
    ///   - font: 后两位数的字体大小
    ///   - color: 颜色
    /// - Returns: NSMutableString
    func changeMoneyDoubleDecimalStyle(font : UIFont = UIFont(name:"",size: 9)! , color : UIColor = UIColor.lightGray) -> NSAttributedString{
        
        let attStr = NSMutableAttributedString(string: self)
        
        attStr.addAttributes([NSFontAttributeName:font], range: NSMakeRange(self.length - 2, 2))
        attStr.addAttributes([NSForegroundColorAttributeName : color], range: NSMakeRange(0, self.length))
        
        return attStr
    }
    
    
    /**
    return Float
    */
    func toFloat() -> Float? {
        
        let scanner = Scanner(string: self)
        var float: Float = 0
        
        if scanner.scanFloat(&float) {
            return float
        }
        
        return nil
        
    }
    
    /**
    returns: UInt
    */
    func toUInt() -> UInt? {
        if let val = Int(self.removeSpaces()) {
            if val < 0 {
                return nil
            }
            return UInt(val)
        }
        
        return nil
    }
    
    
    func toBool() -> Bool? {
        return self.boolValue()
    }
    
    func stringToBool() -> Bool {
        if self == "true" {
        
            return true
        }else{
            return false
        }
    }
    
    /**
    解析日期字符串
    默认格式yyyy-MM-dd，但可以修改。
    
    - returns: 解析NSDate 如果不是的话，就为空
    */
    func toDate(_ format : String? = "yyyy-MM-dd") -> Foundation.Date? {
        let text = self.removeSpaces().lowercased()
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.date(from: text)
    }
    
    /**
    解析日期字符串
    默认格式yyyy-MM-dd HH-mm-ss，但可以修改。
    
    - returns: 解析NSDate 如果不是的话，就为空
    */
    func toDateTime(_ format : String? = "yyyy-MM-dd HH-mm-ss") -> Foundation.Date? {
        return toDate(format)
    }
    
    /**
    删除最左边和参数一样的字符 若空则删除空格
    
    - returns: Stripped string
    */
    func trimmedLeft (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        if let range = rangeOfCharacter(from: set.inverted) {
            return self[range.lowerBound..<endIndex]
        }
        
        return ""
    }
    
    /**
    删除最右边和参数一样的字符 若空则删除空格
    
    - returns: Stripped string
    */
    func trimmedRight (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        if let range = rangeOfCharacter(from: set.inverted, options: NSString.CompareOptions.backwards) {
            return self[startIndex..<range.upperBound]
        }
        
        return ""
    }
    
    /**
    删除字符串首部和最后空格
    
    - returns: Stripped string
    */
    func removeSpaces() -> String {
        return trimmedLeft().trimmedRight()
    }
    
    /**
    删除左边和参数相同的字符
    
    - returns: Stripped string
    */
    func removeLeftSpaces(_ str:String) -> String {
        return trimmedLeft(characterSet: CharacterSet(charactersIn: str))
    }
    
    /**
    删除右边和参数相同的字符
    
    - returns: Stripped string
    */
    func removeRightSpaces(_ str:String) -> String {
        return trimmedRight(characterSet: CharacterSet(charactersIn: str))
    }
    
//    /**
//    驼峰拼写法
//    */
//    public var camelCase: String {
//        get {
//            return self.deburr().words().reduceWithIndex("") { (result, index, word) -> String in
//                let lowered = word.lowercased()
//                return result + (index > 0 ? lowered.capitalized : lowered)
//            }
//        }
//    }
//    
//    /**
//    用－把单词分开拼写法
//    */
//    public var kebabCase: String {
//        get {
//            return self.deburr().words().reduceWithIndex("", combine: { (result, index, word) -> String in
//                return result + (index > 0 ? "-" : "") + word.lowercased()
//            })
//        }
//    }
//    
//    /**
//    用_把单词分开拼写法
//    */
//    public var snakeCase: String {
//        get {
//            return self.deburr().words().reduceWithIndex("", combine: { (result, index, word) -> String in
//                return result + (index > 0 ? "_" : "") + word.lowercased()
//            })
//        }
//    }
//    
//    /**
//    用空格把单词分开
//    */
//    public var startCase: String {
//        get {
//            return self.deburr().words().reduceWithIndex("", combine: { (result, index, word) -> String in
//                return result + (index > 0 ? " " : "") + word.capitalized
//            })
//        }
//    }
    
    /**
    根据索引返回字符
    
    - i : 索引值
    - return :  根据索引返回的字符
    */
    
    public subscript(i: Int) -> Character? {
        if let char = Array(self.characters).get(i) {
            return char
        }
        return .none
    }
    
    /// 根据输入字符在字符串里找，如果找到就输出，未找到就输出nil
    ///
    /// :return 找到的字符
    public subscript(pattern: String) -> String? {
        if let range = Regex(pattern).rangeOfFirstMatch(self).toRange() {
            return self[range]
        }
        return .none
    }
    
    /// 根据范围查找字符
    ///
    /// :param range 范围
    /// :return Substring
    public subscript(range: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: range.lowerBound)
        let end = characters.index(startIndex, offsetBy: range.upperBound)
        return self.substring(with: (start ..< end))
    }
    
    /// 查找输入的字符在字符串中的位置
    ///
    /// :return start index of .None if not found
    public func indexOf(_ char: Character) -> Int? {
        return self.indexOf(char.description)
    }
    
    /// 查找输入的字符串在字符串中的位置
    ///
    /// :return start index of .None if not found
    public func indexOf(_ str: String) -> Int? {
        return self.indexOfRegex(Regex.escapeStr(str))
    }
    
    /// 根据输入的正则表达式在字符串中的查找位置
    ///
    /// :return 开始位置 如果未发现输出.None
    public func indexOfRegex(_ pattern: String) -> Int? {
        if let range = Regex(pattern).rangeOfFirstMatch(self).toRange() {
            return range.lowerBound
        }
        return .none
    }
    
    /// 根据输入的分隔符，把字符串分割成数组
    ///
    /// :return Array
    public func split(_ delimiter: Character) -> [String] {
        return self.components(separatedBy: String(delimiter))
    }
    
    /// 删除字符串前的空格
    ///
    /// :return 没有前置空格的String
    public func lstrip() -> String {
        return self["[^\\s]+.*$"]!
    }
    
    /// 删除字符串后的空格
    ///
    /// :return 没有后置空格的String
    public func rstrip() -> String {
        return self["^.*[^\\s]+"]!
    }
    
    /// 删除字符串前后的空格
    ///
    /// :return 没有前后空格的String
    public func strip() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
//    /// 字符串拆分成单词数组
//    func words() -> [String] {
//        let hasComplexWordRegex = try! NSRegularExpression(pattern: RegexHelper.hasComplexWord, options: [])
//        let wordRange = NSMakeRange(0, self.characters.count)
//        let hasComplexWord = hasComplexWordRegex.rangeOfFirstMatch(in: self, options: [], range: wordRange)
//        let wordPattern = hasComplexWord.length > 0 ? RegexHelper.complexWord : RegexHelper.basicWord
//        let wordRegex = try! NSRegularExpression(pattern: wordPattern, options: [])
//        let matches = wordRegex.matches(in: self, options: [], range: wordRange)
//        let words = matches.map { (result: NSTextCheckingResult) -> String in
//            if let range = self.rangeFromNSRange(result.range) {
//                return self.substring(with: range)
//            } else {
//                return ""
//            }
//        }
//        return words
//    }
    
    /// Strip string of accents and diacritics
    func deburr() -> String {
        let mutString = NSMutableString(string: self)
        CFStringTransform(mutString, nil, kCFStringTransformStripCombiningMarks, false)
        return mutString as String
    }
    
//    /// Converts an NSRange to a Swift friendly Range supporting Unicode
//    ///
//    /// :param nsRange the NSRange to be converted
//    /// :return A corresponding Range if possible
//    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
//
//        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
//        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
//        if let from = String.Index(from16, within: self),
//            let to = String.Index(to16, within: self) {
//                return from ..< to
//        } else {
//            return nil
//        }
//    }
    
    
}

infix operator =~

/// Regex match the string on the left with the string pattern on the right
///
/// :return true if string matches the pattern otherwise false
public func =~(str: String, pattern: String) -> Bool {
    return Regex(pattern).test(str)
}

/// Concat the string to itself n times
///
/// :return concatenated string
public func * (str: String, n: Int) -> String {
    var stringBuilder = [String]()
    n.times {
        stringBuilder.append(str)
    }
    return stringBuilder.joined(separator: "")
}

protocol StringType{
    var characters: String.CharacterView { get }
}

extension String{
    
    public func subString(_ startIndex: Int, length: Int) -> String{
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self.substring(with: (start ..< end))
    }
    
    public func indexOf(_ target: String) -> Int{
        let range = self.range(of: target)
        if let tempRange = range {
            return self.characters.distance(from: self.startIndex, to: tempRange.lowerBound)
        } else {
            return -1
        }
    }
    
    public func indexOf(_ target: String, startIndex: Int) -> Int{
        let startRange = self.characters.index(self.startIndex, offsetBy: startIndex)
        
        let range = self.range(of: target, options: NSString.CompareOptions.literal, range: (startRange ..< self.endIndex))
        
        if let range = range {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        }
        else {
            return -1
        }
    }
    
    
    
    public func isMatch(_ regex: String, options: NSRegularExpression.Options) -> Bool{
        var exp : NSRegularExpression?
        
        do{
            exp = try NSRegularExpression(pattern: regex, options: options)
            
        }catch _ as NSError{
            
        }
        
        let matchCount = exp!.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.length))
        return matchCount > 0
    }
    
    public func getMatches(_ regex: String, options: NSRegularExpression.Options) -> [NSTextCheckingResult]{
        
        var exp : NSRegularExpression?
        
        do{
            exp = try NSRegularExpression(pattern: regex, options: options)
            
        }catch _ as NSError{
            
        }
        let matches = exp!.matches(in: self, options: [], range: NSMakeRange(0, self.length))
        return matches as [NSTextCheckingResult]
    }
    
    fileprivate var vowels: [String]{
        return ["a", "e", "i", "o", "u"]
    }
    
    fileprivate var consonants: [String]{
        return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
    }
    
    public func pluralize(_ count: Int) -> String
    {
        if count == 1 {
            return self
        } else {
            let lastChar = self.subString(self.length - 1, length: 1)
            let secondToLastChar = self.subString(self.length - 2, length: 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercased() == "y" && vowels.filter({x in x == secondToLastChar}).count == 0 {
                prefix = self[0 ..< self.length - 1]
                suffix = "ies"
            } else if lastChar.lowercased() == "s" || (lastChar.lowercased() == "o" && consonants.filter({x in x == secondToLastChar}).count > 0) {
                prefix = self[0 ..< self.length]
                suffix = "es"
            } else {
                prefix = self[0 ..< self.length]
                suffix = "s"
            }
            
            return prefix + (lastChar != lastChar.uppercased() ? suffix : suffix.uppercased())
        }
    }
    
//    public func regexMatchesInString(_ regexString:String) -> [String] {
//        
//        var arr :[String] = []
//        var rang = (self.characters.indices)
//        var foundRange:Range<String.Index>?
//        
//        repeat{
//            
//            foundRange = self.range(of: regexString, options: NSString.CompareOptions.regularExpression, range: rang, locale: nil)
//            
//            if let a = foundRange {
//                arr.append(self.substring(with: a))
//                rang.lowerBound = a.upperBound
//            }
//        }
//            while foundRange != nil
//        
//        
//        return arr
//        //"Hello".regexMatchesInString("[^Hh]{1,}")
//    }
    
}


public extension String{
    
    var toInt : Int{
        return Int(self)!
    }
    
    var toInt32 : Int32{
        return Int32(self)!
    }
    
    var toInt64 : Int64{
        // 32 bit check needed
        return (Int(self) != nil) ? Int64(self)! : ((self as NSString).longLongValue)
    }
    
    var toNumber : NSNumber{
        return NSNumber(value: self.toInt as Int)
    }
    
    var toNumber_32Bit : NSNumber{
        return NSNumber(value: self.toInt32 as Int32)
    }
    
    var toNumber_64Bit : NSNumber{
        return NSNumber(value: self.toInt64 as Int64)
    }
}

//MARK: BASIC
public extension String{
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func trimNewLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func contains(_ str:String?)->Bool{
        return (self.range(of: str!) != nil) ? true : false
    }
    
    func replaceCharacterWith(_ characters: String, toSeparator: String) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: toSeparator)
        return result
    }
    
    func wipeCharacters(_ characters: String) -> String {
        return self.replaceCharacterWith(characters, toSeparator: "")
    }
    
    func replace(find findStr: String, replaceStr: String) -> String{
        return self.replacingOccurrences(of: findStr, with: replaceStr, options: NSString.CompareOptions.literal, range: nil)
    }
    
//    func splitStringWithLimit(_ delimiter:String?="", limit:Int=0) -> [String]{
//        let arr = self.components(separatedBy: (delimiter != nil ? delimiter! : ""))
//        return Array(arr[0 ..< (limit > 0 ? min(limit, arr.count) : arr.count)])
//        
//        // use : print(s.split(",", limit:2))  //->["part1","part2"]
//    }
    
    func createURL() -> URL{
        return URL(string: self)!
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        
        return result
    }
    
    /**
    检查是不是手机号
    
    - returns: true 是手机号
    */
    func isTelNumber()->Bool
    {
        let mobile = "^1+[34578]+\\d{9}"
        let newMobile = "/^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestNewmobile = NSPredicate(format: "SELF MATCHES %@",newMobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestNewmobile.evaluate(with: self)  == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /**
    验证是不是身份证号
    
    - returns: true 是身份证号
    */
    func isUserIdCard()-> Bool{
//       let isIDCard1 = "/^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$/"
//       let isIDCard2 = "/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$/"
//        let pattern = "\(isIDCard1)|\(isIDCard2)"
//        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X|x)$)"
        let partternTwo = "^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[X])$)$"
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",partternTwo)
        if(regextestcm.evaluate(with: self) == true){
            if(self == "111111111111111111"){
                
                return false
            }
            return true
        }else{
            
            return false
        }
    }
    
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func containsEmoji()->Bool{
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F:
                return true
            default:
                continue
            }
        }
        
        return false
    }
    
    
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func hasEmoji()->Bool {
        
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@",pattern)
        return pred.evaluate(with: self)
    }
    
    /// 判断是不是九宫格
    ///
    /// - Returns: true false
    func isNineKeyBoard()->Bool{
        let other : NSString = "➋➌➍➎➏➐➑➒"
        let len = self.length
        for i in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        
        return true
    }
    
    
    /**
    判断是不是英文或者数字
    */
    func isEnglishOrNumber()->Bool{
        let emailRegEx = "^[a-zA-Z0-9]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /**
     判断是不是英文
     */
    func isEnglish()->Bool{
        let emailRegEx = "^[a-zA-Z]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    /**
     判断是不是数字
     */
    func isNumber()->Bool{
        let emailRegEx = "^[0-9]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    /**
     判断是不是Double
     */
    func isDouble()->Bool{
        let emailRegEx = "^[0-9.]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    /**
    判断是不是汉字 ➋ 这种东西可能导致 某些机型不能输入汉字
    */
    func isHanZi()->Bool{
        let emailRegEx = "([\\u4e00-\\u9fa5]{1,4})|([\\u4e00-\\u9fa5]{2,9})"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    /**
     判断是不是汉字英文或者数字
     */
    func isHanZiOrEnglishOrNumber()->Bool{
        let emailRegEx = "[\\u4e00-\\u9fa5\\w]+"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: self)
    }
    
    /**
     监测对象的类型
     
     - returns: 对象类型ObjectType
     */
    func checkObjectType()-> ObjectType{
        switch self{
        case "NSArray": return .nsListType
        case "NSMutableArray": return .nsListType
        case "Array": return .nsListType
        case "NSSet": return .nsSetType
        case "NSMutableSet": return .nsSetType
        case "Set": return .nsSetType
        case "String": return .nsObjectType
        case "Dictionary": return .nsObjectType
        case "Int": return .nsObjectType
        case "Int8": return .nsObjectType
        case "Int16": return .nsObjectType
        case "Int32": return .nsObjectType
        case "Int64": return .nsObjectType
        case "Float": return .nsObjectType
        case "Double": return .nsObjectType
        case "CGFloat": return .nsObjectType
        default:
            if(self.contains("NS")){
                return .nsObjectType
            }else{
                return .unNSObjectType
            }
        }
        
    }
    
    /**
     提取字符串中的数字
     [NSCharacterSet alphanumericCharacterSet];          //所有数字和字母(大小写)
     [NSCharacterSet decimalDigitCharacterSet];          //0-9的数字
     [NSCharacterSet letterCharacterSet];                //所有字母
     [NSCharacterSet lowercaseLetterCharacterSet];       //小写字母
     [NSCharacterSet uppercaseLetterCharacterSet];       //大写字母
     [NSCharacterSet punctuationCharacterSet];           //标点符号
     [NSCharacterSet whitespaceAndNewlineCharacterSet];  //空格和换行符
     [NSCharacterSet whitespaceCharacterSet];            //空格
     - returns: 返回数字字符串
     */
    func getNumberForString()->String{
    
        let str = self as NSString
        
        let numberArr = str.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        let numberString = (numberArr as NSArray).componentsJoined(by: "")
        
        return numberString
        
    }
    
    
}

extension String {
    
    /**
     根据类名生成实例对象
     
     - returns: 实例对象
     */
    func classFromString() -> NSObject? {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            let classStringName = "\(appName).\(self)"
            let classType = NSClassFromString(classStringName) as? NSObject.Type
            if let type = classType {
                let newClass = type.init()
                return newClass
            }
        }
        return nil;
    }
    
    
}

// MARK: - 项目逻辑相关
extension String{
    
    func iconUrlIsEqualTo(_ otherUrl:String)->Bool{
        
        if(!otherUrl.contains("Time=")){ return false }
        if(!self.contains("Time=")){ return false }
        let otherArray = otherUrl.components(separatedBy: "Time=")
        let array =  self.components(separatedBy: "Time=")
        if(array[1] == otherArray[1]){ return true }
        
        return false
    }
    
    func iconUrlDivision()->String{
        
        return self
        //        if(!self.contain(subStr: "?")){ return self }
        //        let array =  self.componentsSeparatedByString("?")
        //
        //        return array[0]
    }
    
    /**
     转换成UTF8的数组
     
     - returns:
     */
    func toUInt8Map()->[UInt8]{
        
        return self.utf8.lazy.map({ $0 as UInt8 })
    }
    
    
    /// 格式化时间
    ///
    /// - Parameter type: 1 默认(1: 今天 18:19 2: 今天(08/29))
    /// - Returns: return value description
    func ProcessTheDateFormat(type : String = "1")->String{
        
        var retultStr = ""
        if self == ""{
            return retultStr
        }
        
        let nowDate = Date().toString("yyyy-MM-dd")
        let yesterDate = Date().beforeDate(1).toString("yyyy-MM-dd")
        let dayBeforeyesterDate = Date().beforeDate(2).toString("yyyy-MM-dd")
        let tomorrowData = Date().nextDate(1).toString("yyyy-MM-dd")
        let AftertomorrowDate = Date().nextDate(2).toString("yyyy-MM-dd")
        
        if(type == "1"){
            
            let tempArray = self.components(separatedBy: " ")
            let minStr = tempArray.last?.subString(0, length: 5)
            
            if (self.contains(nowDate)){
                retultStr = "今天 \(minStr ?? "")"
                return retultStr
            }
            
            if (self.contains(yesterDate)){
                retultStr = "昨天 \(minStr ?? "")"
                return retultStr
            }
            
            if (self.contains(dayBeforeyesterDate)){
                retultStr = "前天 \(minStr ?? "")"
                return retultStr
            }
            
            if (self.contains(tomorrowData)){
                retultStr = "明天 \(minStr ?? "")"
                return retultStr
            }
            
            if (self.contains(AftertomorrowDate)){
                retultStr = "后天 \(minStr ?? "")"
                return retultStr
            }

            let dataStr = (tempArray.first!).toDateTime("yyyy/MM/dd")?.toString("yyyy/MM/dd")
            retultStr = dataStr!
            
            return retultStr
        }else{
            
            let tempArray = self.components(separatedBy: " ")
            let minStr = tempArray[0]
            let dataStr = minStr.toDateTime("yyyy/MM/dd")?.toString("yyyy/MM/dd")
            let dataTimeStr = minStr.toDateTime("yyyy/MM/dd")?.toString("MM/dd")
            if (self.contains(nowDate)){
                retultStr = "今天(\(dataTimeStr ?? ""))"
                return retultStr
            }
            
            if (self.contains(yesterDate)){
                retultStr = "昨天(\(dataTimeStr ?? ""))"
                return retultStr
            }
            
            if (self.contains(dayBeforeyesterDate)){
                retultStr = "前天(\(dataTimeStr ?? ""))"
                return retultStr
            }
            
            if (self.contains(tomorrowData)){
                retultStr = "明天(\(dataTimeStr ?? ""))"
                return retultStr
            }
            
            if (self.contains(AftertomorrowDate)){
                retultStr = "后天(\(dataTimeStr ?? ""))"
                return retultStr
            }
            retultStr = dataStr!
            
            return retultStr
        }
    }
    
    
    /// 保留纪委小数
    ///
    /// - Parameter position: 位数
    /// - Returns: 字符串
    func stringKeepTwoDecimalPlaces(position:Int16)->String{
        let roundUp = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.bankers, scale: position, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let tempDecimal = NSDecimalNumber(string: self)
        let resultDecimal = tempDecimal.rounding(accordingToBehavior: roundUp)
        return resultDecimal.toString
    }
    
    /// 字符串截取小数点后面两位
    ///
    /// - Returns:
    func stringSave2()->String{
        if self.contains("."){
            if self.substringFromIndex(self.indexOf(".")).length >= 3{
                return self.substringToIndex(self.indexOf(".") + 3)
            }else{
                return self + "0"
            }
        }
        return self + ".00"
    }
}
