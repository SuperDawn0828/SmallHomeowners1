//
//  ZSBaseSeationView.m
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/5.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSBaseSectionView.h"

@implementation ZSBaseSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ZSColorWhite;
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    //顶部线条
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.5)];
    topLineView.backgroundColor = ZSColorLine;
    [self addSubview:topLineView];
    
    //左侧竖线
    self.verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(0, (self.height-11)/2, 4, 11)];
    self.verticalLineView.backgroundColor = ZSColorGolden;
    [self addSubview:self.verticalLineView];
    
    //左边label
    self.leftLab = [self LabelWithFrame:CGRectMake(self.verticalLineView.right + 10, 0, ZSWIDTH/2, self.frame.size.height) textAlignment:NSTextAlignmentLeft textColor:ZSColorListRight];
    self.leftLab.font = [UIFont boldSystemFontOfSize:15];
    
    //右边label
    self.rightLab = [self LabelWithFrame:CGRectMake(ZSWIDTH/2-30, 0, ZSWIDTH/2, self.frame.size.height) textAlignment:NSTextAlignmentRight textColor:ZSColorGolden];
    self.rightLab.font = [UIFont systemFontOfSize:14];
    
    //底部的线
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, ZSWIDTH, 0.5)];
    bottomLineView.backgroundColor = ZSColorLine;
    [self addSubview:bottomLineView];
}

- (UILabel *)LabelWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)color
{
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.textAlignment = textAlignment;
    lab.textColor = color;
    lab.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:lab];
    return lab;
}

@end
