//
//  ZSNotificationViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/26.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSNotificationViewController.h"
#import "ZSNotificationTableViewCell.h"
#import "ZSCreateOrderPersonInfoViewController.h"
#import "ZSOrderDetailViewController.h"
#import "ZSCertificationViewController.h"

@interface ZSNotificationViewController ()
@property (nonatomic,strong)NSMutableArray   *dataArray;
@property (nonatomic,assign)int              currentPage;     //当前页
@end

@implementation ZSNotificationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //列表页面清空订单详情的数据
    global.pcOrderDetailModel = nil;
    
    //请求个人信息,用于资质认证点进去的状态更新
    [self getUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"消息" withBackBtn:NO];
    [self configureTableView:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT- kNavigationBarHeight - kTabbarHeight + SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    [self configureErrorViewWithStyle:ZSErrorWithoutNoti];
    //Data
    [self addHeader];
    [self addFooter];
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:KSUpdateNotiList object:nil];
}

#pragma mark /*------------------------------------------数据请求------------------------------------------*/
- (void)reloadCell
{
    self.currentPage = 0;
    self.dataArray  = [[NSMutableArray alloc]init];
    [self requestData];//列表
}

- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataArray = [[NSMutableArray alloc]init];
        weakSelf.currentPage = ListBeginPage;
        [weakSelf requestData];//数据请求
    }];
    [weakSelf.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf requestData];
    }];
    footer.automaticallyHidden = YES;
    weakSelf.tableView.mj_footer = footer;
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                  @"pageSize":[NSNumber numberWithInt:ListPageSize],
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getNotifacationList] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefreshWitharray:weakSelf.dataArray];
        NSArray *array = dic[@"respData"][@"content"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSNotificationModel *model = [ZSNotificationModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
        }
        if (array.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        if (weakSelf.dataArray.count > 0) {
            weakSelf.errorView.hidden = YES;
        }else{
            weakSelf.errorView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
        [weakSelf endRefreshWitharray:weakSelf.dataArray];
    }];
}

#pragma mark 获取个人信息
- (void)getUserInfo
{
    if (![ZSLogInManager isLogIn]){
        return;
    }
    
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getUserInformation] SuccessBlock:^(NSDictionary *dic) {
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSLogInManager saveUserInfoWithDic:newdic];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSNotificationTableViewCell *cell = (ZSNotificationTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentLabel.bottom + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSNotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.dataArray.count > 0) {
        ZSNotificationModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.dataArray.count > 0)
    {
        ZSNotificationModel *model = self.dataArray[indexPath.row];
        //认证是否成功
        if ([model.title containsString:@"认证"])
        {
            ZSCertificationViewController *certifitcationVC = [[ZSCertificationViewController alloc]init];
            certifitcationVC.cerType = ZSFromPersonalWithCertified;
            [self.navigationController pushViewController:certifitcationVC animated:YES];
        }
        //跟订单有关的消息才让进入详情
        else if (model.tid)
        {
            if ([model.orderState isEqualToString:@"信息录入中"])
            {
                ZSCreateOrderPersonInfoViewController *detailVC = [[ZSCreateOrderPersonInfoViewController alloc]init];
                global.prdType = model.prdType;
                detailVC.personType = ZSFromOrderList;
                detailVC.orderIDString = model.serialNo;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else
            {
                ZSOrderDetailViewController *detailVC = [[ZSOrderDetailViewController alloc]init];
                global.prdType = model.prdType;
                detailVC.orderIDString = model.serialNo;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
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
