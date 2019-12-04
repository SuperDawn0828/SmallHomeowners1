//
//  ZSBaseViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseViewController.h"

@interface ZSBaseViewController ()

@end

@implementation ZSBaseViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //隐藏键盘
    [self hideKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启手势
    [self openInteractivePopGestureRecognizerEnable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //页面背景色
    self.view.backgroundColor = ZSViewBackgroundColor;
    //状态栏颜色
    [self setStatusBarTextColorWhite];
    //隐藏系统导航栏
    self.navigationController.navigationBar.hidden = YES; 
}

#pragma mark /*------------------------------------------手势相关-------------------------------------------*/
#pragma mark 开启返回手势(自定义返回按钮会导致手势失效)
- (void)openInteractivePopGestureRecognizerEnable
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark 返回手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 判断是否是侧滑相关的手势
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        // 如果当前展示的控制器是根控制器就不让其响应
        if (self.navigationController.viewControllers.count < 2 ||
            self.navigationController.visibleViewController == [self.navigationController.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark /*-------------------------------------------状态栏设置--------------------------------------------*/
#pragma mark 状态栏背景色
- (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = color;
}

- (void)cleanStatusBarBackgroundColor
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = [UIColor clearColor];
}

#pragma mark 设置状态栏字体颜色
- (void)setStatusBarTextColorBlack
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)setStatusBarTextColorWhite
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark /*------------------------------------------自定义导航栏-------------------------------------------*/
#pragma mark 自定义导航栏
- (void)configureNavgationBar:(NSString *)titleString withBackBtn:(BOOL)needBack;
{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, kNavigationBarHeight)];
    self.navView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navgationBarBackground"]];
    [self.view addSubview:self.navView];
    
    //标题
    CGFloat titleW = ZSWIDTH - NavBtnW * 6;
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH-titleW)/2, kStatusBarHeight, titleW, kNavigationBarHeight-kStatusBarHeight)];
    self.titleLabel.font = FontMain;
    self.titleLabel.textColor = ZSColorWhite;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = titleString ? titleString : @"";
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.5;
    [self.navView addSubview:self.titleLabel];
    
    //返回按钮
    if (needBack) {
        [self setLeftBarButtonItem];
    }
}

#pragma mark 返回按钮
- (void)setLeftBarButtonItem
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, kStatusBarHeight, NavBtnW, NavBtnW);
    [self.leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (NavBtnW-20)/2, 20, 20)];
    self.backImg.image = [UIImage imageNamed:@"head_return_n"];
    [self.leftButton addSubview:self.backImg];
    [self.navView addSubview:self.leftButton];
}

- (void)leftAction
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 右侧按钮(一个)
- (void)configureRightNavItemWithTitle:(NSString*)title withNormalImg:(NSString*)norImg withHilightedImg:(NSString*)hilightedImg
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setFrame:CGRectMake(ZSWIDTH-NavBtnW*3-10, 20, NavBtnW*3, 44)];
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightBtn.tag = 0;
    [self.rightBtn addTarget:self action:@selector(RightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //图片
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.rightBtn.width-25, 12, 20, 20)];
    [self.rightBtn addSubview:rightImg];
    if (title) {
        [self.rightBtn setTitle:title forState:UIControlStateNormal];
    }
    if (norImg) {
        rightImg.image = [UIImage imageNamed:norImg];
    }
    if (hilightedImg) {
        rightImg.highlightedImage = [UIImage imageNamed:hilightedImg];
    }
    [self.navView addSubview:self.rightBtn];
}

//右侧导航栏点击事件,需重写
- (void)RightBtnAction:(UIButton*)sender
{
    ZSLOG(@"----点击了右侧导航栏");
}

#pragma mark /*------------------------------------------底部按钮-------------------------------------------*/
#pragma mark 位置不固定
- (void)configuBottomButtonWithTitle:(NSString*)title OriginY:(CGFloat)Y
{
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.frame = CGRectMake(GapWidth, Y, ZSWIDTH-GapWidth*2, 44);
    [self.bottomBtn setTitle:title forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"navgationBarBackground"] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:UIColorFromRGB(0xF5DEB3)] forState:UIControlStateHighlighted];
    self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.bottomBtn.layer.cornerRadius = 22;
    self.bottomBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.bottomBtn];
}

#pragma mark 位置固定
- (void)configuBottomButtonWithTitle:(NSString*)title
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT - 60, ZSWIDTH, 60 + SafeAreaBottomHeight)];
    self.bottomView.backgroundColor = ZSColorWhite;
    [self.view addSubview:self.bottomView];

    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.frame = CGRectMake(GapWidth, 7, ZSWIDTH-GapWidth*2, 44);
    [self.bottomBtn setTitle:title forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"navgationBarBackground"] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:UIColorFromRGB(0xF5DEB3)] forState:UIControlStateHighlighted];
    self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.bottomBtn.layer.cornerRadius = 22;
    self.bottomBtn.layer.masksToBounds = YES;
    [self.bottomView addSubview:self.bottomBtn];
}

#pragma mark 底部按钮是否可点击
- (void)setBottomBtnEnable:(BOOL)enable
{
    if (enable) {
        self.bottomBtn.userInteractionEnabled = YES;
        [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"navgationBarBackground"] forState:UIControlStateNormal];
    }else{
//        self.bottomBtn.userInteractionEnabled = NO;
        [self.bottomBtn setBackgroundImage:[ZSTool createImageWithColor:ZSColorCanNotClick] forState:UIControlStateNormal];
    }
}

#pragma mark 底部按钮触发,需重写
- (void)bottomClick:(UIButton *)sender
{
    
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZSViewBackgroundColor;
    self.tableView.sectionIndexColor = ZSColorAllNotice;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark /*------------------------------------------键盘添加工具栏------------------------------------------*/
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, 35)];
    toolbar.tintColor = ZSColor(0, 126, 229);
    toolbar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    bar.tintColor = ZSColorListRight;
    toolbar.items = @[nextButton, prevButton, space, bar];
    return toolbar;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark /*------------------------------------------上下拉刷新------------------------------------------*/
- (void)endRefreshWitharray:(NSMutableArray *)myArray;
{
    if ([self.tableView.mj_header isRefreshing]) {
        [myArray removeAllObjects];
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

//收到请求失败的通知
- (void)requestFailWitharray:(NSMutableArray *)myArray;
{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    [myArray removeAllObjects];
    [self.tableView reloadData];
    self.errorView.hidden = NO;
}

#pragma mark /*------------------------------------------缺省页------------------------------------------*/
- (void)configureErrorViewWithStyle:(NSInteger)style
{
    self.errorView = [[ZSErrorView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, ZSWIDTH, self.view.height - self.navView.height)];
    self.errorView.hidden = YES;
    [self.view addSubview:self.errorView];
    switch (style) {
        //订单列表无订单
        case ZSErrorWithoutOrder:{
            self.errorView.imagView.image = [UIImage imageNamed:@"withoutOrder"];
            self.errorView.titleLab.text  = KErrorWithoutOrder;
        }
            break;
        //消息列表无数据
        case ZSErrorWithoutNoti:{
            self.errorView.imagView.image = [UIImage imageNamed:@"withoutOrder"];
            self.errorView.titleLab.text  = KErrorWithoutNoti;
        }
            break;
//        //网络未授权
//        case ZSErrorWithoutNetworkPermission:{
//            self.errorView.imagView.image = [UIImage imageNamed:@"withoutNetwork"];
//            self.errorView.titleLab.text  = KErrorWithoutNetworkPermission;
//            self.errorView.titleLab.textColor  = ZSColorListLeft;
//        }
//            break;
        //网络断开连接
        case ZSErrorWithoutNetwork:{
            self.errorView.imagView.image = [UIImage imageNamed:@"withoutNetwork"];
            self.errorView.titleLab.text  = KErrorWithoutNetwork;
            self.errorView.titleLab.textColor  = ZSColorListLeft;
        }
            break;
        //首页无数据
        case ZSErrorWithoutHomePage:{
            self.errorView.imagView.image = [UIImage imageNamed:@"withoutNetwork"];
            self.errorView.titleLab.text  = KErrorWithoutHomePageData;
            self.errorView.titleLab.textColor  = ZSColorListLeft;
        }
            break;
            
        default:
            break;
    }
}

@end
