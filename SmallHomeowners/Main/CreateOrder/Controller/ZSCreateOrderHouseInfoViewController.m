//
//  ZSCreateOrderHouseInfoViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCreateOrderHouseInfoViewController.h"
#import "ZSCreateOrderLoanInfoViewController.h"
#import "ZSSingleLineTextTableViewCell.h"
#import "ZSTextWithPhotosTableViewCell.h"
#import "ZSCreateOrderTopView.h"

@interface ZSCreateOrderHouseInfoViewController ()<ZSSingleLineTextTableViewCellDelegate,ZSTextWithPhotosTableViewCellDelegate>
{
    BOOL          isChanged;//是否有改变值(用于返回按钮检测内容是否有变化)
    BOOL          isFailure;//是否有图片上传失败
    BOOL          isShowHUD;//是否需要显示图片加载进度
    LSProgressHUD *hud;
}
@property(nonatomic,strong)NSMutableArray<ZSDynamicDataModel *> *dataArray;
@property(nonatomic,copy  )NSString                          *currentProID;        //当前选中的省id,用于接口请求
@property(nonatomic,copy  )NSString                          *currentCitID;        //当前选中的城市id,用于接口请求
@property(nonatomic,copy  )NSString                          *currentAreID;        //当前选中的区id,用于接口请求
@end

@implementation ZSCreateOrderHouseInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureViews];
    [self configureRightNavItemWithTitle:@"" withNormalImg:nil withHilightedImg:nil];
    //Data
    [self initData];
    [NOTI_CENTER addObserver:self selector:@selector(initData) name:KSUpdateAllOrderDetailNotification object:nil];
    isShowHUD = NO;
}

#pragma mark /*------------------------------------------数据填充------------------------------------------*/
- (void)initData
{
    //数组初始化
    self.dataArray = [[NSMutableArray alloc]init];
    
    //不动产权证
    ZSDynamicDataModel *realEstateModel = [[ZSDynamicDataModel alloc]init];
    realEstateModel.fieldMeaning = @"不动产权证";
    realEstateModel.isNecessary = @"0";
    realEstateModel.fieldType = @"3";
    
    //楼盘名称
    ZSDynamicDataModel *nameModel = [[ZSDynamicDataModel alloc]init];
    nameModel.fieldMeaning = @"楼盘名称";
    nameModel.isNecessary = @"0";
    nameModel.fieldType = @"1";

    //楼盘地址省市区
    ZSDynamicDataModel *provinceModel = [[ZSDynamicDataModel alloc]init];
    provinceModel.fieldMeaning = @"楼盘地址";
    provinceModel.isNecessary = @"0";
    provinceModel.fieldType = @"5";

    //楼盘地址详细地址
    ZSDynamicDataModel *addressModel = [[ZSDynamicDataModel alloc]init];
    addressModel.fieldMeaning = @" ";
    addressModel.isNecessary = @"0";
    addressModel.fieldType = @"1";

    //楼栋房号
    ZSDynamicDataModel *roomNumModel = [[ZSDynamicDataModel alloc]init];
    roomNumModel.fieldMeaning = @"楼栋房号";
    roomNumModel.isNecessary = @"0";
    roomNumModel.fieldType = @"1";

    //权证号
    ZSDynamicDataModel *rightModel = [[ZSDynamicDataModel alloc]init];
    rightModel.fieldMeaning = @"权证号";
    rightModel.isNecessary = @"0";
    rightModel.fieldType = @"1";

    //房屋功能
    ZSDynamicDataModel *houseModel = [[ZSDynamicDataModel alloc]init];
    houseModel.fieldMeaning = @"房屋功能";
    houseModel.isNecessary = @"0";
    houseModel.fieldType = @"5";

    //建筑面积
    ZSDynamicDataModel *areaModel = [[ZSDynamicDataModel alloc]init];
    areaModel.fieldMeaning = @"建筑面积";
    areaModel.isNecessary = @"0";
    areaModel.fieldType = @"4";
    areaModel.fieldUnit = @"m²";

    //套内面积
    ZSDynamicDataModel *areaModel2 = [[ZSDynamicDataModel alloc]init];
    areaModel2.fieldMeaning = @"套内面积";
    areaModel2.isNecessary = @"0";
    areaModel2.fieldType = @"4";
    areaModel2.fieldUnit = @"m²";
    
    //现有订单编辑房产信息
    //不动产权证
    if (global.pcOrderDetailModel.warrantImg.count)
    {
        realEstateModel.rightData = [self getNeedUploadFilesString];
    }
    //房产信息
    if (global.pcOrderDetailModel.order)
    {
        OrderModel *model = global.pcOrderDetailModel.order;
        if (model.projName) {
            nameModel.rightData = model.projName;
        }
        if (model.province && model.city && model.area) {
            NSString *string = [NSString stringWithFormat:@"%@ %@ %@",model.province,model.city,model.area];
            NSString *stringID = [NSString stringWithFormat:@"%@-%@-%@",model.provinceId,model.cityId,model.areaId];
            provinceModel.rightData = string;
            provinceModel.addressID = stringID;
        }
        if (model.address) {
            addressModel.rightData = model.address;
        }
        if (model.houseNum) {
            roomNumModel.rightData = model.houseNum;
        }
        if (model.warrantNo) {
            rightModel.rightData = model.warrantNo;
        }
        if (model.housingFunction) {
            houseModel.rightData = model.housingFunction;
        }
        if (model.coveredArea) {
            areaModel.rightData = [NSString ReviseString:model.coveredArea];
        }
        if (model.insideArea) {
            areaModel2.rightData = [NSString ReviseString:model.insideArea];
        }
    }

    //添加值
    [self.dataArray addObject:realEstateModel];
    [self.dataArray addObject:nameModel];
    [self.dataArray addObject:provinceModel];
    [self.dataArray addObject:addressModel];
    [self.dataArray addObject:roomNumModel];
    [self.dataArray addObject:rightModel];
    [self.dataArray addObject:houseModel];
    [self.dataArray addObject:areaModel];
    [self.dataArray addObject:areaModel2];

    //刷新table
    [self.tableView reloadData];
}

#pragma mark 获取所要上传的数据
- (NSString *)getNeedUploadFilesString
{
    NSString *string;
    for (WarrantImg *imgModel in global.pcOrderDetailModel.warrantImg) {
        //直接拼接所有的url
        if (imgModel.dataUrl) {
            string = [NSString stringWithFormat:@"%@,%@",string,imgModel.dataUrl];
        }
    }
    string = [string stringByReplacingOccurrencesOfString:@"(null),"withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@",(null)"withString:@""];
    return SafeStr(string);
}

#pragma mark /*------------------------------------------创建页面------------------------------------------*/
- (void)configureViews
{
    //navgationBar
    [self configureNavgationBar:[NSString stringWithFormat:@"创建%@订单",[ZSGlobalModel getProductStateWithCode:global.prdType]] withBackBtn:YES];

    //topview
    ZSCreateOrderTopView *topView = [ZSCreateOrderTopView extractFromXib];
    topView.frame = CGRectMake(0, kNavigationBarHeight, ZSWIDTH, viewTopHeight);
    [topView setImgViewWithProduct:global.prdType withIndex:ZSCreatOrderStyleHouse];
    [self.view addSubview:topView];
    
    //table
    [self configureTableView:CGRectMake(0, topView.bottom, ZSWIDTH, ZSHEIGHT - kNavigationBarHeight - viewTopHeight - 60) withStyle:UITableViewStylePlain];
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"下一步"];
}

#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSDynamicDataModel *model = self.dataArray[indexPath.row];
    //照片
    if (model.fieldType.intValue == 3)
    {
        if (model.cellHeight) {
            return model.cellHeight + 10;
        }
        else {
            return CellHeight + photoWidth + 25;
        }
    }
    //单行文本
    else {
        return CellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSDynamicDataModel *model = self.dataArray[indexPath.row];
    //图片(不复用)
    if (model.fieldType.intValue == 3)
    {
        //照片cell不复用
        ZSTextWithPhotosTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ZSTextWithPhotosTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextWithPhotosCellIdentifier];
            cell.delegate = self;
            cell.isShowAdd = YES;
        }
        if (self.dataArray.count > 0) {
            cell.model = self.dataArray[indexPath.row];
            cell.currentIndex = indexPath.row;
        }
        return cell;
    }
    //单行文本
    else
    {
        ZSSingleLineTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ZSSingleLineTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        if (self.dataArray.count > 0) {
            cell.model = self.dataArray[indexPath.row];
            cell.currentIndex = indexPath.row;
        }
        return cell;
    }
}

#pragma mark /*------------------------------------------ZSTextWithPhotosTableViewCellDelegate------------------------------------------*/
//当前cell的高度
- (void)sendCurrentCellHeight:(CGFloat)collectionHeight withIndex:(NSUInteger)currentIndex;
{
    //保存数据
    ZSDynamicDataModel *model = self.dataArray[currentIndex];
    model.cellHeight = collectionHeight;
    [self.dataArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前tableView(只刷新高度)
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

//本地图片数组(已经选择完毕,但是未上传完)
- (void)sendImageArrayData:(NSArray *)imageDataArray WithIndex:(NSUInteger)currentIndex;
{
    //保存数据
    ZSDynamicDataModel *model = self.dataArray[currentIndex];
    if (imageDataArray.count > 0) {
        model.imageDataArray = imageDataArray;
        model.rightData = @" ";
        [self.dataArray replaceObjectAtIndex:currentIndex withObject:model];
    }
}

//已上传的照片
- (void)sendProcessOfPhototWithData:(NSString *)string WithIndex:(NSUInteger)currentIndex;
{
    //保存数据
    ZSDynamicDataModel *model = self.dataArray[currentIndex];
    model.rightData = string ? string : model.rightData;
    [self.dataArray replaceObjectAtIndex:currentIndex withObject:model];
   
    //上传进度
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:KhasbeenUploadNum];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:KneedUploadNum];
 
    //右侧按钮,用于显示上传进度
    if (hasbeenUploadNum > needUploadNum) {
        hasbeenUploadNum = needUploadNum;
    }
    if (needUploadNum > 0 && hasbeenUploadNum <= needUploadNum) {
        [self.rightBtn setTitle:[NSString stringWithFormat:@"已上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum] forState:UIControlStateNormal];
    }
    else{
        [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    }
  
    //点击了底部保存按钮,此时图片未上传完
    if (isShowHUD == YES)
    {
        if (hasbeenUploadNum < needUploadNum) {
            hud = [LSProgressHUD showWithMessage:[NSString stringWithFormat:@"正在上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
            //如果有图片未上传成功,需要发送通知
            if (isFailure) {
                [NOTI_CENTER postNotificationName:@"reUploadImage" object:nil];
                isFailure = NO;
                isShowHUD = NO;
            }
        }
        else {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:self.view];
            //资料上传
            [self bottomClick:nil];
        }
    }
}

//图片有增删或修改,都需要请求网络
- (void)checkPhototCellChangeState:(BOOL)isChange
{
    isChanged = isChange;
}

//判断是否有图片上传失败
- (void)sendPictureUploadingFailureWithIndex:(BOOL)isFailure
{
    isFailure = isFailure;
}

#pragma mark /*------------------------------------------ZSSingleLineTextTableViewCellDelegate------------------------------------------*/
#pragma mark 传递输入框的值或者"请选择"按钮选择成功以后的值
- (void)sendCurrentCellData:(NSString *)string withIndex:(NSUInteger)currentIndex;
{
    ZSDynamicDataModel *model = self.dataArray[currentIndex];
    model.rightData = string;
    [self.dataArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)sendCurrentCellID:(NSString *)string withIndex:(NSUInteger)currentIndex;
{
    //回显修改用
    ZSDynamicDataModel *model = self.dataArray[currentIndex];
    model.addressID = string;
    [self.dataArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //接口上传用
    NSArray *array = [string componentsSeparatedByString:@"-"];
    self.currentProID = array[0];
    self.currentCitID = array[1];
    self.currentAreID = array[2];
}

#pragma mark /*------------------------------------------跳到贷款信息页面------------------------------------------*/
- (void)bottomClick:(UIButton *)sender
{
    //如果有图片未上传成功,需要发送通知
    if (isFailure) {
        [NOTI_CENTER postNotificationName:@"reUploadImage" object:nil];
        isFailure = NO;
    }
    
    //有上传的资料
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:KhasbeenUploadNum];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:KneedUploadNum];
    if (hasbeenUploadNum < needUploadNum) {
        hud = [LSProgressHUD showWithMessage:[NSString stringWithFormat:@"正在上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
        isShowHUD = YES;
        return;
    }
    
    //建筑面积>套内面积
    if (self.dataArray[7].rightData.length && self.dataArray[8].rightData.length)
    {
        NSDecimalNumber *contractAmount = [NSDecimalNumber decimalNumberWithString:self.dataArray[7].rightData];
        NSDecimalNumber *applyLoanAmount = [NSDecimalNumber decimalNumberWithString:self.dataArray[8].rightData];
        NSDecimalNumber *numResult = [contractAmount decimalNumberBySubtracting:applyLoanAmount];
        NSString *endStr = [numResult stringValue];
        if (endStr.floatValue < 0){
            [ZSTool showMessage:@"套内面积不能大于建筑面积" withDuration:DefaultDuration];
            return;
        }
    }
    
    //接口请求
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self uploadOrderParameter] url:[ZSURLManager getUpdateHouseInfo] SuccessBlock:^(NSDictionary *dic) {
        //订单详情存值
        global.pcOrderDetailModel = [ZSPCOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //页面跳转
        ZSCreateOrderLoanInfoViewController *loanVC = [[ZSCreateOrderLoanInfoViewController alloc]init];
        [weakSelf.navigationController pushViewController:loanVC animated:YES];
        //通知刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
    } ErrorBlock:^(NSError *error) {
    }];
}

//上传参数
- (NSMutableDictionary *)uploadOrderParameter
{
    NSMutableDictionary *dict = @{
                                  @"prdType":global.prdType,
                                  @"orderId":global.pcOrderDetailModel.order.tid,
                                  }.mutableCopy;
    //不动产权证
    if (self.dataArray[0].rightData.length) {
        [dict setObject:self.dataArray[0].rightData forKey:@"warrantImg"];
    }
    //楼盘名称
    if (self.dataArray[1].rightData.length) {
        [dict setObject:self.dataArray[1].rightData forKey:@"building"];
    }
    //楼盘地址省市区
    if (self.currentProID) {
        [dict setObject:self.currentProID forKey:@"provinceId"];
    }
    if (self.currentCitID) {
        [dict setObject:self.currentCitID forKey:@"cityId"];
    }
    if (self.currentAreID) {
        [dict setObject:self.currentAreID forKey:@"areaId"];
    }
    //楼盘地址详细地址
    if (self.dataArray[3].rightData.length) {
        [dict setObject:self.dataArray[3].rightData forKey:@"address"];
    }
    //楼栋房号
    if (self.dataArray[4].rightData.length) {
        [dict setObject:self.dataArray[4].rightData forKey:@"houseNo"];
    }
    //权证号
    if (self.dataArray[5].rightData.length) {
        [dict setObject:self.dataArray[5].rightData forKey:@"warrantNo"];
    }
    //房屋功能
    if (self.dataArray[6].rightData.length) {
        [dict setObject:self.dataArray[6].rightData forKey:@"housingFunction"];
    }
    //建筑面积
    if (self.dataArray[7].rightData.length) {
        [dict setObject:self.dataArray[7].rightData forKey:@"coveredArea"];
    }
    //套内面积
    if (self.dataArray[8].rightData.length) {
        [dict setObject:self.dataArray[8].rightData forKey:@"insideArea"];
    }
    
    return dict;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];
}

@end
