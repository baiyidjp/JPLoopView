//
//  JPLoopView.h
//  JPLoopViewDemo
//
//  Created by tztddong on 2016/10/31.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLoopCellModel.h"

typedef NS_ENUM(NSInteger, JPLoopViewPageControlAliment) {
    JPLoopViewPageControlAlimentNone,//隐藏分页
    JPLoopViewPageControlAlimentLeft,
    JPLoopViewPageControlAlimentCenter,
    JPLoopViewPageControlAlimentRight
};


@class JPLoopView;
@protocol JPLoopViewDelegate <NSObject>

@optional
//* 点击图片的代理方法 */
- (void)didSelectItem:(JPLoopView *)loopView index:(NSInteger)index;
//* 点击图片的代理方法 */
- (void)didSelectItem:(JPLoopView *)loopView index:(NSInteger)index currentImageView:(UIImageView *)imageView;

//手指开始滑动
- (void)loopViewWillBeginDragging;
//手指结束滑动
- (void)loopViewDidEndDragging;

@end

@interface JPLoopView : UIView

@property(nonatomic,weak)id<JPLoopViewDelegate> delegate;


/**
 类方法创建轮播图

 @param frame 布局
 @return JPLoopView
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame;

/**
 创建一个轮播图
 
 @param frame 布局
 @param delegate 代理
 @return JPLoopView
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<JPLoopViewDelegate>)delegate;

/**
 创建一个轮播图

 @param frame frame description
 @param placeholderImage placeholderImage description
 @return return value description
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage;

/**
 创建一个轮播图

 @param frame 布局
 @param delegate 代理
 @param placeholderImage 占位图(可为nil)
 @return JPLoopView
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<JPLoopViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;


/**
 刷新轮播图数据(只有图片没有文本)

 @param loopImageArray 图片资源(建议[NSString] NSURL也支持)
 */
- (void)setLoopImageArray:(NSArray *)loopImageArray;

/**
 刷新轮播图数据(带有文本)

 @param loopImageArray 图片资源(建议[NSString] NSURL也支持)
 @param loopTitleArray 文本资源(建议[NSString])
 */
- (void)setLoopImageArray:(NSArray *)loopImageArray loopTitleArray:(NSArray *)loopTitleArray;

/**
 设置是否可以滚动轮播图

 @param canScroll canScroll description
 */
- (void)setLoopViewCanScroll:(BOOL)canScroll;

/**
 启动定时器
 */
- (void)startTimer;

/**
 停止定时器
 */
- (void)stopTimer;

/*********************轮播相关***********************/

/** loopViewBackgroundColor */
@property(nonatomic,strong) UIColor *loopViewBackgroundColor;

/** placeholderImage 未加载图片的占位图 */
@property(nonatomic,strong) UIImage *placeholderImage;

/** pageAliment 分页控件的位置 默认center */
@property(nonatomic,assign) JPLoopViewPageControlAliment pageControlAliment;

/** currentPageIndicatorTintColor 当前选中的颜色 */
@property(nonatomic,strong) UIColor *currentPageIndicatorTintColor;

/** currentPageIndicatorImage 当前图片 默认nil */
@property(nonatomic,strong) UIImage *currentPageIndicatorImage;

/** pageIndicatorImage 未选中的图片 默认nil */
@property(nonatomic,strong) UIImage *pageIndicatorImage;

/** pageIndicatorTintColor 未选中的颜色 */
@property(nonatomic,strong) UIColor *pageIndicatorTintColor;

/** pageIndicatorSpaing 分页控件小控件间距 默认5 */
@property(nonatomic,assign) CGFloat pageIndicatorSpaing;

/** currentPageIndicatorSize 分页控件的当前选中的控件的size 默认{6,6} */
@property(nonatomic,assign) CGSize currentPageIndicatorSize;

/** pageIndicatorSize 分页控件当前未选中的控件的size 默认{6,6} */
@property(nonatomic,assign) CGSize pageIndicatorSize;

/** userInteractionEnabled 分页控件是否可以点击 默认NO */
@property(nonatomic,assign) BOOL pageControlEnabled;

/** singleHidden 一张图时 不显示pageControl */
@property(nonatomic,assign) BOOL hidesPageControlWhenSingle;

/** pageLeftOffset 分页左边的间距 默认10 */
@property(nonatomic,assign) CGFloat pageControlLeftOffset;

/** pageRightOffset 分页右边边的间距 默认10 */
@property(nonatomic,assign) CGFloat pageControlRightOffset;

/** pageBottomOffset 分页下班边的间距 默认5 */
@property(nonatomic,assign) CGFloat pageControlBottomOffset;

/** isShowImageMaskView NO */
@property(nonatomic,assign) BOOL isShowImageMaskView;

/** imageMaskViewColor black 0.2 */
@property(nonatomic,strong) UIColor *imageMaskViewColor;

/** imageMaskViewFrame default image.bounds */
@property(nonatomic,assign) CGRect imageMaskViewFrame;

/** isShowImageCornerRadius NO */
@property(nonatomic,assign) BOOL isShowImageCornerRadius;

/** imageCornerRadius default 8 */
@property(nonatomic,assign) CGFloat imageCornerRadius;

/** isShowimageBorder default NO */
@property(nonatomic,assign) BOOL isShowimageBorder;

/** imageBorderWidth default 1  */
@property(nonatomic,assign) CGFloat imageBorderWidth;

/** imageBorderColor default [UIColor grayColor]] */
@property(nonatomic,strong) UIColor *imageBorderColor;

/*********************轮播相关***********************/

/*********************文本相关***********************/

/** titleAliment 轮播图文本的位置 默认center*/
@property(nonatomic,assign) JPLoopViewTitleAliment titleAliment;

/** titleNumLines 默认1 */
@property(nonatomic,assign) CGFloat titleNumLines;

/** titlefont 默认 17 */
@property(nonatomic,strong) UIFont *titleFont;

/** title color 默认 白色 */
@property(nonatomic,strong) UIColor *titleColor;

/** leftOffset 左边距离BgView的间距 默认10 */
@property(nonatomic,assign) CGFloat titleLeftOffset;

/** rightOffset 右边距离BgView的间距 默认10 */
@property(nonatomic,assign) CGFloat titleRightOffset;

/** height title高度 默认44 */
@property(nonatomic,assign) CGFloat titleHeight;

/** bottomOffset 下边距离BgView的间距 默认0 */
@property(nonatomic,assign) CGFloat titleBottomOffset;

/** showAttritubedText 默认NO */
@property (nonatomic, assign) BOOL showAttritubedText;

/** banner heights */
@property(nonatomic,strong) NSArray *titleHeights;

/** bgcolor 默认 黑色0.5透明 */
@property(nonatomic,strong) UIColor *bgViewColor;

/** bgView 左边的间距 默认0 */
@property(nonatomic,assign) CGFloat bgViewLeftOffset;

/** bgView 右边边的间距 默认0 */
@property(nonatomic,assign) CGFloat bgViewRightOffset;

/** bgView 下边的间距 默认0 */
@property(nonatomic,assign) CGFloat bgViewBottomOffset;

/** bgView height 文本和背景保持同高 默认 44 */
@property(nonatomic,assign) CGFloat bgViewHeight;

/*********************文本相关***********************/

/*********************计时相关***********************/

/** isAutoScroll 是否自动滚动 默认YES */
@property(nonatomic,assign) BOOL isAutoScroll;

/** 如果设置了isAutoScroll=YES 一张图片是否自动滚动 默认YES */
@property(nonatomic,assign) BOOL isAutoScrollOnlyOne;

/** intervalTime 自动滚动时间间隔 默认2s */
@property(nonatomic,assign) NSTimeInterval intervalTime;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/*********************计时相关***********************/

@end
