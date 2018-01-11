//
//  DZCarDetialTableView.swift
//  FSZCItem
//
//  Created by apple on 2016/11/16.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import UIKit
import SnapKit

public protocol MoreTableProtocol:NSObjectProtocol {
    func progress(index:Int)
}

/// 自定义弹出tableview ----使用方式：  只要定义他的origin即可，也可以受用snp定义他的 origin---然后顺序添加闭包到tapactions数组,如果要用 snp布局，则需要设置 width = 130  &  height = 30 + 40 * datalist.count
public class MoreTableView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    //文字列表
    var dataListName = NSMutableArray()
    //图片列表
    var dataListImage = NSMutableArray()
    //背景图片
    var backGroundImageView = UIImageView()
    //当前也的tableview
    var myTableView:UITableView!
    //遮蔽层
    var bigBGGrayView = UIView()
    //处理事件代理方法
    weak var del:MoreTableProtocol?
    
    /// 使用方式：只要定义他的origin即可，也可以受用snp定义他的 origin---然后顺序添加闭包到tapactions数组,如果要用 snp布局，则需要设置 width = 130  &  height = 30 + 40 * datalist.count
    ///
    /// - Parameters:
    ///   - frame: 无意义
    ///   - dataList: 文字数组
    ///   - imageList: 图片名字数组
    public init(frame: CGRect,dataList:NSMutableArray,imageList:NSMutableArray) {
        super.init(frame: frame)
        
        self.dataListImage = imageList
        self.dataListName = dataList
        self.frame.origin = CGPoint(x: 0, y: 0)
        //设置背景图片的 size
        let heightI = 15 + 15 + 40 * dataList.count
        self.frame.size = CGSize(width: 130, height: heightI)
        let aks = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        let ak = UIImage(named: "More_TableB@2x")?.resizableImage(withCapInsets: aks, resizingMode: .stretch)
        backGroundImageView.image = ak
        self.addSubview(backGroundImageView)
        backGroundImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        myTableView = UITableView(frame: CGRect.zero)
        self.addSubview(myTableView)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.isScrollEnabled = false
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        myTableView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(17)
            make.bottom.equalTo(-15)
            make.right.equalTo(-10)
        }
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomMoreTabVCell(style: UITableViewCellStyle.default, reuseIdentifier: "noreuse")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let line = UIView()
        line.backgroundColor = UIColor.gray
        cell.addSubview(line)
        line.snp.makeConstraints({ (make) -> Void in
            make.bottom.equalTo(0)
            make.right.equalTo(-10)
            make.height.equalTo(0.5)
            make.left.equalTo(35)
        })
        cell.setInfo(image: UIImage(named:"\(dataListImage[indexPath.row])")!, titleInfo: "\(dataListName[indexPath.row])")
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(!HTTPRequestWithAlamofire.AnalyzeNetWork()){
//            DZAlertView.sharedInstance.show(DZAlertViewType.blackViewAndClickDisappear, contentType: DZAlertContentViewType.warning, message: [MessageCloud.netWorkNotCanUse])
//            return
//        }
        //执行每个cell的点击事件
        //self.tapActions?[indexPath.row]()
        del?.progress(index: indexPath.row)
        //隐藏这个TABLE
        hidenSelf()
    }
    
    /**
     显示自己--添加一个遮蔽层
     */
    func showSelf(){
        if self.superview != nil {
            bigBGGrayView.isHidden = false
            bigBGGrayView.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.keyWindow!.bounds.width, height: UIApplication.shared.keyWindow!.bounds.height - 64)
            bigBGGrayView.alpha = 0.3
            bigBGGrayView.backgroundColor = UIColor.black
            bigBGGrayView.tapActionsGesture({ [weak self] in
                self?.hidenSelf()
            })
            self.superview?.insertSubview(bigBGGrayView, belowSubview: self)
        }
        self.alpha = 1
        self.isHidden = false
        self.transform = CGAffineTransform.identity
        myTableView.isHidden  = false
        myTableView.alpha = 1
    }
    
    /**
     隐藏自己
     */
    func hidenSelf(){
        UIView.animate(withDuration: 0.3, animations: {[weak self]Void in
            self?.bigBGGrayView.isHidden = true
            self?.alpha = 0
        }) { (BOOLINFO) in
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
