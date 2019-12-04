//
//  ZSBaseViewController.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/6/2.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSErrorView.h"
#import "ZSGlobalModel.h"

static CGFloat NavBtnW = 44;//导航栏按钮的高宽

@interface ZSBaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView             *navView;         //自定义导航栏
@property (nonatomic,strong) UILabel            *titleLabel;      //导航栏标题
@property (nonatomic,strong) UIButton           *leftButton;      //左侧返回按钮
@property (nonatomic,strong) UIImageView        *backImg;         //返回按钮图片
@property (nonatomic,strong) UIButton           *rightBtn;        //右侧一个按钮
@property (nonatomic,strong) UIView             *bottomView;      //底部按钮背景view
@property (nonatomic,strong) UIButton           *bottomBtn;       //底部按钮
@property (nonatomic,strong) UITableView        *tableView;       //tableView
@property (nonatomic,strong) ZSErrorView        *errorView;       //缺省页
//订单详情用的
@property (nonatomic,copy  ) NSString           *orderIDString;   //订单id
@property (nonatomic,assign) ZSPersonInfoType   personType;       //页面类型

#pragma mark 状态栏
- (void)setStatusBarBackgroundColor:(UIColor *)color;
- (void)cleanStatusBarBackgroundColor;
- (void)setStatusBarTextColorBlack;
- (void)setStatusBarTextColorWhite;

#pragma mark 自定义导航栏
- (void)configureNavgationBar:(NSString *)titleString withBackBtn:(BOOL)needBack;

#pragma mark 返回按钮
- (void)setLeftBarButtonItem;//创建返回按钮
- (void)leftAction;//返回事件

#pragma mark 右侧导航栏按钮
- (void)configureRightNavItemWithTitle:(NSString*)title withNormalImg:(NSString*)norImg withHilightedImg:(NSString*)hilightedImg;//一个
- (void)RightBtnAction:(UIButton*)sender;//右侧导航栏点击事件,需重写

#pragma mark 底部按钮
- (void)configuBottomButtonWithTitle:(NSString*)title OriginY:(CGFloat)Y;//高度不固定
- (void)configuBottomButtonWithTitle:(NSString*)title;//高度固定
- (void)bottomClick:(UIButton *)sender;//底部按钮触发,需重写
- (void)setBottomBtnEnable:(BOOL)enable;

#pragma mark 创建tableview
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style;

#pragma mark 键盘添加工具栏
- (UIToolbar *)addToolbar;
- (void)hideKeyboard;//键盘隐藏

#pragma mark 上下拉刷新
- (void)endRefreshWitharray:(NSMutableArray *)myArray;
- (void)requestFailWitharray:(NSMutableArray *)myArray;//收到请求失败的通知

#pragma mark 无数据
- (void)configureErrorViewWithStyle:(NSInteger)style;

@end
