//
//  MyNSUserDefaultsExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/22.
//  Copyright © 2015年 东正. All rights reserved.
//

import Foundation
import UIKit


extension UserDefaults{
    
    public func setColor(_ color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
    
    public func colorForKey(_ key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
}



