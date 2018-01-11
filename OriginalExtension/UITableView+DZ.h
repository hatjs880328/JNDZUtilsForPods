//
//  UITableView+DZ.h
//
//  Created by 马耀 on 2017/5/11.
//  Copyright © 2017年 JNDZ. All rights reserved.
//  处理tableView没数据时状态的分类（加载中也可以）

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

typedef void (^loadingBlock)();
@interface UITableView (DZ)<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/**
 *  是否在加载 true:转菊花 or flase:立即空状态界面
 *  在加载数据前设置为YES(必需)，随后根据数据调整为NO(可选)
 */
@property (nonatomic, assign)BOOL loading;

/**
 *  是否需要加载 Loding 一开始是false 在调用一次reloadData 之后就成了true
 *
 */
@property (nonatomic, assign)BOOL showldReloadLodingStyle;

/**
 *  刷新状态是否自动变成无数据状态 默认NO 自动变。
 *
 */
@property (nonatomic, assign)BOOL reloadLodingStyleCanAutoChange;

/**
 是否需要加载动画 YES  不需要加载动画  NO 需要加载动画 默认NO
 */
@property (nonatomic, assign)BOOL noShowWaitingForAnimation;

/**
 *  不加载状态下的图片(loading = NO)
 *  PS:空状态下显示图片
 */
@property (nonatomic, copy)NSString *loadedImageName;
@property (nonatomic, copy)NSString *descriptionText;// 空状态下的文字详情
/**
 *  刷新按钮文字
 */
@property (nonatomic, copy)NSString *buttonText;
@property (nonatomic,strong) UIColor *buttonNormalColor;// 按钮Normal状态下文字颜色
@property (nonatomic,strong) UIColor *buttonHighlightColor;// 按钮Highlight状态下文字颜色

/**
 *  视图的垂直位置
 *  tableView中心点为基准点,(基准点＝0)
 */
@property (nonatomic, assign)CGFloat dataVerticalOffset;

@property(nonatomic,copy)loadingBlock loadingClick;// 点击回调block的属性
/**
 *  点击回调方法：跟loadingClick属性效果一样的
 *
 *  @param block 要执行的操作
 */
-(void)DZLoading:(loadingBlock)block;

/**
 从有数据状态/无数据状态，返回刷新状态。需要注意的是：有数据状态，调用此方法前（1）要把数据源清空,清空完毕后不需要调用 reloadData 方法，（2）直接调用goToLodingStyle方法即可，（3）调用完毕此方法之后如果调用reloadData 方法，tableView将变成无数据状态，所以不要立即调用reloadData。
 */
-(void)goToLodingStyle;

@end
