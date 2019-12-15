//
//  ZSOrderListViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/26.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSOrderListViewController.h"
#import "ZSOrderListTableViewCell.h"
#import "ZSBaseSearchViewController.h"
#import "ZSOrderDetailViewController.h"
#import "ZSCreateOrderPersonInfoViewController.h"
#import "ZSHomeApplyViewController.h"

@interface ZSOrderListViewController ()
@property (nonatomic,strong)UILabel          *sayhelloLabel;   //打招呼label
@property (nonatomic,strong)UILabel          *noticeLabel;     //提示label
@property (nonatomic,strong)NSMutableArray   *dataArray;
@property (nonatomic,assign)int              currentPage;      //当前页
@end

@implementation ZSOrderListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //列表页面清空订单详情的数据
    global.pcOrderDetailModel = nil;
    
    //普通的页面
    if (!self.searchKeyWord)
    {
        //打招呼label
        if ([ZSLogInManager readUserInfo].username.length) {
            self.sayhelloLabel.text = [NSString stringWithFormat:@"%@，%@！",[ZSLogInManager readUserInfo].username,[ZSTool getTheTimeBucket]];
        }else{
            self.sayhelloLabel.text = [NSString stringWithFormat:@"%@!",[ZSTool getTheTimeBucket]];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureTopView];
    [self configureTable];
    [self configureErrorViewWithStyle:ZSErrorWithoutOrder];//无订单
    //Data
    [self addHeader];
    [self addFooter];
    [NOTI_CENTER addObserver:self selector:@selector(reloadCell) name:KSUpdateAllOrderListNotification object:nil];
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
                                  @"keywords":self.searchKeyWord ? self.searchKeyWord : @"",
                                  @"prdType":@"",
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getOrderList] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefreshWitharray:weakSelf.dataArray];
        NSArray *array = dic[@"respData"][@"content"];
        NSLog(@"%@", array);
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSAllListModel *model = [ZSAllListModel yy_modelWithDictionary:dict];
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
            weakSelf.noticeLabel.text = @"    我的订单";
        }else{
            weakSelf.errorView.hidden = NO;
            weakSelf.noticeLabel.text = @"";
        }
        [weakSelf.tableView reloadData];
    } ErrorBlock:^(NSError *error) {
        [weakSelf endRefreshWitharray:weakSelf.dataArray];
        if (weakSelf.dataArray.count > 0) {
            weakSelf.errorView.hidden = YES;
            weakSelf.noticeLabel.text = @"    我的订单";
        }else{
            weakSelf.errorView.hidden = NO;
            weakSelf.noticeLabel.text = @"";
        }
    }];
}

#pragma mark /*------------------------------------------顶部------------------------------------------*/
- (void)configureTopView
{
    //普通的页面
    if (!self.searchKeyWord)
    {
        [self configureNavgationBar:@"" withBackBtn:NO];
        self.navView.frame = CGRectMake(0, 0, ZSWIDTH, kStatusBarHeight + (10+CellHeight) + 60);
        
        //打招呼label
        self.sayhelloLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, kStatusBarHeight + 10, ZSWIDTH - 30, CellHeight)];
        self.sayhelloLabel.font = [UIFont systemFontOfSize:25];
        self.sayhelloLabel.textColor = ZSColorWhite;
        self.sayhelloLabel.adjustsFontSizeToFitWidth = YES;
        [self.navView addSubview:self.sayhelloLabel];
        
        //搜索按钮
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(GapWidth, self.sayhelloLabel.bottom + (60-35)/2, ZSWIDTH-GapWidth*2, 35);
        [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
        searchBtn.backgroundColor = ZSColorAlpha(255, 255, 255, 0.5);
        searchBtn.layer.cornerRadius = 17.5;
        searchBtn.clipsToBounds = YES;
        [self.navView addSubview:searchBtn];
        
        //搜索图片
        UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, (35-15)/2, 15, 15)];
        searchImage.image = [UIImage imageNamed:@"head_search_n"];
        [searchBtn addSubview:searchImage];
        
        //搜索label
        UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 200, 35)];
        searchLabel.font = FontSecondTitle;
        searchLabel.textColor = ZSColorWhite;
        searchLabel.text = @"输入客户姓名/身份证号/手机号";
        [searchBtn addSubview:searchLabel];
    }
    //搜索结果页面
    else
    {
        [self configureNavgationBar:self.searchKeyWord withBackBtn:YES];
    }
}

#pragma mark /*------------------------------------------创建table------------------------------------------*/
- (void)configureTable
{
    //普通的页面
    if (!self.searchKeyWord)
    {
        [self configureTableView:CGRectMake(0, self.navView.bottom, ZSWIDTH, ZSHEIGHT - self.navView.height - kTabbarHeight + SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
        
        //提示label
        self.noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,ZSWIDTH, CellHeight)];
        self.noticeLabel.font = FontBtn;
        self.noticeLabel.textColor = ZSColorBlack;
        self.tableView.tableHeaderView = self.noticeLabel;
    }
    //搜索结果页面
    else
    {
        [self configureTableView:CGRectMake(0, self.navView.bottom, ZSWIDTH, ZSHEIGHT - self.navView.height) withStyle:UITableViewStylePlain];
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 10)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.dataArray.count > 0)
    {
        ZSAllListModel *model = self.dataArray[indexPath.row];
        if (([model.order_state isEqualToString:@"信息录入中"] || [model.order_state isEqualToString:@"待风控调查"]) && model.isConfirmed == 0 && [ZSLogInManager readUserInfo].userType.intValue == 6)
        {
            ZSHomeApplyViewController *createVC = [[ZSHomeApplyViewController alloc]init];
            global.prdType = @"1084";
            global.pcOrderDetailModel = nil;
            createVC.personType = ZSFromCreateOrderWithAdd;
            createVC.orderIDString = model.tid;
            createVC.roleTypeString = @"业务申请";
            [self.navigationController pushViewController:createVC animated:YES];
        }
        else
        {
            ZSOrderDetailViewController *detailVC = [[ZSOrderDetailViewController alloc]init];
            global.prdType = model.prd_type;
            detailVC.orderIDString = model.tid;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark /*------------------------------------------事件------------------------------------------*/
#pragma mark 跳转到搜索框
- (void)searchBtnAction
{
    if (![ZSLogInManager isLogIn])
    {
        [ZSLogInManager gotoLogInViewCtrl:self isCanDismissSelf:YES];
        return;
    }
    
    ZSBaseSearchViewController *searchVC = [[ZSBaseSearchViewController alloc]init];
    searchVC.filePathString = KAllListSearch;
    [self.navigationController pushViewController:searchVC animated:YES];
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
