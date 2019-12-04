//
//  ZSOrderDetailViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/27.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSOrderDetailViewController.h"
#import "ZSCreditReportViewController.h"
#import "ZSTextWithPhotosTableViewCell.h"
#import "ZSOrderDetailPersonCell.h"
#import "ZSWSNewLeftRightCell.h"
#import "ZSOrderPersonDetailViewController.h"

@interface ZSOrderDetailViewController ()<ZSTextWithPhotosTableViewCellDelegate>
@property (nonatomic,strong) UIView         *topHeaderView;   //
@property (nonatomic,strong) UIImageView    *stateImageView;   //订单状态图标
@property (nonatomic,strong) UILabel        *stateLabel;       //订单状态
@property (nonatomic,strong) UILabel        *noticeLabel;      //提示语
@property (nonatomic,strong) UIButton       *callMediationBtn; //联系客户经理按钮
//@property (nonatomic,strong) UIImageView    *jumpImage;        //跳转图片
@property (nonatomic,strong) NSMutableArray *personDatdArray;  //人员信息
@property (nonatomic,strong) NSMutableArray *loanDatdArray;    //贷款信息
@property (nonatomic,strong) NSMutableArray *houseDatdArray;   //房产信息
@property (nonatomic,strong) NSMutableArray *orderDatdArray;   //订单信息
@end

@implementation ZSOrderDetailViewController

- (NSMutableArray *)loanDatdArray
{
    if (_loanDatdArray == nil) {
        _loanDatdArray = [[NSMutableArray alloc]init];
    }
    return _loanDatdArray;
}

- (NSMutableArray *)houseDatdArray
{
    if (_houseDatdArray == nil) {
        _houseDatdArray = [[NSMutableArray alloc]init];
    }
    return _houseDatdArray;
}

- (NSMutableArray *)orderDatdArray
{
    if (_orderDatdArray == nil) {
        _orderDatdArray = [[NSMutableArray alloc]init];
    }
    return _orderDatdArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"订单详情" withBackBtn:YES];
    [self configureTable];
    [self configureTopView];
    //Data
    [self requestData];
    [NOTI_CENTER addObserver:self selector:@selector(requestData) name:KSUpdateAllOrderDetailNotification object:nil];
}

#pragma mark /*---------------------------------------返回事件---------------------------------------*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isFromCreateOrder)
    {
        [self leftAction];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)leftAction
{
    if (self.isFromCreateOrder)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark /*---------------------------------------数据填充---------------------------------------*/
#pragma mark 请求订单详情接口
- (void)requestData
{
    [LSProgressHUD show];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":global.prdType,
                                  @"orderId":self.orderIDString ? self.orderIDString : global.pcOrderDetailModel.order.tid,
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getAgentOrderDetail] SuccessBlock:^(NSDictionary *dic) {
        //订单详情存值
        global.pcOrderDetailModel = [ZSPCOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //数据填充
        [weakSelf fillTheData];
        [LSProgressHUD hide];
    } ErrorBlock:^(NSError *error) {
        [LSProgressHUD hide];
    }];
}

#pragma mark 数据填充
- (void)fillTheData
{
    //title
    if (global.pcOrderDetailModel.customers.count) {
        CustomersModel *model = global.pcOrderDetailModel.customers.firstObject;
        self.titleLabel.text = [NSString stringWithFormat:@"%@的订单",model.name];
    }
    
    //订单状态
    OrderModel *model = global.pcOrderDetailModel.order;
    AgentPrecredit *agentModel = global.pcOrderDetailModel.agentPrecredit;
    if (model.orderState)
    {
        if ([model.orderState isEqualToString:@"待生成预授信报告"])
        {
            self.topHeaderView.height = 120;
            self.noticeLabel.height = 20;
            self.callMediationBtn.top = self.noticeLabel.bottom+10;
            self.stateImageView.image = [UIImage imageNamed:@"u4"];
            self.stateLabel.text = [NSString stringWithFormat:@"%@",model.orderState];
            self.noticeLabel.text = @"评估师正在进行评估，请稍后查看！";
            self.callMediationBtn.hidden = NO;
        }
        else if ([model.orderState isEqualToString:@"已生成预授信报告"] || [model.orderState isEqualToString:@"订单处理中"])
        {
            self.topHeaderView.height = 150;
            self.noticeLabel.height = 50;
            self.callMediationBtn.top = self.noticeLabel.bottom+10;
            self.callMediationBtn.hidden = NO;
            if (agentModel.canLoan.intValue == 1) {
                self.stateImageView.image = [UIImage imageNamed:@"u0"];
                self.stateLabel.text = @"已生成预授信报告-可贷款";
                self.noticeLabel.text = [NSString stringWithFormat:@"将由您的专属客户经理 %@ 为您提供服务，请注意接听来电！",SafeStr(model.customerManagerName)];
            }
            else if (agentModel.canLoan.intValue == 2) {
                self.stateImageView.image = [UIImage imageNamed:@"u2"];
                self.stateLabel.text = @"已生成预授信报告-不可贷款";
                self.noticeLabel.text = @"根据您提供的资料，无法提供相应贷款服务，请补充资料重新提交或联系客户经理寻找解决方案。";
            }
        }
        else
        {
            self.topHeaderView.height = 50;
            self.stateLabel.text = [NSString stringWithFormat:@"%@",model.orderState];
        }
    }
    
    //-------------------------------------人员信息-------------------------------------//
    if (global.pcOrderDetailModel.customers.count) {
        self.personDatdArray = [[NSMutableArray alloc]initWithArray:global.pcOrderDetailModel.customers];
    }
    
    //-------------------------------------贷款信息-------------------------------------//
    //所在城市
    ZSOrderModel *cityModel = [[ZSOrderModel alloc]init];
    cityModel.leftName = @"所在城市";
    cityModel.rightData = model.loanCity ? model.loanCity : @"";
    [self.loanDatdArray addObject:cityModel];
  
    //合同总价
    //星速贷,代办业务
    if ([global.prdType isEqualToString:kProduceTypeStarLoan] || [global.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        ZSOrderModel *contractAmountModel = [[ZSOrderModel alloc]init];
        contractAmountModel.leftName = @"合同总价";
        contractAmountModel.rightData = model.contractAmount ? [NSString stringWithFormat:@"%@ 元",[NSString ReviseString:model.contractAmount]] : @"";
        [self.loanDatdArray addObject:contractAmountModel];
    }
    
    //申请贷款总额
    ZSOrderModel *applyLoanAmountModel = [[ZSOrderModel alloc]init];
    applyLoanAmountModel.leftName = [NSString stringWithFormat:@"申请%@总额",[ZSGlobalModel changeLoanString:@"贷款"]];
    applyLoanAmountModel.rightData = model.applyLoanAmount ? [NSString stringWithFormat:@"%@ 元",[NSString ReviseString:model.applyLoanAmount]] : @"";
    [self.loanDatdArray addObject:applyLoanAmountModel];
    
    //贷款年限
    ZSOrderModel *loanLimitModel = [[ZSOrderModel alloc]init];
    loanLimitModel.leftName = [NSString stringWithFormat:@"%@年限",[ZSGlobalModel changeLoanString:@"贷款"]];
    loanLimitModel.rightData = model.loanLimit ? [NSString stringWithFormat:@"%@ 年",model.loanLimit] : @"";
    [self.loanDatdArray addObject:loanLimitModel];
    
    //-------------------------------------房产信息-------------------------------------//
    //不动产权证
    ZSDynamicDataModel *realEstateModel = [[ZSDynamicDataModel alloc]init];
    realEstateModel.fieldMeaning = @"不动产权证";
    realEstateModel.isNecessary = @"0";
    if (global.pcOrderDetailModel.warrantImg.count){
        realEstateModel.rightData = [self getNeedUploadFilesString];
    }
    [self.houseDatdArray addObject:realEstateModel];
    
    //楼盘名称
    ZSOrderModel *nameModel = [[ZSOrderModel alloc]init];
    nameModel.leftName = @"楼盘名称";
    nameModel.rightData = model.projName ? model.projName : @"";
    [self.houseDatdArray addObject:nameModel];
    
    //楼盘地址
    ZSOrderModel *provinceModel = [[ZSOrderModel alloc]init];
    provinceModel.leftName = @"楼盘地址";
    NSString *addressString = @"";
    if (model.province && model.city && model.area) {
        addressString = [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.area];
    }
    if (model.address) {
        addressString = [NSString stringWithFormat:@"%@%@",addressString,model.address];
    }
    provinceModel.rightData = addressString;
    [self.houseDatdArray addObject:provinceModel];
    
    //楼栋房号
    ZSOrderModel *roomNumModel = [[ZSOrderModel alloc]init];
    roomNumModel.leftName = @"楼栋房号";
    roomNumModel.rightData = model.houseNum ? model.houseNum : @"";
    [self.houseDatdArray addObject:roomNumModel];
    
    //权证号
    ZSOrderModel *rightModel = [[ZSOrderModel alloc]init];
    rightModel.leftName = @"权证号";
    rightModel.rightData = model.warrantNo ? model.warrantNo : @"";
    [self.houseDatdArray addObject:rightModel];
    
    //房屋功能
    ZSOrderModel *houseModel = [[ZSOrderModel alloc]init];
    houseModel.leftName = @"房屋功能";
    houseModel.rightData = model.housingFunction ? model.housingFunction : @"";
    [self.houseDatdArray addObject:houseModel];
    
    //建筑面积
    ZSOrderModel *areaModel = [[ZSOrderModel alloc]init];
    areaModel.leftName = @"建筑面积";
    if (model.coveredArea) {
        areaModel.rightData = [NSString stringWithFormat:@"%@ m²",[NSString ReviseString:model.coveredArea]];
    }
    [self.houseDatdArray addObject:areaModel];

    //套内面积
    ZSOrderModel *areaModel2 = [[ZSOrderModel alloc]init];
    areaModel2.leftName = @"套内面积";
    if (model.insideArea) {
        areaModel2.rightData = [NSString stringWithFormat:@"%@ m²",[NSString ReviseString:model.insideArea]];
    }
    [self.houseDatdArray addObject:areaModel2];
    
    //-------------------------------------订单信息-------------------------------------//
    //订单编号
    ZSOrderModel *orderNoModel = [[ZSOrderModel alloc]init];
    orderNoModel.leftName = @"订单编号";
    if (model.orderNo) {
        orderNoModel.rightData = [NSString stringWithFormat:@"%@  |  复制",model.orderNo];
    }
    [self.orderDatdArray addObject:orderNoModel];
    
    //创建时间
    ZSOrderModel *createDateModel = [[ZSOrderModel alloc]init];
    createDateModel.leftName = @"创建时间";
    createDateModel.rightData = model.createDate ? model.createDate : @"";
    [self.orderDatdArray addObject:createDateModel];

    //订单创建人
    ZSOrderModel *agentUserNameModel = [[ZSOrderModel alloc]init];
    agentUserNameModel.leftName = @"订单创建人";
    agentUserNameModel.rightData = model.agentUserName ? model.agentUserName : @"";
    [self.orderDatdArray addObject:agentUserNameModel];
    
    //所属中介
    ZSOrderModel *agencyNameModel = [[ZSOrderModel alloc]init];
    agencyNameModel.leftName = @"所属中介";
    agencyNameModel.rightData = model.agencyName ? model.agencyName : @"";
    [self.orderDatdArray addObject:agencyNameModel];

    //联系方式
    ZSOrderModel *agencyContactPhoneModel = [[ZSOrderModel alloc]init];
    agencyContactPhoneModel.leftName = @"联系方式";
    agencyContactPhoneModel.rightData = model.agencyContactPhone ? model.agencyContactPhone : @"";
    [self.orderDatdArray addObject:agencyContactPhoneModel];
    
    //刷新tableview
    [self.tableView reloadData];
}

#pragma mark 获取不动产权证的数据
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

#pragma mark /*---------------------------------------顶部页面---------------------------------------*/
- (void)configureTopView
{
    self.topHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 150)];
    self.topHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navgationBarBackground"]];
    self.tableView.tableHeaderView = self.topHeaderView;
    
    //订单状态icon
    self.stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, 12.5, 20, 20)];
    [self.topHeaderView addSubview:self.stateImageView];
    
    //订单状态
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.stateImageView.right+10, 0, ZSWIDTH-70, 45)];
    self.stateLabel.font = [UIFont boldSystemFontOfSize:20];
    self.stateLabel.textColor = ZSColorWhite;
    self.stateLabel.adjustsFontSizeToFitWidth = YES;
    [self.topHeaderView addSubview:self.stateLabel];
    
    //提示语
    self.noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.stateImageView.right+10, self.stateLabel.bottom, ZSWIDTH-70, 45)];
    self.noticeLabel.font = [UIFont systemFontOfSize:15];
    self.noticeLabel.textColor = ZSColorWhite;
    self.noticeLabel.numberOfLines = 0;
    self.noticeLabel.adjustsFontSizeToFitWidth = YES;
    [self.topHeaderView addSubview:self.noticeLabel];
    
    //联系客户经理按钮
    self.callMediationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callMediationBtn.frame = CGRectMake(self.stateImageView.right+10,  self.noticeLabel.bottom+5, 150, 30);
    [self.callMediationBtn setTitle:@"联系客户经理" forState:UIControlStateNormal];
    [self.callMediationBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    self.callMediationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.callMediationBtn.layer.borderWidth = 0.5;
    self.callMediationBtn.layer.borderColor = ZSColorWhite.CGColor;
    self.callMediationBtn.layer.masksToBounds = YES;
    self.callMediationBtn.layer.cornerRadius = 5;
    [self.callMediationBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.callMediationBtn.hidden = YES;
    [self.topHeaderView addSubview:self.callMediationBtn];
}

- (void)callBtnAction:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%@",SafeStr(global.pcOrderDetailModel.order.customerManagerPhone)];
    if (string.length > 0){
        [ZSTool callPhoneStr:string withVC:self];
    }
    else{
        [ZSTool showMessage:@"当前客户经理未录入电话号码" withDuration:DefaultDuration];
    }
}

#pragma mark /*---------------------------------------tableView---------------------------------------*/
- (void)configureTable
{
    [self configureTableView:CGRectMake(0, self.navView.bottom, ZSWIDTH, ZSHEIGHT - self.navView.height) withStyle:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = CellHeight;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
}

#pragma mark tableViewCell代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.personDatdArray.count;
    }
    else if (section == 1) {
        return self.loanDatdArray.count;
    }
    else if (section == 2) {
        return self.houseDatdArray.count;
    }
    else {
        return self.orderDatdArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 95;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            if (global.pcOrderDetailModel.warrantImg.count > 0)
            {
                ZSDynamicDataModel *model = self.houseDatdArray[0];
                return model.cellHeight + 10;
            }
            else{
                return CellHeight;
            }
        }
        else
        {
            return UITableViewAutomaticDimension;
        }
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    view.backgroundColor = ZSViewBackgroundColor;
    ZSBaseSectionView *sectionView = [[ZSBaseSectionView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    sectionView.leftLab.text = @[@"人员信息",[NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款"]],@"房产信息",@"订单信息"][section];
    [view addSubview:sectionView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //人员信息
    if (indexPath.section == 0)
    {
        ZSOrderDetailPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ZSOrderDetailPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (self.personDatdArray.count > 0) {
            cell.model = self.personDatdArray[indexPath.row];
        }
        return cell;
    }
    //贷款信息
    else if (indexPath.section == 1)
    {
        ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        if (!cell) {
            cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        }
        if (self.loanDatdArray.count > 0) {
            cell.model = self.loanDatdArray[indexPath.row];
        }
        return cell;
    }
    //房产信息
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            //不动产权证 cell不复用
            ZSTextWithPhotosTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ZSTextWithPhotosTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextWithPhotosCellIdentifier];
                cell.delegate = self;
                cell.isShowAdd = NO;
            }
            if (global.pcOrderDetailModel.warrantImg.count > 0) {
                cell.model = self.houseDatdArray[indexPath.row];
                cell.currentIndex = indexPath.row;
            }
            else{
                cell.model = self.houseDatdArray[indexPath.row];
                cell.isHiddenCollectionView = YES;//隐藏cell上的图片空间
            }
            return cell;
        }
        else
        {
            ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
            if (!cell) {
                cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
            }
            if (self.houseDatdArray.count > 0) {
                cell.model = self.houseDatdArray[indexPath.row];
            }
            return cell;
        }
    }
    //订单信息
    else
    {
        ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        if (!cell) {
            cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        }
        if (self.orderDatdArray.count > 0) {
            cell.model = self.orderDatdArray[indexPath.row];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //人员信息
    if (indexPath.section == 0)
    {
        global.currentCustomer = self.personDatdArray[indexPath.row];
        ZSOrderPersonDetailViewController *detailVC = [[ZSOrderPersonDetailViewController alloc]init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    //订单信息
    else if (indexPath.section == 3 && indexPath.row == 0)
    {
        if (global.pcOrderDetailModel.order.orderNo)
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = global.pcOrderDetailModel.order.orderNo;
            [ZSTool showMessage:@"订单编号已复制到剪贴板" withDuration:DefaultDuration];
        }
    }
}

#pragma mark 清除sectionHeadr黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 54;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark /*------------------------------------------ZSTextWithPhotosTableViewCellDelegate------------------------------------------*/
//当前cell的高度
- (void)sendCurrentCellHeight:(CGFloat)collectionHeight withIndex:(NSUInteger)currentIndex
{
    //保存数据
    ZSDynamicDataModel *model = self.houseDatdArray[currentIndex];
    model.cellHeight = collectionHeight;
    [self.houseDatdArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前tableView(只刷新高度)
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark /*---------------------------------------查看征信报告详情---------------------------------------*/
- (void)checkCreditReport
{
    if (global.pcOrderDetailModel.agentPrecredit)
    {
        ZSCreditReportViewController *reportVC = [[ZSCreditReportViewController alloc]init];
        [self.navigationController pushViewController:reportVC animated:YES];
    }
}

#pragma mark /*---------------------------------------提交贷款---------------------------------------*/
- (void)bottomClick:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":global.prdType,
                                  @"orderId":self.orderIDString,
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getSubmitLoan] SuccessBlock:^(NSDictionary *dic) {
        //通知刷新订单列表
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        //返回
        [weakSelf leftAction];
        //提示
        [ZSTool showMessage:@"提交成功" withDuration:DefaultDuration];
    } ErrorBlock:^(NSError *error) {
    }];
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
