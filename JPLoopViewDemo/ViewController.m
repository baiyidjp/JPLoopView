//
//  ViewController.m
//  JPLoopViewDemo
//
//  Created by baiyi on 2018/9/18.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "ViewController.h"
#import "LoopViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickLoopViewBtn:(id)sender {
    
    [self.navigationController pushViewController:[LoopViewController new] animated:YES];
}


@end
