//
//  NavViewController.m
//
//
//  Created by 黄曼文 on 14-11-5.
//  Copyright (c) 2014年 黄曼文. All rights reserved.
//

#import "ZSNavViewController.h"
#import "ZSTabBarViewController.h"

@interface ZSNavViewController ()

@end

@implementation ZSNavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark 显示或隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
