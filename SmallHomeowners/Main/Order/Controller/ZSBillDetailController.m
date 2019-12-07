#import "ZSBillDetailController.h"
#import "ZSWSNewLeftRightCell.h"
#import "ZSOrderModel.h"
#import "ZSRepaymentDetailsCell.h"

@interface ZSBillDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *personDataList;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *stateImageView;

@property (nonatomic, strong) UILabel *stateLabel;

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
    
    ZSOrderModel *orderModel1 = [[ZSOrderModel alloc] init];
    orderModel1.leftName = @"贷款金额";
    [self.personDataList addObject:orderModel1];
    
    ZSOrderModel *orderModel2 = [[ZSOrderModel alloc] init];
    orderModel2.leftName = @"还款期数";
    [self.personDataList addObject:orderModel2];
    
    ZSOrderModel *orderModel3 = [[ZSOrderModel alloc] init];
    orderModel3.leftName = @"还款日";
    [self.personDataList addObject:orderModel3];
    
    ZSOrderModel *orderModel4 = [[ZSOrderModel alloc] init];
    orderModel4.leftName = @"贷款利率";
    [self.personDataList addObject:orderModel4];
    
    ZSOrderModel *orderModel5 = [[ZSOrderModel alloc] init];
    orderModel5.leftName = @"担保费率";
    [self.personDataList addObject:orderModel5];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.personDataList.count;
    } else {
        return 1;
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
        cell.rightLab.text = @"";
        return cell;
    } else {
        ZSRepaymentDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSRepaymentDetailsCell"];
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
