//
//  MyTableViewCellExtension.swift
//  demo
//
//  Created by 东正 on 16/2/3.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//如果由于某些原因无法自动计算UITableViewCell的高度，可调用此方法my_cellHeight 
//但是要注意的是 一定要设置my_lastViewInCell最下面的视图

import Foundation
import UIKit
//import SnapKit

private var __my_lastViewInCellKey  = "__my_lastViewInCellKey"
private var __my_bottomOffsetToCell = "__my_bottomOffsetToCell"
private let __currentVersion = "1.0"

extension UITableViewCell {
    /// 所指定的距离cell底部较近的参考视图，必须指定，若不指定则会assert失败
    public var my_lastViewInCell: UIView? {
        get {
            let lastView = objc_getAssociatedObject(self, &__my_lastViewInCellKey);
            return lastView as? UIView
        }
        
        set {
            objc_setAssociatedObject(self,
                &__my_lastViewInCellKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 可不指定，若不指定则使用默认值0
    public var my_bottomOffsetToCell: CGFloat? {
        get {
            let offset = objc_getAssociatedObject(self, &__my_bottomOffsetToCell);
            return offset as? CGFloat
        }
        
        set {
            objc_setAssociatedObject(self,
                &__my_bottomOffsetToCell,
                newValue,
                .OBJC_ASSOCIATION_ASSIGN);
        }
    }
    
    /**
    唯一的类方法，用于计算行高
    
    - parameter indexPath:	index path
    - parameter config:		在config中调用配置数据方法等
    
    - returns: 所计算得到的行高
    */
    public class func my_cellHeight(forIndexPath indexPath: IndexPath, config: ((_ cell: UITableViewCell) -> Void)?) -> CGFloat {
        let cell = self.init(style: .default, reuseIdentifier: nil)
        
        if let block = config {
            block(cell);
        }

        return cell.my_calculateCellHeight(forIndexPath: indexPath)
    }
    
    // MARK: Private
    fileprivate func my_calculateCellHeight(forIndexPath indexPath: IndexPath) -> CGFloat {
        assert(self.my_lastViewInCell != nil, "my_lastViewInCell property can't be nil")
        
        layoutIfNeeded()
        
        var height = self.my_lastViewInCell!.frame.origin.y + self.my_lastViewInCell!.frame.size.height;
        height += self.my_bottomOffsetToCell ?? 0.0
        
        return height
    }
}

