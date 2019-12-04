//
//  ZSChangeNameViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/6.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSChangeNameViewController.h"

@interface ZSChangeNameViewController ()
@property(nonatomic,strong)UITextField *nameTxt;
@end

@implementation ZSChangeNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"修改姓名" withBackBtn:YES];
    [self configureViews];
    //Data
    NSString *nameString = [ZSLogInManager readUserInfo].username;
    if (nameString && nameString.length > 0) {
        self.nameTxt.text = [ZSLogInManager readUserInfo].username;
        [self setBottomBtnEnable:YES];
    }
}

- (void)configureViews
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, ZSWIDTH, CellHeight)];
    backgroundView.backgroundColor = ZSColorWhite;
    [self.view addSubview:backgroundView];
    
    UILabel *label_old = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth,0,70, CellHeight)];
    label_old.font = [UIFont systemFontOfSize:15];
    label_old.textColor = ZSColorListLeft;
    label_old.text = @"姓名";
    [backgroundView addSubview:label_old];
    
    self.nameTxt = [[UITextField alloc]initWithFrame:CGRectMake(GapWidth + label_old.width, 0, ZSWIDTH - GapWidth*2 - label_old.width, CellHeight)];
    self.nameTxt.placeholder = @"请输入姓名";
    self.nameTxt.font = [UIFont systemFontOfSize:15];
    self.nameTxt.textAlignment = NSTextAlignmentRight;
    self.nameTxt.inputAccessoryView = [self addToolbar];
    [self.nameTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:self.nameTxt];
    
    //确定按钮
    [self configuBottomButtonWithTitle:@"确定" OriginY:backgroundView.bottom + 15];
    [self setBottomBtnEnable:NO];//默认不可点击
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    //输入限制
    NSString *currentString = textField.text;
    NSString *currentLang = [[textField textInputMode] primaryLanguage];// 键盘输入模式
    //中文输入法下,只对已输入完成的文字进行字数统计和限制
    if ([currentLang isEqualToString:@"zh-Hans"] == YES)// 简体中文输入，包括简体拼音，健体五笔，简体手写
    {
        //获取高亮部分
        UITextRange *markedRange = [textField markedTextRange];
        UITextPosition *markedPosition = [textField positionFromPosition:markedRange.start offset:0];
        
        if (!markedPosition)
        {
            if (currentString.length > LengthLimitDefault) {
                textField.text = [currentString substringToIndex:LengthLimitDefault];
            }
        }
        
    }
    else
    {
        if (currentString.length > LengthLimitDefault) {
            textField.text = [currentString substringToIndex:LengthLimitDefault];
        }
    }
    
    //底部按钮
    if (self.nameTxt.text.length > 0) {
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
    if (self.nameTxt.text.length == 0) {
        [ZSTool showMessage:@"请输入姓名" withDuration:DefaultDuration];
        return;
    }
    
    //键盘回收
    [self hideKeyboard];
    
    //修改姓名
    __weak typeof(self) weakSelf = self;
    [ZSLogInManager changeUserInfoWithRequest:ZSUserName withString:self.nameTxt.text withID:nil withResult:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
