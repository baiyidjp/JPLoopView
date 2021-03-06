//
//  JPLoopViewCell.h
//  JPLoopViewDemo
//
//  Created by tztddong on 2016/10/31.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPLoopCellModel;
@interface JPLoopViewCell : UICollectionViewCell

/** model */
@property(nonatomic,strong) JPLoopCellModel *cellModel;

/** imageView */
- (UIImageView *)getLoopImageView;

@end
