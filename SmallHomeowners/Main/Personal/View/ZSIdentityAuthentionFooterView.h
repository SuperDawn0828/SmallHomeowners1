//
//  ZSIdentityAuthentionFooterView.h
//  SmallHomeowners
//
//  Created by 黎明 on 2019/12/5.
//  Copyright © 2019 maven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZSIdentityAuthentionFooterView;
@protocol ZSIdentityAuthentionFooterViewDelegate <NSObject>

- (void)identityAuthentionFooterViewDidSelectedButton:(ZSIdentityAuthentionFooterView *)view;

@end

@interface ZSIdentityAuthentionFooterView : UIView

@property (nonatomic, weak) id <ZSIdentityAuthentionFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
