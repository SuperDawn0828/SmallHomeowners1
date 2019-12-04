//
//  ZSProductViewTableViewCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/9/25.
//  Copyright © 2018 maven. All rights reserved.
//

#import "ZSProductViewTableViewCell.h"

@interface ZSProductViewTableViewCell  ()

@property(nonatomic,strong)UIImageView *imgView;  //产品图片
@property(nonatomic,strong)UILabel *productLabel; //产品名称
@property(nonatomic,strong)UILabel *prdIntroductionLabel; //产品介绍

@end

@implementation ZSProductViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleSpacing;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    //图片
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, GapWidth, productsImageWidth, productsImageHeight)];
    self.imgView.layer.cornerRadius = 10;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.userInteractionEnabled = YES;
    [self addSubview:self.imgView];
    
    //cover
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, productsImageHeight-60, productsImageWidth, 60)];
    coverView.backgroundColor = ZSColorBlack;
    coverView.alpha = 0.5;
    coverView.layer.masksToBounds = YES;
    [self.imgView addSubview:coverView];
    
    //产品名
    self.productLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, productsImageHeight-60+10, ZSWIDTH-GapWidth*3-75, 20)];
    self.productLabel.textColor = ZSColorWhite;
    self.productLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.imgView addSubview:self.productLabel];
    
    self.prdIntroductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, self.productLabel.bottom, ZSWIDTH-GapWidth*3-75, 20)];
    self.prdIntroductionLabel.font = FontSecondTitle;
    self.prdIntroductionLabel.textColor = ZSColorWhite;
    self.prdIntroductionLabel.numberOfLines = 0;
    self.prdIntroductionLabel.adjustsFontSizeToFitWidth = YES;
    [self.imgView addSubview:self.prdIntroductionLabel];
    
    //立即申请
    UILabel *createLabel = [[UILabel alloc]initWithFrame:CGRectMake(productsImageWidth-75-GapWidth, productsImageHeight-60+20, 75, 30)];
    createLabel.font = [UIFont systemFontOfSize:12];
    createLabel.textColor = ZSColorGolden;
    createLabel.text = @"立即申请";
    createLabel.textAlignment = NSTextAlignmentCenter;
    createLabel.backgroundColor = ZSColorWhite;
    createLabel.layer.cornerRadius = 15;
    createLabel.clipsToBounds = YES;
    [self.imgView addSubview:createLabel];
}

- (void)setModel:(ZSCreateOrderPopupModel *)model
{
    _model = model;
    
    //图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,model.homepageImg]] placeholderImage:defaultImage_rectangle];
    
    //产品名
    if (model.prdName) {
        self.productLabel.text = [NSString stringWithFormat:@"%@",[ZSGlobalModel changeLoanString:model.prdName]];
    }
    
    //产品介绍
    if (model.prdFeature) {
        self.prdIntroductionLabel.text = [NSString stringWithFormat:@"%@",model.prdFeature];
    }
}

@end
