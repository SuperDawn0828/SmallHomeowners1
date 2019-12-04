//
//  ZSSettingViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/9/30.
//  Copyright © 2018 maven. All rights reserved.
//

#import "ZSSettingViewController.h"
#import "ZSPersonalDetailCell.h"

@interface ZSSettingViewController ()<ZSAlertViewDelegate>

@end

@implementation ZSSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"设置" withBackBtn:YES];
    [self configureTable];
}

#pragma mark 创建table
- (void)configureTable
{
    [self configureTableView:CGRectMake(0, self.navView.bottom, ZSWIDTH, ZSHEIGHT - self.navView.height) withStyle:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    
    //footer
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = backgroundView;

    //退出按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0,10, ZSWIDTH, CellHeight);
    logoutBtn.backgroundColor = ZSColorWhite;
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [logoutBtn setTitleColor:ZSColorGolden forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:logoutBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSPersonalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSPersonalDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.leftLabel.textColor = ZSColorListRight;
    }
    //赋值
    NSArray *array_img   = @[@"my_clean_n"];
    NSArray *array_title = @[@"清除缓存"];
    cell.leftImage.image = [UIImage imageNamed:array_img[indexPath.row]];
    cell.leftLabel.text = array_title[indexPath.row];
    //获取图片缓存大小
    CGFloat size = [[SDImageCache sharedImageCache] getSize];
    CGFloat totalSize = size/1000.0/1000.0;
    cell.rightLabel.text = [NSString stringWithFormat:@"%.2f MB",totalSize];
    cell.rightLabel.textColor = ZSColorAllNotice;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //清除缓存
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确定要清空缓存吗?" sureTitle:@"确定" cancelTitle:@"取消"];
    alert.delegate = self;
    alert.tag = 100;
    [alert show];
}

#pragma mark 退出
- (void)loginOutClick
{
    ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"确定要退出吗?" sureTitle:@"确定" cancelTitle:@"取消"];
    alert.delegate = self;
    alert.tag = 110;
    [alert show];
}

- (void)AlertView:(ZSAlertView *)alert
{
    if (alert.tag == 100)
    {
        __weak typeof(self) weakSelf = self;
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [ZSTool showMessage:@"清除成功" withDuration:DefaultDuration];
            [weakSelf.tableView reloadData];
        }];
    }
    else if (alert.tag == 110)
    {
        [ZSLogInManager userLogOut:self];
    }
}


@end
