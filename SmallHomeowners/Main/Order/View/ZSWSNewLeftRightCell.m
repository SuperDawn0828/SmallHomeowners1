//
//  ZSWSNewLeftRightCell.m
//  ZSMoneytocar
//
//  Created by gengping on 17/4/27.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSWSNewLeftRightCell.h"

@implementation ZSWSNewLeftRightCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftLab.textColor  = ZSColorListLeft;
    self.rightLab.textColor = ZSColorListRight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //换行的时候靠左显示
    float height = [ZSTool getStringHeight:self.rightLab.text withframe:CGSizeMake(self.rightLab.width, MAXFLOAT) withSizeFont:[UIFont systemFontOfSize:15]] + 20;
    if (height > CellHeight)
    {
        self.rightLab.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        self.rightLab.textAlignment = NSTextAlignmentRight;
    }
}

- (void)setModel:(ZSOrderModel *)model
{
    _model = model;
    
    if (model.leftName) {
        self.leftLab.text = model.leftName;
    }
    
    if ([model.leftName isEqualToString:@"订单编号"]) {
        if (model.rightData.length)
        {
            NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:model.rightData];
            [mutableString addAttribute:NSForegroundColorAttributeName value:ZSColorGolden range:NSMakeRange(model.rightData.length - 2, 2)];
            self.rightLab.attributedText = mutableString;
        }
    }
    else
    {
        self.rightLab.text = model.rightData;
    }
}

- (void)setHiddenLineView:(BOOL)hiddenLineView
{
    self.lineViewHeight.constant = 0;
}

@end
