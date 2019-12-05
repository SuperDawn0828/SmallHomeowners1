//
//  WTHomeViewController.m
//  SmallHomeowners
//
//  Created by mac on 2019/11/26.
//  Copyright © 2019 maven. All rights reserved.
//

#import "WTHomeViewController.h"
#import "ZSLenderInfoViewController.h"
#import "ZSHomeApplyViewController.h"
@interface WTHomeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCos;

@end

@implementation WTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float width = [UIScreen  mainScreen].bounds.size.width;
    self.heightCos.constant = (896*width)/414.0;
    [self configureNavgationBar:@"" withBackBtn:NO];
    self.navView.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (IBAction)gotoDkPage:(UIButton *)sender {
    
    
    NSLog(@"我们点击了");
//
//    ZSLenderInfoViewController *createVC = [[ZSLenderInfoViewController alloc]init];
//    global.prdType = @"1084";
//    global.pcOrderDetailModel = nil;
//    createVC.personType = ZSFromCreateOrderWithAdd;
//    createVC.roleTypeString = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款人"]];
//    createVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:createVC animated:YES];
    ZSHomeApplyViewController *createVC = [[ZSHomeApplyViewController alloc]init];
    global.prdType = @"1084";
    global.pcOrderDetailModel = nil;
    createVC.personType = ZSFromCreateOrderWithAdd;
//    createVC.roleTypeString = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款人"]];
    createVC.roleTypeString = @"业务申请";
    [self.navigationController pushViewController:createVC animated:YES];
    
}

@end
