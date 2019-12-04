//
//  ZSAboutViewController.m
//  ZSSmallLandlord
//
//  Created by cong on 17/6/6.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAboutViewController.h"

@interface ZSAboutViewController ()

@end

@implementation ZSAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavgationBar:@"关于" withBackBtn:YES];
    [self configureViews];
}

- (void)configureViews
{
    //版本框
    UIView *whiteColorView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, kNavigationBarHeight + GapWidth, ZSWIDTH-GapWidth*2, ZSHEIGHT-GapWidth*2-kNavigationBarHeight)];
    whiteColorView.backgroundColor = ZSColorWhite;
    whiteColorView.layer.cornerRadius = 10;
    [self.view addSubview:whiteColorView];
    
    //图片
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake((whiteColorView.width - 90)/2, 80, 90, 90)];
    logoImage.image = [UIImage imageNamed:@"about_logo_n"];
    logoImage.layer.cornerRadius = 8;
    logoImage.clipsToBounds = YES;
    [whiteColorView addSubview:logoImage];
    
    //版本
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, logoImage.bottom + 20, ZSWIDTH-GapWidth*2, 30)];
    versionLabel.font = [UIFont boldSystemFontOfSize:15];
    versionLabel.textColor = ZSColorListLeft;
    versionLabel.text = [NSString stringWithFormat:@"版本号%@",[ZSTool localVersionShort]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [whiteColorView addSubview:versionLabel];
    
    //版权
    UILabel *copyrightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, whiteColorView.height-100, ZSWIDTH-GapWidth*2, 30)];
    copyrightLabel.font = [UIFont systemFontOfSize:12];
    copyrightLabel.textColor = ZSColorListLeft;
    copyrightLabel.text = @"Copyright © 2018  All Rights Reserved";
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    [whiteColorView addSubview:copyrightLabel];
    
    //公司
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, copyrightLabel.bottom, ZSWIDTH-GapWidth*2, 30)];
    companyLabel.font = [UIFont systemFontOfSize:12];
    companyLabel.textColor = ZSColorListLeft;
    companyLabel.text = @"湖南小房主金福网络科技有限公司    版权所有";
    companyLabel.textAlignment = NSTextAlignmentCenter;
    [whiteColorView addSubview:companyLabel];
}

- (UILabel *)LabelWithFrame:(CGRect)frame LabelText:(NSString *)title LableColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.text = title;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    return label;
}

@end
