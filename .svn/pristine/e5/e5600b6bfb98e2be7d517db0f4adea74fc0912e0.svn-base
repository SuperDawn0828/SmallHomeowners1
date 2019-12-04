//
//  ZSCreateOrderPopupView.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/27.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCreateOrderPopupView.h"
#import "ZSCreateOrderPopupCell.h"

@interface ZSCreateOrderPopupView  ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UIView             *blackBackgroundView;
@property (nonatomic,strong)UIView             *whiteBackgroundView;
@property (nonatomic,strong)UITableView        *tableView;       
@end

@implementation ZSCreateOrderPopupView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //黑底
        self.blackBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        self.blackBackgroundView.backgroundColor = ZSColorBlack;
        self.blackBackgroundView.alpha = 0;
        [self addSubview:self.blackBackgroundView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self.blackBackgroundView addGestureRecognizer:tap];
        
        //白底
        self.whiteBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, ZSHEIGHT_PopupWindow, ZSWIDTH, ZSHEIGHT_PopupWindow*0.66)];
        self.whiteBackgroundView.backgroundColor = ZSColorWhite;
        self.whiteBackgroundView.layer.cornerRadius = 3;
        self.whiteBackgroundView.alpha = 0;
        [self addSubview:self.whiteBackgroundView];
        
        //选择产品
        UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 20, 100, CellHeight)];
        chooseLabel.font = [UIFont boldSystemFontOfSize:16];
        chooseLabel.textColor = ZSColorBlack;
        chooseLabel.text = @"选择产品";
        [self.whiteBackgroundView addSubview:chooseLabel];
        
        //关闭
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(ZSWIDTH-CellHeight-GapWidth, 20, CellHeight, CellHeight);
        [closeBtn setImage:[UIImage imageNamed:@"tool_guanbi_n"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.whiteBackgroundView addSubview:closeBtn];
        
        //table
        [self configureTableView:CGRectMake(0, 30+CellHeight, ZSWIDTH, self.whiteBackgroundView.height-30-CellHeight-SafeAreaBottomHeight) withStyle:UITableViewStylePlain];
        
    }
    return self;
}

#pragma mark /*------------------------------------------tableview------------------------------------------*/
- (void)configureTableView:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ZSColorWhite;
    [self.whiteBackgroundView addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return global.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCreateOrderPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSCreateOrderPopupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (global.productArray.count > 0) {
        ZSCreateOrderPopupModel *model = global.productArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismiss];
    if (global.productArray.count > 0)
    {
        ZSCreateOrderPopupModel *model = global.productArray[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(selectProductWithType:)]){
            [_delegate selectProductWithType:model.prdType];
        }
    }
}

#pragma mark 显示自己
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.blackBackgroundView.alpha = 0.5;
        self.whiteBackgroundView.alpha = 1;
        self.whiteBackgroundView.top = ZSHEIGHT_PopupWindow-ZSHEIGHT_PopupWindow*0.66;
    }];
}

#pragma mark 移除自己
- (void)dismiss
{
    [self removeFromSuperview];
}

@end
