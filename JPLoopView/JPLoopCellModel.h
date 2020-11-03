//
//  JPLoopCellModel.h
//  BaseViewController
//
//  Created by baiyi on 2018/9/17.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPLoopViewTitleAliment) {
    JPLoopViewTitleAlimentNone,//隐藏文本
    JPLoopViewTitleAlimentLeft,
    JPLoopViewTitleAlimentCenter,
    JPLoopViewTitleAlimentRight
};


@interface JPLoopCellModel : NSObject

/** URL */
@property(nonatomic,copy) NSString *imageUrlStr;
/** placeholderimage */
@property(nonatomic,strong) UIImage *placeholderImage;

/** showtext */
@property(nonatomic,assign) BOOL isShowTitle;
/** text */
@property(nonatomic,copy) NSString *imageTitleStr;
/** showAtt */
@property(nonatomic,assign) BOOL isShowAttributedText;
/** text富文本 */
@property(nonatomic,copy) NSAttributedString *imageTitleAttStr;
/** titletype */
@property(nonatomic,assign) JPLoopViewTitleAliment titleAliment;
/** titlefont */
@property(nonatomic,strong) UIFont *titleFont;
/** titleNumLines */
@property(nonatomic,assign) CGFloat titleNumLines;
/** title color*/
@property(nonatomic,strong) UIColor *titleColor;
/** leftOffset 左边距离BgView的间距 默认10 */
@property(nonatomic,assign) CGFloat titleLeftOffset;
/** bottomOffset 下边距离BgView的间距 默认0 */
@property(nonatomic,assign) CGFloat titleBottomOffset;
/** rightOffset 右边距离BgView的间距 默认10 */
@property(nonatomic,assign) CGFloat titleRightOffset;
/** height titleheight 默认44 */
@property(nonatomic,assign) CGFloat titleHeight;

/** bgcolor */
@property(nonatomic,strong) UIColor *bgViewColor;
/** bgView 左边的间距 默认0 */
@property(nonatomic,assign) CGFloat bgViewLeftOffset;
/** bgView 右边边的间距 默认0 */
@property(nonatomic,assign) CGFloat bgViewRightOffset;
/** bgView 下边的间距 默认0 */
@property(nonatomic,assign) CGFloat bgViewBottomOffset;
/** bgView height */
@property(nonatomic,assign) CGFloat bgViewHeight;

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

/** imageBorderWidth default 0  */
@property(nonatomic,assign) CGFloat imageBorderWidth;

/** imageBorderColor default clear */
@property(nonatomic,strong) UIColor *imageBorderColor;

@end
