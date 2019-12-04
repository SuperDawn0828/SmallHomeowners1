//
//  ZSHomeHeaderView.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSHomeHeaderView.h"
#import "ZSHomeCarouselView.h"
#import "ZSHomeToolButton.h"
#import "ZSCreateOrderPopupModel.h"

#define carouselViewHeight  ZSWIDTH/2                       //轮播图高度 宽高2:1
#define productsImageWidth  300                             //产品推荐图片高度 宽高8:5
#define productsImageHeight 300/8*5                         //产品推荐图片高度 宽高8:5
#define productsViewHeight  10*4 + 32 + productsImageHeight //产品推荐高度

@interface ZSHomeHeaderView  ()<ZSHomeCarouselViewDelegate>
@property (nonatomic,strong) ZSHomeCarouselView *carouselView; //轮播图
@property (nonatomic,strong) UIView             *toolBtnsView; //工具模块
@property (nonatomic,strong) UIView             *productsView; //产品推荐
@property (nonatomic,strong) UIView             *noticeView;   //小房主快讯
@end

@implementation ZSHomeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
   
    }
    return self;
}

#pragma mark /*---------------------------------轮播图---------------------------------*/
- (void)fillInCarouselViewData:(NSArray *)array
{
    self.carouselView = [[ZSHomeCarouselView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, carouselViewHeight)];
    self.carouselView.delegate = self;
    self.carouselView.currentPageColor = ZSColorWhite;
    self.carouselView.pageColor = ZSColorAlpha(0,0,0,0.5);
    [self addSubview:self.carouselView];
    
    //图片数据
    if (array.count > 0) {
        NSMutableArray *newArray = [[NSMutableArray alloc]init];
        for (ZSHomeCarouselModel *model in array) {
            [newArray addObject:model.carouselUrl];
        }
        self.carouselView.imagesArray = newArray;
    }
    else
    {
        self.carouselView.imagesArray = @[[UIImage imageNamed:@"home_bg_n_default"]];
    }
}

- (void)carouselView:(ZSHomeCarouselView *)carouselView indexOfClickedImageBtn:(NSUInteger )index
{
    if (_delegate && [_delegate respondsToSelector:@selector(indexOfClickedImageBtn:)]) {
        [_delegate indexOfClickedImageBtn:index];
    }
}

#pragma mark /*---------------------------------工具模块---------------------------------*/
- (void)fillInToolBtnsViewData:(NSArray *)array
{
    CGFloat Width_Space = 0.5;//2个按钮之间的间距
    CGFloat Button_Width = ZSWIDTH/4;//按钮宽度
    CGFloat Button_height = 90;//按钮高度
    
    //底色高度
    NSInteger page = array.count / 4;
    if (page == 0) {
        page = 1;
    }
    
    if (array.count > 0)
    {
        self.toolBtnsView = [[UIView alloc]initWithFrame:CGRectMake(0, carouselViewHeight, ZSWIDTH, (Button_height + Width_Space) * page)];
        self.toolBtnsView.backgroundColor = ZSColorWhite;
        [self addSubview:self.toolBtnsView];
        
        //创建按钮
        for (int i = 0 ; i < array.count; i++)
        {
            NSInteger index = i % 4;
            NSInteger page = i / 4;
            ZSHomeToolButton *toolBtn = [[ZSHomeToolButton alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space), page  * (Button_height + Width_Space), Button_Width, Button_height)];
            [toolBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            toolBtn.tag = i;
            toolBtn.backgroundColor = ZSColorWhite;
            [self.toolBtnsView addSubview:toolBtn];
            //按钮赋值
            ZSHomeToolModel *model = array[i];
            [toolBtn.imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",APPDELEGATE.zsImageUrl,model.funcIcon,@"?p=0"]] placeholderImage:defaultImage_square];
            toolBtn.label_text.text = model.funcName;
        }
    }
    else
    {
        [self.toolBtnsView removeFromSuperview];
    }
}

- (void)toolBtnClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(indexOfClickedToolsBtn:)]) {
        [_delegate indexOfClickedToolsBtn:sender.tag];
    }
}

#pragma mark /*---------------------------------产品推荐---------------------------------*/
- (void)fillInProductsViewData:(NSArray *)array
{
    if (array.count > 0)
    {
        self.productsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, productsViewHeight)];
        [self addSubview:self.productsView];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, productsViewHeight-10)];
        bgView.backgroundColor = ZSColorWhite;
        [self.productsView addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, 0, 120, CellHeight)];
        titleLabel.textColor = ZSColorBlack;
        titleLabel.text = @"产品推荐";
        titleLabel.font = FontBtn;
        [bgView addSubview:titleLabel];
        
        //查看全部按钮
        UILabel *allPrdLabel = [[UILabel alloc] initWithFrame:CGRectMake(ZSWIDTH-30-65, 0, 65, CellHeight)];
        allPrdLabel.textColor = ZSPageItemColor;
        allPrdLabel.text = @"查看全部";
        allPrdLabel.font = FontBtn;
        [bgView addSubview:allPrdLabel];
        UIImageView *pushImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-30, (CellHeight-15)/2, 15, 15)];
        pushImage.image = [UIImage imageNamed:@"list_arrow_n"];
        [bgView addSubview:pushImage];
        UIButton *allPrdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allPrdBtn.frame = CGRectMake(ZSWIDTH-100, 0, 100, CellHeight);
        [allPrdBtn addTarget:self action:@selector(allPrdBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:allPrdBtn];
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, CellHeight, ZSWIDTH-GapWidth*2, 0.5)];
        lineView.backgroundColor = ZSColorLine;
        [bgView addSubview:lineView];
        
        //产品介绍scrollView
        UIScrollView *productScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54.5, ZSWIDTH, productsImageHeight+20)];
        productScroll.showsHorizontalScrollIndicator = NO;
        productScroll.contentSize = CGSizeMake((GapWidth + productsImageWidth)*array.count + GapWidth, 0);
        [bgView addSubview:productScroll];
        
        for (int i = 0 ; i < array.count; i++)
        {
            ZSCreateOrderPopupModel *model = array[i];
            
            //图片
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth + (GapWidth + productsImageWidth) * i, 0, productsImageWidth, productsImageHeight)];
            imgView.layer.cornerRadius = 10;
            imgView.layer.masksToBounds = YES;
            imgView.userInteractionEnabled = YES;
            imgView.tag = i;
            [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,model.homepageImg]] placeholderImage:defaultImage_rectangle];
            [productScroll addSubview:imgView];
            UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapAction:)];
            [imgView addGestureRecognizer:imgTap];
            
            //cover
            UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, productsImageHeight-60, productsImageWidth, 60)];
            coverView.backgroundColor = ZSColorBlack;
            coverView.alpha = 0.5;
            coverView.layer.masksToBounds = YES;
            [imgView addSubview:coverView];
            
            //产品名
            UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, productsImageHeight-60+10, ZSWIDTH-GapWidth*3-75, 20)];
            productLabel.textColor = ZSColorWhite;
            productLabel.font = [UIFont boldSystemFontOfSize:15];
            [imgView addSubview:productLabel];
            if (model.prdName) {
                productLabel.text = [NSString stringWithFormat:@"%@",[ZSGlobalModel changeLoanString:model.prdName]];
            }
            
            //产品介绍
            UILabel *prdIntroductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, productLabel.bottom, ZSWIDTH-GapWidth*3-75, 20)];
            prdIntroductionLabel.font = FontSecondTitle;
            prdIntroductionLabel.textColor = ZSColorWhite;
            prdIntroductionLabel.numberOfLines = 0;
            prdIntroductionLabel.adjustsFontSizeToFitWidth = YES;
            [imgView addSubview:prdIntroductionLabel];
            if (model.prdFeature) {
                prdIntroductionLabel.text = [NSString stringWithFormat:@"%@",model.prdFeature];
            }
            
            //立即申请
            UILabel *createLabel = [[UILabel alloc]initWithFrame:CGRectMake(productsImageWidth-75-GapWidth, productsImageHeight-60+20, 75, 30)];
            createLabel.font = [UIFont systemFontOfSize:12];
            createLabel.textColor = ZSColorGolden;
            createLabel.text = @"立即申请";
            createLabel.textAlignment = NSTextAlignmentCenter;
            createLabel.backgroundColor = ZSColorWhite;
            createLabel.layer.cornerRadius = 15;
            createLabel.clipsToBounds = YES;
            [imgView addSubview:createLabel];
        }
    }
    else
    {
        [self.productsView removeFromSuperview];
    }
}

#pragma mark 查看全部
- (void)allPrdBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(checkAllProduct)]) {
        [_delegate checkAllProduct];
    }
}

#pragma mark 点击产品
- (void)imgViewTapAction:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(indexOfClickedProductImageView:)]) {
        [_delegate indexOfClickedProductImageView:tap.view.tag];
    }
}

#pragma mark /*---------------------------------提示label---------------------------------*/
- (void)configureNoticeLabel
{
    if (self.noticeView) {
        return;
    }
    
    self.noticeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 54)];
    [self addSubview:self.noticeView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ZSWIDTH, CellHeight)];
    bgView.backgroundColor = ZSColorWhite;
    [self.noticeView addSubview:bgView];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth*2, CellHeight)];
    noticeLabel.textColor = ZSColorBlack;
    noticeLabel.text = @"小房主快讯";
    noticeLabel.font = FontBtn;
    [bgView addSubview:noticeLabel];
}

#pragma mark 设置自己的高度
- (void)resetSelfHeight
{
    //产品推荐view
    self.productsView.top = self.toolBtnsView ? self.toolBtnsView.bottom : carouselViewHeight;
   
    //列表noticeLabel
    self.noticeView.top = self.productsView ? self.productsView.bottom : self.toolBtnsView ? self.toolBtnsView.bottom : carouselViewHeight;

    //自身高度
    self.height = carouselViewHeight + self.toolBtnsView.height + self.productsView.height + self.noticeView.height;
}

@end
