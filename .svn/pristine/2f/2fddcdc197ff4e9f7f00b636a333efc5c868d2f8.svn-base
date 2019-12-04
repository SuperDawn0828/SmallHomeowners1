//
//  ZSProductDetailViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/9/14.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSProductDetailViewController.h"
#import "ZSLenderInfoViewController.h"

@interface ZSProductDetailViewController ()<UIScrollViewDelegate,ZSAlertViewDelegate>
@property(nonatomic,strong)UIButton *backButton;
@end

@implementation ZSProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureViews];
    [self configureBackButton];
    [self configureNavgationBar:[ZSGlobalModel getProductStateWithCode:global.prdType] withBackBtn:YES];
    self.navView.alpha = 0;
}

#pragma mark 图片
- (void)configureViews
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kStatusBarHeight, ZSWIDTH, ZSHEIGHT - 60 + kStatusBarHeight)];
    scrollView.backgroundColor = ZSColorWhite;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    //图片
    if (self.imageUrlString)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0)];
        [scrollView addSubview:imgView];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.imageUrlString]] placeholderImage:defaultImage_square options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //获取到图片宽高之后根据比例重新设置图片和scrollview大小
            imgView.frame = CGRectMake(0, 0, ZSWIDTH, ZSWIDTH * (image.size.height/image.size.width));
            scrollView.contentSize = CGSizeMake(ZSWIDTH, ZSWIDTH * (image.size.height/image.size.width));
            //隐藏加载框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"立即申请"];
}

#pragma mark 返回按钮
- (void)configureBackButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, kStatusBarHeight, NavBtnW, NavBtnW);
    [self.backButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, (NavBtnW-20)/2, 20, 20)];
    backImage.image = [UIImage imageNamed:@"head_return_n"];
    [self.backButton addSubview:backImage];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        self.navView.alpha = 0;
    }
    else if (scrollView.contentOffset.y < kNavigationBarHeight)
    {
        self.navView.alpha = scrollView.contentOffset.y/kNavigationBarHeight;
    }
    else
    {
        self.navView.alpha = 1;
    }
}

#pragma mark 底部按钮触发,需重写
- (void)bottomClick:(UIButton *)sender
{
    if ([self.titleLabel.text isEqualToString:@"安居贷"])
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"申请安居消费贷需要下载“华安信宝APP”后注册申请，是否确认前往下载？"];
        alert.delegate = self;
        [alert show];
    }
    else
    {
        ZSLenderInfoViewController *createVC = [[ZSLenderInfoViewController alloc]init];
        createVC.personType = ZSFromCreateOrderWithAdd;
        createVC.roleTypeString = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款人"]];
        [self.navigationController pushViewController:createVC animated:YES];
    }
}

- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.sinosafe.xb.client&fromcase=40002"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
