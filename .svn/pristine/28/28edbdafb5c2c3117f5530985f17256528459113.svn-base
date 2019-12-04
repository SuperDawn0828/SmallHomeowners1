//
//  ZSCreateOrderTopView.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/8/23.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSCreateOrderTopView.h"

@implementation ZSCreateOrderTopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ZSWIDTH, viewTopHeight);
    self.lineView.backgroundColor = ZSViewBackgroundColor;
    
    self.loanLabelNotice.text = [NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

//根据不同的产品和当前所在第几个页面展示不同的图片
- (void)setImgViewWithProduct:(NSString *)productName withIndex:(NSInteger)index
{
    //1.客户信息
    if (index == ZSCreatOrderStyleCustomer)
    {
        self.customerImgView.image   = ImageName(@"客户信息");
        self.customerLabel.textColor = ZSColorGolden;
    }
    
    //2.房产信息
    if (index == ZSCreatOrderStyleHouse)
    {
        self.customerImgView.image   = ImageName(@"客户信息");
        self.customerLabel.textColor = ZSColorGolden;
        self.houseImgView.image   = ImageName(@"房产信息");
        self.houseLabel.textColor = ZSColorGolden;
        self.leftArrowImgView.image = ImageName(@"箭头-实线");
    }
    
    //3.贷款信息
    if (index == ZSCreatOrderStyleLoan)
    {
        self.customerImgView.image   = ImageName(@"客户信息");
        self.customerLabel.textColor = ZSColorGolden;
        self.houseImgView.image   = ImageName(@"房产信息");
        self.houseLabel.textColor = ZSColorGolden;
        self.loanImgView.image   = ImageName(@"贷款信息");
        self.loanLabel.textColor = ZSColorGolden;
        self.leftArrowImgView.image = ImageName(@"箭头-实线");
        self.rightArrowImgView.image = ImageName(@"箭头-实线");
    }    
}

#pragma mark dismiss
- (void)dismiss
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark show
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.alpha = 1;
    }];
}

@end
