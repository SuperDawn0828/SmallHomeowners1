//
//  ZSGetAPIViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/11.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSGetAPIViewController.h"
#import "ZSTabBarViewController.h"
#import "ZSLogInViewController.h"

@interface ZSGetAPIViewController ()<ZSAlertViewDelegate>
@property (nonatomic,strong)UIImageView *imgView;
@end

@implementation ZSGetAPIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //设置状态栏字体颜色
    [self setStatusBarTextColorBlack];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //设置状态栏字体颜色
    [self setStatusBarTextColorWhite];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self getAPIAddress];
    [self configureErrorViewWithStyle:ZSErrorWithoutNetwork];//无网络
    [NOTI_CENTER addObserver:self selector:@selector(getAPIAddress) name:KRequestNetwork object:nil];//恢复网络后点击屏幕重新请求
}

- (void)initViews
{
    //图片
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    self.imgView.image = [UIImage imageNamed:@"apiimage_1242x2208"];
    [self.view addSubview:self.imgView];
}

- (void)getAPIAddress
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameterDict = @{@"category":[NSString stringWithFormat:@"agentAppServicePath%@",[ZSTool localVersionShort]]}.mutableCopy;
    [ZSRequestManager requestWithParameter:parameterDict url:[ZSURLManager getAppAccessURL] SuccessBlock:^(NSDictionary *dic) {
        NSString *zsurlHead = [NSString stringWithFormat:@"%@",dic[@"respData"]];
        //1.服务器地址未更换
        if ([zsurlHead isEqualToString:KPreProductionUrl] || [zsurlHead isEqualToString:[NSString stringWithFormat:@"%@/",KPreProductionUrl]] ||
            [zsurlHead isEqualToString:KPreProductionUrl_port] || [zsurlHead isEqualToString:[NSString stringWithFormat:@"%@/",KPreProductionUrl_port]])
        {
            ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
            if (userInfo.userid) {
                ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
                APPDELEGATE.window.rootViewController = tabbarVC;
            }
            else
            {
                APPDELEGATE.window.rootViewController = [[ZSLogInViewController alloc]init];
            }
        }
        
        //2.更换接口地址,并保存
        else
        {
            APPDELEGATE.zsurlHead  = zsurlHead;
            APPDELEGATE.zsImageUrl = KFormalServerImgUrl;
            [USER_DEFALT setObject:zsurlHead forKey:APIAddress];
            [USER_DEFALT setObject:KFormalServerImgUrl forKey:APIImgAddress];
            //2.1 更换成功后重新登录
            APPDELEGATE.window.rootViewController = [[ZSLogInViewController alloc]init];
        }
        
        //3.发送版本更新检查的通知
        [NOTI_CENTER postNotificationName:KSCheckVerisonUpdate object:nil];
        weakSelf.errorView.hidden = YES;
    }
    ErrorBlock:^(NSError *error)
     {
         weakSelf.imgView.hidden = YES;
         weakSelf.errorView.hidden = NO;
    }];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
