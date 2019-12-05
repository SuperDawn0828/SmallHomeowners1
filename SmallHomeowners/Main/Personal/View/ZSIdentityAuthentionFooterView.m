//
//  ZSIdentityAuthentionFooterView.m
//  SmallHomeowners
//
//  Created by 黎明 on 2019/12/5.
//  Copyright © 2019 maven. All rights reserved.
//

#import "ZSIdentityAuthentionFooterView.h"

@implementation ZSIdentityAuthentionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 345) / 2.0,15,345,44);
        button.layer.borderColor = [UIColor colorWithRed:189/255.0 green:156/255.0 blue:92/255.0 alpha:1.0].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 22;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithRed:189/255.0 green:156/255.0 blue:92/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:189/255.0 green:156/255.0 blue:92/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)buttonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(identityAuthentionFooterViewDidSelectedButton:)]) {
        [self.delegate identityAuthentionFooterViewDidSelectedButton:self];
    }
}

@end
