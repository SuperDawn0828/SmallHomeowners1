//
//  ChangePasswordViewController.m
//  ZSSmallLandlord
//
//  Created by cong on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSChangePasswordViewController.h"
#import "ZSLogInViewController.h"

@interface ZSChangePasswordViewController ()
@property(nonatomic,strong)UITextField *oldPassword;
@property(nonatomic,strong)UITextField *NewPassword;
@property(nonatomic,strong)UITextField *againPasswordTxt;
@end

@implementation ZSChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavgationBar:@"修改密码" withBackBtn:YES];
    [self configureViews];
}

- (void)configureViews
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, ZSWIDTH, CellHeight*3)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
   
    //旧密码
    UILabel *label_old = [[UILabel alloc]initWithFrame:CGRectMake(15,0,70, CellHeight)];
    label_old.font = [UIFont systemFontOfSize:15];
    label_old.textColor = ZSColorListLeft;
    label_old.text = @"旧密码";
    [backgroundView addSubview:label_old];
    self.oldPassword = [[UITextField alloc]initWithFrame:CGRectMake(label_old.right+10, 0, ZSWIDTH-110, CellHeight)];
    self.oldPassword.placeholder = @"请输入旧密码";
    self.oldPassword.font = [UIFont systemFontOfSize:15];
    self.oldPassword.textAlignment = NSTextAlignmentRight;
    self.oldPassword.inputAccessoryView = [self addToolbar];
    self.oldPassword.secureTextEntry = YES;
    [self.oldPassword addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.oldPassword];
    //分割线
    UIView *oldLineView = [[UIView alloc]initWithFrame:CGRectMake(15, CellHeight-0.5  , ZSWIDTH-15, 0.5)];
    [self.oldPassword addSubview:oldLineView];
    
    //新密码
    UILabel *label_new = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight,70, CellHeight)];
    label_new.font = [UIFont systemFontOfSize:15];
    label_new.textColor = ZSColorListLeft;
    label_new.text = @"新密码";
    [backgroundView addSubview:label_new];
    self.NewPassword = [[UITextField alloc]initWithFrame:CGRectMake(label_new.right+10,CellHeight, ZSWIDTH-110, CellHeight)];
    self.NewPassword.placeholder = @"请输入新密码";
    self.NewPassword.font = [UIFont systemFontOfSize:15];
    self.NewPassword.textAlignment = NSTextAlignmentRight;
    self.NewPassword.inputAccessoryView = [self addToolbar];
    self.NewPassword.secureTextEntry = YES;
    [self.NewPassword addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.NewPassword];
    //分割线
    UIView *newLineView = [[UIView alloc]initWithFrame:CGRectMake(15, CellHeight-0.5  , ZSWIDTH-15, 0.5)];
    [self.NewPassword addSubview:newLineView];
    
    //第二次新密码
    UILabel *label_newagain = [[UILabel alloc]initWithFrame:CGRectMake(15,CellHeight*2,70, CellHeight)];
    label_newagain.font = [UIFont systemFontOfSize:15];
    label_newagain.textColor = ZSColorListLeft;
    label_newagain.text = @"确认密码";
    [backgroundView addSubview:label_newagain];
    self.againPasswordTxt = [[UITextField alloc]initWithFrame:CGRectMake(label_newagain.right+10,CellHeight*2, ZSWIDTH-110, CellHeight)];
    self.againPasswordTxt.placeholder = @"确认密码";
    self.againPasswordTxt.font = [UIFont systemFontOfSize:15];
    self.againPasswordTxt.textAlignment = NSTextAlignmentRight;
    self.againPasswordTxt.inputAccessoryView = [self addToolbar];
    self.againPasswordTxt.secureTextEntry = YES;
    [self.againPasswordTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.againPasswordTxt];
    //分割线
    UIView *againLineView = [[UIView alloc]initWithFrame:CGRectMake(15, CellHeight-0.5  , ZSWIDTH-15, 0.5)];
    [self.againPasswordTxt addSubview:againLineView];
  
    //确定按钮
    [self configuBottomButtonWithTitle:@"确定" OriginY:backgroundView.bottom + 15];
    [self setBottomBtnEnable:NO];//默认不可点击
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    //输入限制
    if (textField.text.length > LengthMAXLimitPassword) {
        textField.text = [textField.text substringToIndex:LengthMAXLimitPassword];
    }
    
    //底部按钮
    if (self.oldPassword.text.length>0 && self.NewPassword.text.length>0 && self.againPasswordTxt.text.length>0) {
        [self setBottomBtnEnable:YES];//恢复点击
    }
    else
    {
        [self setBottomBtnEnable:NO];//不可点击
    }
}

#pragma mark 确定
- (void)bottomClick:(UIButton *)sender
{
    if (self.oldPassword.text.length == 0) {
        [ZSTool showMessage:@"请输入旧密码" withDuration:DefaultDuration];
        return;
    }else if (self.NewPassword.text.length == 0 || self.againPasswordTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入新密码" withDuration:DefaultDuration];
        return;
    }
    else if (self.NewPassword.text.length < LengthMINLimitPassword || self.againPasswordTxt.text.length < LengthMINLimitPassword) {
        [ZSTool showMessage:[NSString stringWithFormat:@"密码长度不能少于%d位",LengthMINLimitPassword] withDuration:DefaultDuration];
        return;
    }
    else if (![ZSTool isPassword:self.NewPassword.text] || ![ZSTool isPassword:self.againPasswordTxt.text]) {
        [ZSTool showMessage:@"密码不符合规则,请重新输入" withDuration:DefaultDuration];
        return;
    }
    else if (![self.NewPassword.text isEqualToString:self.againPasswordTxt.text]) {
        [ZSTool showMessage:@"两次密码输入不一致" withDuration:DefaultDuration];
        return;
    }
    
    //键盘回收
    [self hideKeyboard];
    
    //修改密码接口
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"oldPassword":self.oldPassword.text,
                                  @"newPassword":self.NewPassword.text
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getChangePassword] SuccessBlock:^(NSDictionary *dic) {
        //提示
        [ZSTool showMessage:@"密码修改成功" withDuration:DefaultDuration];
        //修改本地储存的密码
        [USER_DEFALT setObject:self.NewPassword.text forKey:LoginPassword];
        //返回上个页面
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } ErrorBlock:^(NSError *error) {
    }];
}

@end
