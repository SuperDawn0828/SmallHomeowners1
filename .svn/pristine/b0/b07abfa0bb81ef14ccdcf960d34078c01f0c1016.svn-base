//
//  ZSBaseWebViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/9.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSBaseWebViewController.h"

@interface ZSBaseWebViewController ()

@end

@implementation ZSBaseWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //设置状态栏字体颜色
    [self setStatusBarTextColorBlack];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //设置状态栏字体颜色
    [self setStatusBarTextColorWhite];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    self.view.backgroundColor = ZSColorWhite;
    [self configureNavgationBar:@"" withBackBtn:YES];
    self.navView.backgroundColor = ZSColor(249, 249, 249);
    self.backImg.image = [UIImage imageNamed:@"tool_guanbi_n"];
    self.backImg.frame = CGRectMake(15, (NavBtnW-15)/2, 15, 15);
    self.titleLabel.frame = CGRectMake(44, kStatusBarHeight, ZSWIDTH-44*2, kNavigationBarHeight-kStatusBarHeight);
    self.titleLabel.textColor = ZSColorBlack;
    //webview
    [self initWebView];
}

- (void)initWebView
{
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, 5)];
    self.progressView.progressTintColor = ZSColorGreen;
    self.progressView.trackTintColor = ZSColorWhite;
    [self.view addSubview:self.progressView];
    
    //webview
    self.mywebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight)];
    self.mywebView.UIDelegate = self;
    self.mywebView.navigationDelegate = self;
    NSURLRequest *requese = [NSURLRequest requestWithURL:[NSURL URLWithString:self.stringUrl]];
    [self.mywebView loadRequest:requese];
    [self.view addSubview:self.mywebView];
    
    //监听当前网页加载的进度和title
    [self.mywebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.mywebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark webviewDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    ZSLOG(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    ZSLOG(@"加载完成");
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    ZSLOG(@"加载失败");
}

//在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //进度值
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.mywebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            self.progressView.hidden = YES;
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.mywebView)
        {
            self.titleLabel.text = self.mywebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.mywebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.mywebView removeObserver:self forKeyPath:@"title"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
