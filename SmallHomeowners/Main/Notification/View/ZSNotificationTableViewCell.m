//
//  ZSNotificationTableViewCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSNotificationTableViewCell.h"

@interface ZSNotificationTableViewCell  ()
@property (nonatomic,strong) UIImageView *logoImage;       //通知logo
@property (nonatomic,strong) UILabel     *titleLabel;      //通知标题
@property (nonatomic,strong) UILabel     *timeLabel;       //通知时间
@end

@implementation ZSNotificationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleFill;//设置cell上分割线的风格
        [self configureViews];
    }
    return self;
}

- (void)configureViews
{
    //logo
    self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 38, 38)];
//    self.logoImage.image = [UIImage imageNamed:@"notice_credit_feedback_n"];
    [self addSubview:self.logoImage];
   
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.logoImage.right+15, 15, ZSWIDTH-110-85, 15)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = ZSColorListRight;
//    self.titleLabel.text = @"预授信报告生成通知";
    [self addSubview:self.titleLabel];
   
    //时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZSWIDTH-110-15, 15, 110, 12)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = ZSColorAllNotice;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
//    self.timeLabel.text = @"2018-09-00 99:99";
    [self addSubview:self.timeLabel];
  
    //内容
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.logoImage.right+15, 41, ZSWIDTH-45-38, 35)];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = UIColorFromRGB(0x737373);
    self.contentLabel.numberOfLines = 0;
//    self.contentLabel.text = @"这里是通知内容，最多展示两行，如果文字没展示完就“…”，点击消息后出现弹框。";
    [self addSubview:self.contentLabel];
}

- (void)setModel:(ZSNotificationModel *)model
{
    _model = model;
    
    if (model.title)
    {
        //logo
        if ([model.title isEqualToString:@"认证成功通知"]) {
            self.logoImage.image = [UIImage imageNamed:@"认证成功"];
        }
        else if ([model.title isEqualToString:@"认证失败通知"]) {
            self.logoImage.image = [UIImage imageNamed:@"认证失败"];
        }
        else {
            self.logoImage.image = [UIImage imageNamed:@"notice_credit_feedback_n"];
        }
        
        //标题
        self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    }
    
    //时间
    if (model.createDate) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",model.createDate];
    }
    
    //内容
    if (model.content) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
        self.contentLabel.height = [ZSTool getStringHeight:model.content withframe:CGSizeMake(ZSWIDTH-45-38, 1000) withSizeFont:[UIFont systemFontOfSize:14]];
    }
}

@end
