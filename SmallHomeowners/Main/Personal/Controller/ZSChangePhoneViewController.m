//
//  ZSChangePhoneViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/31.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSChangePhoneViewController.h"

@interface ZSChangePhoneViewController ()
@property(nonatomic,strong)UITextField *phoneTxt;
@property(nonatomic,strong)UITextField *codeTxt;
@property(nonatomic,strong)UITextField *passwordTxt;
@property(nonatomic,strong)UIButton    *getCodeBtn;
@property(nonatomic,assign)NSInteger   i_phoneNumber;//定义全局变量
@end

@implementation ZSChangePhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"手机号" withBackBtn:YES];
    [self initChangePhoneNumberView];
}

#pragma mark 已绑定-更换手机号
- (void)initChangePhoneNumberView
{
    //背景view
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, ZSWIDTH, 155)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
  
    //手机图标
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((ZSWIDTH-70)/2, 15,85, 85)];
    imgview.image = [UIImage imageNamed:@"list_binding_n"];
    [backgroundView addSubview:imgview];
    
    //手机号
    UILabel *label_phone = [[UILabel alloc]initWithFrame:CGRectMake(0,imgview.bottom+20, ZSWIDTH, 15)];
    label_phone.textColor = ZSColorListLeft;
    label_phone.font = [UIFont systemFontOfSize:15];
    label_phone.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:label_phone];
    ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
    label_phone.text = [NSString stringWithFormat:@"手机号码: %@",userInfo.telphone];
  
    //底部按钮
    [self configuBottomButtonWithTitle:@"更换手机号" OriginY:backgroundView.bottom + 15];
}

#pragma mark 绑定手机号
- (void)initBindingView
{
    //先移除底部按钮
    if (self.bottomBtn) {
        [self.bottomBtn removeFromSuperview];
    }
 
    //背景view
    UIView *backgroundView_gray = [[UIView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, ZSWIDTH, ZSHEIGHT)];
    backgroundView_gray.backgroundColor = ZSViewBackgroundColor;
    [self.view addSubview:backgroundView_gray];

    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight*3)];
    backgroundView.backgroundColor = ZSColorWhite;
    [backgroundView_gray addSubview:backgroundView];
 
    //登录密码
    UILabel *label_newagain = [[UILabel alloc]initWithFrame:CGRectMake(15,0,70, CellHeight)];
    label_newagain.font = [UIFont systemFontOfSize:15];
    label_newagain.textColor = ZSColorListLeft;
    label_newagain.text = @"登录密码";
    [backgroundView addSubview:label_newagain];
    self.passwordTxt = [[UITextField alloc]initWithFrame:CGRectMake(label_newagain.right+10,0, ZSWIDTH-110, CellHeight)];
    self.passwordTxt.placeholder = @"请输入";
    self.passwordTxt.font = [UIFont systemFontOfSize:15];
    self.passwordTxt.textAlignment = NSTextAlignmentRight;
    self.passwordTxt.inputAccessoryView = [self addToolbar];
    self.passwordTxt.secureTextEntry = YES;
    [self.passwordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.passwordTxt];

    //手机号
    UILabel *label_old = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight,70, CellHeight)];
    label_old.font = [UIFont systemFontOfSize:15];
    label_old.textColor = ZSColorListLeft;
    label_old.text = @"新手机号";
    [backgroundView addSubview:label_old];
    self.phoneTxt = [[UITextField alloc]initWithFrame:CGRectMake(label_old.right+10, CellHeight, ZSWIDTH-110, CellHeight)];
    self.phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTxt.placeholder = @"请输入";
    self.phoneTxt.font = [UIFont systemFontOfSize:15];
    self.phoneTxt.textAlignment = NSTextAlignmentRight;
    self.phoneTxt.inputAccessoryView = [self addToolbar];
    [self.phoneTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.phoneTxt];
    self.i_phoneNumber = 0;
  
    //验证码
    UILabel *label_new = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight*2,70, CellHeight)];
    label_new.font = [UIFont systemFontOfSize:15];
    label_new.textColor = ZSColorListLeft;
    label_new.text = @"验证码";
    [backgroundView addSubview:label_new];
    self.codeTxt = [[UITextField alloc]initWithFrame:CGRectMake(label_new.right+10,CellHeight*2, ZSWIDTH-110-130, CellHeight)];
    self.codeTxt.placeholder = @"请输入";
    self.codeTxt.font = [UIFont systemFontOfSize:15];
    self.codeTxt.textAlignment = NSTextAlignmentLeft;
    self.codeTxt.inputAccessoryView = [self addToolbar];
    [self.codeTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.codeTxt];
 
    //分割线
    UIView *lineView_s = [[UIView alloc]initWithFrame:CGRectMake(ZSWIDTH-130, self.phoneTxt.bottom+12, 0.5, 20)];
    lineView_s.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView_s];

    //获取验证码按钮
    self.getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeBtn.frame = CGRectMake(lineView_s.right,self.phoneTxt.bottom,130, CellHeight);
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.getCodeBtn setTitleColor:ZSColorGolden forState:UIControlStateNormal];
    [self.getCodeBtn addTarget:self action:@selector(getCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:self.getCodeBtn];
  
    //分割线
    UIView *oldLineView = [[UIView alloc]initWithFrame:CGRectMake(15, CellHeight-0.5  , ZSWIDTH-15, 0.5)];
    [backgroundView addSubview:oldLineView];
    UIView *newLineView = [[UIView alloc]initWithFrame:CGRectMake(15, CellHeight*2-0.5  , ZSWIDTH-15, 0.5)];
    [backgroundView addSubview:newLineView];
    UIView *againLineView = [[UIView alloc]initWithFrame:CGRectMake(15, CellHeight*3-0.5  , ZSWIDTH-15, 0.5)];
    [backgroundView addSubview:againLineView];
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"确认" OriginY:self.navView.height + CellHeight*3 + 15];
    [self setBottomBtnEnable:NO];
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    //输入限制
    if (textField == self.passwordTxt)
    {
        if (textField.text.length > LengthMAXLimitPassword) {
            textField.text = [textField.text substringToIndex:LengthMAXLimitPassword];
        }
    }
    else if (textField == self.phoneTxt)
    {
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
    else if (textField == self.codeTxt)
    {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
    
    //底部按钮
    if ([self.bottomBtn.titleLabel.text isEqualToString:@"确认"]) {
        if (self.phoneTxt.text.length>0 && self.codeTxt.text.length>0 && self.passwordTxt.text.length > 0) {
            [self setBottomBtnEnable:YES];//恢复点击
        }else{
            [self setBottomBtnEnable:NO];//不可点击
        }
    }
}

#pragma mark 提交
- (void)bottomClick:(UIButton *)sender
{
    //键盘回收
    [self.passwordTxt resignFirstResponder];
    [self.phoneTxt    resignFirstResponder];
    [self.codeTxt resignFirstResponder];

    if ([sender.titleLabel.text isEqualToString:@"更换手机号"] ) {
        [self initBindingView];
    }
    else{
        [self updateUserInformation];
    }
}

#pragma mark 获取验证码
- (void)getCodeBtnAction
{
    if (self.passwordTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入密码" withDuration:DefaultDuration];
        return;
    }
    else if (self.phoneTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入手机号" withDuration:DefaultDuration];
        return;
    }
    else if (![ZSTool isMobileNumber:self.phoneTxt.text]) {
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        return;
    }
    else {
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *dict = @{
                                      @"telephone":[ZSTool filteringTheBlankSpace:self.phoneTxt.text],
                                      @"password":self.passwordTxt.text,
                                      @"bizType":@"3"
                                      }.mutableCopy;
        [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getVerificationCode] SuccessBlock:^(NSDictionary *dic) {
            [ZSTool showMessage:@"验证码发送成功,请注意查收" withDuration:DefaultDuration];
            [weakSelf openCountdown];
            //不是正式环境直接显示到框框里面
            if (![APPDELEGATE.zsurlHead isEqualToString:KFormalServerUrl]) {
                weakSelf.codeTxt.text = dic[@"respData"];
                [weakSelf setBottomBtnEnable:YES];
            }
        } ErrorBlock:^(NSError *error) {
            [ZSTool showMessage:@"发送失败,请重试" withDuration:DefaultDuration];
        }];
    }
}

#pragma mark 倒计时
- (void)openCountdown
{
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:ZSColorGolden forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds]  forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark 修改绑定的手机号
- (void)updateUserInformation
{
    if (self.passwordTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入密码" withDuration:DefaultDuration];
        return;
    }
    else if (self.phoneTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入手机号" withDuration:DefaultDuration];
        return;
    }
    else if (![ZSTool isMobileNumber:self.phoneTxt.text]) {
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        return;
    }
    else if (self.codeTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入验证码" withDuration:DefaultDuration];
        return;
    }
    else {
        //键盘回收
        [self hideKeyboard];
        
        //修改手机号(验证验证码接口,type传3就可以了)
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *dict = @{
                                      @"telephone":[ZSTool filteringTheBlankSpace:self.phoneTxt.text],
                                      @"validateCode":self.codeTxt.text,
                                      @"bizType":@"3"
                                      }.mutableCopy;
        [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getVerificationCodeCompare] SuccessBlock:^(NSDictionary *dic) {
            //保存个人信息
            NSDictionary *newdic = dic[@"respData"];
            [ZSLogInManager saveUserInfoWithDic:newdic];
            //提示
            [ZSTool showMessage:@"手机号修改成功" withDuration:DefaultDuration];
            //修改本地储存的手机号
            [USER_DEFALT setObject:[ZSTool filteringTheBlankSpace:self.phoneTxt.text] forKey:LoginAccount];
            //返回上个页面
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } ErrorBlock:^(NSError *error) {
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
