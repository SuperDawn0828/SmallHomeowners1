//
//  ZSNewDetailViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSNewDetailViewController.h"

@interface ZSNewDetailViewController ()<UIScrollViewDelegate>
@end

@implementation ZSNewDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initWebView
{
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, 5)];
    self.progressView.progressTintColor = ZSColorGreen;
    self.progressView.trackTintColor = ZSColorWhite;
    [self.view addSubview:self.progressView];
    
    //webview
    self.mywebView = [[WKWebView alloc]initWithFrame:CGRectMake(GapWidth, kNavigationBarHeight, ZSWIDTH-GapWidth*2, ZSHEIGHT - kNavigationBarHeight + 50)];
    self.mywebView.UIDelegate = self;
    self.mywebView.navigationDelegate = self;
    self.mywebView.scrollView.delegate = self;
    self.mywebView.scrollView.scrollEnabled = YES;
    self.mywebView.backgroundColor = ZSColorWhite;
    self.mywebView.scrollView.backgroundColor = ZSColorWhite;
    self.mywebView.scrollView.showsVerticalScrollIndicator = NO;
    //修复图片和文字失调的问题
    NSString *htmlstr = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-size:45px;}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body>"
                         "<script type='text/javascript'>"
                         "window.onload = function(){\n"
                         "var $img = document.getElementsByTagName('img');\n"
                         "for(var p in  $img){\n"
                         " $img[p].style.width = '100%%';\n"
                         "$img[p].style.height ='auto'\n"
                         "}\n"
                         "}"
                         "</script>%@"
                         "</body>"
                         "</html>",self.model.content];
    [self.mywebView loadHTMLString:htmlstr baseURL:nil];
    [self.view addSubview:self.mywebView];
    
    //监听当前网页加载的进度和title
    [self.mywebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.mywebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    //----------------------------------------------帖子上面的内容----------------------------------------------
    //1.先计算标题高度
    CGFloat titleHeight = [ZSTool getStringHeight:self.model.title withframe:CGSizeMake(ZSWIDTH-GapWidth*2, 500) withSizeFont:[UIFont systemFontOfSize:22]];
    CGFloat topViewHeight = 10 + titleHeight + 10 + 20 + 45;
    
    //2.设置额外滚动大小
    self.mywebView.scrollView.contentInset = UIEdgeInsetsMake(topViewHeight, 0, topViewHeight, 0);
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, -topViewHeight, ZSWIDTH-GapWidth*2, topViewHeight)];
    [self.mywebView.scrollView addSubview:topBgView];
    
    //帖子标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH-GapWidth*2, titleHeight)];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = ZSColorBlack;
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = [ZSTool setTextString:[NSString stringWithFormat:@"%@",self.model.title] withSizeFont:[UIFont systemFontOfSize:22]];
    [topBgView addSubview:titleLabel];
    
    //帖子来源 + /帖子时间
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom + 15, ZSWIDTH-GapWidth*2, 20)];
    sourceLabel.font = [UIFont systemFontOfSize:14];
    sourceLabel.textColor = ZSColorListLeft;
    sourceLabel.text = [NSString stringWithFormat:@"%@  %@",self.model.source,self.model.pubTime];
    [topBgView addSubview:sourceLabel];
}

//禁止左右滑动左右
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
