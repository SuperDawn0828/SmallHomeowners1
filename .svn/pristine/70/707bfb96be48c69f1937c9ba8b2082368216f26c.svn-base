//
//  ZSCertificationViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/28.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCertificationViewController.h"
#import "ZSCertificationView.h"
#import "ZSTabBarViewController.h"
#import "ZSCertificationView.h"

@interface ZSCertificationViewController ()<ZSCertificationViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel     *textLabel;
@property (weak, nonatomic) IBOutlet UILabel     *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton    *skipBtn;
@property (nonatomic,strong) UIImageView         *stateImage;         //认证图片
@property (nonatomic,strong) UILabel             *stateLabel;         //认证状态
@property (nonatomic,strong) ZSCertificationView *certificationView;  //认证资料
@end

@implementation ZSCertificationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setStatusBarTextColorBlack];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self setStatusBarTextColorWhite];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureViews];
    //Data
    if ([ZSLogInManager isLogIn]) {
        [self initData];
    }
}

#pragma mark 创建页面
- (void)configureViews
{
    if (self.cerType == ZSFromRegister)
    {
        //背景色
        self.view.backgroundColor = ZSColorWhite;
        
        //顶部提示
        self.textLabel.hidden = NO;
        self.noticeLabel.hidden = NO;
        self.skipBtn.hidden = NO;
        
        //资质认证填写
        self.certificationView = [[ZSCertificationView alloc]initWithFrame:CGRectMake(0, self.noticeLabel.bottom+30, ZSWIDTH, KCerViewHeight)];
        self.certificationView.delegate = self;
        self.certificationView.isCanUpload = YES;
        [self.view addSubview:self.certificationView];
        
        //底部按钮
        [self configuBottomButtonWithTitle:@"提交审核" OriginY: self.certificationView.bottom + 15];
        [self setBottomBtnEnable:NO];
    }
    else if (self.cerType == ZSFromPersonalWithUnauthorized)
    {
        //背景色
        self.view.backgroundColor = ZSViewBackgroundColor;
        
        //顶部提示
        self.textLabel.hidden = YES;
        self.noticeLabel.hidden = YES;
        self.skipBtn.hidden = YES;
        
        //navgationBar
        [self configureNavgationBar:@"资质认证" withBackBtn:YES];
        self.navView.backgroundColor = ZSColorWhite;
        [self setStatusBarTextColorBlack];
        self.titleLabel.textColor = ZSColorBlack;
        self.backImg.image = [UIImage imageNamed:@"head_return_black"];
        
        //资质认证填写
        self.certificationView = [[ZSCertificationView alloc]initWithFrame:CGRectMake(0, self.navView.bottom+10, ZSWIDTH, KCerViewHeight)];
        self.certificationView.delegate = self;
        self.certificationView.isCanUpload = YES;
        [self.view addSubview:self.certificationView];
        
        //底部按钮
        [self configuBottomButtonWithTitle:@"提交审核" OriginY: self.certificationView.bottom + 15];
        [self setBottomBtnEnable:NO];
    }
    else if (self.cerType == ZSFromPersonalWithCertified)
    {
        //背景色
        self.view.backgroundColor = ZSViewBackgroundColor;
        
        //顶部提示
        self.textLabel.hidden = YES;
        self.noticeLabel.hidden = YES;
        self.skipBtn.hidden = YES;
        
        //navgationBar
        [self configureNavgationBar:@"资质认证" withBackBtn:YES];
        self.navView.backgroundColor = ZSColorWhite;
        self.navView.frame = CGRectMake(0, 0, ZSWIDTH, kNavigationBarHeight+CellHeight);
        [self setStatusBarTextColorBlack];
        self.titleLabel.textColor = ZSColorBlack;
        self.backImg.image = [UIImage imageNamed:@"head_return_black"];
        
        //认证图片
        self.stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, kNavigationBarHeight+(CellHeight-24)/2, 24, 24)];
        [self.navView addSubview:self.stateImage];
        
        //认证状态
        self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.stateImage.right+10,kNavigationBarHeight,250, CellHeight)];
        self.stateLabel.font = FontMain;
        [self.navView addSubview:self.stateLabel];

        //资质认证填写
        self.certificationView = [[ZSCertificationView alloc]initWithFrame:CGRectMake(0, self.navView.bottom+10, ZSWIDTH, KCerViewHeight)];
        self.certificationView.delegate = self;
        self.certificationView.isCanUpload = NO;
        [self.view addSubview:self.certificationView];
        
        //不显示底部按钮,页面也不可以操作
        self.certificationView.companyView.userInteractionEnabled = NO;
        self.certificationView.positionView.userInteractionEnabled = NO;
    }
}

- (void)initData
{
    ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
    
    //认证状态
    if (userInfo.authState) {
        self.stateLabel.text = [ZSUidInfo getAuthState:userInfo.authState];
        if (userInfo.authState.intValue == 1) {
            self.stateImage.image = [UIImage imageNamed:@"list_in approval_n"];
            self.stateLabel.textColor = ZSColorYellow;
        }
        else if (userInfo.authState.intValue == 2) {
            self.stateImage.image = [UIImage imageNamed:@"list_completed_n"];
            self.stateLabel.textColor = ZSColorGreen;
        }
        else if (userInfo.authState.intValue == 3 || userInfo.authState.intValue == 4) {
            self.stateImage.image = [UIImage imageNamed:@"list_nouploaded_n"];
            self.stateLabel.textColor = ZSColorRed;
        }
    }
    
    //名片
    if (userInfo.visitingCard.length) {
        [self.certificationView.bussinessCardImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=300",APPDELEGATE.zsImageUrl,userInfo.visitingCard]] placeholderImage:ImageName(@"身份证正面")];
        self.certificationView.urlString = userInfo.visitingCard;
    }
    //公司
    if (userInfo.company) {
        self.certificationView.companyView.inputTextFeild.text = userInfo.company;
    }
    //职位
    if (userInfo.position) {
        self.certificationView.positionView.inputTextFeild.text = userInfo.position;
    }
    
    //底部按钮
    if (self.certificationView.urlString &&
        self.certificationView.companyView.inputTextFeild.text.length > 0 &&
        self.certificationView.positionView.inputTextFeild.text.length > 0)
    {
        [self setBottomBtnEnable:YES];
    }
}

#pragma mark 跳过资质认证
- (IBAction)skipChooseIdentify:(id)sender
{
    ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
    APPDELEGATE.window.rootViewController = tabbarVC;
}

#pragma mark ZSCertificationViewDelegate
- (void)sendCertificationData;
{
    [self setBottomBtnEnable:YES];
}

#pragma mark 提交审核
- (void)bottomClick:(UIButton *)sender
{
    if (self.certificationView.urlString == nil) {
        [ZSTool showMessage:@"请上传名片" withDuration:DefaultDuration];
        return;
    }
    else if (self.certificationView.companyView.inputTextFeild.text.length == 0) {
        [ZSTool showMessage:@"请上传公司名称" withDuration:DefaultDuration];
        return;
    }
    else if (self.certificationView.positionView.inputTextFeild.text.length == 0) {
        [ZSTool showMessage:@"请上传职位名称" withDuration:DefaultDuration];
        return;
    }
    
    //键盘回收
    [self hideKeyboard];
    
    //提交审核
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict = @{
                                  @"visitingCard":self.certificationView.urlString,
                                  @"company":self.certificationView.companyView.inputTextFeild.text,
                                  @"position":self.certificationView.positionView.inputTextFeild.text,
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getQualificationCertification] SuccessBlock:^(NSDictionary *dic) {
        [ZSTool showMessage:@"已提交,请耐心等待审核结果" withDuration:DefaultDuration];
        if (weakSelf.navigationController) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
            APPDELEGATE.window.rootViewController = tabbarVC;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } ErrorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
