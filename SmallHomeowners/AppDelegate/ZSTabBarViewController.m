//
//  ZSTabBarViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSTabBarViewController.h"
#import "ZSNavViewController.h"
#import "ZSHomeViewController.h"
#import "ZSOrderListViewController.h"
#import "ZSNotificationViewController.h"
#import "ZSPersonalViewController.h"
#import "ZSLenderInfoViewController.h"
#import "ZSCreateOrderPopupModel.h"
#import "ZSTabBar.h"
#import "ZSNewHomeViewController.h"
#import "WTHomeViewController.h"
@interface ZSTabBarViewController ()<UITabBarControllerDelegate,ZSCreateOrderPopupViewDelegate,ZSAlertViewDelegate>

@end

@implementation ZSTabBarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [NOTI_CENTER addObserver:self selector:@selector(createOrderBtnAction) name:KgotoCreateOrderNoti object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [NOTI_CENTER removeObserver:self name:KgotoCreateOrderNoti object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.selectedIndex = 0;//默认选择第一页
    self.delegate = self;
    [self initTabBar];
    [self requestData];
}

#pragma mark 获取可创建订单的产品列表
- (void)requestData
{
    if (global.productArray.count == 0)
    {
        NSMutableArray *productArray = [[NSMutableArray alloc]init];
        [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getOnlineProducts] SuccessBlock:^(NSDictionary *dic) {
            NSArray *array = dic[@"respData"];
            if (array.count > 0) {
                for (NSDictionary *dict in array) {
                    ZSCreateOrderPopupModel *model = [ZSCreateOrderPopupModel yy_modelWithDictionary:dict];
                    [productArray addObject:model];
                }
                global.productArray = productArray;
            }
            else if (array.count == 0)
            {
                [ZSTool showMessage:@"暂无可操作产品" withDuration:DefaultDuration];
            }
        } ErrorBlock:^(NSError *error) {
        }];
    }
}

#pragma mark 创建tabbar
- (void)initTabBar
{
    ZSTabBar *tabBar = [[ZSTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    //创建子控制器
    NSMutableArray *viewCtrlArray = [[NSMutableArray alloc]init];
   
    //首页
//    ZSHomeViewController *homeVC = [[ZSHomeViewController alloc]init];
    WTHomeViewController *homeVC = [[WTHomeViewController alloc]init];
    homeVC.title = @"首页";
    homeVC.tabBarItem.image = [ImageName(@"bottom_home_n") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [ImageName(@"bottom_home_s") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZSNavViewController *homeNavVC = [[ZSNavViewController alloc] initWithRootViewController:homeVC];
    [viewCtrlArray addObject:homeNavVC];
  
    //订单
    ZSOrderListViewController *orderVC = [[ZSOrderListViewController alloc]init];
    orderVC.title = @"订单";
    orderVC.tabBarItem.image = [ImageName(@"bottom_tool_n") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderVC.tabBarItem.selectedImage = [ImageName(@"bottom_tool_s") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZSNavViewController *orderNavVC = [[ZSNavViewController alloc] initWithRootViewController:orderVC];
    [viewCtrlArray addObject:orderNavVC];
 
    //创建订单
    [tabBar.createOrderBtn addTarget:self action:@selector(createOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
   
    //消息
    ZSNotificationViewController *messageVC = [[ZSNotificationViewController alloc]init];
    messageVC.title = @"消息";
    messageVC.tabBarItem.image = [ImageName(@"bottom_notice_n") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageVC.tabBarItem.selectedImage = [ImageName(@"bottom_notice_s") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZSNavViewController *messageNavVC = [[ZSNavViewController alloc] initWithRootViewController:messageVC];
    [viewCtrlArray addObject:messageNavVC];
 
    //我的
    ZSPersonalViewController *personalVC = [[ZSPersonalViewController alloc]init];
    personalVC.title = @"我";
    personalVC.tabBarItem.image = [ImageName(@"bottom_my_n") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalVC.tabBarItem.selectedImage = [ImageName(@"bottom_my_s") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZSNavViewController *personalNavVC = [[ZSNavViewController alloc] initWithRootViewController:personalVC];
    [viewCtrlArray addObject:personalNavVC];
  
    self.viewControllers = viewCtrlArray;
}

#pragma mark 点击tabbarItem自动调用
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    //判断是否登录
    if (index != 0) {
        if (![ZSLogInManager isLogIn]) {
            [ZSLogInManager gotoLogInViewCtrl:self.viewControllers[self.selectedIndex] isCanDismissSelf:YES];
            return;
        }
    }
    //按钮图片缩放动画
    [self animationWithIndex:index];
}

//tabbar按钮缩放动画
- (void)animationWithIndex:(NSInteger)index
{
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    //只图标做动画，文字不做动画
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            for (UIView *subView in tabBarButton.subviews) {
                if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [tabbarbuttonArray addObject:subView];
                }
            }
        }
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:1];
    pulse.toValue = [NSNumber numberWithFloat:1.2];
   
    UIView *v = tabbarbuttonArray[index];
    [v.layer addAnimation:pulse forKey:nil];
}

#pragma mark 点击"创建订单"的按钮调用
//显示创建订单弹窗
- (void)createOrderBtnAction
{
    if (![ZSLogInManager isLogIn])
    {
        [ZSLogInManager gotoLogInViewCtrl:self.viewControllers[self.selectedIndex] isCanDismissSelf:YES];
        return;
    }
    else
    {
        if (global.productArray.count > 0) {
            ZSCreateOrderPopupView *createView = [[ZSCreateOrderPopupView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
            createView.delegate = self;
            [createView show];
        }
        else
        {
            [self requestData];
        }
    }
}

//跳转到创建订单页面  ZSCreateOrderPopupViewDelegate
- (void)selectProductWithType:(NSString *)prdType
{
    if ([prdType isEqualToString:kProduceTypeEasyLoans])
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"申请安居消费贷需要下载“华安信宝APP”后注册申请，是否确认前往下载？"];
        alert.delegate = self;
        [alert show];
    }
    else
    {
        ZSLenderInfoViewController *createVC = [[ZSLenderInfoViewController alloc]init];
        global.prdType = prdType;
        global.pcOrderDetailModel = nil;
        createVC.personType = ZSFromCreateOrderWithAdd;
        createVC.roleTypeString = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款人"]];
        [self.viewControllers[self.selectedIndex] pushViewController:createVC animated:YES];
    }
}

- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.sinosafe.xb.client&fromcase=40002"]];
}

#pragma mark 收到推送,重设选中的index
- (void)resetCurrentIndex:(NSInteger)index;
{
    self.selectedIndex = index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
