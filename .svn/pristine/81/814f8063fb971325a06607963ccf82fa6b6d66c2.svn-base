//
//  ZSCertificationView.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/28.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSCertificationView.h"

@interface ZSCertificationView  ()<UITextFieldDelegate,ZSActionSheetViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@end

@implementation ZSCertificationView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ZSColorWhite;
        self.urlString = @"";
        
        //名片
        UILabel *bussinessLabel = [[UILabel alloc]initWithFrame:CGRectMake(GapWidth, 10, 100, CellHeight)];
        bussinessLabel.font = FontBtn;
        bussinessLabel.textColor = ZSColorListLeft;
        bussinessLabel.attributedText = [ZSTool addStarWithString:@"名片"];
        [self addSubview:bussinessLabel];

        //名片图片(宽高比1:0.63)
        self.bussinessCardImage = [[UIImageView alloc]initWithFrame:CGRectMake(GapWidth*4, bussinessLabel.bottom, ZSWIDTH-GapWidth*8, (ZSWIDTH-GapWidth*8)*0.63)];
        self.bussinessCardImage.image = [UIImage imageNamed:@"身份证正面"];
        self.bussinessCardImage.userInteractionEnabled = YES;
        self.bussinessCardImage.layer.cornerRadius = 5;
        self.bussinessCardImage.layer.borderWidth = 0.5;
        self.bussinessCardImage.layer.borderColor = ZSColorGolden.CGColor;
        self.bussinessCardImage.layer.masksToBounds = YES;
        [self addSubview:self.bussinessCardImage];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto)];
        [self.bussinessCardImage addGestureRecognizer:tapGesture];
        
        //公司
        self.companyView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.bussinessCardImage.bottom+10, ZSWIDTH, CellHeight) withInputAction:@"公司 *" withRightTitle:nil withKeyboardType:UIKeyboardTypeDefault];
        [self.companyView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        self.companyView.lineView.top = CellHeight-0.5;
        [self addSubview:self.companyView];
        
        //职位
        self.positionView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, self.companyView.bottom, ZSWIDTH, CellHeight) withInputAction:@"职位 *" withRightTitle:nil withKeyboardType:UIKeyboardTypeDefault];
        [self.positionView.inputTextFeild addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        self.positionView.lineView.hidden = YES;
        [self addSubview:self.positionView];
    }
    return self;
}

#pragma mark 选择照片
- (void)choosePhoto
{
    //上传照片的弹窗
    if (self.isCanUpload == YES)
    {
        if (self.urlString.length)
        {
            ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"拍照",@"从手机相册选择",@"查看大图"]];
            actionsheet.delegate = self;
            [actionsheet show:3];
        }
        else
        {
            ZSActionSheetView *actionsheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:@[@"拍照",@"从手机相册选择"]];
            actionsheet.delegate = self;
            [actionsheet show:2];
        }
    }
    //查看大图
    else
    {
        [self showBigImage];
    }
}

- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag
{
    if (tag == 0) {
        [self chooseTakePhoto];
    }
    else if (tag == 1) {
        [self imagePicker];
    }
    else {
        [self showBigImage];
    }
}

- (void)showBigImage
{
    //1.创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT)];
    //2.赋值
    if (self.urlString.length){
        photoBroseView.imagesURL = @[[NSString stringWithFormat:@"%@%@",APPDELEGATE.zsImageUrl,self.urlString]];
    }else{
        photoBroseView.images = @[[UIImage imageNamed:@"身份证正面"]];
    }
    photoBroseView.showFromView = self.bussinessCardImage;
    photoBroseView.hiddenToView = self.bussinessCardImage;
    photoBroseView.currentIndex = 0;
    //3.显示
    [photoBroseView show];
}

#pragma mark 监听输入框状态
- (void)textFieldTextChange:(UITextField *)textField
{
    if (self.companyView.inputTextFeild.text.length>0 && self.positionView.inputTextFeild.text.length>0 && self.urlString.length)
    {
        //代理传值
        if (_delegate && [_delegate respondsToSelector:@selector(sendCertificationData)]){
            [_delegate sendCertificationData];
        }
    }
    
    NSString *currentString = textField.text;
    NSString *currentLang = [[textField textInputMode] primaryLanguage];// 键盘输入模式
    //中文输入法下,只对已输入完成的文字进行字数统计和限制
    if ([currentLang isEqualToString:@"zh-Hans"] == YES)// 简体中文输入，包括简体拼音，健体五笔，简体手写
    {
        //获取高亮部分
        UITextRange *markedRange = [textField markedTextRange];
        UITextPosition *markedPosition = [textField positionFromPosition:markedRange.start offset:0];
        
        if (!markedPosition)
        {
            if (currentString.length > LengthLimitDefault) {
                textField.text = [currentString substringToIndex:LengthLimitDefault];
            }
        }
        
    }
    //其他输入法直接限制
    else
    {
        if (currentString.length > LengthLimitDefault) {
            textField.text = [currentString substringToIndex:LengthLimitDefault];
        }
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
    [[ZSTool getCurrentVCWithCurrentView:self] presentViewController:picker animated:YES completion:nil];
}

#pragma mark 从手机相册选择
- (void)imagePicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [[ZSTool getCurrentVCWithCurrentView:self] presentViewController:picker animated:YES completion:nil];
}

#pragma mark 拍照或选择照片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *Photoimage  = info[UIImagePickerControllerOriginalImage];
    if (Photoimage != nil) {
        //修正图片方向
        UIImage *imagerotate = [UIImage fixOrientation:Photoimage];
        //照片回显
        self.bussinessCardImage.image = imagerotate;
        //照片上传
        NSData *data = UIImageJPEGRepresentation(imagerotate, [ZSTool configureRandomNumber]);
        [self uploadImageData:data];
    }
    [[ZSTool getCurrentVCWithCurrentView:self] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 上传照片
- (void)uploadImageData:(NSData *)data
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.bussinessCardImage animated:YES];    
    [ZSRequestManager uploadImageWithNativeAPI:data SuccessBlock:^(NSDictionary *dic)
    {
        NSString *dataUrl = [NSString stringWithFormat:@"%@",dic[@"MD5"]];
        self.urlString = dataUrl;
        if (weakSelf.companyView.inputTextFeild.text.length>0 && weakSelf.positionView.inputTextFeild.text.length>0 && weakSelf.urlString.length)
        {
            //代理传值
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCertificationData)]){
                [weakSelf.delegate sendCertificationData];
            }
        }
        [MBProgressHUD hideHUDForView:weakSelf.bussinessCardImage animated:YES];
    } ErrorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.bussinessCardImage animated:YES];
    }];
}

@end
