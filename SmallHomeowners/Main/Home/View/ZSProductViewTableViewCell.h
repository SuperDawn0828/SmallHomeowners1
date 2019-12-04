//
//  ZSProductViewTableViewCell.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/9/25.
//  Copyright © 2018 maven. All rights reserved.
//

#import "ZSBaseTableViewCell.h"
#import "ZSCreateOrderPopupModel.h"

#define productsImageWidth  ZSWIDTH - GapWidth*2   //产品推荐图片高度 宽高8:5
#define productsImageHeight (ZSWIDTH - GapWidth*2)/8*5  //产品推荐图片高度 宽高8:5

static NSString *CellIdentifier = @"ZSHomeTableViewCell";

NS_ASSUME_NONNULL_BEGIN

@interface ZSProductViewTableViewCell : ZSBaseTableViewCell

@property(nonatomic,strong)ZSCreateOrderPopupModel *model;

@end

NS_ASSUME_NONNULL_END
