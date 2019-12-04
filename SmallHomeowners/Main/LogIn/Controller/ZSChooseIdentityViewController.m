//
//  ZSChooseIdentityViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/27.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSChooseIdentityViewController.h"
#import "ZSCertificationViewController.h"
#import "ZSTabBarViewController.h"
#import "ZSPositionViewController.h"
#import "ZSCityModel.h"

@interface ZSChooseIdentityViewController ()<LocationManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton    *skipBtn;
@property (weak, nonatomic) IBOutlet UIButton    *mediationBtn;
@property (weak, nonatomic) IBOutlet UIButton    *personalBtn;
@property (weak, nonatomic) IBOutlet UILabel     *mediationLabel;
@property (weak, nonatomic) IBOutlet UILabel     *personalLabel;
@property (weak, nonatomic) IBOutlet UIButton    *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (nonatomic,assign) NSInteger           i_phoneNumber;
@property (nonatomic,copy  ) NSString            *btnType;       //0中介 1个人
@property (nonatomic,strong) NSMutableArray      *dataArray;     //城市列表
@property (nonatomic,copy  ) NSString            *cityID;        //城市id
@end

@implementation ZSChooseIdentityViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

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
    [self setUI];
    [self iniData];
}

#pragma mark /*------------------------------------------数据展示------------------------------------------*/
- (void)iniData
{
    //获取位置信息
    NSString *cityString = [USER_DEFALT objectForKey:KLocationInfo];
    if (cityString.length)
    {
        [self.cityBtn setTitle:cityString forState:UIControlStateNormal];
        [self.cityBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
        
        if ([cityString isEqualToString:@"定位中"] || [cityString isEqualToString:@"定位失败"]) {
            LocationManager *manger = [LocationManager shareInfo];
            manger.delegate = self;
            [manger startPositioning];
        }
        else
        {
            if (self.dataArray.count == 0) {
                [self requestData:cityString];
            }
            else{
                [self findCityID:cityString];
            }
            //修改所在城市
            [ZSLogInManager changeUserInfoWithRequest:ZSCityName withString:cityString withID:self.cityID withResult:nil];
        }
    }
    else
    {
        LocationManager *manger = [LocationManager shareInfo];
        manger.delegate = self;
        [manger startPositioning];
    }
}

#pragma mark LocationManagerDelegate 定位之后的城市
- (void)currentCityInfo:(NSString *)string;//当前城市信息
{
    [self.cityBtn setTitle:string forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];

    if (![string isEqualToString:@"定位中"] && ![string isEqualToString:@"定位失败"]) {
        if (self.dataArray.count == 0) {
            [self requestData:string];
        }
        else{
            [self findCityID:string];
        }
        //修改所在城市
        [ZSLogInManager changeUserInfoWithRequest:ZSCityName withString:string withID:self.cityID withResult:nil];
    }
}

- (void)requestData:(NSString *)cityName
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getOpenBusinessCity] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSCityModel *model = [ZSCityModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf findCityID:cityName];
        }
    } ErrorBlock:^(NSError *error) {
    }];
}

//遍历数组根据城市名查找城市id
- (void)findCityID:(NSString *)cityName
{
    for (ZSCityModel *model in self.dataArray) {
        if ([model.city isEqualToString:cityName]) {
            self.cityID = model.cityId;
            return;
        }
    }
}

#pragma mark /*------------------------------------------设置样式------------------------------------------*/
- (void)setUI
{
    self.view.backgroundColor = ZSColorWhite;
    
    self.mediationBtn.layer.cornerRadius = 40;
    [self.mediationBtn setImage:[UIImage imageNamed:@"经纪人-选中"] forState:UIControlStateNormal];
    self.mediationLabel.textColor = ZSColorGolden;
    self.btnType = @"5";

    self.personalBtn.layer.cornerRadius = 40;
    self.personalBtn.layer.borderWidth = 2;
    self.personalBtn.layer.borderColor = ZSColorAllNotice.CGColor;
    [self.personalBtn setImage:[UIImage imageNamed:@"个人-未选中"] forState:UIControlStateNormal];
    
    self.phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
//    [self.phoneTxt setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:self.phoneTxt.placeholder attributes:@{NSForegroundColorAttributeName : ZSColorAllNotice}];
    self.phoneTxt.attributedPlaceholder = arrStr;
    [self.phoneTxt addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTxt.delegate = self;
    self.i_phoneNumber = 0;

    [self configuBottomButtonWithTitle:@"下一步"];//默认下一步 选择中介写下一步,个人写提交
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    //输入限制
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

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    //手机号不为空
    if (self.phoneTxt.text.length > 0)
    {
        if (![ZSTool isMobileNumber:[ZSTool filteringTheBlankSpace:self.phoneTxt.text]]) {
            [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
            return;
        }
        
        //上传推荐人手机号码
        [ZSLogInManager changeUserInfoWithRequest:ZSRefereesPhoneNum withString:[ZSTool filteringTheBlankSpace:self.phoneTxt.text] withID:nil withResult:nil];
    }
}

#pragma mark /*------------------------------------------事件------------------------------------------*/
#pragma mark 跳过选择身份
- (IBAction)skipChooseIdentify:(id)sender
{
    ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
    APPDELEGATE.window.rootViewController = tabbarVC;
}

#pragma mark 选择中介身份
- (IBAction)chooseMediation:(id)sender
{
    [self.mediationBtn setImage:[UIImage imageNamed:@"经纪人-选中"] forState:UIControlStateNormal];
    self.mediationBtn.layer.borderWidth = 0;
    [self.personalBtn setImage:[UIImage imageNamed:@"个人-未选中"] forState:UIControlStateNormal];
    self.personalBtn.layer.borderWidth = 2;
    self.personalBtn.layer.borderColor = ZSColorAllNotice.CGColor;
    self.mediationLabel.textColor = ZSColorGolden;
    self.personalLabel.textColor = [UIColor lightGrayColor];
    [self.bottomBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.btnType = @"5";
}

#pragma mark 选择个人身份
- (IBAction)choosePersonal:(id)sender
{
    [self.mediationBtn setImage:[UIImage imageNamed:@"经纪人-未选中"] forState:UIControlStateNormal];
    self.mediationBtn.layer.borderWidth = 2;
    self.mediationBtn.layer.borderColor = ZSColorAllNotice.CGColor;
    [self.personalBtn setImage:[UIImage imageNamed:@"个人-选中"] forState:UIControlStateNormal];
    self.personalBtn.layer.borderWidth = 0;
    self.mediationLabel.textColor = [UIColor lightGrayColor];
    self.personalLabel.textColor = ZSColorGolden;
    [self.bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.btnType = @"6";
}

#pragma mark 选择所在城市
- (IBAction)chooseCity:(id)sender
{
    __weak typeof(self) weakSelf = self;
    ZSPositionViewController *positionVC = [[ZSPositionViewController alloc]init];
    positionVC.postionBlock = ^(NSString *cityName){
        [weakSelf.cityBtn setTitle:cityName forState:UIControlStateNormal];
        [weakSelf.cityBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
    };
    [self presentViewController:positionVC animated:YES completion:nil];
}

#pragma mark 提交审核
- (void)bottomClick:(UIButton *)sender
{
    if (self.btnType == nil) {
        [ZSTool showMessage:@"请选择身份" withDuration:DefaultDuration];
        return;
    }

    //修改角色类型
    __weak typeof(self) weakSelf = self;
    if ([self.btnType isEqualToString:@"5"])
    {
        [ZSLogInManager changeUserInfoWithRequest:ZSRoletype withString:self.btnType withID:nil withResult:^(BOOL isSuccess) {
            if (isSuccess) {
                ZSCertificationViewController *certifitcationVC = [[ZSCertificationViewController alloc]init];
                certifitcationVC.cerType = ZSFromRegister;
                [weakSelf presentViewController:certifitcationVC animated:NO completion:nil];
            }
        }];
    }
    else if ([self.btnType isEqualToString:@"6"])
    {
        [ZSLogInManager changeUserInfoWithRequest:ZSRoletype withString:self.btnType withID:nil withResult:^(BOOL isSuccess) {
            if (isSuccess) {
                ZSTabBarViewController *tabbarVC = [[ZSTabBarViewController alloc]init];
                APPDELEGATE.window.rootViewController = tabbarVC;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
