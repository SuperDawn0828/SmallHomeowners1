#import "ZSIdentityAuthenticationViewController.h"
#import "ZSIdentityAuthentionCell.h"
#import "ZSIdentityAuthentionFooterView.h"

@interface ZSIdentityAuthenticationViewController () <ZSIdentityAuthentionFooterViewDelegate>

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
    } else if (indexPath.row == 1) {
        cell.leftLabel.text = @"身份证号";
        cell.textField.placeholder = @"请输入身份证号码";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)identityAuthentionFooterViewDidSelectedButton:(ZSIdentityAuthentionFooterView *)view {
    
}

@end
