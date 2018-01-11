//
//  UITableView+DZ.h
//
//  Created by 马耀 on 2017/5/11.
//  Copyright © 2017年 JNDZ. All rights reserved.
//  处理tableView没数据时状态的分类（加载中也可以）

#import "UITableView+DZ.h"
#import <objc/runtime.h>
//#import "MJRefresh.h"

@implementation UITableView (DZ)
static const BOOL loadingKey;
static const char showldReloadLodingStyleKey;
static const char reloadLodingStyleCanAutoChangeKey;
static const BOOL noShowWaitingForAnimationKey;
static const char loadedImageNameKey;
static const char descriptionTextKey;
static const char buttonTextKey;
static const char buttonNormalColorKey;
static const char buttonHighlightColorKey;
static const CGFloat dataVerticalOffsetKey;


id (^block)();
/// 因为要和swift 交互 所以swizz 方法不能写OC的
#pragma mark set Mettod
-(void)setLoading:(BOOL)loading
{
    if (self.loading == loading) {
        return;
    }
    if (loading == YES) {// 第一次的时候设置代理
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        [self reloadEmptyDataSet];
    }

    // 这个&loadingKey也可以理解成一个普通的字符串key，用这个key去内存寻址取值
    objc_setAssociatedObject(self, &loadingKey, @(loading), OBJC_ASSOCIATION_ASSIGN);
    // 一定要放在后面，因为上面的代码在设值，要设置完之后数据源的判断条件才能成立
    
    if (loading == NO) {
        [self reloadEmptyDataSet];
    }else {
//        __weak __typeof(&*self)weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (weakSelf.emptyDataSetVisible) {
////                [weakSelf reloadData];
//                weakSelf.loading = NO;
//            }
//        });
    }
}

- (void)setNoShowWaitingForAnimation:(BOOL)noShowWaitingForAnimation{
    objc_setAssociatedObject(self, &noShowWaitingForAnimationKey, @(noShowWaitingForAnimation), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setShowldReloadLodingStyle:(BOOL)noShowWaitingForAnimation{
    objc_setAssociatedObject(self, &showldReloadLodingStyleKey, @(noShowWaitingForAnimation), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setReloadLodingStyleCanAutoChange:(BOOL)reloadLodingStyleCanAutoChange{
    objc_setAssociatedObject(self, &reloadLodingStyleCanAutoChangeKey, @(reloadLodingStyleCanAutoChange), OBJC_ASSOCIATION_ASSIGN);
}

-(void)setLoadingClick:(void (^)())loadingClick
{
    objc_setAssociatedObject(self, &block, loadingClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setLoadedImageName:(NSString *)loadedImageName
{
    objc_setAssociatedObject(self, &loadedImageNameKey, loadedImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setDataVerticalOffset:(CGFloat)dataVerticalOffset
{
    objc_setAssociatedObject(self, &dataVerticalOffsetKey,@(dataVerticalOffset),OBJC_ASSOCIATION_RETAIN);// 如果是对象，请用RETAIN。坑
}

-(void)setDescriptionText:(NSString *)descriptionText
{
    objc_setAssociatedObject(self, &descriptionTextKey, descriptionText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setButtonText:(NSString *)buttonText
{
    objc_setAssociatedObject(self, &buttonTextKey, buttonText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setButtonNormalColor:(UIColor *)buttonNormalColor
{
    objc_setAssociatedObject(self, &buttonNormalColorKey, buttonNormalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setButtonHighlightColor:(UIColor *)buttonHighlightColor
{
    objc_setAssociatedObject(self, &buttonHighlightColorKey, buttonHighlightColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)DZLoading:(loadingBlock)block
{
    if (self.loadingClick) {
        block = self.loadingClick;
    }
    self.loadingClick = block;
}

#pragma mark get Mettod
-(BOOL)loading
{
    // 注意，取出的是一个对象，不能直接返回
    id tmp = objc_getAssociatedObject(self, &loadingKey);
    NSNumber *number = tmp;
    return number.unsignedIntegerValue;
}

-(BOOL)noShowWaitingForAnimation
{
    // 注意，取出的是一个对象，不能直接返回
    id tmp = objc_getAssociatedObject(self, &noShowWaitingForAnimationKey);
    NSNumber *number = tmp;
    return number.unsignedIntegerValue;
}

-(BOOL)showldReloadLodingStyle
{
    // 注意，取出的是一个对象，不能直接返回
    id tmp = objc_getAssociatedObject(self, &showldReloadLodingStyleKey);
    NSNumber *number = tmp;
    return number.unsignedIntegerValue;
}

-(BOOL)reloadLodingStyleCanAutoChange
{
    // 注意，取出的是一个对象，不能直接返回
    id tmp = objc_getAssociatedObject(self, &reloadLodingStyleCanAutoChangeKey);
    NSNumber *number = tmp;
    return number.unsignedIntegerValue;
}

-(void (^)())loadingClick
{
    self.loading = YES;
    return objc_getAssociatedObject(self, &block);
}

-(NSString *)loadedImageName
{
    return objc_getAssociatedObject(self, &loadedImageNameKey);
}

-(CGFloat)dataVerticalOffset
{
    id temp = objc_getAssociatedObject(self, &dataVerticalOffsetKey);
    NSNumber *number = temp;
    return number.floatValue;
}

-(NSString *)descriptionText
{
    return objc_getAssociatedObject(self, &descriptionTextKey);
}

-(NSString *)buttonText
{
    return objc_getAssociatedObject(self, &buttonTextKey);
}

-(UIColor *)buttonNormalColor
{
    return objc_getAssociatedObject(self, &buttonNormalColorKey);
}

-(UIColor *)buttonHighlightColor
{
    return objc_getAssociatedObject(self, &buttonHighlightColorKey);
}

#pragma mark - DZNEmptyDataSetSource
// 返回一个自定义的view（显示的优先级最高，其实在最上面）
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.noShowWaitingForAnimation) {
        
        return nil;
    }
    
    if (self.loading) {
        UIView *v = [[UIView alloc]init];
        v.tag = 100123;
        UIImageView * imageView =  [[UIImageView alloc]init];
        imageView.animationImages = @[[UIImage imageNamed:@"dropdown_anim__0001"],[UIImage imageNamed:@"dropdown_anim__0002"],[UIImage imageNamed:@"dropdown_anim__0003"],[UIImage imageNamed:@"dropdown_anim__0004"]];
        imageView.animationDuration = 1;
        [imageView startAnimating];
        [v addSubview:imageView];
        
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //子view的中心横坐标等于父view的中心横坐标
        NSLayoutConstraint *constrant1 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:v attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        //子view的中心纵坐标等于父view的中心纵坐标
        NSLayoutConstraint *constrant2 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:v attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-40];
        //子view的宽度为125
        NSLayoutConstraint *constrant3 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:185.0];
        //子view的高度为125
        NSLayoutConstraint *constrant4 = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:185.0];
        
        //把约束添加到父视图上
        NSArray *array = [NSArray arrayWithObjects:constrant1, constrant2, constrant3, constrant4, nil];
        [v addConstraints:array];
        
        UILabel * label = [[UILabel alloc]init];
        [v addSubview:label];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        label.text = @"数据加载中，请稍候...";
        [label setNumberOfLines:0];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor lightGrayColor]];
        label.font = [UIFont systemFontOfSize:15];
        //子view的中心横坐标等于父view的中心横坐标
        NSLayoutConstraint *constrant5 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:v attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        //子view的中心纵坐标等于父view的中心纵坐标
        NSLayoutConstraint * constrant6 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        //子view的宽度为125
        NSLayoutConstraint *constrant7 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:185.0];
        //子view的高度为125
        NSLayoutConstraint *constrant8 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
        
        //把约束添加到父视图上
        NSArray *array2 = [NSArray arrayWithObjects:constrant5, constrant6, constrant7, constrant8, nil];
        [v addConstraints:array2];
        
        return v;
//        // 可以是菊花 也可以是其他的
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [activityView startAnimating];
//        return activityView;
    }else {
        // 不是加载状态 就不用显示了
        return nil;
    }
}
// 返回一张空状态的图片在文字上面的
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.noShowWaitingForAnimation) {
    
        return nil;
    }
    
    if (self.loading) {
        return nil;
    }
    else {
        NSString *imageName = @"";
        if (self.loadedImageName) {
            imageName = self.loadedImageName;
        }else if (!self.networkCanUsed){
            imageName = @"TeldCarImg.bundle/icon_no_network";
        }else {
            imageName = @"TeldCarImg.bundle/icon_no_goods";
        }
        return [UIImage imageNamed:imageName];
    }
}

// 返回空状态显示title文字，可以返回富文本 标题啦
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    if (self.loading) {
//        return nil;
//    }else {
//        
//        NSString *text = @"没有数据";
//        
//        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//        paragraph.alignment = NSTextAlignmentCenter;
//        
//        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
//                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
//                                     NSParagraphStyleAttributeName: paragraph};
//        
//        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//    }
//}

// 空状态下的文字详情 标题描述啦
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.noShowWaitingForAnimation) {
        
        return nil;
    }
    
    if (self.loading) {
        return nil;
    }else {
        
        NSString *text = @"";
        if (!self.networkCanUsed){
            text = @"没有网络！您可以尝试重新获取";
        }else {
            text = @"很抱歉！没有数据了~";
        }
        if (self.descriptionText) {
            text = self.descriptionText;
        }
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}

// 返回最下面按钮上的文字 按钮上的文字啦
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.noShowWaitingForAnimation) {
        
        return nil;
    }
    
    if (self.loading) {
        return nil;
    }else if(self.networkCanUsed){
    
        return nil;
    }else {
        UIColor *textColor = nil;
        // 某种状态下的颜色
        UIColor *colorOne = [UIColor colorWithRed:253/255.0f green:120/255.0f blue:76/255.0f alpha:1];
        UIColor *colorTow = [UIColor colorWithRed:247/255.0f green:188/255.0f blue:169/255.0f alpha:1];
        // 判断外部是否有设置
        colorOne = self.buttonNormalColor ? self.buttonNormalColor : colorOne;
        colorTow = self.buttonHighlightColor ? self.buttonHighlightColor : colorTow;
        textColor = state == UIControlStateNormal ? colorOne : colorTow;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName: textColor};

        return [[NSAttributedString alloc] initWithString:self.buttonText ? self.buttonText : @"点击刷新" attributes:attributes];
    }
}

// 返回视图的垂直位置（调整整个视图的垂直位置）
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.dataVerticalOffset != 0) {
        return self.dataVerticalOffset;
    }
    return 0.0;
}

#pragma mark - DZNEmptyDataSetDelegate Methods
// 返回是否显示空状态的所有组件，默认:YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
// 返回是否允许交互，默认:YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    // 只有非加载状态能交互
    return !self.loading;
}
// 返回是否允许滚动，默认:YES
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
// 返回是否允许空状态下的图片进行动画，默认:NO
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return YES;
}
//  点击空状态下的view会调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    // 暂时不响应
//    if (self.loadingClick) {
//        self.loadingClick();
//        [self reloadEmptyDataSet];
//    }
}
// 点击空状态下的按钮会调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (self.noShowWaitingForAnimation) {
        
        return;
    }
    
    if (self.loadingClick && !self.networkCanUsed) {
        self.loadingClick();
        [self reloadEmptyDataSet];
    }
}

-(void)goToLodingStyle{
    self.loading = YES;
    self.reloadLodingStyleCanAutoChange = YES;
    [self reloadEmptyDataSet];
}
@end
