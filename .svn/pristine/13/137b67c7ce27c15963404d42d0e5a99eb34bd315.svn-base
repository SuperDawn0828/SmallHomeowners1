//
//  ZSCreditReportViewController.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCreditReportViewController.h"
#import "ZSWSNewLeftRightCell.h"
#import <UShareUI/UShareUI.h>

@interface ZSCreditReportViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIImage        *shareImage;
@end

@implementation ZSCreditReportViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureViews];
    //Data
    [self initData];
}

#pragma mark /*---------------------------------------数据填充---------------------------------------*/
- (void)initData
{
    AgentPrecredit *model = global.pcOrderDetailModel.agentPrecredit;
    
    if (model.custName) {
        ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        dataModel.leftName = @"客户姓名";
        dataModel.rightData = [NSString stringWithFormat:@"%@",model.custName];
        [self.dataArray addObject:dataModel];
    }
    
    if (model.identityNo) {
        ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        dataModel.leftName = @"身份证号";
        dataModel.rightData = [NSString stringWithFormat:@"%@",model.identityNo];
        [self.dataArray addObject:dataModel];
    }
    
    if (model.custQualification) {
        ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        dataModel.leftName = @"用户资质";
        dataModel.rightData = [ZSGlobalModel getCustomerQualificationStateWithCode:model.custQualification];
        [self.dataArray addObject:dataModel];
    }
    
    if (model.canLoan) {//1可贷 2不可贷
        ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        dataModel.leftName = @"是否可贷";
        dataModel.rightData = [ZSGlobalModel getCanLoanStateWithCode:model.canLoan];
        [self.dataArray addObject:dataModel];
    }
    
    if (model.evaluationAmount) {
        ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        dataModel.leftName = @"房产评估价";
        dataModel.rightData = [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.evaluationAmount]];
        [self.dataArray addObject:dataModel];
    }
    
    if (model.maxCreditLimit) {
        ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        dataModel.leftName = @"最高贷款额";
        dataModel.rightData = [NSString stringWithFormat:@"%@元",[NSString ReviseString:model.maxCreditLimit]];
        [self.dataArray addObject:dataModel];
    }
    
    if (model.remark) {
        ZSOrderModel *dataModel = [[ZSOrderModel alloc]init];
        dataModel.leftName = @"备注";
        dataModel.rightData = [NSString stringWithFormat:@"%@",model.remark];
        [self.dataArray addObject:dataModel];
    }
    
    //刷新tableview
    [self.tableView reloadData];
}

#pragma mark /*---------------------------------------创建页面---------------------------------------*/
- (void)configureViews
{
    //table
    [self configureTableView:CGRectMake(0, kNavigationBarHeight-60, ZSWIDTH, ZSHEIGHT - kNavigationBarHeight) withStyle:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = CellHeight;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
    [self configureHeaderView];
    [self configureFooterView];
    
    //navgationBar
    [self configureNavgationBar:@"预授信报告" withBackBtn:YES];
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"分享至微信"];
}

- (void)configureHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 70)];
    headerView.backgroundColor = ZSViewBackgroundColor;
    self.tableView.tableHeaderView = headerView;
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, 60)];
    companyLabel.backgroundColor = ZSColorWhite;
    companyLabel.font = [UIFont boldSystemFontOfSize:16];
    companyLabel.textColor = ZSColorBlack;
    companyLabel.text = @"预授信报告";
    companyLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:companyLabel];
}

- (void)configureFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 220)];
    footerView.backgroundColor = ZSColorWhite;
    self.tableView.tableFooterView = footerView;
    
    //公司名
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 20, ZSWIDTH-GapWidth*2, 30)];
    companyLabel.font = [UIFont boldSystemFontOfSize:15];
    companyLabel.textColor = ZSColorBlack;
    companyLabel.text = @"湖南小房主金福网络科技有限公司";
    companyLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:companyLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, companyLabel.bottom, ZSWIDTH-GapWidth*2, 30)];
    timeLabel.font = [UIFont boldSystemFontOfSize:15];
    timeLabel.textColor = ZSColorBlack;
    timeLabel.text = global.pcOrderDetailModel.agentPrecredit.createDate;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:timeLabel];
    
    //公司公章
    UIImageView *chapterImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-100-GapWidth, 10, 100, 100)];
    chapterImage.image = [UIImage imageNamed:@"预授信印章"];
    [footerView addSubview:chapterImage];
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, ZSWIDTH, 0.5)];
    lineView.backgroundColor = ZSColorLine;
    [footerView addSubview:lineView];
    
    //公众号相关
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, lineView.bottom + 20, ZSWIDTH-GapWidth*3-80, 30)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = ZSColorListRight;
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"关注微信公众号：小房主金福";
    [footerView addSubview:label];
    
    UILabel *labelBottom = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, label.bottom, ZSWIDTH-GapWidth*3-80, 30)];
    labelBottom.font = [UIFont systemFontOfSize:12];
    labelBottom.textColor = ZSColorListRight;
    labelBottom.adjustsFontSizeToFitWidth = YES;
    labelBottom.text = @"长按识别，获取更快更优质的金融服务！";
    [footerView addSubview:labelBottom];
    
    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-70-GapWidth, lineView.bottom + 15, 70, 70)];
    codeImage.image = [UIImage imageNamed:@"QrCode"];
    [footerView addSubview:codeImage];
}

#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
    if (!cell) {
        cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        cell.hiddenLineView = YES;
    }
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

//不能往上滑哈哈哈,遮住分享需要显示title
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark /*---------------------------------------分享---------------------------------------*/
#pragma mark 分享至微信
- (void)bottomClick:(UIButton *)sender
{
    //设置需要分享的图片
    if (self.shareImage == nil) {
        self.shareImage = [ZSTool saveLongImage:self.tableView];
    }
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    if (!hadInstalledWeixin){
        [ZSTool showMessage:@"请先安装微信" withDuration:DefaultDuration];
    }else{
        [self shareAPP];
    }
}

#pragma mark 分享
- (void)shareAPP
{
    //设置平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    //创建分享
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //设置图片
        [shareObject setShareImage:self.shareImage];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
