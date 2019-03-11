//
//  LoopViewController.m
//  JPLoopViewDemo
//
//  Created by baiyi on 2018/9/18.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "LoopViewController.h"
#import "JPLoopView/JPLoopView.h"

@interface LoopViewController ()<JPLoopViewDelegate>
/** loopView; */
@property(nonatomic,strong) JPLoopView *loopView;
@property(nonatomic,strong) JPLoopView *loopView_1;

@end

@implementation LoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"轮播图";
    
    self.loopView = [JPLoopView loopViewWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width*9.0/16) delegate:self placeholderImage:nil];
    self.loopView.pageIndicatorTintColor = [UIColor whiteColor];
    self.loopView.pageIndicatorImage = [UIImage imageNamed:@"home_new_bannerDotImage"];
    self.loopView.currentPageIndicatorImage = [UIImage imageNamed:@"home_new_bannerCurrentImage"];
    self.loopView.pageIndicatorSize = CGSizeMake(7, 2);
    self.loopView.pageControlAliment = JPLoopViewPageControlAlimentRight;
    [self.view addSubview:self.loopView];
    
    NSArray *images = @[@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/261147252661302_480.jpg",@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/281001502516278_480.jpg",@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/201023267005533_480.jpg"];
    
    [self.loopView setLoopImageArray:images];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.loopView.frame)+10, 100, 30)];
    [btn setTitle:@"换图" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.loopView_1 = [[JPLoopView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+20, self.view.bounds.size.width, self.view.bounds.size.width*9.0/16)];
    self.loopView_1.intervalTime = 5;
    self.loopView_1.pageControlAliment = JPLoopViewPageControlAlimentLeft;
    self.loopView_1.delegate = self;
    [self.view addSubview:self.loopView_1];
    
    NSArray *images_1 = @[@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/261147252661302_480.jpg",@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/281001502516278_480.jpg",@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/201023267005533_480.jpg"];
    
    [self.loopView_1 setLoopImageArray:images_1 loopTitleArray:@[@"0000000000",@"1111111111",@"2222222222"]];
    
    
}

- (void)didSelectItem:(JPLoopView *)loopView index:(NSInteger)index{
    
    NSLog(@"select index -- %zd",index);
}


- (void)changePic {
    
    NSArray *images = @[@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/281001502516278_480.jpg",@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/201023267005533_480.jpg",@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/261147252661302_480.jpg",@"http://ossweb-img.qq.com/upload/qqtalk/news/201610/201023267005533_480.jpg"];
    [self.loopView setLoopImageArray:images loopTitleArray:@[@"0000000000",@"1111111111",@"2222222222",@"3333333333"]];
}

@end
