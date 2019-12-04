//
//  ZSCreateOrderPopupCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/27.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCreateOrderPopupCell.h"

@interface ZSCreateOrderPopupCell  ()
@property (nonatomic,strong)UIImageView *logoImage;             //产品logo
@property (nonatomic,strong)UILabel     *prdTypeLabel;          //产品名
@property (nonatomic,strong)UILabel     *prdIntroductionLabel;  //产品简介
@property (nonatomic,strong)UILabel     *createLabel;
@end

@implementation ZSCreateOrderPopupCell

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
    self.bgView.frame = CGRectMake(GapWidth, 0, cellNewWidth, 100);
    
    //产品logo
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(GapWidth,20,60,60)];
    self.logoImage.backgroundColor = ZSColorWhite;
    self.logoImage.layer.cornerRadius = 30;
    self.logoImage.clipsToBounds = YES;
    [self.bgView addSubview:self.logoImage];
    
    //产品名
    self.prdTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90,25,200, 20)];
    self.prdTypeLabel.font = FontBtn;
    self.prdTypeLabel.textColor = ZSColorWhite;
    [self.bgView addSubview:self.prdTypeLabel];
    
    //产品简介
    self.prdIntroductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, self.prdTypeLabel.bottom+10, ZSWIDTH-90-100, 35)];
    self.prdIntroductionLabel.font = FontSecondTitle;
    self.prdIntroductionLabel.textColor = ZSColorWhite;
    self.prdIntroductionLabel.numberOfLines = 0;
    self.prdIntroductionLabel.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:self.prdIntroductionLabel];
    
    //去申请
    self.createLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellNewWidth-75-GapWidth, (100-30)/2, 75, 30)];
    self.createLabel.font = FontSecondTitle;
    self.createLabel.text = @"去申请";
    self.createLabel.textAlignment = NSTextAlignmentCenter;
    self.createLabel.backgroundColor = ZSColorWhite;
    self.createLabel.layer.cornerRadius = 15;
    self.createLabel.clipsToBounds = YES;
    [self.bgView addSubview:self.createLabel];
}

- (void)setModel:(ZSCreateOrderPopupModel *)model
{
//    [self.bgView addBackGroundLayerWithLeftColor:UIColorFromRGB(0x079b5c) withRightColor:UIColorFromRGB(0x32bc82)];
    //背景色
    if ([model.prdType isEqualToString:kProduceTypeStarLoan])
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navgationBarBackground"]];
        self.createLabel.textColor = ZSColorGolden;
    }
    else if ([model.prdType isEqualToString:kProduceTypeMortgageLoan])
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgView_MortgageLoan"]];
        self.createLabel.textColor = ZSColorGreen;
    }
    else if ([model.prdType isEqualToString:kProduceTypeRedeemFloor])
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgView_RedeemFloor"]];
        self.createLabel.textColor = ZSColorBlue;
    }
    else if ([model.prdType isEqualToString:kProduceTypeCarHire])
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navgationBarBackground"]];
        self.createLabel.textColor = ZSColorGolden;
    }
    else if ([model.prdType isEqualToString:kProduceTypeAgencyBusiness])
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgView_MortgageLoan"]];
        self.createLabel.textColor = ZSColorGreen;
    }
    else if ([model.prdType isEqualToString:kProduceTypeEasyLoans])
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgView_HousingLoans"]];
        self.createLabel.textColor = ZSColorGreen;
    }
    else
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navgationBarBackground"]];
        self.createLabel.textColor = ZSColorGolden;
    }
    
    //产品名
    if (model.prdName){
        self.prdTypeLabel.text = [NSString stringWithFormat:@"%@",[ZSGlobalModel changeLoanString:model.prdName]];
    }
    
    //产品logo
    [ self.logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,model.homepageIcon]] placeholderImage:defaultImage_rectangle];
    
    //产品简介
    if (model.prdDesc) {
        self.prdIntroductionLabel.text = [NSString stringWithFormat:@"%@",model.prdDesc];
    }
}

@end
