//
//  ZSOrderListTableViewCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/27.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSOrderListTableViewCell.h"

@interface ZSOrderListTableViewCell  ()
@property (nonatomic,strong) UILabel     *nameLabel;         //姓名
@property (nonatomic,strong) UILabel     *idCardLabel;       //身份证号
@property (nonatomic,strong) UILabel     *orderStateLabel;   //订单状态
@property (nonatomic,strong) UILabel     *timeLabel;         //订单创建时间
@end

@implementation ZSOrderListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,170, 39)];
    self.nameLabel.font = FontBtn;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = ZSColorListRight;
    [self.bgView addSubview:self.nameLabel];
   
    //身份证号
    self.idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.nameLabel.bottom+3,200, 20)];
    self.idCardLabel.font = FontNotice;
    self.idCardLabel.textColor = ZSColorListLeft;
    [self.bgView addSubview:self.idCardLabel];
   
    //产品名称
    self.productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,40, 15)];
    self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
    self.productNameLabel.font = [UIFont systemFontOfSize:12];
    self.productNameLabel.textColor = ZSColorWhite;
    self.productNameLabel.textAlignment = NSTextAlignmentCenter;
    self.productNameLabel.layer.cornerRadius = 2;
    self.productNameLabel.clipsToBounds = YES;
    [self.bgView addSubview:self.productNameLabel];
  
    //订单状态
    self.orderStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.productNameLabel.left-125,4.5+5,120, 20)];
    self.orderStateLabel.font = [UIFont systemFontOfSize:12];
    self.orderStateLabel.textColor = ZSColorListRight;
    self.orderStateLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.orderStateLabel];
  
    //订单创建时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellNewWidth-150-15,self.nameLabel.bottom+3,150, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = ZSColorListLeft;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.timeLabel];
   
    //重设名字的frame
    self.nameLabel.width = cellNewWidth-30-self.productNameLabel.width-self.orderStateLabel.width;
    if (ZSWIDTH == 320) {
        self.nameLabel.top = 0;
        self.nameLabel.height = 40;
    }else{
        self.nameLabel.top = 4.5;
        self.nameLabel.height = 30;
    }
}

- (void)setModel:(ZSAllListModel *)model
{
    _model = model;
    
    //姓名
    if (model.cust_name) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.cust_name];
    }

    //身份证号
    if (model.identity_no) {
        self.idCardLabel.text = [NSString stringWithFormat:@"%@",model.identity_no];
    }
    
    //产品名称
    if (model.prd_type) {
        self.productNameLabel.text = [ZSGlobalModel getProductStateWithCode:model.prd_type];
        //星速贷
        if ([model.prd_type isEqualToString:kProduceTypeStarLoan])
        {
            self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"navgationBarBackground"] Withview:self.productNameLabel]];
        }
        //抵押贷
        else if ([model.prd_type isEqualToString:kProduceTypeMortgageLoan])
        {
            self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_MortgageLoan"] Withview:self.productNameLabel]];
        }
        //赎楼宝
        else if ([model.prd_type isEqualToString:kProduceTypeRedeemFloor])
        {
            self.productNameLabel.frame = CGRectMake(cellNewWidth-42-10, 4.5+7.5, 42, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgView_RedeemFloor"] Withview:self.productNameLabel]];
        }
        //车位分期
        else if ([model.prd_type isEqualToString:kProduceTypeCarHire])
        {
            self.productNameLabel.frame = CGRectMake(cellNewWidth-55-10, 4.5+7.5, 55, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.productNameLabel]];
        }
        //代办业务
        else if ([model.prd_type isEqualToString:kProduceTypeAgencyBusiness])
        {
            self.productNameLabel.frame = CGRectMake(cellNewWidth-55-10, 4.5+7.5, 55, 15);
            self.productNameLabel.backgroundColor = [UIColor colorWithPatternImage:[ZSTool changeImage:[UIImage imageNamed:@"bgview_CarHire"] Withview:self.productNameLabel]];
        }
    }
    
    //订单状态
    self.orderStateLabel.left = self.productNameLabel.left-125;
    if (model.order_state) {
        self.orderStateLabel.text = [NSString stringWithFormat:@"%@",model.order_state];
    }
    
    //订单创建时间
    if (model.create_date) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",model.create_date];
    }
}

@end
