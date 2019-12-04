//
//  ZSReLoginView.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/8/24.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSReLoginView.h"

@interface ZSReLoginView  ()
@property (nonatomic,strong)UIView *blackBackgroundView;
@property (nonatomic,strong)UIView *whiteBackgroundView;
@end


@implementation ZSReLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //黑底
        self.blackBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        self.blackBackgroundView.backgroundColor = ZSColorBlack;
        self.blackBackgroundView.alpha = 0;
        [self addSubview:self.blackBackgroundView];
        
        //白底
        self.whiteBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(53, (ZSHEIGHT-186)/2, ZSWIDTH-53*2, 98+CellHeight*2)];
        self.whiteBackgroundView.backgroundColor = ZSColorWhite;
        self.whiteBackgroundView.layer.cornerRadius = 4;
        self.whiteBackgroundView.alpha = 0;
        [self addSubview:self.whiteBackgroundView];
        
        //title
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.whiteBackgroundView.width,CellHeight)];
        title.font = [UIFont boldSystemFontOfSize:15];
        title.textColor = UIColorFromRGB(0x4F4F4F);
        title.text = @"登录提醒";
        title.textAlignment = NSTextAlignmentCenter;
        [self.whiteBackgroundView addSubview:title];
        
        //line_top
        UIView *lineView_top = [[UIView alloc]initWithFrame:CGRectMake(0, CellHeight, self.whiteBackgroundView.width, 0.5)];
        lineView_top.backgroundColor = ZSColorLine;
        [self.whiteBackgroundView addSubview:lineView_top];
        
        //显示详情的label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,lineView_top.bottom,self.whiteBackgroundView.width-30,98)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColorFromRGB(0x666666);
        label.text = @"您的账号已经禁用/删除/修改密码,请重新登录或联系管理员!";
        label.numberOfLines = 0;
        [self.whiteBackgroundView addSubview:label];
        
        //line_bottom
        UIView *lineView_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom, self.whiteBackgroundView.width, 0.5)];
        lineView_bottom.backgroundColor = ZSColorLine;
        [self.whiteBackgroundView addSubview:lineView_bottom];
        
        //按钮
        UIButton *btn_know = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_know.frame = CGRectMake(0, lineView_bottom.bottom, self.whiteBackgroundView.width, CellHeight);
        btn_know.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_know setTitle:@"好的" forState:UIControlStateNormal];
        [btn_know setTitleColor:UIColorFromRGB(0x4F4F4F) forState:UIControlStateNormal];
        [btn_know addTarget:self action:@selector(btn_knowAction) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteBackgroundView addSubview:btn_know];
        
    }
    return self;
}

#pragma mark 显示自己
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.blackBackgroundView.alpha = 0.5;
        self.whiteBackgroundView.alpha = 1;
    }];
}

#pragma mark 移除自己
- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)btn_knowAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(gotoRelogin)]){
        [self.delegate gotoRelogin];
    }
}

@end
