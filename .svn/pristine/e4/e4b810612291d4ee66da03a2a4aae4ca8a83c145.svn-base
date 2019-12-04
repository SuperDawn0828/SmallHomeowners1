//
//  ZSCreateOrderPersonInfoCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/4.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCreateOrderPersonInfoCell.h"

@interface ZSCreateOrderPersonInfoCell  ()
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号

@property (nonatomic,strong) UILabel     *roleLabel;         //需要添加的角色
@property (nonatomic,strong) UILabel     *addLabel;          //待添加label
@property (nonatomic,strong) UIImageView *addImage;          //待添加image

@end

@implementation ZSCreateOrderPersonInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleSpacing;//设置cell上分割线的风格
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, 40, 35)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = ZSColorListRight;
//    self.nameLabel.text = @"姓名";
    [self addSubview:self.nameLabel];
    
    //身份证号
    self.idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, self.nameLabel.bottom, 250, 35)];
    self.idCardLabel.font = [UIFont systemFontOfSize:13];
    self.idCardLabel.textColor = ZSColorListLeft;
//    self.idCardLabel.text = @"身份证号";
    [self addSubview:self.idCardLabel];
    
    //人员标签
    self.personnelTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.right+5, (35-15)/2, 29, 15)];
    self.personnelTagLabel.font = [UIFont systemFontOfSize:12];
    self.personnelTagLabel.textColor = ZSColorWhite;
    self.personnelTagLabel.textAlignment = NSTextAlignmentCenter;
    self.personnelTagLabel.layer.cornerRadius = 2;
    self.personnelTagLabel.layer.masksToBounds = YES;
//    self.personnelTagLabel.text = @"本人";
    self.personnelTagLabel.backgroundColor = ZSColorGolden;
    [self addSubview:self.personnelTagLabel];
    
    //添加的角色
    self.roleLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 0, 250, 70)];
    self.roleLabel.font = [UIFont systemFontOfSize:15];
    self.roleLabel.textColor = ZSColorListRight;
    self.roleLabel.hidden = YES;
    [self addSubview:self.roleLabel];
    
    //待添加label
    self.addLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-150-30,0,150, 70)];
    self.addLabel.font = [UIFont systemFontOfSize:15];
    self.addLabel.textColor = ZSColorAllNotice;
    self.addLabel.text = @"待添加";
    self.addLabel.textAlignment = NSTextAlignmentRight;
    self.addLabel.hidden = YES;
    [self addSubview:self.addLabel];
    
    //待添加image
    self.addImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (70-15)/2, 15, 15)];
    self.addImage.image = [UIImage imageNamed:@"list_arrow_n"];
    [self addSubview:self.addImage];
}


- (void)setModel:(CustomersModel *)model
{
    _model = model;
    
    //姓名
    if (model.name) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
        self.nameLabel.width = [ZSTool getStringWidth:self.nameLabel.text withframe:CGSizeMake(ZSWIDTH-100, 35) withSizeFont:[UIFont systemFontOfSize:15]];
        self.personnelTagLabel.left = self.nameLabel.right+5;
    }
    
    //身份证号
    if (model.identityNo) {
        self.idCardLabel.text = [NSString stringWithFormat:@"%@",model.identityNo];
    }
    
    //人员标签 1贷款人 2贷款人配偶 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶
    if (model.releation) {
        self.personnelTagLabel.text = [ZSGlobalModel getReleationStateWithCode:model.releation];
        if (model.releation.intValue == 1) {
            self.personnelTagLabel.width = 42;
        }
        else if (model.releation.intValue == 2) {
            self.personnelTagLabel.width = 68;
        }
        else if (model.releation.intValue == 4) {
            self.personnelTagLabel.width = 42;
        }
        else if (model.releation.intValue == 7) {
            self.personnelTagLabel.width = 29;
        }
        else if (model.releation.intValue == 8) {
            self.personnelTagLabel.width = 55;
        }
    }
    
    //控件显隐
    self.nameLabel.hidden = NO;
    self.idCardLabel.hidden = NO;
    self.personnelTagLabel.hidden = NO;
    self.roleLabel.hidden = YES;
    self.addLabel.hidden = YES;
}

- (void)setRoleString:(NSString *)roleString
{
    self.roleLabel.text = roleString;

    //控件显隐
    self.nameLabel.hidden = YES;
    self.idCardLabel.hidden = YES;
    self.personnelTagLabel.hidden = YES;
    self.roleLabel.hidden = NO;
    self.addLabel.hidden = NO;
}

@end
