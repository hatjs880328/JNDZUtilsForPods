//
//  PeopleSettingTableViewCell.swift
//  FSZCItem
//
//  Created by 东正 on 15/12/28.
//  Copyright © 2015年 Mrshan. All rights reserved.
//个人中心 列表cell

import UIKit
import SnapKit

class CustomMoreTabVCell: UITableViewCell {
    //图片
    var titleIcon: UIImageView!
    //文字
    var titletext: UILabel!
    var sizeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleIcon = UIImageView()
        self.addSubview(titleIcon)
        titleIcon.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(12.5)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        titletext = UILabel()
        self.addSubview(titletext)
        titletext.font = UIFont(name: "", size: 12)
        titletext.snp.makeConstraints { (make) in
            make.left.equalTo(titleIcon.snp.right).offset(15)
            make.top.equalTo(10)
            make.right.equalTo(-5)
            make.height.equalTo(20)
        }
    }
    
    /// 设置信息
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - titleInfo: title
    func setInfo(image:UIImage,titleInfo:String) {
        self.titletext.text = titleInfo
        self.titleIcon.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
