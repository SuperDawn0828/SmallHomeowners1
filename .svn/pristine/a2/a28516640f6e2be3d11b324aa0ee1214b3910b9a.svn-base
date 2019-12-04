//
//  ZSCertificationViewController.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/28.
//  Copyright © 2018年 maven. All rights reserved.
//  注册--设置密码--选择身份--资质认证
//  个人中心--资质认证

#pragma mark 页面类型
typedef NS_ENUM(NSUInteger, ZSCertificationType)
{
    ZSFromRegister = 0,               //注册过来的: 无navgationBar,显示textLabel、noticeLabel、skipBtn;
    ZSFromPersonalWithUnauthorized,   //个人中心过来未认证的情况: 有navgationBar, 不显示textLabel、noticeLabel、skipBtn
    ZSFromPersonalWithCertified,      //个人中心过来已认证的情况: 有navgationBar, 不显示textLabel、noticeLabel、skipBtn, 还要显示认证状态和重新认证按钮
};

#import "ZSBaseViewController.h"

@interface ZSCertificationViewController : ZSBaseViewController

@property(nonatomic,assign)ZSCertificationType cerType;

@end
