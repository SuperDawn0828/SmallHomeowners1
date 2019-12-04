//
//  ZSWSNewLeftRightCell.h
//  ZSMoneytocar
//
//  Created by gengping on 17/4/27.
//  Copyright © 2017年 Wu. All rights reserved.
//  订单详情--贷款信息/房产信息/订单信息cell

#import "ZSBaseTableViewCell.h"
#import "ZSOrderModel.h"

static NSString *KReuseZSWSNewLeftRightCellIdentifier = @"ZSWSNewLeftRightCell";

@interface ZSWSNewLeftRightCell : ZSBaseTableViewCell
@property (weak,  nonatomic) IBOutlet UILabel *leftLab;  //左边label
@property (weak,  nonatomic) IBOutlet UILabel *rightLab; //右边label
@property (weak,  nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (strong,nonatomic) ZSOrderModel *model;
@property (assign,nonatomic) BOOL hiddenLineView;
@end
