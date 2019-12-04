//
//  ZSLogInManager.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/6.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSLogInManager.h"
#import "ZSTabBarViewController.h"
#import "ZSLogInViewController.h"

@implementation ZSLogInManager

#pragma mark 初始化
+ (ZSLogInManager *)shareInfo
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark 登录
+ (void)logInWithAccount:(NSString *)account withPassword:(NSString *)password withResult:(RequestResultBlock)isSuccess;
{
    NSMutableDictionary *dict = @{
                                  @"telephone":account,
                                  @"password":password
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getLoginURL] SuccessBlock:^(NSDictionary *dic) {
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSLogInManager saveUserInfoWithDic:newdic];
        [USER_DEFALT setObject:account  forKey:LoginAccount];
        [USER_DEFALT setObject:password forKey:LoginPassword];
        [USER_DEFALT setObject:dic[@"respData"][@"tokenForApp"] forKey:tokenForApp];
        //通知极光设置用户的alias
        [NOTI_CENTER postNotificationName:KSSendUserAliasToJpush object:nil];
        //回调
        if (isSuccess) {
            isSuccess(YES);
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 更改用户信息(网络请求)
+ (void)changeUserInfoWithRequest:(ZSChangeUserInfoType)type withString:(NSString *)string withID:(NSString *)IDString withResult:(RequestResultBlock)isSuccess;
{
    [MBProgressHUD showLoadingView];
    NSMutableDictionary *dict = @{
                                  @"bizType":[NSString stringWithFormat:@"%ld",(long)type],//1改头像 2改城市 3改身份类型 4改姓名
                                  }.mutableCopy;
    if (type == ZSHeadPhoto)
    {
        [dict setObject:string forKey:@"headPhoto"];
    }
    else if (type == ZSUserName)
    {
        [dict setObject:string forKey:@"username"];
    }
    else if (type == ZSCityName)
    {
        [dict setObject:string forKey:@"city"];
        if (IDString != nil) {
            [dict setObject:IDString forKey:@"cityId"];
        }
    }
    else if (type == ZSRoletype)
    {
        [dict setObject:string forKey:@"userType"];//1中介 2个人
    }
    else if (type == ZSRefereesPhoneNum)
    {
        [dict setObject:string forKey:@"refereeTelphone"];
    }
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getChangeUserInformation] SuccessBlock:^(NSDictionary *dic) {
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSLogInManager saveUserInfoWithDic:newdic];
        //回调
        if (isSuccess) {
            isSuccess(YES);
        }
        [MBProgressHUD hideLoadingView];
    } ErrorBlock:^(NSError *error) {
        [MBProgressHUD hideLoadingView];
    }];
}

#pragma mark 保存用户相关的信息
+ (void)saveUserInfoWithDic:(NSDictionary *)Dic
{
    ZSUidInfo *userInfo       = [ZSUidInfo shareInfo];
    userInfo.createDate       = Dic[@"createDate"];
    userInfo.lastVisitTime    = Dic[@"lastVisitTime"];
    userInfo.state            = Dic[@"state"];
    userInfo.tid              = Dic[@"tid"];
    userInfo.updateDate       = Dic[@"updateDate"];
    userInfo.userid           = Dic[@"userid"];
    userInfo.username         = Dic[@"username"];
    userInfo.version          = Dic[@"version"];
    userInfo.userType         = Dic[@"userType"] ? Dic[@"userType"] : nil;
    userInfo.authState        = Dic[@"authState"] ? Dic[@"authState"] : nil;
    userInfo.headPhoto        = Dic[@"headPhoto"] ? Dic[@"headPhoto"] : nil;
    userInfo.telphone         = Dic[@"telphone"] ? Dic[@"telphone"] : nil;
    userInfo.visitingCard     = Dic[@"visitingCard"] ? Dic[@"visitingCard"] : nil;
    userInfo.company          = Dic[@"company"] ? Dic[@"company"] : nil;
    userInfo.position         = Dic[@"position"] ? Dic[@"position"] : nil;
    userInfo.city             = Dic[@"city"] ? Dic[@"city"] : nil;
    userInfo.cityId           = Dic[@"cityId"] ? Dic[@"cityId"] : nil;
    userInfo.customerManager           = Dic[@"customerManager"] ? Dic[@"customerManager"] : nil;
    userInfo.customerManagerName           = Dic[@"customerManagerName"] ? Dic[@"customerManagerName"] : nil;
    userInfo.customerManagerPhone           = Dic[@"customerManagerPhone"] ? Dic[@"customerManagerPhone"] : nil;
    NSData   *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:KCurrentUserInfo];
    [data writeToFile:filePath atomically:NO];
}

#pragma mark 获取用户信息
+ (ZSUidInfo *)readUserInfo
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:KCurrentUserInfo];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //如果文件存在
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        //NSKeyedUnarchiver解码器，能够把二进制数据解码为对象。
        ZSUidInfo *userInfo = [ZSUidInfo shareInfo];
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return userInfo;
    }else{
        return nil;
    }
}

#pragma mark 判断用户是否登录
+ (BOOL)isLogIn
{
    if ([ZSLogInManager readUserInfo].tid) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark 跳转到登录页面
+ (void)gotoLogInViewCtrl:(UIViewController *)viewCtrl isCanDismissSelf:(BOOL)isCan;
{
    ZSLogInViewController *logInVC = [[ZSLogInViewController alloc]init];
    logInVC.isCanDismiss = isCan;
    [viewCtrl presentViewController:logInVC animated:NO completion:nil];
}

#pragma mark 退出登录
+ (void)userLogOut:(UIViewController *)viewCtrl
{
    //退出登录,清空用户信息
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:KCurrentUserInfo];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    //清空token
    [USER_DEFALT setObject:@"" forKey:tokenForApp];
    //清空城市名
    [USER_DEFALT setObject:@"" forKey:KLocationInfo];
    //清除推送注册别名
    [NOTI_CENTER postNotificationName:KClearUserAliasToJpush object:nil];
    //跳转至登录页
    [ZSLogInManager gotoLogInViewCtrl:viewCtrl isCanDismissSelf:NO];
}

@end
