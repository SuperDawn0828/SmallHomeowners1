//
//  ZSBaseAddResourceViewController.m
//  ZSSmallLandlord
//
//  Created by gengping on 2017/9/13.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSAddResourceViewController.h"
#import "TZImageManager.h"

@interface ZSAddResourceViewController ()<ZSSLDataCollectionViewDelegate,ZSAlertViewDelegate>
{
    LSProgressHUD      *hud;
    BOOL               isShowHUD;
}
@property(nonatomic,strong)ZSSLDataCollectionView     *dataCollectionView;
@property(nonatomic,strong)UIScrollView               *bgScrollView;       //滑动ScrollView
@property(nonatomic,strong)NSMutableArray             *fileArray;          //请求数据数组
@property(nonatomic,assign)BOOL                       isFailure;           //是否有图片上传失败
@property(nonatomic,assign)BOOL                       isChanged;           //判断当前页面是否有操作,用于返回提示
@end

@implementation ZSAddResourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:self.titleString withBackBtn:YES];//navgationBar
    [self configureRightNavItemWithTitle:@"" withNormalImg:nil withHilightedImg:nil];//右侧按钮
    [self configureViews];
    isShowHUD = NO;
    //Data
    [self fillInData];
}

#pragma mark /*--------------------------------返回事件-------------------------------------------*/
#pragma mark 判断当前页面是否有数据修改
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //有新增图片或删除图片,或者文本资料有改动
    if (self.isChanged == YES)
    {
        [self leftAction];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)leftAction;
{
    //有新增图片或删除图片,或者文本资料有改动
    if (self.isChanged == YES)
    {
        ZSAlertView *alertView = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"是否确认放弃保存本次编辑的内容?" cancelTitle:@"放弃" sureTitle:@"我要保存"];
        alertView.delegate = self;
        [alertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ZSAlertViewDelegate
- (void)AlertView:(ZSAlertView *)alert;//确认按钮响应的方法
{
    [self bottomClick:nil];
}

- (void)AlertViewCanCleClick:(ZSAlertView *)alert;//取消按钮响应的方法
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark /*--------------------------------数据填充-------------------------------------------*/
- (void)fillInData
{
    if (self.photoUrl.length)
    {
        NSMutableArray *dataArray = @[].mutableCopy;
        //户口本
        if (self.addDataStyle == ZSAddResourceDataTwo)
        {
            //给collectionview赋值
            NSDictionary *newDic = [NSString stringToDictory:self.photoUrl];
            //两个都有
            if (newDic[@"houseRegisterMaster"] && newDic[@"houseRegisterPersonal"])
            {
                ZSWSFileCollectionModel *fileModel1 = [[ZSWSFileCollectionModel alloc]init];
                fileModel1.dataUrl = newDic[@"houseRegisterMaster"];
                fileModel1.dataId = @"";
                [dataArray addObject:fileModel1];
                
                ZSWSFileCollectionModel *fileModel2 = [[ZSWSFileCollectionModel alloc]init];
                fileModel2.dataUrl = newDic[@"houseRegisterPersonal"];
                fileModel2.dataId = @"";
                [dataArray addObject:fileModel2];
            }
            //只有户主页
            else if (newDic[@"houseRegisterMaster"] && !newDic[@"houseRegisterPersonal"])
            {
                ZSWSFileCollectionModel *fileModel1 = [[ZSWSFileCollectionModel alloc]init];
                fileModel1.dataUrl = newDic[@"houseRegisterMaster"];
                fileModel1.dataId = @"";
                [dataArray addObject:fileModel1];
                
                ZSWSFileCollectionModel *fileModel2 = [[ZSWSFileCollectionModel alloc]init];
                fileModel2.dataId = @"";
                [dataArray addObject:fileModel2];
            }
            //只有个人页
            else if (!newDic[@"houseRegisterMaster"] && newDic[@"houseRegisterPersonal"])
            {
                ZSWSFileCollectionModel *fileModel1 = [[ZSWSFileCollectionModel alloc]init];
                fileModel1.dataId = @"";
                [dataArray addObject:fileModel1];
                
                ZSWSFileCollectionModel *fileModel2 = [[ZSWSFileCollectionModel alloc]init];
                fileModel2.dataUrl = newDic[@"houseRegisterPersonal"];
                fileModel2.dataId = @"";
                [dataArray addObject:fileModel2];
            }
        }
        //征信报告
        else
        {
            NSArray *array = [self.photoUrl componentsSeparatedByString:@","];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZSWSFileCollectionModel *fileModel = [[ZSWSFileCollectionModel alloc]init];
                fileModel.dataUrl = array[idx];
                fileModel.dataId = @"";
                [dataArray addObject:fileModel];
            }];
        }

        NSMutableArray *itemDataArray = [[NSMutableArray alloc]initWithObjects:dataArray,nil];
        self.dataCollectionView.itemArray = itemDataArray;
        [self.dataCollectionView.myCollectionView reloadData];
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
    }
    //没有数据的时候
    else
    {
        if (self.addDataStyle == ZSAddResourceDataTwo)
        {
            ZSWSFileCollectionModel *fileModel = [[ZSWSFileCollectionModel alloc]init];
            NSMutableArray *dataArray = @[fileModel,fileModel].mutableCopy;
            NSMutableArray *itemDataArray = [[NSMutableArray alloc]initWithObjects:dataArray,nil];
            self.dataCollectionView.itemArray = itemDataArray;
            [self.dataCollectionView.myCollectionView reloadData];
            [self.dataCollectionView layoutSubviews];
        }
    }
}

#pragma mark /*--------------------------------UI-------------------------------------------*/
- (void)configureViews
{
    //滑动scrollView
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, ZSWIDTH, ZSHEIGHT-self.navView.height-60)];
    self.bgScrollView.backgroundColor = ZSViewBackgroundColor;
    self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, ZSHEIGHT);
    [self.view addSubview:self.bgScrollView];
    
    //datacollectionView
    self.dataCollectionView = [[ZSSLDataCollectionView alloc]init];
    self.dataCollectionView.frame = CGRectMake(0, -30, ZSWIDTH,self.dataCollectionView.height);//top为-34是为了盖住分组title
    self.dataCollectionView.backgroundColor = ZSViewBackgroundColor;
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.myCollectionView.scrollEnabled = NO;
    self.dataCollectionView.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;//添加照片的形式
    self.dataCollectionView.titleNameArray = [[NSMutableArray alloc]initWithObjects:@" ", nil];//随便传什么只要数组不为空就可以
    [self.bgScrollView addSubview :self.dataCollectionView];
    
    //底部按钮
    [self configuBottomButtonWithTitle:@"保存"];
}

#pragma mark /*-------------------------------ZSSLDataCollectionViewDelegate------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    self.isChanged = YES;
    
    //多张的时候更新坐标
    if (self.addDataStyle == ZSAddResourceDataCountless)
    {
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
        self.bgScrollView.contentSize = CGSizeMake(ZSWIDTH, self.dataCollectionView.myCollectionView.bottom + 120);
    }
}

//显示上传进度
- (void)showProgress:(NSString *)progressString;
{
    //上传进度
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:KhasbeenUploadNum];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:KneedUploadNum];
    
    //右侧按钮,用于显示上传进度
    if (hasbeenUploadNum > needUploadNum) {
        hasbeenUploadNum = needUploadNum;
    }
    if (needUploadNum > 0 && hasbeenUploadNum <= needUploadNum) {
        [self.rightBtn setTitle:[NSString stringWithFormat:@"已上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum] forState:UIControlStateNormal];
    }
    else{
        [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    //点击了底部保存按钮,此时图片未上传完
    if (isShowHUD == YES)
    {
        if (hasbeenUploadNum < needUploadNum) {
            hud = [LSProgressHUD showWithMessage:[NSString stringWithFormat:@"正在上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
            //如果有图片未上传成功,需要发送通知
            if (self.isFailure) {
                [NOTI_CENTER postNotificationName:@"reUploadImage" object:nil];
                self.isFailure = NO;
                isShowHUD = NO;
            }
        }
        else {
            [LSProgressHUD hide];
            [LSProgressHUD hideForView:self.view];
            //资料上传
            [self bottomClick:nil];
        }
    }
}

//判断是否有图片上传失败
- (void)judePictureUploadingFailure:(BOOL)isFailure;
{
    self.isFailure = isFailure;
}

#pragma mark /*--------------------------------底部按钮------------------------------------------*/
#pragma mark 点击底部按钮(保存资料)
- (void)bottomClick:(UIButton *)btn
{
    //如果有图片未上传成功,需要发送通知
    if (self.isFailure) {
        [NOTI_CENTER postNotificationName:@"reUploadImage" object:nil];
        self.isFailure = NO;
    }

    //有上传的资料
    NSUInteger hasbeenUploadNum = [USER_DEFALT integerForKey:KhasbeenUploadNum];
    NSUInteger needUploadNum = [USER_DEFALT integerForKey:KneedUploadNum];
    if (hasbeenUploadNum < needUploadNum) {
        hud = [LSProgressHUD showWithMessage:[NSString stringWithFormat:@"正在上传%ld/%ld",(long)hasbeenUploadNum,(long)needUploadNum]];
        isShowHUD = YES;
        return;
    }

    //返回上级页面
    if (self.phototBlock) {
        self.phototBlock([self getNeedUploadFilesString]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取所要上传的图片数据
- (NSString *)getNeedUploadFilesString
{
    NSString *string;
    //户口本
    if (self.addDataStyle == ZSAddResourceDataTwo)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (NSMutableArray *array in self.dataCollectionView.itemArray) {
            if ([array count]) {
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZSWSFileCollectionModel *colletionModel = array[idx];
                    if (idx == 0 && colletionModel.dataUrl) {
                        [dict setObject:colletionModel.dataUrl forKey:@"houseRegisterMaster"];
                    }
                    if (idx == 1 && colletionModel.dataUrl) {
                        [dict setObject:colletionModel.dataUrl forKey:@"houseRegisterPersonal"];
                    }
                }];
            }
        }
        return [NSString dictoryToString:dict];
    }
    //央行征信报告
    else
    {
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
}

- (void)dealloc
{
    [USER_DEFALT setInteger:0 forKey:KhasbeenUploadNum];
    [USER_DEFALT setInteger:0 forKey:KneedUploadNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
