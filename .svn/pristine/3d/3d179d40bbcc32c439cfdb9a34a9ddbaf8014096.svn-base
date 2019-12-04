//
//  ZSLogInManager.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/6.
//  Copyright © 2018年 maven. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 修改个人信息类型(服务器入参按这个code,不要随意修改)
typedef NS_ENUM(NSUInteger, ZSChangeUserInfoType) {
    ZSHeadPhoto = 1,        //头像
    ZSUserName = 4,         //用户名
    ZSCityName = 2,         //所在城市
    ZSRoletype = 3,         //角色类型  1中介 2个人
    ZSRefereesPhoneNum = 5, //推荐人手机号
};

typedef void (^RequestResultBlock)(BOOL isSuccess);

@interface ZSLogInManager : NSObject

#pragma mark 初始化
+ (ZSLogInManager *)shareInfo;

#pragma mark 登录
+ (void)logInWithAccount:(NSString *)account withPassword:(NSString *)password withResult:(RequestResultBlock)isSuccess;

#pragma mark 更改用户信息(网络请求)
+ (void)changeUserInfoWithRequest:(ZSChangeUserInfoType)type withString:(NSString *)string withID:(NSString *)IDString withResult:(RequestResultBlock)isSuccess;

#pragma mark 保存用户相关的信息
+ (void)saveUserInfoWithDic:(NSDictionary *)Dic;

#pragma mark 获取用户信息
+ (ZSUidInfo *)readUserInfo;

#pragma mark 判断用户是否登录
+ (BOOL)isLogIn;

#pragma mark 跳转到登录页面
+ (void)gotoLogInViewCtrl:(UIViewController *)viewCtrl isCanDismissSelf:(BOOL)isCan;

#pragma mark 退出登录
+ (void)userLogOut:(UIViewController *)viewCtrl;

@end
