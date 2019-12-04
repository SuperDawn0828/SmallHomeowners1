//
//  ZSNewHomeViewController.m
//  SmallHomeowners
//
//  Created by jeck on 2019/11/26.
//  Copyright © 2019 maven. All rights reserved.
//

#import "ZSNewHomeViewController.h"
#import "ZSHomeApplyViewController.h"
@interface ZSNewHomeViewController ()
@property(nonatomic,strong) UIScrollView *scorllView;
@end

@implementation ZSNewHomeViewController
#pragma mark - scorllView
-(UIScrollView *)scorllView{
    if (!_scorllView) {
        //获取导航栏和状态栏的高度
        CGFloat barHeight = [self barHeight];
        _scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -kStatusBarHeight, ZSWIDTH, ZSHEIGHT_PopupWindow - kTabbarHeight+kStatusBarHeight)];
//        CGFloat imgH = [self imgContentHeight];
//        _scorllView.contentSize = CGSizeMake(0,imgH);//设置滚动视图的大小
//        _scView.pagingEnabled = YES;//设置是否可以进行画面切换  分块显示
        _scorllView.bounces = NO;
        _scorllView.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
        _scorllView.showsVerticalScrollIndicator = NO;//
    }
    return _scorllView;
}
#pragma mark - 内容的高度
-(CGFloat)imgContentHeight{
    //获取图片高度
    UIImage *img = [UIImage imageNamed:@"process"];
    CGFloat imgHeight = img.size.height;
    CGFloat imgWidth = img.size.width;
    CGFloat imgH = imgHeight * (ZSWIDTH / imgWidth);
    return imgH;
}
#pragma mark - 获取导航栏和状态栏的高度
-(CGFloat)barHeight{
    //获取导航栏和状态栏的高度
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGFloat barHeight = statusBarFrame.size.height + navBarFrame.size.height;
    return barHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavgationBar:@"" withBackBtn:NO];

    [self creatSubView];
}
-(void)creatSubView{
    [self.view addSubview:self.scorllView];
    CGSize size = [UIImage imageNamed:@"newhome_bg"].size;

    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
    [bgImg setImage:[UIImage imageNamed:@"newhome_bg"]];
    bgImg.userInteractionEnabled = YES;
    bgImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.scorllView addSubview:bgImg];
    
    self.scorllView.contentSize = CGSizeMake(ZSWIDTH,bgImg.height);
    
    UIButton *playBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, bgImg.height-60, ZSWIDTH-60, 40)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"button_apply"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(ApplyBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:playBtn];
    
    UIImageView *processImg = [[UIImageView alloc]initWithFrame:CGRectMake(30, bgImg.height-210,ZSWIDTH-60, 130)];
    [processImg setImage:[UIImage imageNamed:@"process"]];
//    processImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgImg addSubview:processImg];
    
}
-(void)ApplyBtn{
    ZSHomeApplyViewController *createVC = [[ZSHomeApplyViewController alloc]init];
    global.prdType = @"1084";
    global.pcOrderDetailModel = nil;
    createVC.personType = ZSFromCreateOrderWithAdd;
    createVC.roleTypeString = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款人"]];
    [self.navigationController pushViewController:createVC animated:YES];
}
@end
