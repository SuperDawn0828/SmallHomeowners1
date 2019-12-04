//
//  ZSOrderDetailPersonCell.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//  订单详情-人员信息cell

#import "ZSBaseTableViewCell.h"

static NSString *CellIdentifier = @"ZSOrderDetailPersonCell";

@interface ZSOrderDetailPersonCell : ZSBaseTableViewCell

@property(nonatomic,strong)CustomersModel *model;

@end
