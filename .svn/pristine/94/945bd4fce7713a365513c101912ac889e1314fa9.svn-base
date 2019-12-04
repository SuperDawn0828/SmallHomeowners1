//
//  ZSErrorView.m
//  ZSMoneytocar
//
//  Created by 武 on 16/7/6.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSErrorView.h"

@interface ZSErrorView  ()

@end

@implementation ZSErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.imagView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-120)/2, (self.height-120-30)/2, 120, 120)];
    [self addSubview:self.imagView];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, self.imagView.bottom, ZSWIDTH-40, 50)];
    self.titleLab.textColor = ZSColorGolden;;
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLab];
   
    //无数据时 轻扫手势通知接口请求
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sendNotification)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeGesture];
    
    //点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendNotification)];
    [self addGestureRecognizer:tapGesture];
}

- (void)sendNotification
{
    if ([self.titleLab.text isEqualToString:KErrorWithoutOrder])
    {
        //弹出创建订单弹窗
        [NOTI_CENTER postNotificationName:KgotoCreateOrderNoti object:nil];
    }
    else if ([self.titleLab.text isEqualToString:KErrorWithoutNoti])
    {
        //通知列表刷新
        [NOTI_CENTER postNotificationName:KSUpdateNotiList object:nil];
    }
//    else if ([self.titleLab.text isEqualToString:KErrorWithoutNetworkPermission])
//    {
//        //跳转到设置页面开启网络权限
//        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if ([[UIApplication sharedApplication] canOpenURL:appSettings]) {
//            [[UIApplication sharedApplication] openURL:appSettings];
//        }
//        //没有网络,点击重试
//        [NOTI_CENTER postNotificationName:KRequestNetwork object:nil];
//    }
    else if ([self.titleLab.text isEqualToString:KErrorWithoutNetwork])
    {
        //没有网络,点击重试
        [NOTI_CENTER postNotificationName:KRequestNetwork object:nil];
    }
    else if ([self.titleLab.text isEqualToString:KErrorWithoutHomePageData])
    {
        //首页无数据
        [NOTI_CENTER postNotificationName:KUpdateHomePageData object:nil];
    }
}

@end
