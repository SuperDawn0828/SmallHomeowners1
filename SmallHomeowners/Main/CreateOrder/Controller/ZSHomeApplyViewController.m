//
//  ZSHomeApplyViewController.m
//  SmallHomeowners
//
//  Created by jeck on 2019/11/26.
//  Copyright © 2019 maven. All rights reserved.
//

#import "ZSHomeApplyViewController.h"
#import "ZSCreateOrderPersonInfoViewController.h"
#import "ZSSingleLineTextTableViewCell.h"
#import "ZSSLDataCollectionView.h"
#import "ZSHomeApplyFooterView.h"

typedef NS_ENUM(NSUInteger, alertViewTag) {
    deletePersonTag   = 0,     //删除人员信息
    changeMarryTag    = 1998,  //修改婚姻状况
    noticeTag         = 9,     //信息不回保存提示
    scanTag           = 11,    //扫描
    openCameraFailTag = 1,     //相机打开失败
    hasnoPhoneNum     = 2,     //已有订单添加人没有填写手机号
    revalidationPhone = 3,     //修改手机号后是否重新验证
};
@interface ZSHomeApplyViewController ()<ZSSingleLineTextTableViewCellDelegate,ZSActionSheetViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZSAlertViewDelegate,TZImagePickerControllerDelegate,ZSSLDataCollectionViewDelegate>
@property(nonatomic,strong)UIImageView    *frontImage;                   //身份证正面
@property(nonatomic,strong)UIImageView    *reverseImage;                 //身份证反面
@property(nonatomic,strong)NSMutableArray<ZSDynamicDataModel *> *dataArray;
@property(nonatomic,assign)NSInteger      currentIndex;                  //当前选择的照片下标 正面0 反面1
@property(nonatomic,copy  )NSString       *urlFront;                     //身份证正面照片
@property(nonatomic,copy  )NSString       *urlBack;                      //身份证背面照片
@property(nonatomic,assign)BOOL           isChange;                      //是否有数据更改
@property(nonatomic,strong)ZSSLDataCollectionView     *dataCollectionView;
@property(nonatomic,strong)ZSSLDataCollectionView     *dataCollectionView1;

@property(nonatomic,assign)ZSAddResourceDataStyle     addDataStyle;        //添加按钮格式
@property(nonatomic,strong) NSMutableArray *bdImgArr; //不动产权图片
@property(nonatomic,strong) NSMutableArray *zxImgArr; //征信报告图片

@end


@implementation ZSHomeApplyViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (NSMutableArray *)bdImgArr
{
    if (_bdImgArr == nil) {
        _bdImgArr = [[NSMutableArray alloc]init];
    }
    return _bdImgArr;
}
- (NSMutableArray *)zxImgArr
{
    if (_zxImgArr == nil) {
        _zxImgArr = [[NSMutableArray alloc]init];
    }
    return _zxImgArr;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureViews];
    //Data
    [self initData];
}

#pragma mark /*---------------------------------------返回事件---------------------------------------*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isChange)
    {
        [self leftAction];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)leftAction
{
    if (self.isChange)
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"退出后信息将不会被保存" sureTitle:@"确定" cancelTitle:@"取消"];
        alert.tag = noticeTag;
        alert.delegate = self;
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark /*------------------------------------------数据填充------------------------------------------*/
- (void)initData
{
    //姓名
    ZSDynamicDataModel *nameModel = [[ZSDynamicDataModel alloc]init];
    nameModel.fieldMeaning = @"姓名";
    nameModel.isNecessary = @"1";
    nameModel.fieldType = @"1";
    
    //身份证号
    ZSDynamicDataModel *IDCardModel = [[ZSDynamicDataModel alloc]init];
    IDCardModel.fieldMeaning = @"身份证号";
    IDCardModel.isNecessary = @"1";
    IDCardModel.fieldType = @"1";
    
    //手机号
    ZSDynamicDataModel *phoneModel = [[ZSDynamicDataModel alloc]init];
    phoneModel.fieldMeaning = @"手机号";
    phoneModel.isNecessary = @"1";
    phoneModel.fieldType = @"4";
    
    //贷款人金额
    ZSDynamicDataModel *DKRModel = [[ZSDynamicDataModel alloc]init];
    DKRModel.fieldMeaning = @"申请贷款金额";
    DKRModel.isNecessary = @"1";
    DKRModel.fieldType = @"4";
    //    不动产权
    ZSDynamicDataModel *propertyRightModel = [[ZSDynamicDataModel alloc]init];
    propertyRightModel.fieldMeaning = @"不动产权证";
    propertyRightModel.isNecessary = @"0";
    propertyRightModel.fieldType = @"4";
    
    //贷款人金额
    ZSDynamicDataModel *zxbgModel = [[ZSDynamicDataModel alloc]init];
    zxbgModel.fieldMeaning = @"央行征信报告";
    zxbgModel.isNecessary = @"0";
    zxbgModel.fieldType = @"5";
    
    
    
    //    //婚姻状况
    //    ZSDynamicDataModel *marryModel = [[ZSDynamicDataModel alloc]init];
    //    marryModel.fieldMeaning = @"婚姻状况";
    //    marryModel.isNecessary = @"1";
    //    marryModel.fieldType = @"5";
    //
    //户口本
//    ZSDynamicDataModel *DontMove = [[ZSDynamicDataModel alloc]init];
//    DontMove.fieldMeaning = @"不动产权";
//    DontMove.isNecessary = @"0";
//    DontMove.fieldType = @"5";
    //
    //央行征信报告
    //    ZSDynamicDataModel *reportModel = [[ZSDynamicDataModel alloc]init];
    //    reportModel.fieldMeaning = @"央行征信报告";
    //    reportModel.isNecessary = @"0";
    //    reportModel.fieldType = @"5";
    
    //现有订单编辑人员信息
    if (self.personType == ZSFromExistingOrderWithEditor)
    {
        if (global.currentCustomer.identityPos) {
            [self.frontImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,global.currentCustomer.identityPos]] placeholderImage:ImageName(@"身份证正面")];
            self.urlFront = global.currentCustomer.identityPos;
        }
        if (global.currentCustomer.identityBak) {
            [self.reverseImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,global.currentCustomer.identityBak]] placeholderImage:ImageName(@"身份证反面")];
            self.urlBack = global.currentCustomer.identityBak;
        }
        if (global.currentCustomer.name) {
            nameModel.rightData = global.currentCustomer.name;
        }
        if (global.currentCustomer.identityNo) {
            IDCardModel.rightData = global.currentCustomer.identityNo;
        }
        if (global.currentCustomer.cellphone) {
            phoneModel.rightData = global.currentCustomer.cellphone;
        }
        //        if (global.currentCustomer.beMarrage) {
        //            marryModel.rightData = [ZSGlobalModel getMarrayStateWithCode:global.currentCustomer.beMarrage];
        //        }
        if (global.currentCustomer.houseRegisterMaster || global.currentCustomer.houseRegisterPersonal) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            if (global.currentCustomer.houseRegisterMaster) {
                [dict setObject:global.currentCustomer.houseRegisterMaster forKey:@"houseRegisterMaster"];
            }
            if (global.currentCustomer.houseRegisterPersonal) {
                [dict setObject:global.currentCustomer.houseRegisterPersonal forKey:@"houseRegisterPersonal"];
            }
            //            residenceModel.rightData = [NSString dictoryToString:dict];
        }
        //        if (global.currentCustomer.bankCredits) {
        //            reportModel.rightData = global.currentCustomer.bankCredits;
        //        }
    }
    
    //添加值
    [self.dataArray addObject:nameModel];
    [self.dataArray addObject:IDCardModel];
    [self.dataArray addObject:phoneModel];
    [self.dataArray addObject:DKRModel];
    [self.dataArray addObject:propertyRightModel];
//    [self.dataArray addObject:DontMove];
    [self.dataArray addObject:zxbgModel];
    
    self.addDataStyle = ZSAddResourceDataCountless;
    NSMutableArray *imgArray = @[].mutableCopy;
    
    ZSWSFileCollectionModel *fileModel1 = [[ZSWSFileCollectionModel alloc]init];
    fileModel1.dataId = @"";
    fileModel1.currentIndex = 2;
    
    [imgArray addObject:fileModel1];
    
    NSMutableArray *itemDataArray = [[NSMutableArray alloc]initWithObjects:imgArray,nil];
    self.dataCollectionView.itemArray = itemDataArray;
    [self.dataCollectionView.myCollectionView reloadData];
    [self.dataCollectionView layoutSubviews];
    self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
    
    NSMutableArray *imgArray2 = @[].mutableCopy;
    
    ZSWSFileCollectionModel *fileModel2 = [[ZSWSFileCollectionModel alloc]init];
    fileModel2.dataId = @"";
    fileModel2.currentIndex = 3;
    [imgArray2 addObject:fileModel2];
    
    NSMutableArray *itemDataArray2 = [[NSMutableArray alloc]initWithObjects:imgArray2,nil];
    self.dataCollectionView1.itemArray = itemDataArray2;
    [self.dataCollectionView1.myCollectionView reloadData];
    [self.dataCollectionView1 layoutSubviews];
    self.dataCollectionView1.height = self.dataCollectionView1.myCollectionView.height;
    
    //    if ([self.roleTypeString isEqualToString:@"贷款人信息"] || [self.roleTypeString isEqualToString:@"卖方信息"]) {//配偶不需要添加婚姻状况
    //        [self.dataArray addObject:marryModel];
    //    }
    //    [self.dataArray addObject:residenceModel];
    //    [self.dataArray addObject:reportModel];
    
    //刷新table
    [self.tableView reloadData];
}

#pragma mark /*------------------------------------------创建页面------------------------------------------*/
- (void)configureViews
{
    //navgationBar
    [self configureNavgationBar:@"" withBackBtn:YES];
    self.titleLabel.text = self.roleTypeString ? self.roleTypeString : @"贷款人信息";
    if (![self.roleTypeString isEqualToString:@"贷款人信息"] && self.personType == ZSFromExistingOrderWithEditor) {
        [self configureRightNavItemWithTitle:nil withNormalImg:@"head_delete_n" withHilightedImg:@"head_delete_n"];//删除人员角色按钮
    }
    
    //table
    [self configureTableView:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight-60) withStyle:UITableViewStylePlain];
    //    self.tableView.scrollEnabled = NO;
    [self configureHeaderView];
    
    //bottomBtn
    [self configuBottomButtonWithTitle:@"保存"];
}

- (void)configureHeaderView
{
    //图片宽高比1:0.63
    CGFloat imageWidth = (ZSWIDTH-GapWidth*5)/2;
    CGFloat imageHeight = imageWidth * 0.63;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, GapWidth*4 + imageHeight)];
    headerView.backgroundColor = ZSColorWhite;
    self.tableView.tableHeaderView = headerView;
    
    ZSHomeApplyFooterView *footerView = [[ZSHomeApplyFooterView alloc] init];
    footerView.frame = CGRectMake(0,0,375,31);
    footerView.layer.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0].CGColor;
    self.tableView.tableFooterView = footerView;
    
    //身份证正面
    self.frontImage = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth*2, GapWidth, imageWidth, imageHeight)];
    self.frontImage.image = [UIImage imageNamed:@"身份证正面"];
    self.frontImage.userInteractionEnabled = YES;
    self.frontImage.layer.cornerRadius = 5;
    self.frontImage.layer.borderWidth = 0.5;
    self.frontImage.layer.borderColor = ZSColorGolden.CGColor;
    self.frontImage.layer.masksToBounds = YES;
    [headerView addSubview:self.frontImage];
    
    UITapGestureRecognizer *frontTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto:)];
    [self.frontImage addGestureRecognizer:frontTapGesture];
    
    UILabel *frontLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth*2, self.frontImage.bottom, imageWidth, GapWidth*2)];
    frontLabel.text = @"身份证正面";
    frontLabel.textColor = ZSColorAllNotice;
    frontLabel.font = [UIFont systemFontOfSize:12];
    frontLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:frontLabel];
    
    //身份证反面
    self.reverseImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frontImage.right + GapWidth, GapWidth, imageWidth, imageHeight)];
    self.reverseImage.image = [UIImage imageNamed:@"身份证反面"];
    self.reverseImage.userInteractionEnabled = YES;
    self.reverseImage.layer.cornerRadius = 5;
    self.reverseImage.layer.borderWidth = 0.5;
    self.reverseImage.layer.borderColor = ZSColorGolden.CGColor;
    self.reverseImage.layer.masksToBounds = YES;
    [headerView addSubview:self.reverseImage];
    UITapGestureRecognizer *backTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto:)];
    [self.reverseImage addGestureRecognizer:backTapGesture];
    
    UILabel *reverseLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frontImage.right + GapWidth, self.reverseImage.bottom, imageWidth, GapWidth*2)];
    reverseLabel.text = @"身份证反面";
    reverseLabel.textColor = ZSColorAllNotice;
    reverseLabel.font = [UIFont systemFontOfSize:12];
    reverseLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:reverseLabel];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataArray.count-2) {
        return  130;
    }else  if (indexPath.row == self.dataArray.count-1) {
        return  120;
    }else{
        return CellHeight;
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSSingleLineTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZSSingleLineTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        if (indexPath.row == self.dataArray.count-2) {
            self.dataCollectionView = [[ZSSLDataCollectionView alloc]init];
            self.dataCollectionView.tag = 500;
            self.dataCollectionView.frame = CGRectMake(0, 0, ZSWIDTH,self.dataCollectionView.height);//top为-34是为了盖住分组title
            self.dataCollectionView.backgroundColor = ZSViewBackgroundColor;
            self.dataCollectionView.delegate = self;
            self.dataCollectionView.isShowTitle = NO;
            self.dataCollectionView.myCollectionView.scrollEnabled = NO;
            self.dataCollectionView.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;//添加照片的形式
            self.dataCollectionView.titleNameArray = [[NSMutableArray alloc]initWithObjects:@" ", nil];//随便传什么只要数组不为空就可以
            [cell.contentView addSubview:self.dataCollectionView];
            
            UIView *bdView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ZSWIDTH, 30)];
//            bdView.backgroundColor = ZSColorgreen;
            [cell.contentView addSubview:bdView];
            
            UILabel *bdLba = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
            bdLba.text = @"不动产权证";
            bdLba.font = [UIFont systemFontOfSize:13];
            bdLba.textColor = ZSColorSecondTitle;
            [bdView addSubview:bdLba];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 129, ZSWIDTH, 1)];
            lineView.backgroundColor = ZSColorLine;
            [cell.contentView addSubview:lineView];
        }
        if (indexPath.row == self.dataArray.count-1) {
            self.dataCollectionView1 = [[ZSSLDataCollectionView alloc]init];
            self.dataCollectionView1.frame = CGRectMake(0, 0, ZSWIDTH,self.dataCollectionView1.height);//top为-34是为了盖住分组title
            self.dataCollectionView1.backgroundColor = ZSViewBackgroundColor;
            self.dataCollectionView1.delegate = self;
            self.dataCollectionView1.isShowTitle = NO;
            self.dataCollectionView1.tag = 600;
            self.dataCollectionView1.myCollectionView.scrollEnabled = NO;
            self.dataCollectionView1.addDataStyle = (ZSAddResourceDataStyle)self.addDataStyle;//添加照片的形式
            self.dataCollectionView1.titleNameArray = [[NSMutableArray alloc]initWithObjects:@" ", nil];//随便传什么只要数组不为空就可以
            [cell.contentView addSubview:self.dataCollectionView1];
            
            UILabel *bdLba = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 200, 20)];
            //               bdLba.top = 100;
            //               bdLba.py_centerX = self.dataCollectionView.py_centerX;
            bdLba.text = @"央行征信报告";
            bdLba.font = [UIFont systemFontOfSize:13];
            bdLba.textColor = ZSColorSecondTitle;
            [cell.contentView addSubview:bdLba];
        }
    }
    if (self.dataArray.count > 0) {
        if (indexPath.row < self.dataArray.count-2) {
            cell.model = self.dataArray[indexPath.row];
            cell.currentIndex = indexPath.row;
        }
    }
    
    
    return cell;
}
#pragma mark /*-------------------------------ZSSLDataCollectionViewDelegate------------------------*/
//重置collview高度代理
- (void)refershDataCollectionViewHegiht
{
    //    self.isChanged = YES;
    
    //多张的时候更新坐标
    if (self.addDataStyle == ZSAddResourceDataCountless)
    {
        [self.dataCollectionView layoutSubviews];
        self.dataCollectionView.height = self.dataCollectionView.myCollectionView.height;
    }
    NSLog(@"----%@",self.dataCollectionView.itemArray);
    [self.dataCollectionView.itemArray  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSLog(@"array==%@",obj);
        [self.bdImgArr addObject:obj];
//
//        for (ZSWSFileCollectionModel *colletionModel in obj) {
//            //                    ZSWSFileCollectionModel *mode = (ZSWSFileCollectionModel *)obj;
//        }

    }];
    [self.dataCollectionView1.itemArray  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSLog(@"array==%@",obj);
        [self.zxImgArr addObject:obj];

//        for (ZSWSFileCollectionModel *colletionModel in obj) {
//            //                    ZSWSFileCollectionModel *mode = (ZSWSFileCollectionModel *)obj;
//            [self.zxImgArr addObject:colletionModel];
//        }

    }];
    
    [self.tableView reloadData];
}
#pragma mark /*----------------------------ZSSingleLineTextTableViewCellDelegate-------------------------------*/
#pragma mark 传递输入框的值或者"请选择"按钮选择成功以后的值
- (void)sendCurrentCellData:(NSString *)string withIndex:(NSUInteger)currentIndex;
{
    self.isChange = YES;//用于返回提示未保存信息
    
    ZSDynamicDataModel *model = self.dataArray[currentIndex];
    model.rightData = string;
    [self.dataArray replaceObjectAtIndex:currentIndex withObject:model];
    //刷新当前cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark /*------------------------------------------选择身份证照片------------------------------------------*/
- (void)choosePhoto:(UITapGestureRecognizer *)tap
{
    //回收键盘
    [NOTI_CENTER postNotificationName:@"hideKeyboard" object:nil];
    
    //给个标记,是正面还是反面
    if ([tap.view isEqual:self.frontImage]) {
        self.currentIndex = 0;
    }else{
        self.currentIndex = 1;
    }
    
    //显示弹窗
    ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:[self getShowPhotoArray]];
    actionsheet.delegate = self;
    [actionsheet show:[self getShowPhotoArray].count];
}

- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    if (tag == 0) {
        [self chooseTakePhoto];
    }
    else if (tag == 1) {
        [self imagePicker];
    }
    else{
        [self bigImgShow];
    }
}

- (NSArray *)getShowPhotoArray
{
    NSArray *array;
    if (self.currentIndex == 0) {
        if (self.urlFront) {
            array = @[@"拍照",@"从手机相册选择",@"查看大图"];
        }
        else{
            array = @[@"拍照",@"从手机相册选择"];
        }
    }
    else
    {
        if (self.urlBack) {
            array = @[@"拍照",@"从手机相册选择",@"查看大图"];
        }
        else{
            array = @[@"拍照",@"从手机相册选择"];
        }
    }
    return array;
}

#pragma mark 查看大图
- (void)bigImgShow
{
    //1.创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    //2.赋值
    if (self.currentIndex == 0) {
        photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlFront]];
        photoBroseView.showFromView = self.frontImage;
        photoBroseView.hiddenToView = self.frontImage;
    }
    else{
        photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlBack]];
        photoBroseView.showFromView = self.reverseImage;
        photoBroseView.hiddenToView = self.reverseImage;
    }
    photoBroseView.currentIndex = 0;
    //3.显示
    [photoBroseView show];
}

#pragma mark选中拍照
- (void)chooseTakePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 从手机相册选择
- (void)imagePicker
{
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    picker.delegate = self;
    //    [self presentViewController:picker animated:YES completion:nil];
    
#pragma mark 用系统原生的不提示相册权限, 还是改成第三方吧
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.delegate = self;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    //照片数据处理
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self dealWithImage:photos[0]];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark 拍照或选择照片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dealWithImage:info[UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 照片数据处理
- (void)dealWithImage:(UIImage *)Photoimage
{
    //用于返回提示未保存信息
    self.isChange = YES;
    
    //图片处理
    if (Photoimage != nil) {
        //修正图片方向
        UIImage *imagerotate = [UIImage fixOrientation:Photoimage];
        //照片回显
        NSData *data = UIImageJPEGRepresentation(imagerotate, [ZSTool configureRandomNumber]);
        if (self.currentIndex == 0) {
            self.frontImage.image = imagerotate;
            [self uploadFrontImageData:data];
        }else{
            self.reverseImage.image = imagerotate;
            [self uploadReverseImageData:data];
        }
    }
}

#pragma mark 上传照片
- (void)uploadFrontImageData:(NSData *)data
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.frontImage animated:YES];
    [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic)
     {
        NSString *dataUrl = [NSString stringWithFormat:@"%@",dic[@"MD5"]];
        weakSelf.urlFront = dataUrl;//用于接口参数
        [weakSelf uploadImageUrl:dataUrl];//ocr识别
        [MBProgressHUD hideHUDForView:weakSelf.frontImage animated:YES];
    } ErrorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.frontImage animated:YES];
    }];
}

- (void)uploadReverseImageData:(NSData *)data
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.reverseImage animated:YES];
    [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic)
     {
        NSString *dataUrl = [NSString stringWithFormat:@"%@",dic[@"MD5"]];
        weakSelf.urlBack = dataUrl;
        [MBProgressHUD hideHUDForView:weakSelf.reverseImage animated:YES];
    } ErrorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.reverseImage animated:YES];
    }];
}

#pragma mark 照片识别
- (void)uploadImageUrl:(NSString *)dataUrl
{
    __weak typeof(self) weakSelf  = self;
    NSMutableDictionary *dict = @{
        @"url":dataUrl,
        @"ocrType":@"idCard",
    }.mutableCopy;
    [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getOcrRecognition] SuccessBlock:^(NSDictionary *dic) {
        //如果有身份证和姓名信息,并给与提示
        if (dic[@"respMap"]) {
            NSString *stringName = SafeStr(dic[@"respMap"][@"name"]);
            NSString *stringNum = SafeStr(dic[@"respMap"][@"idCardNo"]);
            if (stringName.length || stringNum.length) {
                [ZSTool showMessage:@"姓名及身份证号已自动获取，请注意核对与证件信息是否一致！！！" withDuration:2.0];
                if (stringName.length) {
                    ZSDynamicDataModel *model = self.dataArray[0];
                    model.rightData = stringName;
                    [weakSelf.dataArray replaceObjectAtIndex:0 withObject:model];
                }
                if (stringNum.length) {
                    ZSDynamicDataModel *model = self.dataArray[1];
                    model.rightData = stringNum;
                    [weakSelf.dataArray replaceObjectAtIndex:1 withObject:model];
                }
                //刷新数据
                [weakSelf.tableView reloadData];
            }
        }
        [MBProgressHUD hideHUDForView:weakSelf.frontImage animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.reverseImage animated:YES];
    } ErrorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.frontImage animated:YES];
        [MBProgressHUD hideHUDForView:weakSelf.reverseImage animated:YES];
    }];
}

#pragma mark /*------------------------------------------保存信息------------------------------------------*/
- (void)bottomClick:(UIButton *)sender
{
    //    if (!self.urlFront) {
    //        [ZSTool showMessage:@"请上传身份证正面照片" withDuration:DefaultDuration];
    //        return;
    //    }
    //
    //    if (!self.urlBack) {
    //        [ZSTool showMessage:@"请上传身份证反面照片" withDuration:DefaultDuration];
    //        return;
    //    }
    
    //有必填项没有填
    for (ZSDynamicDataModel *model in self.dataArray) {
        if (model.isNecessary.intValue == 1) {
            if (model.rightData.length == 0 || [model.rightData isKindOfClass:[NSNull class]]) {
                [ZSTool showMessage:[NSString stringWithFormat:@"请输入%@",model.fieldMeaning] withDuration:DefaultDuration];
                return;
            }
        }
    }
    
    //身份证号是否正确
    if (![ZSTool isIDCard:self.dataArray[1].rightData]) {
        [ZSTool showMessage:@"请输入正确的身份证号" withDuration:DefaultDuration];
        return;
    }
    
    //手机号是否正确
    if (self.dataArray[2].rightData.length > 0) {
        if (![ZSTool isMobileNumber:self.dataArray[2].rightData]) {
            [ZSTool showMessage:@"请输入正确的手机号" withDuration:DefaultDuration];
            return;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:[self uploadOrderParameter] url:[ZSURLManager getAddOrUpdateCustomer] SuccessBlock:^(NSDictionary *dic) {
        //订单详情存值
        NSLog(@"%@", dic);
        global.pcOrderDetailModel = [ZSPCOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
        //页面跳转
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        ZSCreateOrderPersonInfoViewController *createVC = [[ZSCreateOrderPersonInfoViewController alloc]init];
//        createVC.personType = weakSelf.personType;
//        createVC.orderIDString = global.pcOrderDetailModel.order.tid;
//        [weakSelf.navigationController pushViewController:createVC animated:YES];
        //通知刷新
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderListNotification object:nil];
        [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
    } ErrorBlock:^(NSError *error) {
    }];
}

#pragma mark 上传参数
- (NSMutableDictionary *)uploadOrderParameter
{
    NSString *string1;
    NSString *string2;

    if ([self.bdImgArr count]) {
        for (NSMutableArray *array in self.bdImgArr) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    //直接拼接所有的url
                    if (colletionModel.dataUrl) {
                        string1 = [NSString stringWithFormat:@"%@,%@",string1,colletionModel.dataUrl];
                    }
                }
            }
        }
    }
    string1 = [string1 stringByReplacingOccurrencesOfString:@"(null),"withString:@""];
    string1 = [string1 stringByReplacingOccurrencesOfString:@",(null)"withString:@""];
    
    if ([self.zxImgArr count]) {
        for (NSMutableArray *array in self.zxImgArr) {
            if ([array count]) {
                for (ZSWSFileCollectionModel *colletionModel in array) {
                    //直接拼接所有的url
                    if (colletionModel.dataUrl) {
                        string2 = [NSString stringWithFormat:@"%@,%@",string2,colletionModel.dataUrl];
                    }
                }
            }
        }
    }
    string2 = [string2 stringByReplacingOccurrencesOfString:@"(null),"withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@",(null)"withString:@""];

    NSLog(@"string1===%@",string1);
    NSLog(@"string2===%@",string2);

    NSMutableDictionary *dict = @{
        @"prdType":global.prdType ? global.prdType : @"",
        @"releation":[ZSGlobalModel getReleationCodeWithState:self.titleLabel.text],
        @"name":self.dataArray[0].rightData ? self.dataArray[0].rightData : @"",
        @"identityNo":self.dataArray[1].rightData ? self.dataArray[1].rightData : @"",
        @"loanAmount":self.dataArray[3].rightData ? self.dataArray[3].rightData : @""
    }.mutableCopy;
    //身份证正面
    if (self.urlFront) {
        [dict setObject:self.urlFront forKey:@"identityPosUrl"];
    }
    //身份证反面
    if (self.urlBack) {
        [dict setObject:self.urlBack forKey:@"identityBakUrl"];
    }
    //手机号
    if (self.dataArray[2].rightData.length) {
        [dict setObject:self.dataArray[2].rightData forKey:@"cellphone"];
    }
    //婚姻状况 户口本 央行征信报告
    if ([self.roleTypeString isEqualToString:@"贷款人信息"] || [self.roleTypeString isEqualToString:@"卖方信息"]) {//配偶不需要添加婚姻状况
        //婚姻状况
        [dict setObject:[ZSGlobalModel getMarrayCodeWithState:self.dataArray[3].rightData] forKey:@"beMarrage"];
        //户口本
        if (self.dataArray[4].rightData.length) {
            NSDictionary *newDic = [NSString stringToDictory:self.dataArray[4].rightData];
            [dict setObject:newDic[@"houseRegisterMaster"] ? newDic[@"houseRegisterMaster"] : @"" forKey:@"houseRegisterMaster"];
            [dict setObject:newDic[@"houseRegisterPersonal"] ? newDic[@"houseRegisterPersonal"] : @"" forKey:@"houseRegisterPersonal"];
        }
        //央行征信报告
        if (self.dataArray[5].rightData.length) {
            [dict setObject:self.dataArray[5].rightData forKey:@"bankCredits"];
        }
    }
    else
    {
        //不动产证
        if (self.dataCollectionView.itemArray.count > 0) {
            NSMutableArray<NSString *> *list = [[NSMutableArray alloc] initWithCapacity:0];
            for (ZSWSFileCollectionModel *element in (NSMutableArray *)[self.dataCollectionView.itemArray firstObject]) {
                if (element.dataUrl) {
                    [list addObject:element.dataUrl];
                }
            }
            NSString *string = [list componentsJoinedByString:@","];
            [dict setObject:string forKey:@"houseEstateCredentials"];
        }
        //央行征信报告
        if (self.dataCollectionView1.itemArray.count > 0) {
            NSMutableArray<NSString *> *list = [[NSMutableArray alloc] initWithCapacity:0];
            for (ZSWSFileCollectionModel *element in (NSMutableArray *)[self.dataCollectionView1.itemArray firstObject]) {
                if (element.dataUrl) {
                    [list addObject:element.dataUrl];
                }
            }
            NSString *string = [list componentsJoinedByString:@","];
            [dict setObject:string forKey:@"bankCredits"];
        }
    }
    //订单id
    if (global.pcOrderDetailModel.order.tid) {
        [dict setObject:global.pcOrderDetailModel.order.tid forKey:@"orderId"];
    }
    //人员id
    if (global.currentCustomer.tid) {
        [dict setObject:global.currentCustomer.tid forKey:@"custId"];
    }
    return dict;
}

#pragma mark /*------------------------------------------删除人员信息------------------------------------------*/
- (void)RightBtnAction:(UIButton*)sender
{
    if ([self.roleTypeString isEqualToString:@"卖方信息"])
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"删除后信息将无法恢复，同时卖方配偶信息会一并删除，是否确认删除？" sureTitle:@"确认" cancelTitle:@"取消"];
        alert.delegate = self;
        alert.tag = deletePersonTag;
        [alert show];
    }
    else
    {
        ZSAlertView *alert = [[ZSAlertView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withNotice:@"删除后信息将无法恢复，是否确认删除" sureTitle:@"确定" cancelTitle:@"取消"];
        alert.delegate = self;
        alert.tag = deletePersonTag;
        [alert show];
    }
}

- (void)AlertView:(ZSAlertView *)alert;
{
    //返回提示信息未保存
    if (alert.tag == noticeTag)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //删除配偶提示信息
    else if (alert.tag == deletePersonTag)
    {
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *dict = @{
            @"prdType":global.prdType,
            @"orderId":global.pcOrderDetailModel.order.tid,
            @"custId":global.currentCustomer.tid
        }.mutableCopy;
        [ZSRequestManager requestWithParameter:dict url:[ZSURLManager getDeleteCustomer] SuccessBlock:^(NSDictionary *dic) {
            //订单详情存值
            global.pcOrderDetailModel = [ZSPCOrderDetailModel yy_modelWithDictionary:dic[@"respData"]];
            //页面跳转
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //通知刷新
            [NOTI_CENTER postNotificationName:KSUpdateAllOrderDetailNotification object:nil];
        } ErrorBlock:^(NSError *error) {
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
