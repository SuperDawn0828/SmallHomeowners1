//
//  ZSLogInViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/26.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSLogInViewController.h"
#import "ZSTabBarViewController.h"
#import "ZSRegisteredViewController.h"
#import "ZSForgetPasswordViewController.h"

@interface ZSLogInViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *phoneTxt;
@property(nonatomic,strong)UITextField *passwordTxt;
@property(nonatomic,assign)NSInteger   i_phoneNumber;
@end

@implementation ZSLogInViewController

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
    self.view.backgroundColor = ZSColorWhite;
    [self configureViews];
}

#pragma mark 创建页面
- (void)configureViews
{
    //暂不登录按钮
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.frame = CGRectMake(20, kNavigationBarHeight, 60, 24);
    [skipBtn setImage:[UIImage imageNamed:@"tool_guanbi_high"] forState:UIControlStateNormal];
    skipBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -36, 0, 36);
    [skipBtn addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
    skipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:skipBtn];
    
    //logo
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake((ZSWIDTH-158.9)/2, kNavigationBarHeight+74, 158.9, 28.8)];
    logoImage.image = [UIImage imageNamed:@"login_logo_n"];
    [self.view addSubview:logoImage];
    
    //输入框-用户名
    self.phoneTxt = [[UITextField alloc]initWithFrame:CGRectMake(20, logoImage.bottom+60, ZSWIDTH-40, 30)];
    self.phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTxt.font = [UIFont systemFontOfSize:15];
    self.phoneTxt.placeholder = @"请输入手机号";
//    [self.phoneTxt setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:self.phoneTxt.placeholder attributes:@{NSForegroundColorAttributeName : ZSColorAllNotice}];
    self.phoneTxt.attributedPlaceholder = arrStr;
    self.phoneTxt.delegate = self;
    self.phoneTxt.inputAccessoryView = [self addToolbar];
    [self.phoneTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.phoneTxt];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, self.phoneTxt.bottom, ZSWIDTH-40, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [self.view addSubview:lineView];
    self.i_phoneNumber = 0;
 
    //输入框-密码
    self.passwordTxt = [[UITextField alloc]initWithFrame:CGRectMake(20, lineView.bottom+20, ZSWIDTH-60, 30)];
    self.passwordTxt.font = [UIFont systemFontOfSize:15];
    self.passwordTxt.placeholder = @"请输入密码";
//    [self.passwordTxt setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
    NSMutableAttributedString *arrStr1 = [[NSMutableAttributedString alloc]initWithString:self.passwordTxt.placeholder attributes:@{NSForegroundColorAttributeName : ZSColorAllNotice}];
    self.passwordTxt.attributedPlaceholder = arrStr1;
    self.passwordTxt.delegate = self;
    self.passwordTxt.inputAccessoryView = [self addToolbar];
    [self.passwordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTxt.secureTextEntry = YES;
    [self.view addSubview:self.passwordTxt];
    UIView *lineView_psw = [[UIView alloc]initWithFrame:CGRectMake(20, self.passwordTxt.bottom, ZSWIDTH-40, 0.5)];
    lineView_psw.backgroundColor = ZSColorLine;
    [self.view addSubview:lineView_psw];
 
    //是否显示密码按钮
    UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeBtn.frame = CGRectMake(ZSWIDTH-30-20,lineView.bottom+20, 30, 30);
    [seeBtn addTarget:self action:@selector(seeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [seeBtn setImage:[UIImage imageNamed:@"login_password_n"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"login_password_s"] forState:UIControlStateSelected];
    [self.view addSubview:seeBtn];
 
    //登陆按钮
    [self configuBottomButtonWithTitle:@"登录" OriginY:self.passwordTxt.bottom+20];
    [self setBottomBtnEnable:NO];//默认不可点击

    //注册按钮
    UIButton *registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registeredBtn.frame = CGRectMake(20,self.bottomBtn.bottom+10, 75, CellHeight);
    [registeredBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    registeredBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    registeredBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [registeredBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
    [registeredBtn addTarget:self action:@selector(registeredBtnAction) forControlEvents:UIControlEventTouchUpInside];
    registeredBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:registeredBtn];
    
    //忘记密码按钮
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(ZSWIDTH-75-20,self.bottomBtn.bottom+10, 75, CellHeight);
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    forgetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [forgetBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:forgetBtn];
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    //输入限制
    if (textField == self.phoneTxt) {
        if (textField.text.length > self.i_phoneNumber) {
            if (textField.text.length == 4 || textField.text.length == 9 ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
                [str insertString:@" " atIndex:(textField.text.length-1)];
                textField.text = str;
            }if (textField.text.length >= 13 ) {//输入完成
                textField.text = [textField.text substringToIndex:13];
                [textField resignFirstResponder];
            }
            self.i_phoneNumber = textField.text.length;
            
        }else if (textField.text.length < self.i_phoneNumber){//删除
            if (textField.text.length == 4 || textField.text.length == 9) {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length-1)];
            }
            self.i_phoneNumber = textField.text.length;
        }
    }
    else if (textField == self.passwordTxt) {
        if (textField.text.length > LengthMAXLimitPassword) {
            textField.text = [textField.text substringToIndex:LengthMAXLimitPassword];
        }
    }
    
    //底部按钮
    if (self.phoneTxt.text.length>0 && self.passwordTxt.text.length>0) {
        [self setBottomBtnEnable:YES];//恢复点击
    }
    else
    {
        [self setBottomBtnEnable:NO];//不可点击
    }
}

#pragma mark 查看密码
- (void)seeBtnAction:(UIButton *)btn
{
    if (btn.selected == NO) {
        btn.selected = YES;
        self.passwordTxt.secureTextEntry = NO;//显示密码
    }else{
        btn.selected = NO;
        self.passwordTxt.secureTextEntry = YES;//隐藏
    }
}

#pragma mark 跳过登录
- (void)skipBtnAction
{
    //键盘回收
    [self hideKeyboard];
    
//    if (self.isCanDismiss == YES)
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
//    {
        ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
        APPDELEGATE.window.rootViewController = tabbarVC;
//    }
}

#pragma mark 登录
- (void)bottomClick:(UIButton *)sender
{
    if (self.phoneTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入账号" withDuration:DefaultDuration];
        return;
    }
    else if (self.passwordTxt.text.length == 0){
        [ZSTool showMessage:@"请输入密码" withDuration:DefaultDuration];
        return;
    }
    else if (self.passwordTxt.text.length < LengthMINLimitPassword) {
        [ZSTool showMessage:[NSString stringWithFormat:@"密码长度不能少于%d位",LengthMINLimitPassword] withDuration:DefaultDuration];
        return;
    }
    else
    {
        //键盘回收
        [self hideKeyboard];
        //登录
        [ZSLogInManager logInWithAccount:[ZSTool filteringTheBlankSpace:self.phoneTxt.text] withPassword:self.passwordTxt.text withResult:^(BOOL isSuccess) {
            ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
            APPDELEGATE.window.rootViewController = tabbarVC;
        }];
    }
}

#pragma mark 注册
- (void)registeredBtnAction
{
    ZSRegisteredViewController *registerVC = [[ZSRegisteredViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}

#pragma mark 忘记密码
- (void)forgetBtnAction
{
    ZSForgetPasswordViewController *forgetVC = [[ZSForgetPasswordViewController alloc]init];
    [self presentViewController:forgetVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
