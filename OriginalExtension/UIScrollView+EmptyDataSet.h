//
//  UIScrollView+EmptyDataSet.h
//  DZNEmptyDataSet
//  https://github.com/dzenbot/DZNEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

@protocol DZNEmptyDataSetSource;
@protocol DZNEmptyDataSetDelegate;

/**
 A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display.
 @discussion It will work automatically, by just conforming to DZNEmptyDataSetSource, and returning the data you want to show.
 */
@interface UIScrollView (EmptyDataSet)
/**
 *  网络是否可以用
 */
@property (nonatomic, assign)BOOL networkCanUsed;

/** 空数据集数据源。 */
@property (nonatomic, weak) IBOutlet id <DZNEmptyDataSetSource> emptyDataSetSource;
/** 空数据集代理。 */
@property (nonatomic, weak) IBOutlet id <DZNEmptyDataSetDelegate> emptyDataSetDelegate;
/** 空数据集是否可见 */
@property (nonatomic, readonly, getter = isEmptyDataSetVisible) BOOL emptyDataSetVisible;

/**
 重载空数据集内容接收器。
 @调用此方法强制所有数据刷新。调用reloadData是相似的，但这方法只有空的数据加载，而不是整个表或视图的集合视图。
 */
- (void)reloadEmptyDataSet;

@end


/**
 空数据集的数据源的对象。
 @discussion The data source must adopt the DZNEmptyDataSetSource protocol. The data source is not retained. All data source methods are optional.
 */
@protocol DZNEmptyDataSetSource <NSObject>
@optional

/**
 要求标题的数据源。
 默认情况下，数据集使用固定字体样式，如果没有设置属性。如果需要不同的字体样式，返回属性字符串。
 @param ScrollView个ScrollView类通知数据源。
 @返回一个属性字符串数据集的标题，结合字体，文本颜色，文本pararaph风格，等等。
 */
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;

/**
 要求数据源数据集。
 默认情况下，数据集使用固定字体样式，如果没有设置属性。如果需要不同的字体样式，返回属性字符串。
 @param ScrollView个ScrollView类通知数据源。
 @返回一个属性字符串对数据集的描述文本，结合字体，文本颜色，文本pararaph风格，等等。
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;

/**
 要求图片的数据源。
 @param ScrollView个ScrollView类通知数据源。
 @返回数据集的图像。
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;


/**
 询问图像数据集的着色颜色的数据源。默认为nil。
 @param ScrollView一滚动视图子类对象通知数据源。
 @返回一个颜色，以着色的数据集的图像。
 */
- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView;

/**
 *  Asks the data source for the image animation of the dataset.
 *
 *  @param scrollView A scrollView subclass object informing the delegate.
 *
 *  @return image animation
 */
- (CAAnimation *) imageAnimationForEmptyDataSet:(UIScrollView *) scrollView;

/**
 Asks the data source for the title to be used for the specified button state.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for the image to be used for the specified button state.
 This method will override buttonTitleForEmptyDataSet:forState: and present the image only without any text.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An image for the dataset button imageview.
 */
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for a background image to be used for the specified button state.
 There is no default style for this call.
 
 @param scrollView A scrollView subclass informing the data source.
 @param state The state that uses the specified image. The values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for the background color of the dataset. Default is clear color.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to be applied to the dataset background view.
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a custom view to be displayed instead of the default views such as labels, imageview and button. Default is nil.
 Use this method to show an activity view indicator for loading feedback, or for complete custom empty data set.
 Returning a custom view will ignore -offsetForEmptyDataSet and -spaceHeightForEmptyDataSet configurations.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The custom view.
 */
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a offset for vertical and horizontal alignment of the content. Default is CGPointZero.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The offset for vertical and horizontal alignment.
 */
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use -verticalOffsetForEmptyDataSet:");
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for a vertical space between elements. Default is 11 pts.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The space height between elements.
 */
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView;

@end


/**
 The object that acts as the delegate of the empty datasets.
 @discussion The delegate can adopt the DZNEmptyDataSetDelegate protocol. The delegate is not retained. All delegate methods are optional.
 
 @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@protocol DZNEmptyDataSetDelegate <NSObject>
@optional

/**
 通知代理空数据集是否应在显示时淡入. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should fade in.
 */
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView;

/**
 通知 代理 是否应呈现和显示空数据集。 Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should show.
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;

/**
 是否可以点击. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset receives touch gestures.
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView;

/**
 是否滑动 Default is NO.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to be scrollable.
 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;

/**
 是否做图像动画 Default is NO.
 Make sure to return a valid CAAnimation object from imageAnimationForEmptyDataSet:
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to animate
 */
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView;

/**
 告诉委托空数据集视图已被利用。 弃用
 用这个方法可以让textfield or searchBar resignFirstResponder
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use emptyDataSet:didTapView:");

/**
 告诉代理，操作按钮被点击。弃用
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use emptyDataSet:didTapButton:");

/**
 告诉委托空数据集视图已被利用。
 用这个方法可以让textfield or searchBar resignFirstResponder
 
 @param scrollView A scrollView subclass informing the delegate.
 @param view the view tapped by the user
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;

/**
 告诉代理，操作按钮被点击。
 
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

/**
 告诉代理empty data将要出现。

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView;

/**
 告诉代理empty data已经出现。

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView;

/**
 告诉代理empty data将要消失。

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView;

/**
 告诉代理empty data消失了。
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView;

@end


@interface DZNEmptyDataSetView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;
- (void)prepareForReuse;

@end


@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) DZNEmptyDataSetView *emptyDataSetView;
@end
