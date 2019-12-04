//
//  ZSCreateOrderPersonInfoViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/2.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCreateOrderPersonInfoViewController.h"
#import "ZSCreateOrderHouseInfoViewController.h"
#import "ZSCreateOrderPersonInfoCell.h"
#import "ZSCreateOrderTopView.h"
#import "ZSLenderInfoViewController.h"

@interface ZSCreateOrderPersonInfoViewController ()
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *arrayAdd;
@end

@implementation ZSCreateOrderPersonInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureViews];
    //Data
    [self initData];
    [NOTI_CENTER addObserver:self selector:@selector(initData) name:KSUpdateAllOrderDetailNotification object:nil];
}

#pragma mark /*---------------------------------------返回事件---------------------------------------*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.personType == ZSFromCreateOrderWithAdd || self.personType == ZSFromExistingOrderWithAdd || self.personType == ZSFromExistingOrderWithEditor)
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
    if (self.personType == ZSFromCreateOrderWithAdd || self.personType == ZSFromExistingOrderWithAdd || self.personType == ZSFromExistingOrderWithEditor)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (self.personType == ZSFromOrderList)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark /*------------------------------------------数据填充------------------------------------------*/
- (void)initData
{
    //订单列表过来需要请求接口,其他的都有数据
    if (self.personType == ZSFromOrderList)
    {
        [self requestData];
    }
    else
    {
        [self fillTheData];
    }
}

#pragma mark 请求订单详情接口
- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"prdType":global.prdType,
                                  @"orderId":self.orderIDString,
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getAgentOrderDetail] SuccessBlock:^(NSDictionary *dic) {
        //订单详情存值
        global.pcOrderDetailModel = [ZSPCOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //数据填充
        [weakSelf fillTheData];
    } ErrorBlock:^(NSError *error) {
    }];
}

//先遍历已有角色和主贷人婚姻状况判断,填充相应的假数据  1本人 2配偶 4共有人 7卖方 8卖方配偶
- (void)fillTheData
{
    //已有数据
    self.dataArray = [[NSMutableArray alloc]initWithArray:global.pcOrderDetailModel.customers];
    
    //假数据
    self.arrayAdd = [[NSMutableArray alloc]init];
    
    //星速贷,代办业务 (贷款人,贷款人配偶,共有人,卖方,卖方配偶)
    if ([global.prdType isEqualToString:kProduceTypeStarLoan] || [global.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        if ([ZSGlobalModel orderStateIsInTheInformationRecorded])
        {
            [self.arrayAdd addObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
            [self.arrayAdd addObject:@"共有人"];
            [self.arrayAdd addObject:@"卖方"];
            //遍历
            [global.pcOrderDetailModel.customers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CustomersModel *info = global.pcOrderDetailModel.customers[idx];
                if (info.releation.intValue == 1) {
                    if (info.beMarrage.intValue != 2) {
                        [self.arrayAdd removeObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
                    }
                }
                else if (info.releation.intValue == 2) {
                    [self.arrayAdd removeObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
                }
                else if (info.releation.intValue == 4) {
                    [self.arrayAdd removeObject:@"共有人"];
                }
                else if (info.releation.intValue == 7) {
                    [self.arrayAdd removeObject:@"卖方"];
                    if (info.beMarrage.intValue == 2) {
                        if (![self.arrayAdd containsObject:@"卖方配偶"]) {
                            [self.arrayAdd addObject:@"卖方配偶"];
                        }
                    }
                }
                else if (info.releation.intValue == 8) {
                    [self.arrayAdd removeObject:@"卖方配偶"];
                }
            }];
        }
    }
    //抵押贷,车位分期 (贷款人,贷款人配偶,担保人,担保人配偶)
    else if ([global.prdType isEqualToString:kProduceTypeMortgageLoan] || [global.prdType isEqualToString:kProduceTypeCarHire])
    {
        if ([ZSGlobalModel orderStateIsInTheInformationRecorded])
        {
            [self.arrayAdd addObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
            [self.arrayAdd addObject:@"担保人"];
            //遍历
            [global.pcOrderDetailModel.customers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CustomersModel *info = global.pcOrderDetailModel.customers[idx];
                if (info.releation.intValue == 1) {
                    if (info.beMarrage.intValue != 2) {
                        [self.arrayAdd removeObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
                    }
                }
                else if (info.releation.intValue == 2) {
                    [self.arrayAdd removeObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
                }
                else if (info.releation.intValue == 5) {
                    [self.arrayAdd removeObject:@"担保人"];
                    if (info.beMarrage.intValue == 2) {
                        if (![self.arrayAdd containsObject:@"担保人配偶"]) {
                            [self.arrayAdd addObject:@"担保人配偶"];
                        }
                    }
                }
                else if (info.releation.intValue == 6) {
                    [self.arrayAdd removeObject:@"担保人配偶"];
                }
            }];
        }
    }
    //赎楼宝 (贷款人,配偶)
    else if ([global.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        if ([ZSGlobalModel orderStateIsInTheInformationRecorded])
        {
            [self.arrayAdd addObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
            //遍历
            [global.pcOrderDetailModel.customers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CustomersModel *info = global.pcOrderDetailModel.customers[idx];
                if (info.releation.intValue == 1) {
                    if (info.beMarrage.intValue != 2) {
                        [self.arrayAdd removeObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
                    }
                }
                else if (info.releation.intValue == 2) {
                    [self.arrayAdd removeObject:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]];
                }
            }];
        }
    }
    
    
    //刷新tableview
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
    [topView setImgViewWithProduct:global.prdType withIndex:ZSCreatOrderStyleCustomer];
    [self.view addSubview:topView];
    
    //table
    [self configureTableView:CGRectMake(0, topView.bottom, ZSWIDTH, ZSHEIGHT - kNavigationBarHeight - viewTopHeight - 60) withStyle:UITableViewStylePlain];

    //底部按钮
    [self configuBottomButtonWithTitle:@"下一步"];
}

#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + self.arrayAdd.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCreateOrderPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCellIdentifier];
    if (!cell) {
        cell = [[ZSCreateOrderPersonInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PersonCellIdentifier];
    }
    if (indexPath.row < self.dataArray.count) {
        if (self.dataArray.count > 0) {
            cell.model = self.dataArray[indexPath.row];
        }
    }
    else{
        if (self.arrayAdd.count > 0) {
            cell.roleString = self.arrayAdd[indexPath.row - self.dataArray.count];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZSLenderInfoViewController *lenderInfo = [[ZSLenderInfoViewController alloc]init];
    
    //目前只有信息录入中的订单才可以编辑人员信息
    if (indexPath.row < self.dataArray.count)
    {
        if ([ZSGlobalModel orderStateIsInTheInformationRecorded])
        {
            global.currentCustomer = self.dataArray[indexPath.row];
            lenderInfo.personType = ZSFromExistingOrderWithEditor;
            lenderInfo.roleTypeString = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel getReleationStateWithCode:global.currentCustomer.releation]];
            [self.navigationController pushViewController:lenderInfo animated:YES];
        }
    }
    else
    {
        global.currentCustomer = nil;
        lenderInfo.personType = ZSFromExistingOrderWithAdd;
        lenderInfo.roleTypeString = [NSString stringWithFormat:@"%@信息",self.arrayAdd[indexPath.row - self.dataArray.count]];
        [self.navigationController pushViewController:lenderInfo animated:YES];
    }
}


#pragma mark /*------------------------------------------跳到房产信息页面------------------------------------------*/
- (void)bottomClick:(UIButton *)sender
{
    ZSCreateOrderHouseInfoViewController *houseVC = [[ZSCreateOrderHouseInfoViewController alloc]init];
    [self.navigationController pushViewController:houseVC animated:YES];
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
