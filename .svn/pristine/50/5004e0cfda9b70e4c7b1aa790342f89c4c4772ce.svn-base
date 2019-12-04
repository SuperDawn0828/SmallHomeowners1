//
//  ZSCreateOrderPopupView.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/27.
//  Copyright © 2018年 maven. All rights reserved.
//  创建订单弹窗

#import <UIKit/UIKit.h>

@class ZSCreateOrderPopupView;
@protocol ZSCreateOrderPopupViewDelegate <NSObject>
@optional
- (void)selectProductWithType:(NSString *)prdType;
@end

@interface ZSCreateOrderPopupView : UIView
@property (weak, nonatomic)id<ZSCreateOrderPopupViewDelegate> delegate;
- (void)show;
@end
