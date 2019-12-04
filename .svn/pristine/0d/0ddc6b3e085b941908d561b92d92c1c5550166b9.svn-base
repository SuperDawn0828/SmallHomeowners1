//
//  ZSPersonalViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/26.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSPersonalViewController.h"
#import "ZSLogInViewController.h"
#import "ZSPersonalDetailCell.h"
#import "ZSCertificationViewController.h"
#import "ZSPersonalDetailViewController.h"
#import "ZSChangePasswordViewController.h"
#import "ZSAboutViewController.h"
#import "ZSCalendarViewController.h"
#import <UShareUI/UShareUI.h>
#import "ZSDaySignSmallView.h"

@interface ZSPersonalViewController ()<ZSAlertViewDelegate>
@property(nonatomic,strong)ZSDaySignSmallView   *daySignView;
@property(nonatomic,strong)UIImageView          *headIcon;
@property(nonatomic,strong)UILabel              *namelabel;
@property(nonatomic,strong)UIButton             *authBtn;
@property(nonatomic,strong)UILabel              *companyLabel;
@end

@implementation ZSPersonalViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //Data
    [self getUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureTable];
    [self configureHeaderView];
}

#pragma mark 获取个人信息
- (void)getUserInfo
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getUserInformation] SuccessBlock:^(NSDictionary *dic) {
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSLogInManager saveUserInfoWithDic:newdic];
        //Data
        [weakSelf initData];
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 数据填充
- (void)initData
{
    ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
    //头像
    if (userInfo.headPhoto) {
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,userInfo.headPhoto]] placeholderImage:ImageName(@"个人-选中")];
    }
    //姓名
    if (userInfo.username) {
        self.namelabel.text = userInfo.username;
        self.namelabel.width = [ZSTool getStringWidth:self.namelabel.text withframe:CGSizeMake(200, 16) withSizeFont:FontMain];
    }
    
    if (userInfo.userType.intValue == 1) {
        //认证标签
        self.authBtn.hidden = NO;
        NSString *string = [ZSUidInfo getAuthState:userInfo.authState];
        if ([string isEqualToString:@"未认证"]) {
            string = @"去认证";
        }
        [self.authBtn setTitle:string forState:UIControlStateNormal];
        self.authBtn.left = self.namelabel.right + 5;
        self.authBtn.width = [ZSTool getStringWidth:[ZSUidInfo getAuthState:userInfo.authState] withframe:CGSizeMake(100, 18) withSizeFont:[UIFont systemFontOfSize:12]] + 10;
        //角色部门标签
        if (userInfo.company && userInfo.position) {
            self.companyLabel.hidden = NO;
            self.companyLabel.text = [NSString stringWithFormat:@"%@ | %@",userInfo.company,userInfo.position];
        }
        else if (userInfo.company && !userInfo.position) {
            self.companyLabel.hidden = NO;
            self.companyLabel.text = [NSString stringWithFormat:@"%@",userInfo.company];
        }
        else if (!userInfo.company && userInfo.position) {
            self.companyLabel.hidden = NO;
            self.companyLabel.text = [NSString stringWithFormat:@"%@",userInfo.position];
        }
    }
    
}

#pragma mark 顶部header
- (void)configureHeaderView
{
    [self configureNavgationBar:@"" withBackBtn:NO];
    self.navView.frame = CGRectMake(0, 0, ZSWIDTH, 178);
    self.tableView.tableHeaderView = self.navView;
    
    //日签
    self.daySignView = [[ZSDaySignSmallView alloc]initWithFrame:CGRectMake(0, -140, ZSWIDTH, 140)];
    [self.navView addSubview:self.daySignView];
    
    //头像
    UIView *headIconBgview = [[UIView alloc]init];
    headIconBgview.frame =  IS_iPhoneX ? CGRectMake(30, 82, 60, 60) : CGRectMake(30, 62, 60, 60);
    headIconBgview.backgroundColor = ZSColorWhite;
    headIconBgview.layer.cornerRadius = 30;
    headIconBgview.layer.masksToBounds = YES;
    [self.navView addSubview:headIconBgview];
    
    self.headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 56, 56)];
    self.headIcon.layer.cornerRadius = 28;
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.userInteractionEnabled = YES;
    self.headIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.headIcon.image = ImageName(@"个人-选中");
    [headIconBgview addSubview:self.headIcon];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImgShow:)];
    [self.headIcon addGestureRecognizer:tap];
    
    //姓名
    self.namelabel = [[UILabel alloc]init];
    self.namelabel.frame =  IS_iPhoneX ? CGRectMake(110,92, 0, 20) : CGRectMake(110,72, 0, 20);
    self.namelabel.textColor = ZSColorWhite;
    self.namelabel.font = FontMain;
    self.namelabel.textAlignment = NSTextAlignmentLeft;
    self.namelabel.text = @"";
    [self.navView addSubview:self.namelabel];
    
    //认证标签
    self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.authBtn.frame =  IS_iPhoneX ? CGRectMake(self.namelabel.right+5, 93, 50, 18) : CGRectMake(self.namelabel.right+5, 73, 50, 18);
    [self.authBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    self.authBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.authBtn.layer.cornerRadius = 3;
    self.authBtn.layer.borderWidth = 0.7;
    self.authBtn.layer.borderColor = ZSColorWhite.CGColor;
    [self.authBtn addTarget:self action:@selector(authBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.authBtn];
    self.authBtn.hidden = YES;
    
    //角色部门标签
    self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, self.namelabel.bottom+8, ZSWIDTH-110-15, 40)];
    self.companyLabel.font = [UIFont systemFontOfSize:14];
    self.companyLabel.textColor = ZSColorWhite;
    self.companyLabel.textAlignment = NSTextAlignmentLeft;
    self.companyLabel.numberOfLines = 0;
    self.companyLabel.hidden = YES;
    [self.navView addSubview:self.companyLabel];
}

#pragma mark 创建table
- (void)configureTable
{
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT - kTabbarHeight) withStyle:UITableViewStylePlain];
    
    //footer
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = backgroundView;
    
    //退出按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0,10, ZSWIDTH, CellHeight);
    logoutBtn.backgroundColor = ZSColorWhite;
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [logoutBtn setTitleColor:ZSColorGolden forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:logoutBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl] || [APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl_port]) {
        return 4;
    }
    else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSPersonalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSPersonalDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.leftLabel.textColor = ZSColorListRight;
    }
    //赋值
    NSArray *array_img   = @[@"my_personal_information_n",@"my_modify_password_n",@"my_about_n",@"my_clean_n",@"my_share_n"];
    NSArray *array_title = @[@"个人信息",@"修改密码",@"关于",@"清除缓存",@"推荐给朋友"];
    cell.leftImage.image = [UIImage imageNamed:array_img[indexPath.row]];
    cell.leftLabel.text = array_title[indexPath.row];
    if (indexPath.row == 3) {
        //获取图片缓存大小
        CGFloat size = [[SDImageCache sharedImageCache] getSize];
        CGFloat totalSize = size/1000.0/1000.0;
        cell.rightLabel.text = [NSString stringWithFormat:@"%.2f MB",totalSize];
        cell.rightLabel.textColor = ZSColorAllNotice;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //个人信息
    if (indexPath.row == 0)
    {
        ZSPersonalDetailViewController *detailVC = [[ZSPersonalDetailViewController alloc]init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    //修改密码
    else if (indexPath.row == 1)
    {
        ZSChangePasswordViewController *changeVC = [[ZSChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    //关于
    else if (indexPath.row == 2)
    {
        ZSAboutViewController *aboutVC = [[ZSAboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    //清除缓存
    else if (indexPath.row == 3)
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确定要清空缓存吗?" sureTitle:@"确定" cancelTitle:@"取消"];
        alert.delegate = self;
        alert.tag = 100;
        [alert show];
    }
    //分享
    else if (indexPath.row == 4)
    {
        BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
        if (!hadInstalledWeixin){
            [ZSTool showMessage:@"请先安装微信" withDuration:DefaultDuration];
        }else{
            [self shareAPP];
        }
    }
}

#pragma mark 点击头像
- (void)bigImgShow:(UITapGestureRecognizer*)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (imageView.image) {
        //1.创建photoBroseView对象
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        //2.赋值
        ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
        if (userInfo.headPhoto) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,userInfo.headPhoto]];
        }else{
            photoBroseView.images = @[[UIImage imageNamed:@"个人-选中"]];
        }
        photoBroseView.showFromView = tap.view;
        photoBroseView.hiddenToView = tap.view;
        photoBroseView.currentIndex = 0;
        //3.显示
        [photoBroseView show];
    }
}

#pragma mark 点击认证按钮
- (void)authBtnAction
{
    ZSCertificationViewController *certifitcationVC = [[ZSCertificationViewController alloc]init];
    if ([self.authBtn.titleLabel.text isEqualToString:@"未认证"]) {
        certifitcationVC.cerType = ZSFromPersonalWithUnauthorized;
    }
    else{
        certifitcationVC.cerType = ZSFromPersonalWithCertified;
    }
    [self.navigationController pushViewController:certifitcationVC animated:YES];
}

#pragma mark 分享
- (void)shareAPP
{
    NSString *title = @"小房主应用下载";
    NSString *describe = @"实时掌握房产资讯，提高贷款效率，快来下载吧！";
    NSString *webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.xiaofangzhu.agent";
    UIImage  *image = ImageName(@"about_logo_n");
    
    //设置平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    //创建分享
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:describe thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = webpageUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            // [self alertWithError:error];
        }];
    }];
}

#pragma mark 退出
- (void)loginOutClick
{
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确定要退出吗?" sureTitle:@"确定" cancelTitle:@"取消"];
    alert.delegate = self;
    alert.tag = 110;
    [alert show];
}

- (void)AlertView:(ZSAlertView *)alert
{
    if (alert.tag == 100)
    {
        __weak typeof(self) weakSelf = self;
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [ZSTool showMessage:@"清除成功" withDuration:DefaultDuration];
            [weakSelf.tableView reloadData];
        }];
    }
    else if (alert.tag == 110)
    {
        [ZSLogInManager userLogOut:self];
    }
}

#pragma mark tableView滑动,修改日签View的提示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -120)
    {
        self.daySignView.noticeLabel.text = hilightString;
    }
    else
    {
        self.daySignView.noticeLabel.text = normalString;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
{
    if (scrollView.contentOffset.y <= -120)
    {
        ZSCalendarViewController *calendarVC = [[ZSCalendarViewController alloc]init];
        //创建动画
        CATransition *animation = [CATransition animation];
        //设置运动轨迹的速度
        //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
        //设置动画类型为立方体动画
        animation.type = @"moveIn";
        //设置动画时长
        animation.duration = 0.5f;
        //设置运动的方向
        animation.subtype = kCATransitionFromBottom;
        //控制器间跳转动画
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
        [self.navigationController pushViewController:calendarVC animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
