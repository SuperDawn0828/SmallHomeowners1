//
//  ZSHomeHeaderView.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//  首页--headerView

#import <UIKit/UIKit.h>
#import "ZSHomeCarouselModel.h"
#import "ZSHomeToolModel.h"

@class ZSHomeHeaderView;
@protocol ZSHomeHeaderViewDelegate <NSObject>
@optional
- (void)indexOfClickedImageBtn:(NSUInteger)index;//点击轮播图
- (void)indexOfClickedProductImageView:(NSUInteger)index;//点击产品
- (void)indexOfClickedToolsBtn:(NSUInteger)index;//点击小工具
- (void)checkAllProduct;//查看全部产品
@end

@interface ZSHomeHeaderView : UIView

@property (weak, nonatomic) id<ZSHomeHeaderViewDelegate> delegate;

#pragma mark 轮播图
- (void)fillInCarouselViewData:(NSArray *)array;

#pragma mark 工具模块
- (void)fillInToolBtnsViewData:(NSArray *)array;

#pragma mark 产品推荐
- (void)fillInProductsViewData:(NSArray *)array;

#pragma mark 提示label
- (void)configureNoticeLabel;

#pragma mark 设置自己的高度
- (void)resetSelfHeight;

@end
