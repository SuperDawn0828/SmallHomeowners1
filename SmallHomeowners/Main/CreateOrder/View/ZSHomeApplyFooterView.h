//
//  ZSHomeApplyFooterView.h
//  SmallHomeowners
//
//  Created by 黎明 on 2019/12/4.
//  Copyright © 2019 maven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZSHomeApplyFooterView;
@protocol ZSHomeApplyFooterViewDelegate <NSObject>

- (void)homeApplyFooterViewDidSelected:(ZSHomeApplyFooterView *)view;

@end

@interface ZSHomeApplyFooterView : UIView

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, weak) id <ZSHomeApplyFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
