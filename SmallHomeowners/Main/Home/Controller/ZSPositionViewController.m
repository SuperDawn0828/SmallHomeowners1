//
//  ZSPositionViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSPositionViewController.h"
#import "ZSCityModel.h"

#define SORT_ARRAY [[_cityDic allKeys]sortedArrayUsingSelector:@selector(compare:)]

static CGFloat TopViewHeight = 88;

@interface ZSPositionViewController ()<LocationManagerDelegate>
@property(nonatomic,strong)UIButton               *cityNameBtn; //定位城市
@property(nonatomic,strong)UILabel                *noticeLabel; //(暂不支持金融业务开展)
@property(nonatomic,strong)NSMutableDictionary    *cityDic;     //城市根据首字母分区字典
@property(nonatomic,copy  )NSString               *cityName;    //选中的定位城市
@property(nonatomic,copy  )NSString               *cityID;      //选中的定位城市id
@end

@implementation ZSPositionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"定位" withBackBtn:YES];
    [self configureTopView];
    [self configureTable];
    //Data
    [self initData];
    //添加重新定位的通知
    [NOTI_CENTER addObserver:self selector:@selector(rePosition) name:KToReposition object:nil];
}

#pragma mark /*---------------------------------------返回事件---------------------------------------*/
- (void)leftAction
{
    self.cityName = self.cityName ? self.cityName : self.cityNameBtn.titleLabel.text;
    
    //1.创建订单-选择贷款城市
    if (self.isFromCreateOrder)
    {
        if (self.postionBlock) {
            self.postionBlock(self.cityName);
        }
        if (self.cityID && self.cityIDBlock) {
            self.cityIDBlock(self.cityID);
        }
   
        //页面返回
        [self backAction];
    }
    else
    {
        //2.已登录情况,修改当前登录账号所在城市
        if ([ZSLogInManager isLogIn])
        {
            __weak typeof(self) weakSelf = self;
            [ZSLogInManager changeUserInfoWithRequest:ZSCityName withString:self.cityName withID:self.cityID withResult:^(BOOL isSuccess) {
                if (isSuccess)
                {
                    //block传值
                    if (weakSelf.postionBlock) {
                        weakSelf.postionBlock(weakSelf.cityName);
                    }
                    //页面返回
                    [weakSelf backAction];
                }
            }];
        }
        //3.未登录情况下,直接传值返回
        else
        {
            //block传值
            if (self.postionBlock) {
                self.postionBlock(self.cityName);
            }
            //页面返回
            [self backAction];
        }
    }
}

#pragma mark 页面返回
- (void)backAction
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark /*------------------------------------------位置信息------------------------------------------*/
- (void)initData
{
    //获取位置信息
    NSString *cityString = [USER_DEFALT objectForKey:KLocationInfo];
    if (cityString.length) {
        [self setCityLabelText:cityString];
        if ([cityString isEqualToString:@"定位中"] || [cityString isEqualToString:@"定位失败"]) {
            LocationManager *manger = [LocationManager shareInfo];
            manger.delegate = self;
            [manger startPositioning];
        }
    }
    else
    {
        //判断定位权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            [self setCityLabelText:@"请开启定位权限"];
        }
        else
        {
            LocationManager *manger = [LocationManager shareInfo];
            manger.delegate = self;
            [manger startPositioning];
        }
    }
    
    //获取开通业务的城市列表
    if (self.dataArray == nil) {
        //数组初始化
        self.dataArray = [[NSMutableArray alloc]init];
        //请求数据
        [self requestData];
    }
    else {
        [self pinyinFromChiniseString];
        [self.tableView reloadData];
    }
}

#pragma mark LocationManagerDelegate 定位获取的城市信息
- (void)currentCityInfo:(NSString *)string;
{
    [self setCityLabelText:string];
}

#pragma mark 城市信息展示
- (void)setCityLabelText:(NSString *)string
{
    if ([string isEqualToString:@"请开启定位权限"]) {
        //设置点击事件,点击跳转到设置权限的页面
        [self.cityNameBtn addTarget:self action:@selector(openAuthorizationStatus) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        //设置点击事件,点击返回上个页面
        //创建订单的时候,当前城市开通了金融业务,按钮才可以点击
        if (self.isFromCreateOrder)
        {
            if (self.cityID) {
                [self.cityNameBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            [self.cityNameBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [self.cityNameBtn setTitle:string forState:UIControlStateNormal];
    self.cityNameBtn.width = [ZSTool getStringWidth:string withframe:CGSizeMake(ZSWIDTH-GapWidth*2, 24) withSizeFont:FontSecondTitle]+10;
    self.noticeLabel.left = self.cityNameBtn.right + 5;
    [self findCity:string];
}

#pragma mark 进入设置开启定位权限
- (void)openAuthorizationStatus
{
    [[LocationManager shareInfo] openAuthorizationStatus];
}

#pragma mark 重新开始定位
- (void)rePosition
{
    LocationManager *manger = [LocationManager shareInfo];
    manger.delegate = self;
    [manger startPositioning];
}

#pragma mark /*------------------------------------------数据请求------------------------------------------*/
#pragma mark 获取城市列表
- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{}.mutableCopy;
    if (self.isFromCreateOrder) {
        [dict setObject:global.prdType forKey:@"prdType"];
    }
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getOpenBusinessCity] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSCityModel *model = [ZSCityModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf pinyinFromChiniseString];
            [weakSelf findCity:weakSelf.cityNameBtn.titleLabel.text];
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 根据首字母排序
- (void)pinyinFromChiniseString
{
    self.cityDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < self.dataArray.count; i++) {
        ZSCityModel *model = self.dataArray[i];
        NSString *cityPinYin = [model.cityPy uppercaseString]; //转大写
        NSString *firstLetter = [cityPinYin substringWithRange:NSMakeRange(0, 1)];//截取城市拼音的第一个字母
        if (![self.cityDic objectForKey:firstLetter])
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [self.cityDic setObject:array forKey:firstLetter];
        }
        [[self.cityDic objectForKey:firstLetter] addObject:model];
    }
}

#pragma mark 判断该城市是否开通了金融业务
- (void)findCity:(NSString *)cityName
{
    for (ZSCityModel *model in self.dataArray) {
        if ([model.city isEqualToString:cityName]) {
            self.noticeLabel.hidden = YES;
            self.cityID = model.cityId;
        }
    }
}

#pragma mark /*------------------------------------------顶部------------------------------------------*/
- (void)configureTopView
{
    UIView *positionView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, TopViewHeight)];
    [self.view addSubview:positionView];
    
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth*2, CellHeight)];
    positionLabel.font = FontSecondTitle;
    positionLabel.textColor = ZSColorBlack;
    positionLabel.text = @"定位城市";
    [positionView addSubview:positionLabel];
    
    //定位城市
    self.cityNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cityNameBtn.frame = CGRectMake(GapWidth, positionLabel.bottom , 100, 24);
    self.cityNameBtn.titleLabel.font = FontSecondTitle;
    [self.cityNameBtn setTitleColor:ZSColorBlack forState:UIControlStateNormal];
    self.cityNameBtn.layer.cornerRadius = 3;
    self.cityNameBtn.layer.borderColor = ZSColorGolden.CGColor;
    self.cityNameBtn.layer.borderWidth = 0.5;
    [positionView addSubview:self.cityNameBtn];
    
    //(暂不支持金融业务开展)
    self.noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.cityNameBtn.right+5, positionLabel.bottom , 140, 24)];
    self.noticeLabel.font = [UIFont systemFontOfSize:12];
    self.noticeLabel.textColor = ZSColorAllNotice;
    self.noticeLabel.text = @"(暂不支持金融业务开展)";
    self.noticeLabel.hidden = NO;
    [positionView addSubview:self.noticeLabel];
}

#pragma mark /*------------------------------------------创建table------------------------------------------*/
- (void)configureTable
{
    [self configureTableView:CGRectMake(0, kNavigationBarHeight + TopViewHeight, ZSWIDTH, ZSHEIGHT - kNavigationBarHeight - TopViewHeight) withStyle:UITableViewStylePlain];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *cityArrays = [self.cityDic objectForKey:SORT_ARRAY[section]];
    return cityArrays.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityDic.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 30)];
    sectionHeaderView.backgroundColor = ZSViewBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth*2, 30)];
    label.font = FontSecondTitle;
    label.textColor = ZSColorAllNotice;
    if (self.dataArray.count > 0) {
        label.text = [NSString stringWithFormat:@"%@",SORT_ARRAY[section]];
    }
    [sectionHeaderView addSubview:label];
    return sectionHeaderView;
}

// 右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return SORT_ARRAY;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        cell.backgroundColor = ZSColorWhite;
    }
    if (self.dataArray.count) {
        NSMutableArray *cityArrays = [self.cityDic objectForKey:SORT_ARRAY[indexPath.section]];
        ZSCityModel *model = cityArrays[indexPath.row];
        cell.textLabel.text = model.city;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //赋值
    if (self.dataArray.count > 0)
    {
        NSMutableArray *cityArrays = [self.cityDic objectForKey:SORT_ARRAY[indexPath.section]];
        ZSCityModel *model = cityArrays[indexPath.row];
        self.cityName = model.city;
        self.cityID = model.cityId;
        [self leftAction];
    }
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
