//
//  ZSRegisteredViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/6/4.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSRegisteredViewController.h"
#import "ZSSetPasswordViewController.h"

@interface ZSRegisteredViewController ()
@property(nonatomic,strong)UITextField *phoneTxt;
@property(nonatomic,strong)UITextField *codeTxt;
@property(nonatomic,strong)UIButton    *getcodeBtn;
@property(nonatomic,assign)NSInteger   i_phoneNumber;
@end

@implementation ZSRegisteredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"注册" withBackBtn:YES];
    [self configureViews];
}

#pragma mark 创建页面
- (void)configureViews
{
    //底色
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, CellHeight*2)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
    
    //输入框-手机号
    self.phoneTxt = [[UITextField alloc]initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth*2, CellHeight)];
    self.phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTxt.font = [UIFont systemFontOfSize:15];
    self.phoneTxt.placeholder = @"请输入手机号";
    self.phoneTxt.inputAccessoryView = [self addToolbar];
    [self.phoneTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.phoneTxt];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, self.phoneTxt.bottom, backgroundView.width-GapWidth*2, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView];
    self.i_phoneNumber = 0;
    
    //输入框-验证码
    self.codeTxt = [[UITextField alloc]initWithFrame:CGRectMake(GapWidth, self.phoneTxt.bottom, 100, CellHeight)];
    self.codeTxt.font = [UIFont systemFontOfSize:15];
    self.codeTxt.placeholder = @"验证码";
    self.codeTxt.inputAccessoryView = [self addToolbar];
    [self.codeTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.codeTxt];
    
    //分割线
    UIView *lineView_s = [[UIView alloc]initWithFrame:CGRectMake(ZSWIDTH-130, self.phoneTxt.bottom+12, 0.5, 20)];
    lineView_s.backgroundColor = ZSColorLine;
    [backgroundView addSubview:lineView_s];
    
    //获取验证码按钮
    self.getcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getcodeBtn.frame = CGRectMake(lineView_s.right,self.phoneTxt.bottom,130, CellHeight);
    [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getcodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.getcodeBtn setTitleColor:ZSColorGolden forState:UIControlStateNormal];
    [self.getcodeBtn addTarget:self action:@selector(getcodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:self.getcodeBtn];
    
    //提交按钮
    [self configuBottomButtonWithTitle:@"注册" OriginY:backgroundView.bottom+15];
    [self setBottomBtnEnable:NO];//默认不可点击]
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
    else if (textField == self.codeTxt) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
    
    //底部按钮
    if (self.phoneTxt.text.length>0 && self.codeTxt.text.length>0) {
        [self setBottomBtnEnable:YES];//恢复点击
    }
    else
    {
        [self setBottomBtnEnable:NO];//不可点击
    }
}

#pragma mark 获取验证码
- (void)getcodeBtnAction
{
    if (self.phoneTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入手机号" withDuration:DefaultDuration];
        return;
    }
    else if (![ZSTool isMobileNumber:self.phoneTxt.text]) {
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        return;
    }
    else
    {
        //键盘回收
        [self hideKeyboard];
        
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *dict = @{
                                      @"telephone":[ZSTool filteringTheBlankSpace:self.phoneTxt.text],
                                      @"bizType":@"1"
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
        }];
    }
}

#pragma mark 提交注册(验证验证码)
- (void)bottomClick:(UIButton *)sender
{
    if (self.phoneTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入手机号" withDuration:DefaultDuration];
        return;
    }else if (![ZSTool isMobileNumber:self.phoneTxt.text]){
        [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
        return;
    }else if (self.codeTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入验证码" withDuration:DefaultDuration];
        return;
    }
    
    //键盘回收
    [self hideKeyboard];
    
    //验证验证码
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"telephone":[ZSTool filteringTheBlankSpace:self.phoneTxt.text],
                                  @"validateCode":self.codeTxt.text,
                                  @"bizType":@"1"
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getVerificationCodeCompare] SuccessBlock:^(NSDictionary *dic) {
        ZSSetPasswordViewController *setpasswordVC = [[ZSSetPasswordViewController alloc]init];
        setpasswordVC.userphone = [ZSTool filteringTheBlankSpace:weakSelf.phoneTxt.text];
        setpasswordVC.setType = ZSRegister;
        [weakSelf presentViewController:setpasswordVC animated:NO completion:nil];
    } ErrorBlock:^(NSError *error) {
    }];
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
                [self.getcodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getcodeBtn setTitleColor:ZSColorGolden forState:UIControlStateNormal];
                self.getcodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.getcodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds]  forState:UIControlStateNormal];
                [self.getcodeBtn setTitleColor:ZSColorAllNotice forState:UIControlStateNormal];
                self.getcodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
