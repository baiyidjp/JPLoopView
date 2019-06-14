//
//  JPLoopViewCell.m
//  JPLoopViewDemo
//
//  Created by tztddong on 2016/10/31.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPLoopViewCell.h"
#import "JPLoopCellModel.h"
#import "UIImageView+WebCache.h"

@interface JPLoopViewCell ()
/** imageView */
@property(nonatomic,strong) UIImageView *loopImageView;
/** maskView */
@property(nonatomic,strong) UIView *maskView;
/** label */
@property(nonatomic,strong) UILabel *loopTitleLabel;
/** sublabel */
@property(nonatomic,strong) UILabel *loopSubTitleLabel;
/** bgView */
@property(nonatomic,strong) UIView *loopTitleBgView;

@end

@implementation JPLoopViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.loopImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.loopImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.loopImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.loopImageView];
        
        self.maskView = [[UIView alloc] init];
        self.maskView.hidden = YES;
        [self.loopImageView addSubview:self.maskView];
        
        self.loopTitleBgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.loopTitleBgView];
        
        self.loopTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.loopTitleLabel];

        self.loopSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.loopSubTitleLabel];
    }
    return self;
}

- (void)setCellModel:(JPLoopCellModel *)cellModel {
    
    _cellModel = cellModel;
    
    [self.loopImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageUrlStr] placeholderImage:cellModel.placeholderImage];
    
    self.maskView.hidden = !cellModel.isShowImageMaskView;
    self.maskView.frame = cellModel.imageMaskViewFrame;
    self.maskView.backgroundColor = cellModel.imageMaskViewColor;
    
    BOOL isShowTitle = cellModel.isShowTitle;
    if (isShowTitle) {

        self.loopTitleLabel.numberOfLines = cellModel.titleNumLines;
        self.loopTitleLabel.font = cellModel.titleFont;
        self.loopTitleLabel.textColor = cellModel.titleColor;
        if (cellModel.imageTitleAttStr.length && cellModel.isShowAttributedText) {
            self.loopTitleLabel.attributedText = cellModel.imageTitleAttStr;
        } else {
            self.loopTitleLabel.text = cellModel.imageTitleStr;
        }
        
        self.loopTitleBgView.hidden = !cellModel.titleHeight;
        self.loopTitleBgView.backgroundColor = cellModel.bgViewColor;
        self.loopTitleBgView.frame = CGRectMake(cellModel.bgViewLeftOffset, self.frame.size.height-cellModel.bgViewHeight-cellModel.bgViewBottomOffset, self.frame.size.width-cellModel.bgViewLeftOffset-cellModel.bgViewRightOffset, cellModel.bgViewHeight);
        self.loopTitleLabel.frame = CGRectMake(CGRectGetMinX(self.loopTitleBgView.frame)+cellModel.titleLeftOffset, CGRectGetHeight(self.loopTitleBgView.frame)-cellModel.titleBottomOffset-cellModel.titleHeight, CGRectGetWidth(self.loopTitleBgView.frame)-cellModel.titleLeftOffset-cellModel.titleRightOffset, cellModel.titleHeight);

        switch (cellModel.titleAliment) {
            case JPLoopViewTitleAlimentNone:
            {
                self.loopTitleLabel.hidden = self.loopTitleBgView.hidden = YES;
            }
                break;
            case JPLoopViewTitleAlimentLeft:
            {
                self.loopTitleLabel.hidden = self.loopTitleBgView.hidden = NO;
                self.loopTitleLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            case JPLoopViewTitleAlimentCenter:
            {
                self.loopTitleLabel.hidden = self.loopTitleBgView.hidden = NO;
                self.loopTitleLabel.textAlignment = NSTextAlignmentCenter;
            }
                break;
            case JPLoopViewTitleAlimentRight:
            {
                self.loopTitleLabel.hidden = self.loopTitleBgView.hidden = NO;
                self.loopTitleLabel.textAlignment = NSTextAlignmentRight;
                
            }
                break;
        }
    }else {
        self.loopTitleLabel.hidden = self.loopTitleBgView.hidden = YES;
    }

}

- (UIImageView *)getLoopImageView {
    
    return self.loopImageView;
}

@end
