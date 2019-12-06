//
//  ZSOrderDetailPhotoItem.m
//  SmallHomeowners
//
//  Created by 黎明 on 2019/12/6.
//  Copyright © 2019 maven. All rights reserved.
//

#import "ZSOrderDetailPhotoItem.h"

@implementation ZSOrderDetailPhotoItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.imageView = [[UIImageView alloc]  init];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
}

@end
