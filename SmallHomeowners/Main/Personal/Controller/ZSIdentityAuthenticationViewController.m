#import "ZSIdentityAuthenticationViewController.h"
#import "ZSIdentityAuthentionCell.h"
#import "ZSIdentityAuthentionFooterView.h"
#import "MBProgressHUD.h"

@interface ZSIdentityAuthenticationViewController () <ZSIdentityAuthentionFooterViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *ID;

@end

@implementation ZSIdentityAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavgationBar:@"身份认证" withBackBtn:YES];
    
    

    [self configureTableView:CGRectMake(0, self.navView.frame.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - self.navView.frame.size.height) withStyle:UITableViewStylePlain];
    
    ZSIdentityAuthentionFooterView *footerView = [[ZSIdentityAuthentionFooterView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 60)];
    footerView.delegate = self;
    self.tableView.tableFooterView = footerView;
    [self.tableView registerClass:[ZSIdentityAuthentionCell class] forCellReuseIdentifier:@"ZSIdentityAuthentionCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSIdentityAuthentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSIdentityAuthentionCell"];
    if (indexPath.row == 0) {
        cell.leftLabel.text = @"姓名";
        cell.textField.placeholder = @"请输入真实姓名";
        cell.textField.delegate = self;
    } else if (indexPath.row == 1) {
        cell.leftLabel.text = @"身份证号";
        cell.textField.placeholder = @"请输入身份证号码";
        cell.textField.delegate = self;
    }
    cell.textField.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)identityAuthentionFooterViewDidSelectedButton:(ZSIdentityAuthentionFooterView *)view {
    [self.view endEditing:YES];
    if (!self.name || !self.ID) {
        [ZSTool showMessage:@"请输入完整的信息" withDuration:DefaultDuration];
        return;
    }
    if (![ZSTool isIDCard:self.ID]) {
        [ZSTool showMessage:@"请输入正确的身份证号" withDuration:DefaultDuration];
        return;
    }

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dictionary setValue:self.ID forKey:@"identityNo"];
    [dictionary setValue:self.name forKey:@"name"];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:dictionary url:[ZSURLManager updateUserIdentityNo] SuccessBlock:^(NSDictionary *dic) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [ZSTool showMessage:@"认证成功" withDuration:2];
        [strongSelf.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@", dic);
    } ErrorBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        self.name = textField.text;
    } else {
        self.ID = textField.text;
    }
}

@end
