//
//  ZSSetPasswordViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSSetPasswordViewController.h"
#import "ZSTabBarViewController.h"
#import "ZSLogInViewController.h"
#import "ZSChooseIdentityViewController.h"

@interface ZSSetPasswordViewController ()
@property(nonatomic,strong)UITextField *nameTxt;           //姓名
@property(nonatomic,strong)UITextField *passwordTxt;
@property(nonatomic,strong)UITextField *againPasswordTxt;
@end

@implementation ZSSetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"设置密码" withBackBtn:YES];
    [self configureViews];
}

#pragma mark 创建页面
- (void)configureViews
{
    //底色
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, CellHeight*2)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
  
    //注册的时候可以填写姓名
    if (self.setType ==ZSRegister)
    {
        backgroundView.height = CellHeight * 3;
        
        //输入框--姓名
        self.nameTxt = [[UITextField alloc]initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth*2, CellHeight)];
        self.nameTxt.font = [UIFont systemFontOfSize:15];
        self.nameTxt.placeholder = @"请输入姓名";
        self.nameTxt.inputAccessoryView = [self addToolbar];
        [self.nameTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [backgroundView addSubview:self.nameTxt];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, self.nameTxt.bottom-0.5, backgroundView.width-GapWidth*2, 0.5)];
        lineView.backgroundColor = ZSColorLine;
        [backgroundView addSubview:lineView];
    }
    
    //输入框-密码
    self.passwordTxt = [[UITextField alloc]initWithFrame:CGRectMake(GapWidth, self.nameTxt.bottom, ZSWIDTH-GapWidth*2, CellHeight)];
    self.passwordTxt.font = [UIFont systemFontOfSize:15];
    self.passwordTxt.placeholder = @"请输入密码";
    self.passwordTxt.inputAccessoryView = [self addToolbar];
    [self.passwordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTxt.secureTextEntry = YES;
    [backgroundView addSubview:self.passwordTxt];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, self.passwordTxt.bottom, backgroundView.width-GapWidth*2, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView];
  
    //输入框-确认密码
    self.againPasswordTxt = [[UITextField alloc]initWithFrame:CGRectMake(GapWidth, self.passwordTxt.bottom,  ZSWIDTH-30, CellHeight)];
    self.againPasswordTxt.font = [UIFont systemFontOfSize:15];
    self.againPasswordTxt.placeholder = @"请再次输入密码";
    self.againPasswordTxt.inputAccessoryView = [self addToolbar];
    [self.againPasswordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.againPasswordTxt.secureTextEntry = YES;
    [backgroundView addSubview:self.againPasswordTxt];
  
    //提交按钮
    [self configuBottomButtonWithTitle:@"提交" OriginY:backgroundView.bottom+15];
    [self setBottomBtnEnable:NO];//默认不可点击
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    //输入限制
    if (textField == self.nameTxt)
    {
        if (textField.text.length > LengthLimitDefault) {
            textField.text = [textField.text substringToIndex:LengthLimitDefault];
        }
    }
    else
    {
        if (textField.text.length > LengthMAXLimitPassword) {
            textField.text = [textField.text substringToIndex:LengthMAXLimitPassword];
        }
    }
    
    //底部按钮
    if (self.passwordTxt.text.length>0 && self.againPasswordTxt.text.length>0) {
        [self setBottomBtnEnable:YES];//恢复点击
    }
    else {
        [self setBottomBtnEnable:NO];//不可点击
    }
}

#pragma mark 提交
- (void)bottomClick:(UIButton *)sender
{
    if (self.passwordTxt.text.length == 0 || self.againPasswordTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入密码" withDuration:DefaultDuration];
        return;
    }
    else if (![ZSTool isPassword:self.passwordTxt.text] || ![ZSTool isPassword:self.againPasswordTxt.text]) {
        [ZSTool showMessage:@"密码不符合规则,请重新输入" withDuration:DefaultDuration];
        return;
    }
    else if (self.passwordTxt.text.length < LengthMINLimitPassword || self.againPasswordTxt.text.length < LengthMINLimitPassword) {
        [ZSTool showMessage:[NSString stringWithFormat:@"密码长度不能少于%d位",LengthMINLimitPassword] withDuration:DefaultDuration];
        return;
    }
    else if (![self.passwordTxt.text isEqualToString:self.againPasswordTxt.text]) {
        [ZSTool showMessage:@"两次密码输入不一致" withDuration:DefaultDuration];
        return;
    }
    else
    {
        //键盘回收
        [self hideKeyboard];
        
        //1.注册设置密码
        __weak typeof(self) weakSelf = self;
        if (self.setType == ZSRegister)
        {
            NSMutableDictionary *dict = @{
                                          @"telephone":self.userphone,
                                          @"password":self.passwordTxt.text
                                          }.mutableCopy;
            [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getRegisteredURL] SuccessBlock:^(NSDictionary *dic) {
                //调用登录接口
                [ZSLogInManager logInWithAccount:self.userphone withPassword:self.passwordTxt.text withResult:^(BOOL isSuccess) {
                    //提示
                    [ZSTool showMessage:@"注册成功" withDuration:DefaultDuration];
                    //选择身份
                    ZSChooseIdentityViewController *setpasswordVC = [[ZSChooseIdentityViewController alloc]init];
                    [weakSelf presentViewController:setpasswordVC animated:NO completion:nil];
                    //设置姓名
                    [weakSelf setUserName];
                }];
            } ErrorBlock:^(NSError *error) {
                [ZSTool showMessage:@"注册失败" withDuration:DefaultDuration];
            }];
        }
        //2.忘记密码设置密码
        else if (self.setType == ZSForgetPassword)
        {
            NSMutableDictionary *dict = @{
                                          @"telephone":self.userphone,
                                          @"newPassword":self.passwordTxt.text
                                          }.mutableCopy;
            [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getRsetPassword] SuccessBlock:^(NSDictionary *dic) {
                //调用登录接口
                [ZSLogInManager logInWithAccount:self.userphone withPassword:self.passwordTxt.text withResult:^(BOOL isSuccess) {
                    //提示
                    [ZSTool showMessage:@"密码设置成功" withDuration:DefaultDuration];
                }];
            } ErrorBlock:^(NSError *error) {
                [ZSTool showMessage:@"密码设置失败" withDuration:DefaultDuration];
            }];
        }
    }
}

#pragma mark 修改姓名
- (void)setUserName
{
    if (self.nameTxt.text.length)
    {
        [ZSLogInManager changeUserInfoWithRequest:ZSUserName withString:self.nameTxt.text withID:nil withResult:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
