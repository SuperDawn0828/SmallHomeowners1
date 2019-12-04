//
//  ZSCreateOrderLoanInfoViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCreateOrderLoanInfoViewController.h"
#import "ZSSingleLineTextTableViewCell.h"
#import "ZSCreateOrderTopView.h"
#import "ZSOrderDetailViewController.h"

@interface ZSCreateOrderLoanInfoViewController ()<ZSSingleLineTextTableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray<ZSDynamicDataModel *> *dataArray;
@property(nonatomic,copy  )NSString                          *cityID;
@end

@implementation ZSCreateOrderLoanInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureViews];
    //Data
    [self initData];
    [NOTI_CENTER addObserver:self selector:@selector(initData) name:KSUpdateAllOrderDetailNotification object:nil];
}

#pragma mark /*------------------------------------------数据填充------------------------------------------*/
- (void)initData
{
    //数组初始化
    self.dataArray = [[NSMutableArray alloc]init];
    
    //所在城市
    ZSDynamicDataModel *cityModel = [[ZSDynamicDataModel alloc]init];
    cityModel.fieldMeaning = @"所在城市";
    cityModel.isNecessary = @"1";
    cityModel.fieldType = @"5";
    
    //合同总价
    ZSDynamicDataModel *contractAmountModel = [[ZSDynamicDataModel alloc]init];
    contractAmountModel.fieldMeaning = @"合同总价";
    contractAmountModel.isNecessary = @"0";
    contractAmountModel.fieldType = @"4";
    contractAmountModel.fieldUnit = @"元";
    
    //申请贷款金额
    ZSDynamicDataModel *applyLoanAmountModel = [[ZSDynamicDataModel alloc]init];
    applyLoanAmountModel.fieldMeaning = [NSString stringWithFormat:@"申请%@金额",[ZSGlobalModel changeLoanString:@"贷款"]];
    applyLoanAmountModel.isNecessary = @"1";
    applyLoanAmountModel.fieldType = @"4";
    applyLoanAmountModel.fieldUnit = @"元";
    
    //贷款年限
    ZSDynamicDataModel *loanLimitModel = [[ZSDynamicDataModel alloc]init];
    loanLimitModel.fieldMeaning = [NSString stringWithFormat:@"%@年限",[ZSGlobalModel changeLoanString:@"贷款"]];
    loanLimitModel.isNecessary = @"0";
    loanLimitModel.fieldType = @"4";
    loanLimitModel.fieldUnit = @"年";
    
    //现有订单编辑房产信息
    if (global.pcOrderDetailModel.order)
    {
        OrderModel *model = global.pcOrderDetailModel.order;

        if (model.loanCity) {
            cityModel.rightData = [NSString stringWithFormat:@"%@",model.loanCity];
        }
        if (model.loanCityId) {
            self.cityID = model.loanCityId;
        }
        if (model.contractAmount) {
            contractAmountModel.rightData = [NSString stringWithFormat:@"%@",[NSString ReviseString:model.contractAmount]];
        }
        if (model.applyLoanAmount) {
            applyLoanAmountModel.rightData = [NSString stringWithFormat:@"%@",[NSString ReviseString:model.applyLoanAmount]];
        }
        if (model.loanLimit) {
            loanLimitModel.rightData = [NSString stringWithFormat:@"%@",model.loanLimit];
        }
    }
    
    //添加值
    [self.dataArray addObject:cityModel];
    //星速贷,代办业务
    if ([global.prdType isEqualToString:kProduceTypeStarLoan] || [global.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        [self.dataArray addObject:contractAmountModel];
    }
    [self.dataArray addObject:applyLoanAmountModel];
    [self.dataArray addObject:loanLimitModel];
    
    //刷新table
    [self.tableView reloadData];
}

#pragma mark /*------------------------------------------创建页面------------------------------------------*/
- (void)configureViews
{
    //navgationBar
    [self configureNavgationBar:[NSString stringWithFormat:@"创建%@订单",[ZSGlobalModel getProductStateWithCode:global.prdType]] withBackBtn:YES];

    //topview
    ZSCreateOrderTopView *topView = [ZSCreateOrderTopView extractFromXib];
    topView.frame = CGRectMake(0, kNavigationBarHeight, ZSWIDTH, viewTopHeight);
    [topView setImgViewWithProduct:global.prdType withIndex:ZSCreatOrderStyleLoan];
    [self.view addSubview:topView];
    
    //table
    [self configureTableView:CGRectMake(0, topView.bottom, ZSWIDTH, ZSHEIGHT - kNavigationBarHeight - viewTopHeight - 60) withStyle:UITableViewStylePlain];

    //底部按钮
    [self configuBottomButtonWithTitle:@"提交申请"];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    self.cityID = string;
}

#pragma mark /*------------------------------------------提交订单------------------------------------------*/
- (void)bottomClick:(UIButton *)sender
{
    //有必填项没有填
    for (ZSDynamicDataModel *model in self.dataArray) {
        if (model.isNecessary.intValue == 1) {
            if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
                [ZSTool showMessage:[NSString stringWithFormat:@"请输入%@",model.fieldMeaning] withDuration:DefaultDuration];
                return;
            }
        }
    }
    
    //星速贷
    if ([global.prdType isEqualToString:kProduceTypeStarLoan])
    {
        //判断一下申请贷款金额是否大于合同总价
        if (self.dataArray[1].rightData.length) {
            NSDecimalNumber *contractAmount = [NSDecimalNumber decimalNumberWithString:self.dataArray[1].rightData];
            NSDecimalNumber *applyLoanAmount = [NSDecimalNumber decimalNumberWithString:self.dataArray[2].rightData];
            NSDecimalNumber *numResult = [contractAmount decimalNumberBySubtracting:applyLoanAmount];
            NSString *endStr = [numResult stringValue];
            if (endStr.floatValue < 0){
                [ZSTool showMessage:@"申请贷款金额不能大于合同总价" withDuration:DefaultDuration];
                return;
            }
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self uploadOrderParameter] url:[ZSURLManager getUpdateMortgageInfo] SuccessBlock:^(NSDictionary *dic) {
        //订单详情存值
        global.pcOrderDetailModel = [ZSPCOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //订单提交预授信
        [weakSelf getApplyPrecredit];
    } ErrorBlock:^(NSError *error) {
    }];
}

//上传参数
- (NSMutableDictionary *)uploadOrderParameter
{
    NSMutableDictionary *dict = @{
                                  @"prdType":global.prdType,
                                  @"orderId":global.pcOrderDetailModel.order.tid,
                                  @"loanCityId":self.cityID,
                                  }.mutableCopy;
    
    //星速贷,代办业务
    if ([global.prdType isEqualToString:kProduceTypeStarLoan] || [global.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        //合同总价
        if (self.dataArray[1].rightData.length) {
            [dict setObject:self.dataArray[1].rightData forKey:@"contractAmount"];
        }
        //申请贷款金额
        if (self.dataArray[2].rightData.length) {
            [dict setObject:self.dataArray[2].rightData forKey:@"applyLoanAmount"];
        }
        //贷款年限
        if (self.dataArray[3].rightData.length) {
            [dict setObject:self.dataArray[3].rightData forKey:@"loanLimit"];
        }
    }
    //抵押贷,赎楼宝,车位分期
    else if ([global.prdType isEqualToString:kProduceTypeMortgageLoan] ||
             [global.prdType isEqualToString:kProduceTypeRedeemFloor] ||
             [global.prdType isEqualToString:kProduceTypeCarHire])
    {
        //申请贷款金额
        if (self.dataArray[1].rightData.length) {
            [dict setObject:self.dataArray[1].rightData forKey:@"applyLoanAmount"];
        }
        //贷款年限
        if (self.dataArray[2].rightData.length) {
            [dict setObject:self.dataArray[2].rightData forKey:@"loanLimit"];
        }
    }
    return dict;
}

#pragma mark 提交订单(预授信)
- (void)getApplyPrecredit
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":global.prdType,
                                  @"orderId":global.pcOrderDetailModel.order.tid,
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getApplyPrecredit] SuccessBlock:^(NSDictionary *dic) {
        //页面跳转
        ZSOrderDetailViewController *detailVC = [[ZSOrderDetailViewController alloc]init];
        detailVC.isFromCreateOrder = YES;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
        //通知刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
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
