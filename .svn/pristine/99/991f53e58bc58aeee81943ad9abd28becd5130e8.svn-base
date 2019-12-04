//
//  ZSHomeViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/26.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSHomeViewController.h"
#import "ZSHomeHeaderView.h"
#import "ZSHomeTableViewCell.h"
#import "ZSPositionViewController.h"
#import "ZSNewDetailViewController.h"
#import "ZSBaseWebViewController.h"
#import "ZSProductDetailViewController.h"
#import "ZSCreateOrderPopupModel.h"
#import "ZSProductListViewController.h"

@interface ZSHomeViewController ()<LocationManagerDelegate,ZSHomeHeaderViewDelegate>
@property (nonatomic,strong)UIImageView      *positionImage;  //定位图片
@property (nonatomic,strong)UILabel          *positionLabel;  //定位状态
@property (nonatomic,strong)ZSHomeHeaderView *headerView;     //tableHeader
@property (nonatomic,strong)NSMutableArray   *imageDataArray;
@property (nonatomic,strong)NSMutableArray   *toolsDataArray;
@property (nonatomic,strong)NSMutableArray   *dataArray;
@property (nonatomic,assign)int              currentPage;     //当前页
@end

@implementation ZSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureTable];
    [self configureTopView];
    //Data
    [self getLocationInfo];
    [self addHeader];
    [self addFooter];
    [self configureErrorViewWithStyle:ZSErrorWithoutHomePage];//首页无数据
    [NOTI_CENTER addObserver:self selector:@selector(addHeader) name:KUpdateHomePageData object:nil];
}

#pragma mark /*------------------------------------------定位信息------------------------------------------*/
- (void)getLocationInfo
{
    //获取位置信息
    NSString *cityString = [USER_DEFALT objectForKey:KLocationInfo];
    if (cityString.length) {
        self.positionLabel.text = cityString;
        if ([cityString isEqualToString:@"定位中"] || [cityString isEqualToString:@"定位失败"]) {
            LocationManager *manger = [LocationManager shareInfo];
            manger.delegate = self;
            [manger startPositioning];
        }
    }
    else
    {
        LocationManager *manger = [LocationManager shareInfo];
        manger.delegate = self;
        [manger startPositioning];
    }
}

#pragma mark /*------------------------------------------数据请求------------------------------------------*/
- (void)addHeader
{
    __weak typeof(self) weakSelf  = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.imageDataArray = [[NSMutableArray alloc]init];
        weakSelf.toolsDataArray = [[NSMutableArray alloc]init];
        weakSelf.dataArray = [[NSMutableArray alloc]init];
        weakSelf.currentPage = ListBeginPage;
        [weakSelf requestProductListData];//可创建订单的产品列表
        [weakSelf requestCarouselsData];//轮播图
        [weakSelf requestToolsData];//小工具列表
        [weakSelf requestNewsData];//资讯列表
    }];
    [weakSelf.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf requestNewsData];
    }];
    footer.automaticallyHidden = YES;
    weakSelf.tableView.mj_footer = footer;
}

//获取可创建订单的产品列表
- (void)requestProductListData
{
    //预生产环境不请求
    if (![APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl] && ![APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl_port])
    {
        __weak typeof(self) weakSelf = self;
        NSMutableArray *productArray = [[NSMutableArray alloc]init];
        [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getOnlineProducts] SuccessBlock:^(NSDictionary *dic) {
            NSArray *array = dic[@"respData"];
            if (array.count > 0) {
                for (NSDictionary *dict in array) {
                    ZSCreateOrderPopupModel *model = [ZSCreateOrderPopupModel yy_modelWithDictionary:dict];
                    [productArray addObject:model];
                }
                global.productArray = productArray;
            }
            //产品推荐
            [weakSelf.headerView fillInProductsViewData:global.productArray];
            [weakSelf.headerView resetSelfHeight];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        } ErrorBlock:^(NSError *error) {
        }];
    }
}

//轮播图
- (void)requestCarouselsData
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getHomeCarousels] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSHomeCarouselModel *model = [ZSHomeCarouselModel yy_modelWithDictionary:dict];
                [weakSelf.imageDataArray addObject:model];
            }
        }
        //刷新headerView
        [weakSelf.headerView fillInCarouselViewData:weakSelf.imageDataArray];
        [weakSelf.headerView resetSelfHeight];
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    } ErrorBlock:^(NSError *error) {
    }];
}

//小工具列表
- (void)requestToolsData
{
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getHomeToolList] SuccessBlock:^(NSDictionary *dic) {
        NSArray *array = dic[@"respData"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSHomeToolModel *model = [ZSHomeToolModel yy_modelWithDictionary:dict];
                [weakSelf.toolsDataArray addObject:model];
            }
        }
        //刷新headerView
        [weakSelf.headerView fillInToolBtnsViewData:weakSelf.toolsDataArray];
        [weakSelf.headerView resetSelfHeight];
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    } ErrorBlock:^(NSError *error) {
    }];
}

//资讯列表
- (void)requestNewsData
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dict = @{
                                  @"nextPage":[NSNumber numberWithInt:self.currentPage],
                                  @"pageSize":[NSNumber numberWithInt:ListPageSize],
                                  }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getHomeNewsList] SuccessBlock:^(NSDictionary *dic) {
        [weakSelf endRefreshWitharray:weakSelf.dataArray];
        NSArray *array = dic[@"respData"][@"content"];
        if (array.count > 0) {
            for (NSDictionary *dict in array) {
                ZSHomeNewsModel *model = [ZSHomeNewsModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
        }
        if (array.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        //刷新headerView
        if (weakSelf.dataArray.count > 0) {
            [weakSelf.headerView configureNoticeLabel];
            [weakSelf.headerView resetSelfHeight];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        }
        [weakSelf.tableView reloadData];
        //缺省页
        [weakSelf showTheDefaultPage];
    } ErrorBlock:^(NSError *error) {
        [weakSelf endRefreshWitharray:weakSelf.dataArray];
        //刷新headerView
        if (weakSelf.dataArray.count > 0) {
            [weakSelf.headerView configureNoticeLabel];
            [weakSelf.headerView resetSelfHeight];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        }
        //缺省页
        [weakSelf showTheDefaultPage];
    }];
}

#pragma mark 缺省页的显隐
- (void)showTheDefaultPage
{
    if ( self.imageDataArray.count + self.toolsDataArray.count + self.dataArray.count == 0)
    {
        self.errorView.hidden = NO;
    }
    else
    {
        self.errorView.hidden = YES;
    }
}

#pragma mark /*------------------------------------------顶部------------------------------------------*/
- (void)configureTopView
{
    [self configureNavgationBar:@"首页" withBackBtn:NO];
    self.navView.alpha = 0;
    
    //定位按钮
    UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    positionBtn.frame = CGRectMake(5, kStatusBarHeight, 150, CellHeight);
    [positionBtn addTarget:self action:@selector(positionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:positionBtn];
    
    //定位图片
    self.positionImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 12, 20, 20)];
    self.positionImage.image = [UIImage imageNamed:@"定位-黄色"];
    [positionBtn addSubview:self.positionImage];
    
    //定位状态
    self.positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.positionImage.right+5, 0, positionBtn.width-30, CellHeight)];
    self.positionLabel.font = FontSecondTitle;
    self.positionLabel.adjustsFontSizeToFitWidth = YES;
    self.positionLabel.textColor = ZSColorGoldenHighlighted;
    self.positionLabel.text = @"请选择定位";
    [positionBtn addSubview:self.positionLabel];
}

- (void)currentCityInfo:(NSString *)string;//当前城市信息
{
    self.positionLabel.text = string;
}

#pragma mark /*------------------------------------------创建table------------------------------------------*/
- (void)configureTable
{
    //table
    [self configureTableView:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT - kTabbarHeight + SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
    
    //header
    self.headerView = [[ZSHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0)];
    self.headerView.delegate = self;
    [self.headerView resetSelfHeight];
    self.tableView.tableHeaderView = self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.dataArray.count > 0) {
        ZSHomeNewsModel *model = self.dataArray[indexPath.row];
        if (model) {
            cell.model = model;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZSNewDetailViewController *detailVC = [[ZSNewDetailViewController alloc]init];
    if (self.dataArray.count > 0) {
        ZSHomeNewsModel *model = self.dataArray[indexPath.row];
        detailVC.model = model;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark /*------------------------------------------事件------------------------------------------*/
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        self.navView.alpha = 0;
        self.positionImage.image = [UIImage imageNamed:@"定位-黄色"];
        self.positionLabel.textColor = ZSColorGoldenHighlighted;
    }
    else if (scrollView.contentOffset.y < kNavigationBarHeight)
    {
        self.navView.alpha = scrollView.contentOffset.y/kNavigationBarHeight;
    }
    else
    {
        self.navView.alpha = 1;
        self.positionImage.image = [UIImage imageNamed:@"定位-白色"];
        self.positionLabel.textColor = ZSColorWhite;
    }
}

#pragma mark 跳转到定位页面
- (void)positionBtnAction
{
    __weak typeof(self) weakSelf = self;
    ZSPositionViewController *positionVC = [[ZSPositionViewController alloc]init];
    positionVC.postionBlock = ^(NSString *cityName){

        weakSelf.positionLabel.text = cityName;
    };
    [self.navigationController pushViewController:positionVC animated:YES];
}

#pragma mark 点击轮播图
- (void)indexOfClickedImageBtn:(NSUInteger)index;//点击轮播图
{
    if (self.imageDataArray.count > 0) {
        ZSHomeCarouselModel *model = self.imageDataArray[index];
        NSString *linkString = [NSString stringWithFormat:@"%@",model.carouselLink];
        if (linkString.length) {
            ZSBaseWebViewController *webView = [[ZSBaseWebViewController alloc]init];
            webView.stringUrl = linkString;
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}

#pragma mark 点击产品推荐(单个)
- (void)indexOfClickedProductImageView:(NSUInteger)index;//点击产品
{
    ZSCreateOrderPopupModel *model = global.productArray[index];
    global.prdType = model.prdType;
    
    ZSProductDetailViewController *detailVC = [[ZSProductDetailViewController alloc]init];
    detailVC.imageUrlString = model.detailImg;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 点击产品推荐(全部产品)
- (void)checkAllProduct;
{
    ZSProductListViewController *listVC = [[ZSProductListViewController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark 点击小工具
- (void)indexOfClickedToolsBtn:(NSUInteger)index;//点击小工具
{
    if (self.toolsDataArray.count) {
        ZSHomeToolModel *model = self.toolsDataArray[index];
        NSString *linkString = [NSString stringWithFormat:@"%@",model.funcLink];
        if (linkString.length) {
            ZSBaseWebViewController *webView = [[ZSBaseWebViewController alloc]init];
            webView.stringUrl = linkString;
            [self.navigationController pushViewController:webView animated:YES];
        }
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
