//
//  ZSTextWithPhotosTableViewCell.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2018/5/17.
//  Copyright © 2018年 黄曼文. All rights reserved.
//

#import "ZSTextWithPhotosTableViewCell.h"
#import "ZSSLDataCollectionView.h"

@interface ZSTextWithPhotosTableViewCell ()<ZSSLDataCollectionViewDelegate>
@property (nonatomic,strong) ZSSLDataCollectionView      *dataCollectionView;
@property (nonatomic,strong) UILabel                *leftLabel;
@property (nonatomic,strong) UIView                 *lineView;
@end

@implementation ZSTextWithPhotosTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    //datacollectionView
    self.dataCollectionView = [[ZSSLDataCollectionView alloc]init];
    self.dataCollectionView.frame = CGRectMake(0, 10, ZSWIDTH, self.height-20);
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.myCollectionView.scrollEnabled = NO;
    self.dataCollectionView.addDataStyle = ZSAddResourceDataCountless;//添加照片的形式
    self.dataCollectionView.titleNameArray = [[NSMutableArray alloc]initWithObjects:@"随便传什么只要数组不为空就可以", nil];
    [self addSubview :self.dataCollectionView];
    
    //提示label(用于盖住collectionView的header)
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight)];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.textColor = ZSColorListLeft;
    self.leftLabel.backgroundColor = ZSColorWhite;
    [self addSubview:self.leftLabel];
}

#pragma mark 赋值
- (void)setModel:(ZSDynamicDataModel *)model
{
    _model = model;
    
    //照片是否可编辑
    self.dataCollectionView.isShowAdd = self.isShowAdd;
    
    //提示label
    if (model.isNecessary.intValue == 0) {
        self.leftLabel.text = [NSString stringWithFormat:@"    %@",model.fieldMeaning];
    }
    else {
        NSString *titleString = [NSString stringWithFormat:@"    %@ *",model.fieldMeaning];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:titleString];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorRed range:NSMakeRange(titleString.length-1, 1) ];
        self.leftLabel.attributedText = mutableStr;
    }
    
    //有本地数据就直接显示
    if (model.imageDataArray.count > 0)
    {
        //给collectionview赋值
        self.dataCollectionView.itemArray = model.imageDataArray.mutableCopy;
        [self.dataCollectionView.myCollectionView reloadData];
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        //刷新当前cell的高度
        if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellHeight:withIndex:)]){
            [_delegate sendCurrentCellHeight:self.dataCollectionView.myCollectionView.height
                                   withIndex:self.currentIndex];
        }
    }
    //无本地数据加载网络数据
    else if (model.rightData.length)
    {
        //给collectionview赋值
        NSMutableArray *dataArray = @[].mutableCopy;
        NSArray *array = [model.rightData componentsSeparatedByString:@","];        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZSWSFileCollectionModel *fileModel = [[ZSWSFileCollectionModel alloc]init];
            fileModel.dataUrl = array[idx];
            fileModel.dataId = @"";
            [dataArray addObject:fileModel];
        }];
        NSMutableArray *itemDataArray = [[NSMutableArray alloc]initWithObjects:dataArray,nil];
        self.dataCollectionView.itemArray = itemDataArray;
        [self.dataCollectionView.myCollectionView reloadData];
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        //刷新当前cell的高度
        if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellHeight:withIndex:)]){
            [_delegate sendCurrentCellHeight:self.dataCollectionView.myCollectionView.height
                                   withIndex:self.currentIndex];
        }
    }
    //啥都没,给个空数组自己玩吧
    else
    {
        //给collectionview赋值
        NSMutableArray *dataArray = @[@[].mutableCopy].mutableCopy;
        self.dataCollectionView.itemArray = dataArray;
        [self.dataCollectionView.myCollectionView reloadData];
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        //刷新当前cell的高度
        if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellHeight:withIndex:)]){
            [_delegate sendCurrentCellHeight:self.dataCollectionView.myCollectionView.height
                                   withIndex:self.currentIndex];
        }
    }
}

- (void)setIsHiddenCollectionView:(BOOL)isHiddenCollectionView
{
    self.dataCollectionView.hidden = YES;
    self.dataCollectionView.myCollectionView.hidden = YES;
}

#pragma mark /*-------------------------------ZSSLDataCollectionViewDelegate-------------------------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{    
    [self.dataCollectionView layoutSubviews];
    self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
    
    //刷新当前cell的高度
    if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellHeight:withIndex:)]){
        [_delegate sendCurrentCellHeight:self.dataCollectionView.myCollectionView.height
                               withIndex:self.currentIndex];
    }
    //本地图片数组(有图片才赋值)
    if (![self.dataCollectionView.itemArray isEqual:@[@[]]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sendImageArrayData:WithIndex:)]) {
            [_delegate sendImageArrayData:self.dataCollectionView.itemArray[0] WithIndex:self.currentIndex];
        }
    }
    //图片有增删或修改,点击底部按钮或返回按钮时都需要有反应
    if (![[self getNeedUploadFilesString] isEqualToString:self.model.rightData])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(checkPhototCellChangeState:)]) {
            [_delegate checkPhototCellChangeState:YES];
        }
    }
}

//显示上传进度
- (void)showProgress:(NSString *)progressString
{
    //传递已上传的图片数据
    if (_delegate && [_delegate respondsToSelector:@selector(sendProcessOfPhototWithData:WithIndex:)]){
        [_delegate sendProcessOfPhototWithData:[self getNeedUploadFilesString] WithIndex:self.currentIndex];
    }
}

//判断是否有图片上传失败
- (void)judePictureUploadingFailure:(BOOL)isFailure;
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendPictureUploadingFailureWithIndex:)]){
        [_delegate sendPictureUploadingFailureWithIndex:isFailure];
    }
}

#pragma mark 获取所要上传的数据
- (NSString *)getNeedUploadFilesString
{
    NSString *string;
    if ([self.dataCollectionView.itemArray count]) {
        for (NSMutableArray *array in self.dataCollectionView.itemArray) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    //直接拼接所有的url
                    if (colletionModel.dataUrl) {
                        string = [NSString stringWithFormat:@"%@,%@",string,colletionModel.dataUrl];
                    }
                }
            }
        }
    }
    string = [string stringByReplacingOccurrencesOfString:@"(null),"withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@",(null)"withString:@""];
    return SafeStr(string);
}

- (void)dealloc
{
    [USER_DEFALT setInteger:0 forKey:KhasbeenUploadNum];
    [USER_DEFALT setInteger:0 forKey:KneedUploadNum];
}

@end
