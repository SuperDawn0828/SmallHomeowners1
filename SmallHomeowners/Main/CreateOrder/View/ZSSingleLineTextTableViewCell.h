//
//  ZSSingleLineTextTableViewCell.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//  单行文本cell

#import "ZSBaseTableViewCell.h"

static NSString *CellIdentifier = @"ZSSingleLineTextTableViewCell";

#pragma mark tag值
typedef NS_ENUM (NSUInteger, ZSPopupViewTag){
    marryStateTag = 0,   //婚姻状况
    buildingAddressTag,  //楼盘地址
    houseFunctionTag,    //房屋功能
    cityTag,             //所在城市
};

@class ZSSingleLineTextTableViewCell;
@protocol ZSSingleLineTextTableViewCellDelegate <NSObject>
@optional
- (void)sendCurrentCellData:(NSString *)string withIndex:(NSUInteger)currentIndex;//传递输入框的值或者"请选择"按钮选择成功以后的值
- (void)sendCurrentCellID:(NSString *)string withIndex:(NSUInteger)currentIndex;//传递输入框的值或者"请选择"按钮选择成功以后的值(ID)
@end

@interface ZSSingleLineTextTableViewCell : ZSBaseTableViewCell
@property(nonatomic,weak  )id<ZSSingleLineTextTableViewCellDelegate>  delegate;
@property(nonatomic,assign)NSUInteger                                 currentIndex; //当前cell所在的indexPath,用于操作后数据传值
@property(nonatomic,strong)ZSDynamicDataModel                         *model;
@end
