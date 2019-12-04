//
//  ZSHomeTableViewCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSHomeTableViewCell.h"

@interface ZSHomeTableViewCell  ()
@property (nonatomic,strong) UIImageView *newsImage; //资讯图片
@property (nonatomic,strong) UILabel     *newsTitle; //资讯标题
@property (nonatomic,strong) UILabel     *newsFrom;  //资讯来源
@property (nonatomic,strong) UILabel     *newsTime;  //资讯时间
@end

@implementation ZSHomeTableViewCell

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
    //资讯图片
    self.newsImage = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, 10, 100, 75)];
    self.newsImage.image = defaultImage_rectangle;
    self.newsImage.layer.masksToBounds = YES;
    [self addSubview:self.newsImage];
    
    //资讯标题
    self.newsTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.newsImage.right+10, 15, ZSWIDTH-100-GapWidth*2-10, 40)];
    self.newsTitle.font = FontBtn;
    self.newsTitle.textColor = ZSColorBlack;
    self.newsTitle.numberOfLines = 2;
    [self addSubview:self.newsTitle];
    
    //资讯来源
    self.newsFrom = [[UILabel alloc]initWithFrame:CGRectMake(self.newsImage.right+10, 62, 120, 18)];
    self.newsFrom.font = [UIFont systemFontOfSize:12];
    self.newsFrom.textColor = [UIColor lightGrayColor];
    [self addSubview:self.newsFrom];
    
    //资讯时间
    self.newsTime = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-130-GapWidth, 62, 130, 18)];
    self.newsTime.font = [UIFont systemFontOfSize:12];
    self.newsTime.textColor = [UIColor lightGrayColor];
    self.newsTime.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.newsTime];
}

- (void)setModel:(ZSHomeNewsModel *)model
{
    _model = model;
    
    //图片
    if (model.listPic) {
        [self.newsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.listPic]] placeholderImage:defaultImage_rectangle];
    }
    
    //标题
    if (model.title) {
        self.newsTitle.attributedText = [ZSTool setTextString:[NSString stringWithFormat:@"%@",model.title] withSizeFont:[UIFont systemFontOfSize:15]];
    }
    
    //来源
    if (model.source) {
        self.newsFrom.text = [NSString stringWithFormat:@"%@",model.source];
    }
    
    //时间
    if (model.pubTime) {
        self.newsTime.text = [NSString stringWithFormat:@"%@",model.pubTime];
    }
}

@end
