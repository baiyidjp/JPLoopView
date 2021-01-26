//
//  JPLoopView.m
//  JPLoopViewDemo
//
//  Created by tztddong on 2016/10/31.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPLoopView.h"
#import "JPLoopViewLayout.h"
#import "JPLoopViewCell.h"
#import "JPPageControl.h"
#import "JPTimerUtils.h"
#import "JPProxy.h"

NSString *const JPCollectionViewCellID = @"JPCollectionViewCellID";
NSInteger const allCount = 10000;//不能是奇数


@interface JPLoopView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** models */
@property(nonatomic,strong) NSMutableArray *loopDataModels;
/** collectionViewLayout */
@property(nonatomic,strong) JPLoopViewLayout *collectionViewLayout;
/** collectionview */
@property(nonatomic,strong) UICollectionView *collectionView;
/** pagecontrol 分页控件 */
@property(nonatomic,strong) JPPageControl *pageControl;
/** totalItems 要显示的所有item的个数*/
@property(nonatomic,assign) NSInteger totalItemsCount;
/** 当前计时器的名字 */
@property(nonatomic,strong) NSString *timerManageName;
/** default frame */
@property(nonatomic,assign) CGRect defaultFrame;

@end

@implementation JPLoopView


- (NSMutableArray *)loopDataModels{
    
    if (!_loopDataModels) {
        
        _loopDataModels = [NSMutableArray array];
    }
    return _loopDataModels;
}

+ (instancetype)loopViewWithFrame:(CGRect)frame {
    
    return [self loopViewWithFrame:frame delegate:nil];
}

+ (instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<JPLoopViewDelegate>)delegate {
    
    return [self loopViewWithFrame:frame delegate:delegate placeholderImage:nil];
}

+ (instancetype)loopViewWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage {
    
    return [self loopViewWithFrame:frame delegate:nil placeholderImage:placeholderImage];
}

+ (instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<JPLoopViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage {
    
    JPLoopView *loopView = [[self alloc] initWithFrame:frame];
    loopView.delegate = delegate;
    loopView.placeholderImage = placeholderImage;
    return loopView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        //记录loopView初始frame
        self.defaultFrame = frame;
        [self p_SetDefaultData];
        [self p_ConfigView];
    }
    return self;
}

#pragma mark -设置默认数据
- (void)p_SetDefaultData {
    
    self.loopViewBackgroundColor = [UIColor whiteColor];
    self.pageControlAliment = JPLoopViewPageControlAlimentCenter;
    self.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.pageIndicatorSpaing = 5;
    self.currentPageIndicatorSize = CGSizeMake(6, 6);
    self.pageIndicatorSize = CGSizeMake(6, 6);
    self.pageControlEnabled = NO;
    self.hidesPageControlWhenSingle = YES;
    self.pageControlLeftOffset = 16;
    self.pageControlRightOffset = 16;
    self.pageControlBottomOffset = 8;
    self.isShowImageMaskView = NO;
    self.imageMaskViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.imageMaskViewFrame = self.bounds;
    self.isShowImageCornerRadius = NO;
    self.isShowimageBorder = NO;
    self.imageCornerRadius = 8;
    self.imageBorderColor = [UIColor grayColor];
    self.imageBorderWidth = 1;
    
    self.titleAliment = JPLoopViewTitleAlimentCenter;
    self.titleNumLines = 1;
    self.titleFont = [UIFont systemFontOfSize:15];
    self.titleColor = [UIColor whiteColor];
    self.titleLeftOffset = 16;
    self.titleRightOffset = 16;
    self.titleHeight = 44;
    self.titleBottomOffset = 0;
    self.showAttritubedText = NO;
    self.bgViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    self.bgViewLeftOffset = 0;
    self.bgViewRightOffset = 0;
    self.bgViewBottomOffset = 0;
    self.bgViewHeight = 44;

    
    self.isAutoScroll = YES;
    self.intervalTime = 2;
    self.infiniteLoop = YES;
}

#pragma mark -设置UI
- (void)p_ConfigView {
    
    self.collectionViewLayout = [[JPLoopViewLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[JPLoopViewCell class] forCellWithReuseIdentifier:JPCollectionViewCellID];
    self.collectionView.backgroundColor = self.loopViewBackgroundColor;
    [self addSubview:self.collectionView];
}

#pragma mark -设置PageControl
- (void)p_SetPageControl {
    
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
    
    if ((self.loopDataModels.count == 1 && self.hidesPageControlWhenSingle) || !self.loopDataModels.count) {
        return;
    }
    
    JPPageControl *pageControl = [[JPPageControl alloc] init];
    pageControl.numberOfPages = self.loopDataModels.count;
    pageControl.pageIndicatorSpaing = self.pageIndicatorSpaing;
    pageControl.currentPageIndicatorSize = self.currentPageIndicatorSize;
    pageControl.pageIndicatorSize = self.pageIndicatorSize;
    pageControl.pageIndicatorImage = self.pageIndicatorImage;
    pageControl.currentPageIndicatorImage = self.currentPageIndicatorImage;
    pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    pageControl.userInteractionEnabled = self.pageControlEnabled;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    CGSize pageSize = pageControl.contentSize;
    CGFloat currentViewWidth = self.frame.size.width;
    CGFloat currentViewHeight = self.frame.size.height;
    
    if ((self.defaultFrame.size.width != self.frame.size.width) || (self.defaultFrame.size.height != self.frame.size.height)) {
        //loopView 进行缩放 会影响pageControl的位置
        currentViewWidth = self.defaultFrame.size.width;
        currentViewHeight = self.defaultFrame.size.height;
    }
    switch (self.pageControlAliment) {
        case JPLoopViewPageControlAlimentNone:
        {
            pageControl.hidden = YES;
            [pageControl removeFromSuperview];
        }
            break;
        case JPLoopViewPageControlAlimentLeft:
        {
            pageControl.hidden = NO;
            pageControl.frame = CGRectMake(self.pageControlLeftOffset, currentViewHeight-self.pageControlBottomOffset-pageSize.height, pageSize.width, pageSize.height);
        }
            break;
        case JPLoopViewPageControlAlimentCenter:
        {
            pageControl.hidden = NO;
            pageControl.frame = CGRectMake(currentViewWidth*0.5-pageSize.width*0.5, currentViewHeight-self.pageControlBottomOffset-pageSize.height, pageSize.width, pageSize.height);

        }
            break;
        case JPLoopViewPageControlAlimentRight:
        {
            pageControl.hidden = NO;
            pageControl.frame = CGRectMake(currentViewWidth-self.pageControlRightOffset-pageSize.width, currentViewHeight-self.pageControlBottomOffset-pageSize.height, pageSize.width, pageSize.height);

        }
            break;
    }
}

#pragma mark - 接收外部传入图片数据
- (void)setLoopImageArray:(NSArray *)loopImageArray {
    
    [self.loopDataModels removeAllObjects];
    
    if (!loopImageArray.count ||!loopImageArray) {
        
        JPLoopCellModel *cellModel = [[JPLoopCellModel alloc] init];
        cellModel.imageUrlStr = @"";
        cellModel.placeholderImage = self.placeholderImage;
        cellModel.isShowTitle = NO;
        cellModel.isShowImageMaskView = self.isShowImageMaskView;
        cellModel.imageMaskViewColor = self.imageMaskViewColor;
        cellModel.imageMaskViewFrame = self.imageMaskViewFrame;
        [self.loopDataModels addObject:cellModel];
        [self setLoopData];
    } else {
        
        NSMutableArray *urls = [NSMutableArray new];
        
        [loopImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *urlString;
            if ([obj isKindOfClass:[NSString class]]) {
                urlString = obj;
            } else if ([obj isKindOfClass:[NSURL class]]) {
                NSURL *url = (NSURL *)obj;
                urlString = [url absoluteString];
            }
            if (urlString && urlString.length) {
                [urls addObject:urlString];
            }
            
        }];
        
        if (urls.count) {
            for (NSString *url in urls) {
                JPLoopCellModel *cellModel = [[JPLoopCellModel alloc] init];
                cellModel.imageUrlStr = url;
                cellModel.placeholderImage = self.placeholderImage;
                cellModel.isShowTitle = NO;
                cellModel.isShowImageMaskView = self.isShowImageMaskView;
                cellModel.imageMaskViewColor = self.imageMaskViewColor;
                cellModel.imageMaskViewFrame = self.imageMaskViewFrame;
                cellModel.isShowImageCornerRadius = self.isShowImageCornerRadius;
                cellModel.isShowimageBorder = self.isShowimageBorder;
                cellModel.imageCornerRadius = self.imageCornerRadius;
                cellModel.imageBorderWidth = self.imageBorderWidth;
                cellModel.imageBorderColor = self.imageBorderColor;
                [self.loopDataModels addObject:cellModel];
            }
            [self setLoopData];
        }
    }
    
}

- (void)setLoopImageArray:(NSArray *)loopImageArray loopTitleArray:(NSArray *)loopTitleArray {
    
    [self.loopDataModels removeAllObjects];
    
    if (!loopImageArray || !loopImageArray.count || (loopTitleArray && loopTitleArray.count && (loopImageArray.count != loopTitleArray.count))) {
        
        JPLoopCellModel *cellModel = [[JPLoopCellModel alloc] init];
        cellModel.imageUrlStr = @"";
        cellModel.placeholderImage = self.placeholderImage;
        cellModel.isShowTitle = NO;
        cellModel.isShowImageMaskView = self.isShowImageMaskView;
        cellModel.imageMaskViewColor = self.imageMaskViewColor;
        cellModel.imageMaskViewFrame = self.imageMaskViewFrame;
        [self.loopDataModels addObject:cellModel];
        [self setLoopData];
    } else {
        
        NSMutableArray *urls = [NSMutableArray new];
        
        [loopImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *urlString;
            if ([obj isKindOfClass:[NSString class]]) {
                urlString = obj;
            } else if ([obj isKindOfClass:[NSURL class]]) {
                NSURL *url = (NSURL *)obj;
                urlString = [url absoluteString];
            }
            if (urlString) {
                [urls addObject:urlString];
            }
            
        }];
        
        if (urls.count) {
            for (NSString *url in urls) {
                JPLoopCellModel *cellModel = [[JPLoopCellModel alloc] init];
                cellModel.imageUrlStr = url;
                cellModel.placeholderImage = self.placeholderImage;
                cellModel.isShowTitle = NO; //不存在文本 强制为NO
                [self.loopDataModels addObject:cellModel];
            }
            if (self.loopDataModels.count && loopTitleArray && loopImageArray.count) {
                for (NSInteger i = 0; i < loopTitleArray.count;i++) {
                    JPLoopCellModel *cellModel = self.loopDataModels[i];
                    cellModel.isShowTitle = YES;
                    cellModel.isShowAttributedText = self.showAttritubedText;
                    if (self.showAttritubedText) {
                        cellModel.imageTitleAttStr = loopTitleArray[i];
                        cellModel.bgViewColor = cellModel.imageTitleAttStr.length ? self.bgViewColor : [UIColor clearColor];
                    }else {
                        cellModel.imageTitleStr = loopTitleArray[i];
                        cellModel.bgViewColor = cellModel.imageTitleStr.length ? self.bgViewColor : [UIColor clearColor];
                    }
                    cellModel.titleNumLines = self.titleNumLines;
                    cellModel.titleFont = self.titleFont;
                    cellModel.titleColor = self.titleColor;
                    cellModel.titleAliment = self.titleAliment;
                    cellModel.titleLeftOffset = self.titleLeftOffset;
                    cellModel.titleRightOffset = self.titleRightOffset;
                    cellModel.titleHeight = [self.titleHeights[i] floatValue];
                    cellModel.titleBottomOffset = self.titleBottomOffset;
                    cellModel.bgViewHeight = self.bgViewHeight;
                    cellModel.bgViewLeftOffset = self.bgViewLeftOffset;
                    cellModel.bgViewRightOffset = self.bgViewRightOffset;
                    cellModel.bgViewBottomOffset = self.bgViewBottomOffset;
                    cellModel.isShowImageMaskView = self.isShowImageMaskView;
                    cellModel.imageMaskViewColor = self.imageMaskViewColor;
                    cellModel.imageMaskViewFrame = self.imageMaskViewFrame;
                    cellModel.isShowImageCornerRadius = self.isShowImageCornerRadius;
                    cellModel.isShowimageBorder = self.isShowimageBorder;
                    cellModel.imageCornerRadius = self.imageCornerRadius;
                    cellModel.imageBorderWidth = self.imageBorderWidth;
                    cellModel.imageBorderColor = self.imageBorderColor;
                }
            }
            [self setLoopData];
        }
    }
}

#pragma mark - 设置显示的数据
- (void)setLoopData {

    if (!self.loopDataModels.count) {
        self.collectionView.scrollEnabled = NO;
        //停止计时器
        [self stopTimer];
        return;
    }
    
    self.totalItemsCount = self.infiniteLoop ? self.loopDataModels.count * allCount : self.loopDataModels.count;
    
    if (self.loopDataModels.count != 1) {
        self.collectionView.scrollEnabled = YES;
        if (self.isAutoScroll) {
            [self startTimer];
        }
    } else {
        if (!self.isAutoScrollOnlyOne) {
            //一张图片不准滑动了
            self.collectionView.scrollEnabled = NO;
            //停止计时器
            [self stopTimer];
        }
    }

    [self p_SetPageControl];
    [self.collectionView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.loopDataModels.count && self.infiniteLoop) {
            [self p_LoopViewScrollToIndexPath:[NSIndexPath indexPathForItem:self.totalItemsCount/2 inSection:0] animated:NO];
        }
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JPLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPCollectionViewCellID forIndexPath:indexPath];
    JPLoopCellModel *cellModel = self.loopDataModels[indexPath.item % self.loopDataModels.count];
    cell.cellModel = cellModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(didSelectItem:index:)]) {
        [self.delegate didSelectItem:self index:indexPath.item % self.loopDataModels.count];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectItem:index:currentImageView:)]) {
        JPLoopViewCell *cell = (JPLoopViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate didSelectItem:self index:indexPath.item % self.loopDataModels.count currentImageView:[cell getLoopImageView]];
    }
}

//滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.loopDataModels.count) {
        return;
    }
    NSInteger index = [self p_CurrentIndex];
    self.pageControl.currentPage = index % self.loopDataModels.count;
    
}

//自动轮播 停止的位置
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger index = [self p_CurrentIndex];
    self.pageControl.currentPage = index % self.loopDataModels.count;
}

//手指开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //如果是无线滚动 结束定时器
    if (self.isAutoScroll) {
        
        [self stopTimer];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopViewWillBeginDragging)]) {
        [self.delegate loopViewWillBeginDragging];
    }
}

//手指结束滑动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //如果是无线滚动 重启定时器
    if (self.isAutoScroll) {
        
        [self startTimer];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopViewDidEndDragging)]) {
        [self.delegate loopViewDidEndDragging];
    }
}

//手指滑动 滚动的位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = [self p_CurrentIndex];
    NSInteger allCellCount = [self.collectionView numberOfItemsInSection:0];
    
    //实现无限滚动
    if (index == 0 || index == allCellCount - 1) {
        
        if (self.infiniteLoop) {
            
            if (index == 0) {
                index = allCellCount/2;
            }else{
                index = allCellCount/2-1;
            }
        }
    }
    self.collectionView.contentOffset = CGPointMake(index*scrollView.bounds.size.width, 0);
    self.pageControl.currentPage = index % self.loopDataModels.count;
    
}


#pragma mark - starTimer 开始定时器
- (void)startTimer {
    
    [self stopTimer];
    
    if (self.loopDataModels.count == 1 && self.isAutoScrollOnlyOne) {
        return;
    }
    
    self.timerManageName = [JPTimerUtils jp_timerBeginWithStartTime:self.intervalTime intervalTime:self.intervalTime repeats:YES async:NO target:[[JPProxy alloc] initWithTarget:self] selector:@selector(p_ScrollLoopView)];
}
- (void)p_ScrollLoopView {
    
    NSInteger nextIndex = [self p_CurrentIndex] + 1;
    if (nextIndex >= self.totalItemsCount) {
        nextIndex = self.totalItemsCount * 0.5;
        [self p_LoopViewScrollToIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] animated:NO];
    } else {
        [self p_LoopViewScrollToIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] animated:YES];
    }
}

//滚动collectionview
- (void)p_LoopViewScrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    
    //获取位置
   UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
   // 滑动
   [self.collectionView setContentOffset:layoutAttributes.frame.origin animated:animated];
}


#pragma mark -invalidateTimer 结束定时器
- (void)stopTimer {
    
    if (self.timerManageName) {
        [JPTimerUtils jp_cancelTask:self.timerManageName];
        self.timerManageName = nil;
    }
}

#pragma mark - 取到当前cell的下标
- (NSInteger)p_CurrentIndex {
    
    CGPoint center = self.collectionView.center;
    center.x += self.collectionView.contentOffset.x;
    center.y = self.collectionView.bounds.size.height/2.0;
    
    NSArray *indexPaths = self.collectionView.indexPathsForVisibleItems;
    
    for (NSIndexPath *indexPath in indexPaths) {
        
        JPLoopViewCell *cell = (JPLoopViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        //检查中心现在何处
        if (CGRectContainsPoint(cell.frame, center)) {
            
            return MAX(0,indexPath.item);
        }
    }
    return 0;
}

- (void)setLoopViewCanScroll:(BOOL)canScroll {
    
    if (self.loopDataModels.count > 1) {

        self.collectionView.scrollEnabled = canScroll;
        
    } else {
        //如果图片小于1张,则不可滑动
        self.collectionView.scrollEnabled = NO;
    }
}

- (void)setLoopViewBackgroundColor:(UIColor *)loopViewBackgroundColor {
    
    _loopViewBackgroundColor = loopViewBackgroundColor;
    self.collectionView.backgroundColor = loopViewBackgroundColor;
}

- (void)dealloc {
    
    NSLog(@"%s",__func__);
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    [self stopTimer];
}

@end
