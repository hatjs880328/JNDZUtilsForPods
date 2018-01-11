////
////  MyImageViewExtension.swift
////  FSZCItem
////
////  Created by 马耀 on 16/5/3.
////  Copyright © 2016年 Mrshan. All rights reserved.
////
//
import UIKit
//import Foundation
//import SDWebImage
//

// MARK: - 添加 网络获取图片的方法
extension UIImageView {
    func sd_Setimage(with url:URL,defaultImage:UIImage?,completed:@escaping ()->Void) {
        self.image = defaultImage
        var imageData: Data = Data()
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: { 
            do{
                try imageData = Data(contentsOf: url)
            }catch {
            }
        }) {
            self.image = UIImage(data: imageData)
            completed()
        }
    }
}
///// 扩展图比缩略图多的名称
//let bigImageName = "Big"
//extension UIImageView{
//    
//    /**
//     利用SDWebImage 根据网络不同加载不同的图片
//     
//     - parameter imageName: 图片名称
//     */
//    func setImageWithSDWebImage(_ imageName:String){
//        
//        let oldImageBig = SDImageCache.shared().imageFromDiskCacheForKey(imageName + "\(bigImageName)")
//        if((oldImageBig) != nil){
//            self.image = oldImageBig
//        }else{
//            let reach =  Reachability.reachabilityForInternetConnection()
//            let status = reach.currentReachabilityStatus()
//            if(status == ReachableViaWiFi){
//                self.sd_setHighlightedImageWithURL(URL(string: imageName + "\(bigImageName)"))
//            }else if(status == ReachableViaWWAN){
////                //     用户的配置项假设利用NSUserDefaults存储到了沙盒中
////                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "alwaysDownloadOriginalImage")
////                NSUserDefaults.standardUserDefaults().synchronize()
////               //从沙盒中读取用户的配置项：在3G\4G环境是否仍然下载原图
////                let alwaysDownloadOriginalImage = NSUserDefaults.standardUserDefaults().boolForKey("alwaysDownloadOriginalImage")
////                if(alwaysDownloadOriginalImage){
//                self.sd_setImageWithURL(URL(string: imageName + "\(bigImageName)"))
////                }else{
//                self.sd_setImageWithURL(URL(string: imageName))
////                }
//            }else{
//                let oldImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(imageName)
//                if(oldImage != nil){
//                    self.sd_setImageWithURL(URL(string: imageName))
//                }else{
//                    // 无缓存 无网络
//                }
//            }
//        }
//    }
//    
//    /**
//     利用SDWebImage 根据网络不同加载不同的图片
//     
//     - parameter imageName: 图片名称
//     - parameter placeholderImage: 替换图片
//     */
//    func setImageWithSDWebImage(_ imageName:String , placeholderImage : String){
//        let oldImageBig = SDImageCache.sharedImageCache().imageFromDiskCache(forKey: imageName + "\(bigImageName)")
//        if((oldImageBig) != nil){
//            self.image = oldImageBig
//        }else{
//            let reach =  Reachability.reachabilityForInternetConnection()
//            let status = reach.currentReachabilityStatus()
//            if(status == ReachableViaWiFi){
//                self.sd_setImageWithURL(URL(string: imageName + "\(bigImageName)"), placeholderImage: UIImage(named: placeholderImage))
//            }else if(status == ReachableViaWWAN){
//                //                //用户的配置项假设利用NSUserDefaults存储到了沙盒中
//                //                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "alwaysDownloadOriginalImage")
//                //                NSUserDefaults.standardUserDefaults().synchronize()
//                //               //从沙盒中读取用户的配置项：在3G\4G环境是否仍然下载原图
//                //                let alwaysDownloadOriginalImage = NSUserDefaults.standardUserDefaults().boolForKey("alwaysDownloadOriginalImage")
//                //                if(alwaysDownloadOriginalImage){
////                self.sd_setImageWithURL(NSURL(string: imageName + "\(bigImageName)"), placeholderImage: UIImage(named: placeholderImage))
//                //                }else{
//                self.sd_setImageWithURL(URL(string: imageName), placeholderImage: UIImage(named: placeholderImage))
//                //                }
//            }else{
//                let oldImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(imageName)
//                if(oldImage != nil){
//                    self.sd_setImageWithURL(URL(string: imageName), placeholderImage: UIImage(named: placeholderImage))
//                }else{
//                    // 无缓存 无网络
//                    self.sd_setImageWithURL(nil, placeholderImage: UIImage(named: placeholderImage))
//                }
//            }
//        }
//    }
//    
//    /**
//     利用SDWebImage 根据网络不同加载不同的图片
//     
//     - parameter imageName: 图片名称
//     - parameter placeholderImage: 替换图片
//     - parameter completed:        回调
//     */
//    func setImageWithSDWebImage(_ imageName:String , placeholderImage : String , completed:SDWebImageCompletionBlock){
//        let oldImageBig = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(imageName + "\(bigImageName)")
//        if((oldImageBig) != nil){
//            self.image = oldImageBig
//        }else{
//            let reach =  Reachability.reachabilityForInternetConnection()
//            let status = reach.currentReachabilityStatus()
//            if(status == ReachableViaWiFi){
//                self.sd_setImageWithURL(URL(string: imageName + "\(bigImageName)"), placeholderImage: UIImage(named: placeholderImage), completed: { (image, error, SDImageCacheType, url) -> Void in
//                    completed(image, error, SDImageCacheType, url)
//                })
//            }else if(status == ReachableViaWWAN){
//                //                //用户的配置项假设利用NSUserDefaults存储到了沙盒中
//                //                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "alwaysDownloadOriginalImage")
//                //                NSUserDefaults.standardUserDefaults().synchronize()
//                //               //从沙盒中读取用户的配置项：在3G\4G环境是否仍然下载原图
//                //                let alwaysDownloadOriginalImage = NSUserDefaults.standardUserDefaults().boolForKey("alwaysDownloadOriginalImage")
//                //                if(alwaysDownloadOriginalImage){
////                self.sd_setImageWithURL(NSURL(string: imageName + "\(bigImageName)"), placeholderImage: UIImage(named: placeholderImage), completed: { (image, error, SDImageCacheType, url) -> Void in
////                    completed(image, error, SDImageCacheType, url)
////                })
//                //                }else{
//                self.sd_setImageWithURL(URL(string: imageName), placeholderImage: UIImage(named: placeholderImage), completed: { (image, error, SDImageCacheType, url) -> Void in
//                    completed(image, error, SDImageCacheType, url)
//                })
//                //                }
//            }else{
//                let oldImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(imageName)
//                if(oldImage != nil){
//                    self.sd_setImageWithURL(URL(string: imageName ), placeholderImage: UIImage(named: placeholderImage), completed: { (image, error, SDImageCacheType, url) -> Void in
//                        completed(image, error, SDImageCacheType, url)
//                    })
//                }else{
//                    // 无缓存 无网络
//                    self.sd_setImageWithURL(nil, placeholderImage: UIImage(named: placeholderImage), completed: { (image, error, SDImageCacheType, url) -> Void in
//                        completed(image, error, SDImageCacheType, url)
//                    })
//                }
//            }
//        }
//    }
//}
