//
//  AppDelegate.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/25.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "IQKeyboardManager.h"
#import "Reachability.h"
#import "ZSVersionUpdateView.h"
#import "ZSReLoginView.h"
#import "ZSTabBarViewController.h"
#import "ZSLogInViewController.h"
#import "ZSGetAPIViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <CoreTelephony/CTCellularData.h>

static NSString *const KJpushAppKey    = @"1f6162e292f5ba46475cc104";                    //极光推送APPKey
static NSString *const KUMAppKey       = @"5b3dba7aa40fa33e96000074";                    //友盟统计APPKey
static NSString *const KWXAppID        = @"wx2f1109b41c54ac54";                          //微信APPID
static NSString *const KWXAppSercet    = @"91f65316d8c0f9be56f756417b847197";            //微信APPKey
static NSString *const KWXRedirectURL  = @"http://mobile.umeng.com/social";              //微信auth2.0认证的url

@interface AppDelegate ()<ZSVersionUpdateViewDelegate,ZSReLoginViewDelegate,JPUSHRegisterDelegate,ZSAlertViewDelegate>
@property (nonatomic,copy  ) NSString               *versionUpdateUrl;
@property (nonatomic,assign) BOOL                   serverAddress;  //yes为生产,no为测试
@property (nonatomic,strong) ZSTabBarViewController *tabbarVC;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //友盟初始化
    [self configureUM];
    
    //键盘相关
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//自动上移
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    
    //监测网络权限状态和联网状态
    [self chechoutNetworkAuthorization];
    [self chechoutNetwork];
    
    //检测版本更新
    [NOTI_CENTER addObserver:self selector:@selector(checkVerisonUpdate) name:KSCheckVerisonUpdate object:nil];
    
    //极光推送
    [self configureJpush:launchOptions];
    [NOTI_CENTER addObserver:self selector:@selector(sendUserAliasToJpush) name:KSSendUserAliasToJpush object:nil];
    [NOTI_CENTER addObserver:self selector:@selector(clearUserAliasToJpush) name:KClearUserAliasToJpush object:nil];

    //配置服务器地址（//yes为生产,no为测试）
    self.serverAddress = NO;
    if (self.serverAddress == YES) {
        //---------------------------------------------------预生产／正式环境---------------------------------------------------------
        //先判断本地储存的服务器地址是不是正式的
        NSString *stringUrl    = [USER_DEFALT objectForKey:APIAddress];
        NSString *stringImgUrl = [USER_DEFALT objectForKey:APIImgAddress];
        NSLog(@"本地储存的服务器地址:%@",stringUrl);
        if ([stringUrl isEqualToString:KFormalServerUrl] || [stringUrl isEqualToString:[NSString stringWithFormat:@"%@/",KFormalServerUrl]] ||
            [stringUrl isEqualToString:KFormalServerUrl_port] || [stringUrl isEqualToString:[NSString stringWithFormat:@"%@/",KFormalServerUrl_port]]) {
            //API赋值
            self.zsurlHead  = stringUrl;
            self.zsImageUrl = stringImgUrl;
            //判断是否登录
            ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
            if (userInfo.userid) {
                self.tabbarVC = [[ZSTabBarViewController alloc]init];
                self.window.rootViewController = self.tabbarVC;
            }else{
                self.window.rootViewController = [[ZSLogInViewController alloc]init];//进入登录页
            }
            //检查版本更新
            [self performSelector:@selector(checkVerisonUpdate) withObject:self afterDelay:1];
        }
        else
        {
            self.zsurlHead  = KPreProductionUrl;
            self.zsImageUrl = KPreProductionImgUrl;
            self.window.rootViewController = [[ZSGetAPIViewController alloc]init];//进入获取API的页面
        }
    }
    else
    {
        /*---------------------------------------------------测试环境---------------------------------------------------------*/
        self.zsurlHead  = KTestServerUrl;
        self.zsImageUrl = KTestServerImgUrl;

        //判断是否登录
        ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
        if (userInfo.userid) {
            self.tabbarVC = [[ZSTabBarViewController alloc]init];
            self.window.rootViewController = self.tabbarVC;
        }else{
            self.window.rootViewController = [[ZSLogInViewController alloc]init];//进入登录页
        }
        //检查版本更新
        [self performSelector:@selector(checkVerisonUpdate) withObject:self afterDelay:1];
    }

    self.window.backgroundColor = ZSColorWhite;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark /*-------------------------------------友盟平台-------------------------------------*/
#pragma mark 友盟初始化
- (void)configureUM
{
    //只有测试环境能打开日志
    if ([self.zsurlHead isEqualToString:KTestServerUrl]) {
        [UMConfigure setLogEnabled:YES];//设置打开日志
    }
    else{
        [UMConfigure setLogEnabled:NO];
    }
    
    //设置成用version作区分而不是build
    NSInteger version = (NSInteger)[ZSTool localVersionShort];
    [UMConfigure setVersion:version];
    
    //初始化
    [UMConfigure initWithAppkey:KUMAppKey channel:@"App Store"];
    
    //友盟分享平台初始化
    [self configUSharePlatforms];
}

#pragma mark 友盟分享平台初始化
- (void)configUSharePlatforms
{
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:KWXAppID appSecret:KWXAppSercet redirectURL:KWXRedirectURL];
    //移除相应平台的分享，如微信收藏
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
}

#pragma mark 友盟分享回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark /*-------------------------------------禁用第三方输入键盘-------------------------------------*/
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

#pragma mark /*---------------------------------------监测网络授权状态和联网---------------------------------------*/
- (void)chechoutNetworkAuthorization
{
    //1.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    //2.此函数会在网络权限改变时再次调用
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
    {
        if (state == kCTCellularDataRestricted)
        {
            NSLog(@"网络未授权");
            if (global.netStatus == 0) {
                [self checkNetworkPermission];
            }
        }
        else if (state == kCTCellularDataNotRestricted)
        {
            NSLog(@"网络已授权");
        }
        else if (state == kCTCellularDataRestrictedStateUnknown)
        {
            NSLog(@"Unknown");
        }
    };
}

#pragma mark 网络未授权
- (void)checkNetworkPermission
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"无法连接网络,请检查网络授权配置" cancelTitle:@"取消" sureTitle:@"确定"];
        alert.delegate = self;
        [alert show];
    });
}

#pragma mark 跳转到设置页开启网络权限
- (void)AlertView:(ZSAlertView *)alert;
{
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:appSettings]) {
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

#pragma mark 监听联网状态
- (void)chechoutNetwork
{
    [NOTI_CENTER addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    global.netStatus = [reachability currentReachabilityStatus];//获取当前网络状态
    [reachability startNotifier];
}

#pragma mark 监听联网状态
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *reach = [note object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reach currentReachabilityStatus];
    global.netStatus = status;
    if (status == NotReachable)
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"网络已断开" btnTitle:@"确定"];
        [alert show];
    }
}

#pragma mark /*---------------------------------------版本更新---------------------------------------*/
- (void)checkVerisonUpdate
{
    __weak typeof(self) weakSelf  = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getVersionUpdates] SuccessBlock:^(NSDictionary *dic) {
        NSString *currentVersion = [ZSTool localVersionShort];
        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *newVersion = dic[@"respData"][@"versions"];
        NSString *newnewVersion = dic[@"respData"][@"versions"];
        newVersion = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (newVersion.intValue > currentVersion.intValue)
        {
            NSString *content = dic[@"respData"][@"content"];
            weakSelf.versionUpdateUrl = dic[@"respData"][@"url"];
            NSString *forcedupdate = dic[@"respData"][@"forcedupdate"];
            //弹窗高度自适应
            CGSize size = CGSizeMake(ZSWIDTH-53*2,10000);
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
            CGSize labelsize = [content boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                                NSStringDrawingUsesLineFragmentOrigin  |
                                NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            //强制更新
            if ([forcedupdate isEqualToString:@"是"]) {
                ZSVersionUpdateView *alert = [[ZSVersionUpdateView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withVersion:newnewVersion withNotice:content withNoticeHeight:labelsize.height withForced:YES] ;
                alert.delegate = weakSelf;
                [alert show];
            }
            else
            {
                //非强制更新
                ZSVersionUpdateView *alert = [[ZSVersionUpdateView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withVersion:newnewVersion withNotice:content withNoticeHeight:labelsize.height withForced:NO
                                              ] ;
                alert.delegate = weakSelf;
                [alert show];
            }
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark ZSVersionUpdateViewDelegate
- (void)sureClick:(ZSVersionUpdateView *)updateView
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.versionUpdateUrl]]) {
        if (iOS10Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionUpdateUrl] options:@{} completionHandler:^(BOOL success) {
                //1.回调后先移除弹窗
                [updateView removeFromSuperview];
                //2.再判断一下是否更新
                [self checkVerisonUpdate];
            }];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionUpdateUrl]];
        }
    }
}

#pragma mark /*---------------------------------------token失效重新登录---------------------------------------*/
- (void)checkTokenState
{
    ZSReLoginView *logInView = [[ZSReLoginView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    logInView.delegate = self;
    [logInView show];
}

#pragma mark ZSReLoginViewDelegate
- (void)gotoRelogin
{
    //退出登录,清空用户信息
    NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:KCurrentUserInfo];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath1 error:nil];
    //跳转至登录页
    self.window.rootViewController = [[ZSLogInViewController alloc]init];
}

#pragma mark /*---------------------------------------极光推送---------------------------------------*/
- (void)configureJpush:(NSDictionary *)launchOptions
{
    //--------------------------初始化APNs----------------------------
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //--------------------------初始化Jpush----------------------------
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    BOOL isProduct = [self.zsurlHead isEqualToString:KTestServerUrl] ? 0 : 1;
    ZSLOG(@"是否是正式环境:%d",isProduct);
    [JPUSHService setupWithOption:launchOptions
                           appKey:KJpushAppKey
                          channel:@"App Store"
                 apsForProduction:isProduct //0(默认值)表示采用的是开发证书，1表示采用生产证书发布应用。
            advertisingIdentifier:nil];
}

#pragma mark 注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark 注册APNs失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark 处理APNs通知回调方法
//app在前台时收到消息调用该方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
API_AVAILABLE(ios(10.0))API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    NSLog(@"前台收到推送消息了");
    //通知通知列表刷新
    [NOTI_CENTER postNotificationName:KSUpdateNotiList object:nil];
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

//app在后台时收到消息调用该方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
API_AVAILABLE(ios(10.0))API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    NSLog(@"收到推送消息了");
    //app从后台唤醒, 进入通知页面
    self.tabbarVC.selectedIndex = 2;
    [self.tabbarVC resetCurrentIndex:2];
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(); //系统要求执行这个方法
}

#pragma mark 登录成功后将用户ID作为极光推送的alias
- (void)sendUserAliasToJpush
{
    //根据不同环境传递不一样的 测试agent_test_  预生产agent_uat_  生产agent_prod_
    ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
    NSString *newAlias;
    if ([self.zsurlHead isEqualToString:KTestServerUrl]) {
        newAlias = [NSString stringWithFormat:@"a_test_%@",userInfo.tid];
    }
    else if ([self.zsurlHead isEqualToString:KPreProductionUrl] || [self.zsurlHead isEqualToString:KPreProductionUrl_port]) {
        newAlias = [NSString stringWithFormat:@"a_uat_%@",userInfo.tid];
    }
    else if ([self.zsurlHead isEqualToString:KFormalServerUrl] || [self.zsurlHead isEqualToString:KFormalServerUrl_port]) {
        newAlias = [NSString stringWithFormat:@"a_prod_%@",userInfo.tid];
    }
    [JPUSHService setTags:nil aliasInbackground:newAlias];
}

- (void)clearUserAliasToJpush
{
    [JPUSHService setAlias:@"" callbackSelector:nil object:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    ZSLOG("->app将进入后台了 applicationWillResignActive()\n");
    //最后把Iconbadge归0
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    ZSLOG("->app已经进入后台了 applicationDidEnterBackground()\n");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    ZSLOG("->app将进入前台了 applicationWillEnterForeground()\n");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    ZSLOG("->app已经进入前台了 applicationDidBecomeActive()\n");
    //判断定位权限
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways))
    {
        //重新发送定位信息
        [NOTI_CENTER postNotificationName:KToReposition object:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    ZSLOG("->application 将要终止了  applicationWillTerminate()\n");
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
