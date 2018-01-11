//
//  MyDevice.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/22.
//  Copyright © 2015年 东正. All rights reserved.
//

import Foundation
import UIKit

struct Device {
    
    // MARK: - 单利
    ///当前设备
    static var CurrentDevice: UIDevice {
        
        struct Singleton {
            static let device = UIDevice.current
        }
        return Singleton.device
    }
    ///当前设备版本
    static var CurrentDeviceVersion: Float {
        
        struct Singleton {
            static let version = Float(UIDevice.current.systemVersion.components(separatedBy: ".")[0])
        }
        return Singleton.version!
    }
    ///当前设备高度
    static var CurrentDeviceHeight: CGFloat {
        struct Singleton {
            static let height = UIScreen.main.bounds.size.height
        }
        return Singleton.height
    }
    // MARK: - 设备
    ///手机还是pad  
    ///return iPhone or iPad or Not iPhone no iPad
    static var PHONE_OR_PAD: String {
        if isPhone() {
            return "iPhone"
        } else if isPad() {
            return "iPad"
        }
        return "Not iPhone no iPad"
    }
    
    ///Debug还是Release
    ///return Debug or Release
    static var DEBUG_OR_RELEASE: String {
        #if DEBUG
            return "Debug"
            #else
            return "Release"
        #endif
    }
    
    ///Device还是Simulator
    ///return Simulator or Device
    static var SIMULATOR_OR_DEVICE: String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return "Simulator"
            #else
            return "Device"
        #endif
    }
    
    
    static func isPhone() -> Bool {
        return CurrentDevice.userInterfaceIdiom == .phone
    }
    
    static func isPad() -> Bool {
        return CurrentDevice.userInterfaceIdiom == .pad
    }
    
    static func isDebug() -> Bool {
        return DEBUG_OR_RELEASE == "Debug"
    }
    
    static func isRelease() -> Bool {
        return DEBUG_OR_RELEASE == "Release"
    }
    
    static func isSimulator() -> Bool {
        return SIMULATOR_OR_DEVICE == "Simulator"
    }
    
    static func isDevice() -> Bool {
        return SIMULATOR_OR_DEVICE == "Device"
    }
    
    // MARK: - 设备版本检查
    
    enum Versions: Float {
        case five = 5.0
        case six = 6.0
        case seven = 7.0
        case eight = 8.0
        case nine = 9.0
    }
    
    ///检查是不是某版本
    static func isVersion(_ version: Versions) -> Bool {
        return CurrentDeviceVersion >= version.rawValue && CurrentDeviceVersion < (version.rawValue + 1.0)
    }
    ///检查是不是某版本之后
    static func isVersionOrLater(_ version: Versions) -> Bool {
        return CurrentDeviceVersion >= version.rawValue
    }
    ///检查是不是某版本之前
    static func isVersionOrEarlier(_ version: Versions) -> Bool {
        return CurrentDeviceVersion < (version.rawValue + 1.0)
    }
    ///当然系统版本
    static var CURRENT_VERSION: String {
        return "\(CurrentDeviceVersion)"
    }
    
    // MARK: 检查 iOS 5
    
    static func IS_OS_5() -> Bool {
        return isVersion(.five)
    }
    
    static func IS_OS_5_OR_LATER() -> Bool {
        return isVersionOrLater(.five)
    }
    
    static func IS_OS_5_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.five)
    }
    
    // MARK: 检查 iOS 6
    
    static func IS_OS_6() -> Bool {
        return isVersion(.six)
    }
    
    static func IS_OS_6_OR_LATER() -> Bool {
        return isVersionOrLater(.six)
    }
    
    static func IS_OS_6_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.six)
    }
    
    // MARK: 检查 iOS 7
    
    static func IS_OS_7() -> Bool {
        return isVersion(.seven)
    }
    
    static func IS_OS_7_OR_LATER() -> Bool {
        return isVersionOrLater(.seven)
    }
    
    static func IS_OS_7_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.seven)
    }
    
    // MARK: 检查 iOS 8
    
    static func IS_OS_8() -> Bool {
        return isVersion(.eight)
    }
    
    static func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(.eight)
    }
    
    static func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eight)
    }
    
    // MARK: 检查 iOS 9
    
    static func IS_OS_9() -> Bool {
        return isVersion(.nine)
    }
    
    static func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(.nine)
    }
    
    static func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.nine)
    }
    
    // MARK: - 检查设备高度
    
    enum Heights: CGFloat {
        case inches_3_5 = 480
        case inches_4 = 568
        case inches_4_7 = 667
        case inches_5_5 = 736
        case inches_5_8 = 812
    }
    
    ///判断size 是否匹配
    static func isSize(_ height: Heights) -> Bool {
        return CurrentDeviceHeight == height.rawValue
    }
    
    static func isSizeOrLarger(_ height: Heights) -> Bool {
        return CurrentDeviceHeight >= height.rawValue
    }
    
    static func isSizeOrSmaller(_ height: Heights) -> Bool {
        return CurrentDeviceHeight <= height.rawValue
    }
    
    static var CURRENT_SIZE: String {
        if IS_3_5_INCHES() {
            return "3.5 Inches"
        } else if IS_4_INCHES() {
            return "4 Inches"
        } else if IS_4_7_INCHES() {
            return "4.7 Inches"
        } else if IS_5_5_INCHES() {
            return "5.5 Inches"
        }
        return "\(CurrentDeviceHeight) Points"
    }
    
    // MARK: 检查是不是IphoneX
    
    static func isIphoneX() -> Bool {
        
        return UIScreen.main.bounds.height.isEqual(to: 1218) &&  UIScreen.main.bounds.width.isEqual(to: 375)
    }
    
    // MARK: 检查是不是视网膜屏幕
    
    static func IS_RETINA() -> Bool {
        return UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))
    }
    
    // MARK: 3.5 Inch Checks
    
    static func IS_3_5_INCHES() -> Bool {
        return isPhone() && isSize(.inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.inches_3_5)
    }
    
    // MARK: 4 Inch Checks
    
    static func IS_4_INCHES() -> Bool {
        return isPhone() && isSize(.inches_4)
    }
    
    static func IS_4_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_4)
    }
    
    static func IS_4_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.inches_4)
    }
    
    // MARK: 4.7 Inch Checks
    
    static func IS_4_7_INCHES() -> Bool {
        return isPhone() && isSize(.inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_4_7)
    }
    
    // MARK: 5.5 Inch Checks
    
    static func IS_5_5_INCHES() -> Bool {
        return isPhone() && isSize(.inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.inches_5_5)
    }
    
    // MARK: - 国际化
    ///当然所处区域
    static var CURRENT_REGION: String {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
    }
}

public extension Bundle {
    
    var applicationVersionNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    /// 工程名称
    var appBundleProjectName: String {
        
        if let version = Bundle.main.infoDictionary?[String(kCFBundleExecutableKey)] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    var applicationBuildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
    
    var BundleID: String {
        if let build = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
