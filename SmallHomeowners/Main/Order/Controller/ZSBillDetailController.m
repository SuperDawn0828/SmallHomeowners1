#import "ZSBillDetailController.h"
#import "ZSWSNewLeftRightCell.h"
#import "ZSOrderModel.h"
#import "ZSRepaymentDetailsCell.h"
#import "ZSRepaymentDetailModel.h"

@interface ZSBillDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *personDataList;

@property (nonatomic, strong) NSArray<ZSRepaymentRepayment *> *repaymentList;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *stateImageView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) ZSRepaymentDetailModel *repaymentDetailModel;

@end

@implementation ZSBillDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavgationBar:@"账单详情" withBackBtn:YES];
    [self configureTableView:CGRectMake(0, CGRectGetMaxY(self.navView.frame), UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - self.navView.frame.size.height) withStyle:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:KReuseZSWSNewLeftRightCellIdentifier bundle:nil] forCellReuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZSRepaymentDetailsCell" bundle:nil] forCellReuseIdentifier:@"ZSRepaymentDetailsCell"];
    
    [self configureTopView];
    
    self.personDataList = [[NSMutableArray alloc] initWithCapacity:0];
    [self requestData];
}

- (void)configureTopView
{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 52)];
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navgationBarBackground"]];
    self.tableView.tableHeaderView = self.headerView;
    
    //订单状态icon
    self.stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, 12.5, 20, 20)];
    self.stateImageView.image = [UIImage imageNamed:@"u4"];
    [self.headerView addSubview:self.stateImageView];
    
    //订单状态
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.stateImageView.right+10, 0, ZSWIDTH-70, 45)];
    self.stateLabel.font = [UIFont boldSystemFontOfSize:20];
    self.stateLabel.textColor = ZSColorWhite;
    self.stateLabel.adjustsFontSizeToFitWidth = YES;
    self.stateLabel.text = @"订单状态";
    [self.headerView addSubview:self.stateLabel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.repaymentList) {
        return self.repaymentList.count + 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.personDataList.count;
    } else {
        if (self.repaymentList) {
            return self.repaymentList.count;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZSWSNewLeftRightCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        if (!cell) {
            cell = [[ZSWSNewLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseZSWSNewLeftRightCellIdentifier];
        }
        ZSOrderModel *model = self.personDataList[indexPath.row];
        cell.leftLab.text = model.leftName;
        cell.rightLab.text = model.rightData;
        return cell;
    } else {
        ZSRepaymentRepayment *repayment = self.repaymentList[indexPath.section];
        ZSRepaymentDetailsCell *cell = (ZSRepaymentDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"ZSRepaymentDetailsCell"];
        cell.curLimit = [[NSString alloc] initWithFormat:@"%ld", repayment.curLimit];
        cell.repaidGuaranteeFee = [[NSString alloc] initWithFormat:@"%ld", repayment.repaidGuaranteeFee];
        cell.repaidMonthAmount = [[NSString alloc] initWithFormat:@"%ld", repayment.repaidMonthAmount];
        cell.repayGuaranteeFee = [[NSString alloc] initWithFormat:@"%ld", repayment.repayGuaranteeFee];
        cell.repayMonthDate = [[NSString alloc] initWithFormat:@"%@", repayment.repayMonthDate];
        cell.repayMonthAmount = [[NSString alloc] initWithFormat:@"%ld", repayment.repayMonthAmount];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

@end

@implementation ZSBillDetailController (Request)

- (void)requestData {
    if (self.orderIDString == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithCapacity:0];
    [parameter setValue:self.orderIDString forKey:@"orderId"];
    [ZSRequestManager requestWithParameter:parameter url:[ZSURLManager getOrderRepayment] SuccessBlock:^(NSDictionary *dic) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.repaymentDetailModel = [ZSRepaymentDetailModel yy_modelWithDictionary:dic];
        [strongSelf updateRepaymentData];
    } ErrorBlock:^(NSError *error) {
        
    }];
}

- (void)updateRepaymentData {
    ZSOrderModel *orderModel1 = [[ZSOrderModel alloc] init];
    orderModel1.leftName = @"贷款金额";
    orderModel1.rightData = [[NSString alloc] initWithFormat:@"%ld", self.repaymentDetailModel.repaymentOveriew.loanAmount];
    [self.personDataList addObject:orderModel1];
    
    ZSOrderModel *orderModel2 = [[ZSOrderModel alloc] init];
    orderModel2.leftName = @"还款期数";
    orderModel2.rightData = [[NSString alloc] initWithFormat:@"%ld", self.repaymentDetailModel.repaymentOveriew.curRepayLimit];
    [self.personDataList addObject:orderModel2];
    
    ZSOrderModel *orderModel3 = [[ZSOrderModel alloc] init];
    orderModel3.leftName = @"还款日";
    orderModel3.rightData = [[NSString alloc] initWithFormat:@"%ld", self.repaymentDetailModel.repaymentOveriew.repayDay];
    [self.personDataList addObject:orderModel3];
    
    ZSOrderModel *orderModel4 = [[ZSOrderModel alloc] init];
    orderModel4.rightData = [[NSString alloc] initWithFormat:@"%ld", self.repaymentDetailModel.repaymentOveriew.loanRate];
    orderModel4.leftName = @"贷款利率";
    [self.personDataList addObject:orderModel4];
    
    ZSOrderModel *orderModel5 = [[ZSOrderModel alloc] init];
    orderModel5.leftName = @"担保费率";
    orderModel4.rightData = [[NSString alloc] initWithFormat:@"%ld", self.repaymentDetailModel.repaymentOveriew.guaranteeRate];
    [self.personDataList addObject:orderModel5];

    self.repaymentList = self.repaymentDetailModel.repayment;
    [self.tableView reloadData];
}

@end
