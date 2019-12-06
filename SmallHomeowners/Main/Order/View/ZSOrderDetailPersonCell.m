//
//  ZSOrderDetailPersonCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSOrderDetailPersonCell.h"

@interface ZSOrderDetailPersonCell  ()
@property(nonatomic,strong)UIImageView *IdCardImage; //身份证照片
@property(nonatomic,strong)UILabel     *nameTitleLabel;   //姓名
@property(nonatomic,strong)UILabel     *nameLabel;   //姓名
@property(nonatomic,strong)UILabel     *idCardTitleLabel; //身份证
@property(nonatomic,strong)UILabel     *idCardLabel; //身份证
@property(nonatomic,strong)UILabel     *phoneTitleLabel;  //手机号
@property(nonatomic,strong)UILabel     *phoneLabel;  //手机号
@end

@implementation ZSOrderDetailPersonCell

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
    //身份证照片
    self.IdCardImage = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth, 10, 100, 75)];
    self.IdCardImage.image = defaultImage_rectangle;
    self.IdCardImage.userInteractionEnabled = YES;
    [self addSubview:self.IdCardImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImgShow:)];
    [self.IdCardImage addGestureRecognizer:tap];
    
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.IdCardImage.right + 15, 10, ZSWIDTH-GapWidth*3-100, 25)];
    self.nameLabel.font = FontSecondTitle;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.nameLabel];
    
    self.nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.IdCardImage.right + 15, 10, ZSWIDTH-GapWidth*3-100, 25)];
    self.nameTitleLabel.font = FontSecondTitle;
    self.nameTitleLabel.numberOfLines = 0;
    self.nameTitleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self addSubview:self.nameTitleLabel];
    
    //身份证号
    self.idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.IdCardImage.right + 15, self.nameLabel.bottom, ZSWIDTH-GapWidth*3-100, 25)];
    self.idCardLabel.font = FontSecondTitle;
    self.idCardLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.idCardLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.idCardLabel];
    
    self.idCardTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.IdCardImage.right + 15, self.nameLabel.bottom, ZSWIDTH-GapWidth*3-100, 25)];
    self.idCardTitleLabel.font = FontSecondTitle;
    self.idCardTitleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self addSubview:self.idCardTitleLabel];
    
    //手机号
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.IdCardImage.right + 15, self.idCardLabel.bottom, ZSWIDTH-GapWidth*3-100, 25)];
    self.phoneLabel.font = FontSecondTitle;
    self.phoneLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.phoneLabel];
    
    self.phoneTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.IdCardImage.right + 15, self.idCardLabel.bottom, ZSWIDTH-GapWidth*3-100, 25)];
    self.phoneTitleLabel.font = FontSecondTitle;
    self.phoneTitleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self addSubview:self.phoneTitleLabel];
}

- (void)setModel:(CustomersModel *)model
{
    _model = model;
    
    //身份证照片
    if (model.identityPos) {
        [self.IdCardImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,model.identityPos]] placeholderImage:defaultImage_rectangle];
    }
    else if (model.identityBak) {
        [self.IdCardImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,model.identityBak]] placeholderImage:defaultImage_rectangle];
    }
    
    //姓名
    if (model.name) {
        NSString *roleString = [ZSGlobalModel getReleationStateWithCode:model.releation];
        self.nameTitleLabel.text = [[NSString alloc] initWithFormat:@"%@:", roleString];
        self.nameLabel.text = model.name;
    }
    
    //身份证号
    if (model.identityNo) {
        self.idCardTitleLabel.text = @"身份证号:";
        self.idCardLabel.text = model.identityNo;
    }
    
    //手机号
    if (model.cellphone) {
        self.phoneTitleLabel.text = @"手机号:";
        self.phoneLabel.text = model.cellphone;
    }
}

#pragma mark 查看大图
- (void)bigImgShow:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (imageView.image) {
        //1.创建photoBroseView对象
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
        //2.赋值
        if (_model.identityPos && _model.identityBak) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,_model.identityPos],[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,_model.identityBak]];
        }
        else if (_model.identityPos && !_model.identityBak) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,_model.identityPos]];
        }
        else if (!_model.identityPos && _model.identityBak) {
            photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,_model.identityBak]];
        }
        else {
            photoBroseView.images = @[defaultImage_rectangle];
        }
        photoBroseView.showFromView = tap.view;
        photoBroseView.hiddenToView = tap.view;
        photoBroseView.currentIndex = 0;
        //3.显示
        [photoBroseView show];
    }
}

@end
