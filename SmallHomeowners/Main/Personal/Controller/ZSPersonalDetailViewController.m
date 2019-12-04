//
//  ZSPersonalDetailViewController.m
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/7/13.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import "ZSPersonalDetailViewController.h"
#import "ZSPersonalDetailCell.h"
#import "ZSChangeNameViewController.h"
#import "ZSChangePhoneViewController.h"
#import "ZSCertificationViewController.h"
#import "ZSPositionViewController.h"

@interface ZSPersonalDetailViewController ()<ZSActionSheetViewDelegate,ZSAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)NSMutableArray *personInfoArray;     //人员基本资料
@property(nonatomic,strong)NSMutableArray *rightPersonInfoArray;//右边人员基本资料
@end

@implementation ZSPersonalDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //Data
    [self getUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UI
    [self configureNavgationBar:@"个人信息" withBackBtn:YES];
    [self configureTableView:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT - kNavigationBarHeight) withStyle:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
}

#pragma mark 获取个人信息
- (void)getUserInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [ZSRequestManager requestWithParameter:nil url:[ZSURLManager getUserInformation] SuccessBlock:^(NSDictionary *dic) {
        //保存个人信息
        NSDictionary *newdic = dic[@"respData"];
        [ZSLogInManager saveUserInfoWithDic:newdic];
        //Data
        [weakSelf initData];
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } ErrorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark 数据填充
- (void)initData
{
    ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
    self.personInfoArray = @[@"头像",@"用户名",@"手机号",@"所在地",@"类型",@"专属客户经理"].mutableCopy;
    self.rightPersonInfoArray = [[NSMutableArray alloc]init];
    
    //头像
    if (userInfo.headPhoto) {
        [self.rightPersonInfoArray addObject:userInfo.headPhoto];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
  
    //用户名
    if (userInfo.username) {
        [self.rightPersonInfoArray addObject:userInfo.username];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
   
    //手机号
    if (userInfo.telphone) {
        [self.rightPersonInfoArray addObject:userInfo.telphone];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
 
    //所在地
    if (userInfo.city) {
        [self.rightPersonInfoArray addObject:userInfo.city];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
  
    //账号类型
    if (userInfo.userType) {
        [self.rightPersonInfoArray addObject:[ZSUidInfo getRoleType:userInfo.userType]];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
   
    //专属客户经理
    if (userInfo.customerManagerName) {
        [self.rightPersonInfoArray addObject:userInfo.customerManagerName];
    }else{
        [self.rightPersonInfoArray addObject:@""];
    }
    
    //资质认证(只有中介显示该行)
    if (userInfo.userType.intValue == 1) {
        [self.personInfoArray addObject:@"资质认证"];
        if (userInfo.authState) {
            [self.rightPersonInfoArray addObject:[ZSUidInfo getAuthState:userInfo.authState]];
        }
        else{
            [self.rightPersonInfoArray addObject:@"去认证"];
        }
    }
}

#pragma mark tableview--delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return CellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZSPersonalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZSPersonalDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.leftImage.hidden = YES;
        cell.leftLabel.left = 15;
        cell.rightLabel.hidden = YES;
    }
    
    //左侧的数据
    cell.leftLabel.text = self.personInfoArray[indexPath.row];
   
    //右侧的数据
    if (indexPath.row == 0) {
        cell.leftLabel.top = (70-CellHeight)/2;
        cell.pushImage.top = (70-15)/2;
        UIImageView *HeadPortraitImage = [[UIImageView alloc]initWithFrame:CGRectMake(ZSWIDTH-40-35, 10, 40, 40)];
        HeadPortraitImage.backgroundColor = ZSColorListLeft;
        HeadPortraitImage.layer.cornerRadius = 20;
        HeadPortraitImage.layer.masksToBounds = YES;
        HeadPortraitImage.contentMode = UIViewContentModeScaleAspectFill;
        [cell addSubview:HeadPortraitImage];
        [HeadPortraitImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?w=200",APPDELEGATE.zsImageUrl,self.rightPersonInfoArray.firstObject]] placeholderImage:[UIImage imageNamed:@"个人-选中"]];
    }
    else
    {
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = self.rightPersonInfoArray[indexPath.row];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0://修改头像
        {
            ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"拍照",@"从相册选择"]];
            actionsheet.delegate = self;
            actionsheet.tag = ZSHeadPhoto;
            [actionsheet show:2];
        }
            break;
        case 1://修改用户名
        {
            ZSChangeNameViewController *changeName = [[ZSChangeNameViewController alloc]init];
            [self.navigationController pushViewController:changeName animated:YES];
        }
            break;
        case 2://修改手机号
        {
            ZSChangePhoneViewController *ChangephoneVC = [[ZSChangePhoneViewController alloc]init];
            [self.navigationController pushViewController:ChangephoneVC animated:YES];
        }
            break;
        case 3://修改所在地
        {
            ZSPositionViewController *positionVC = [[ZSPositionViewController alloc]init];
            [self.navigationController pushViewController:positionVC animated:YES];
        }
            break;
        case 4://修改角色类型
        {
            ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"中介",@"个人"]];
            actionsheet.delegate = self;
            actionsheet.tag = ZSRoletype;
            [actionsheet show:2];
        }
            break;
        case 5://客户经理打电话
        {
            ZSUidInfo *userInfo = [ZSLogInManager readUserInfo];
            NSString *string = [NSString stringWithFormat:@"%@",SafeStr(userInfo.customerManagerPhone)];
            if (string.length){
                [ZSTool callPhoneStr:string withVC:self];
            }
            else{
                [ZSTool showMessage:@"当前客户经理未录入电话号码" withDuration:DefaultDuration];
            }
        }
            break;
        case 6://资质认证
        {
            ZSCertificationViewController *certifitcationVC = [[ZSCertificationViewController alloc]init];
            NSString *string = self.rightPersonInfoArray[6];
            if ([string isEqualToString:@"去认证"] || [string isEqualToString:@"未认证"]) {
                certifitcationVC.cerType = ZSFromPersonalWithUnauthorized;
            }
            else {
                certifitcationVC.cerType = ZSFromPersonalWithCertified;
            }
            [self.navigationController pushViewController:certifitcationVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark ZSActionSheetViewDelegate
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag;//选中某个按钮响应方法
{
    //修改头像
    if (sheetView.tag == ZSHeadPhoto)
    {
        if (tag == 0) {
            [self chooseTakePhoto];
        }
        else {
            [self imagePicker];
        }
    }
    //修改角色类型
    else if (sheetView.tag == ZSRoletype)
    {
        NSString *roleString;
        if (tag == 0) {
            roleString = @"5";
        }else if (tag == 1) {
            roleString = @"6";
        }
        __weak typeof(self) weakSelf = self;
        [ZSLogInManager changeUserInfoWithRequest:ZSRoletype withString:roleString withID:nil withResult:^(BOOL isSuccess) {
            if (isSuccess) {
                //刷新tableview
                [weakSelf initData];
                [weakSelf.tableView reloadData];
            }
        }];
        
    }
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 拍照或选择照片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *Photoimage  = info[UIImagePickerControllerOriginalImage];
    if (Photoimage != nil) {
        //修正图片方向
        UIImage *imagerotate = [UIImage fixOrientation:Photoimage];
        //照片上传
        NSData *data = UIImageJPEGRepresentation(imagerotate, [ZSTool configureRandomNumber]);
        [self uploadImageData:data];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 上传照片
- (void)uploadImageData:(NSData *)data
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic)
     {
         NSString *dataUrl = [NSString stringWithFormat:@"%@",dic[@"MD5"]];
         //请求接口更新
         [weakSelf changeHeadIcon:dataUrl];
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
     } ErrorBlock:^(NSError *error) {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)changeHeadIcon:(NSString *)dataUrl
{
    __weak typeof(self) weakSelf = self;
    [ZSLogInManager changeUserInfoWithRequest:ZSHeadPhoto withString:dataUrl withID:nil withResult:^(BOOL isSuccess) {
        if (isSuccess) {
            //刷新tableview
            [weakSelf.rightPersonInfoArray replaceObjectAtIndex:0 withObject:dataUrl];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
