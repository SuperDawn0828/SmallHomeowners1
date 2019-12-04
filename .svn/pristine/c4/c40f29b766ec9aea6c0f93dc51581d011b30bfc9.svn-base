//
//  ZSSingleLineTextTableViewCell.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSSingleLineTextTableViewCell.h"
#import "ZSAddResourceViewController.h"
#import "ZSPositionViewController.h"
#import "ZSProvincesPopView.h"

@interface ZSSingleLineTextTableViewCell  ()<ZSInputOrSelectViewDelegate,UITextFieldDelegate,ZSActionSheetViewDelegate>
@property(nonatomic,strong)ZSInputOrSelectView *inputView;
@property(nonatomic,copy)NSString            *photoUrl;  //当前存在的图片url
@property(nonatomic,copy)NSString            *addressID; //当前存在的省市区,用于修改地址时展示
@end

@implementation ZSSingleLineTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.topLineStyle = CellLineStyleNone;//设置cell上分割线的风格
        self.bottomLineStyle = CellLineStyleNone;//设置cell上分割线的风格
    }
    return self;
}

#pragma mark /*----------------------------------------------画界面-----------------------------------------------*/
- (void)setModel:(ZSDynamicDataModel *)model
{
    _model = model;
    
    //展示类型(fieldType)  1文本 2多行文本 3图片 4数字 5选择按钮
    //文本
    if (model.fieldType.intValue == 1)
    {
        if (model.isNecessary.intValue == 0) {
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:model.fieldMeaning withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
        }
        else {
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning] withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDefault];
        }
    }
    //数字
    else if (model.fieldType.intValue == 4)
    {
        if (model.isNecessary.intValue == 0) {
            if (model.fieldUnit.length > 0) {//带单位
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:model.fieldMeaning withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:model.fieldUnit];
                if ([model.fieldUnit isEqualToString:@"万元"]) {
                    self.inputView.inputTextFeild.width = ZSWIDTH-160-15-30;
                }
            }
            else{
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:model.fieldMeaning withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad];
            }
        }
        else {
            if (model.fieldUnit.length > 0) {
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning] withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad withElement:model.fieldUnit];
            }
            else{
                self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withInputAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning] withRightTitle:KPlaceholderInput withKeyboardType:UIKeyboardTypeDecimalPad];
            }
        }
    }
    //选择框
    else if (model.fieldType.intValue == 5 || model.fieldType.intValue == 6)
    {
        //非必填
        if (model.isNecessary.intValue == 0) {
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:model.fieldMeaning];
        }
        else {//必填
            self.inputView = [[ZSInputOrSelectView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, CellHeight) withClickAction:[NSString stringWithFormat:@"%@ *",model.fieldMeaning]];
        }
    }
    
#pragma mark 特殊类型处理
    if ([model.fieldMeaning isEqualToString:@"身份证号"]) {
        self.inputView.inputTextFeild.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([model.fieldMeaning isEqualToString:@"手机号"]) {
        self.inputView.inputTextFeild.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([model.fieldMeaning containsString:@"年限"]) {
        self.inputView.inputTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([model.fieldMeaning containsString:@"户口本"] || [model.fieldMeaning containsString:@"央行征信报告"]) {
        self.inputView.rightLabel.text = @"待上传";
    }
    
#pragma mark 右边的数据
    if (model.rightData.length > 0)
    {
        if (self.inputView.inputTextFeild) {
            self.inputView.inputTextFeild.text = SafeStr(model.rightData);
            self.inputView.inputTextFeild.textColor = ZSColorListRight;
        }
        else
        {
            self.inputView.rightLabel.text = SafeStr(model.rightData);
            self.inputView.rightLabel.textColor = ZSColorListRight;
            if ([model.fieldMeaning containsString:@"户口本"] || [model.fieldMeaning containsString:@"央行征信报告"]) {
                self.inputView.rightLabel.text = @"已上传";
                self.photoUrl = model.rightData;
            }
            if ([model.fieldMeaning containsString:@"楼盘地址"]) {
                self.addressID = model.addressID;
            }
        }
    }
    self.inputView.delegate = self;
    self.inputView.inputTextFeild.delegate = self;
    [self addSubview:self.inputView];
}

#pragma mark /*----------------------------------------点击"请选择"按钮响应的方法--------------------------------*/
#pragma mark ZSInputOrSelectViewDelegate
- (void)clickBtnAction:(ZSInputOrSelectView *)view;
{
    //键盘回收
    [NOTI_CENTER postNotificationName:@"hideKeyboard" object:nil];
    
    //婚姻状况
    if ([_model.fieldMeaning containsString:@"婚姻状况"])
    {
        ZSActionSheetView *actionSheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:[ZSGlobalModel getMarrayStateArray]];
        actionSheet.delegate = self;
        [actionSheet show:[[ZSGlobalModel getMarrayStateArray] count]];
    }
    //户口本,央行征信报告
    else if ([self.inputView.leftLabel.text containsString:@"户口本"] || [self.inputView.leftLabel.text containsString:@"央行征信报告"])
    {
        ZSAddResourceViewController *addVC = [[ZSAddResourceViewController alloc]init];
        addVC.titleString = self.inputView.leftLabel.text;
        addVC.addDataStyle = [self.inputView.leftLabel.text containsString:@"户口本"] ? ZSAddResourceDataTwo :ZSAddResourceDataCountless;
        addVC.photoUrl = self.photoUrl ? self.photoUrl : @"";//传递当前存在的图片url
        [[ZSTool getCurrentVCWithCurrentView:self].navigationController pushViewController:addVC animated:YES];
        //上传照片后返回的数据
        __weak typeof(self) weakSelf = self;
        addVC.phototBlock = ^(NSString *photoUrl) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
                [weakSelf.delegate sendCurrentCellData:photoUrl withIndex:(long)weakSelf.currentIndex];
            }
        };
    }
    //房屋功能
    else if ([_model.fieldMeaning containsString:@"房屋功能"])
    {
        ZSActionSheetView *actionSheet = [[ZSActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT) withArray:[ZSGlobalModel getHousingFunctionArray]];
        actionSheet.delegate = self;
        [actionSheet show:[[ZSGlobalModel getHousingFunctionArray] count]];
    }
    //楼盘地址
    else if ([_model.fieldMeaning containsString:@"楼盘地址"])
    {
        ZSProvincesPopView *provincesView = [[ZSProvincesPopView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, ZSHEIGHT_PopupWindow)];
        provincesView.addressID = self.addressID ? self.addressID : @"";//当前存在的省市区,用于修改地址时展示
        provincesView.addressName = _model.rightData.length ? _model.rightData :  nil;
        [provincesView show];
        //省市区页返回的数据
        __block NSString *stringName;
        __block NSString *stringID;
        __weak typeof(self) weakSelf = self;
        provincesView.addressArray = ^(NSArray * _Nonnull modelArray)
        {
            for (ZSProvinceModel *model in modelArray) {
                stringName = stringName.length ? [NSString stringWithFormat:@"%@ %@",stringName,model.name] : [NSString stringWithFormat:@"%@",model.name];
                stringID = stringID.length ? [NSString stringWithFormat:@"%@-%@",stringID,model.ID] : [NSString stringWithFormat:@"%@",model.ID];
            }
            self.addressID = stringID;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
                [weakSelf.delegate sendCurrentCellData:stringName withIndex:(long)weakSelf.currentIndex];
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCurrentCellID:withIndex:)]){
                [weakSelf.delegate sendCurrentCellID:stringID withIndex:(long)weakSelf.currentIndex];
            }
        };
    }
    //所在城市
    else if ([_model.fieldMeaning containsString:@"所在城市"])
    {
        ZSPositionViewController *chooesVC = [[ZSPositionViewController alloc]init];
        chooesVC.isFromCreateOrder = YES;
        [[ZSTool getCurrentVCWithCurrentView:self].navigationController pushViewController:chooesVC animated:YES];
        //选择城市返回的数据
        __weak typeof(self) weakSelf = self;
        chooesVC.postionBlock = ^(NSString *cityName) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
                [weakSelf.delegate sendCurrentCellData:cityName withIndex:(long)weakSelf.currentIndex];
            }
        };
        chooesVC.cityIDBlock = ^(NSString *cityID) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendCurrentCellID:withIndex:)]){
                [weakSelf.delegate sendCurrentCellID:cityID withIndex:(long)weakSelf.currentIndex];
            }
        };
    }
}

#pragma mark ZSActionSheetViewDelegate
- (void)SheetView:(ZSActionSheetView *)sheetView btnClick:(NSInteger)tag;
{
    //婚姻状况
    if ([self.inputView.leftLabel.text containsString:@"婚姻状况"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
            [self.delegate sendCurrentCellData:[ZSGlobalModel getMarrayStateArray][tag] withIndex:(long)self.currentIndex];
        }
    }
    //房屋功能
    else if ([self.inputView.leftLabel.text containsString:@"房屋功能"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
            [self.delegate sendCurrentCellData:[ZSGlobalModel getHousingFunctionArray][tag] withIndex:(long)self.currentIndex];
        }
    }
}

#pragma mark /*--------------------------------------UITextFieldDelegate----------------------------------------*/
#pragma mark 当文本输入框已经停止编辑的时候会调用这个方法
//两种停止编辑的情况:1.放弃第一响应者  2.点击了其他的输入框
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendCurrentCellData:withIndex:)]){
        [self.delegate sendCurrentCellData:textField.text withIndex:(long)self.currentIndex];
    }
}

#pragma mark textField--限制输入的字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"]){ return YES;}
    //限制输入表情
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([ZSTool isNineKeyBoard:string] ){
        return YES;
    }else{
        //限制输入表情
        if ([ZSTool stringContainsEmoji:string]) {
            return NO;
        }
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
    if ([self.inputView.leftLabel.text containsString:@"身份证号"])
    {
        if ([toBeString length] > 18) {
            textField.text = [toBeString substringToIndex:18];
            return NO;
        }
    }
    else if ([self.inputView.leftLabel.text containsString:@"手机号"])
    {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    else if ([self.inputView.leftLabel.text containsString:@"面积"])//面积类的0-10000m²,最多两位小数
    {
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"10000.00" alert:YES]){
            [ZSTool showMessage:@"超过最大限制了!" withDuration:DefaultDuration];
            return NO;
        }
        if ([toBeString length] > 8) {
            textField.text = [toBeString substringToIndex:8];
            return NO;
        }
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    else if ([self.inputView.leftLabel.text containsString:@"金额"]
             || [self.inputView.leftLabel.text containsString:@"总价"])//金额类的0-100000000元,最多两位小数
    {
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:KMaxAmount alert:YES]){
            [ZSTool showMessage:@"金额太大了!" withDuration:DefaultDuration];
            return NO;
        }
        if ([toBeString length] > 12) {
            textField.text = [toBeString substringToIndex:12];
            return NO;
        }
        return [textField checkTextField:textField WithString:string Range:range numInt:2];
    }
    else if ([self.inputView.leftLabel.text containsString:@"年限"])//年限类的0-100年
    {
        if ([ZSTool checkMaxNumWithInputNum:toBeString MaxNum:@"100" alert:YES]){
            [ZSTool showMessage:@"年份超过最大限制了!" withDuration:DefaultDuration];
            return NO;
        }
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:3];
            return NO;
        }
    }
    else
    {
        NSString *currentString = textField.text;
        NSString *currentLang = [[textField textInputMode] primaryLanguage];// 键盘输入模式
        //中文输入法下,只对已输入完成的文字进行字数统计和限制
        if ([currentLang isEqualToString:@"zh-Hans"] == YES)// 简体中文输入，包括简体拼音，健体五笔，简体手写
        {
            UITextRange *markedRange = [textField markedTextRange];
            UITextPosition *markedPosition = [textField positionFromPosition:markedRange.start offset:0];
            if (!markedPosition)
            {
                if (currentString.length > LengthLimitDefault) {
                    textField.text = [currentString substringToIndex:LengthLimitDefault];
                }
            }
        }
        else
        {
            if (currentString.length > LengthLimitDefault) {
                textField.text = [currentString substringToIndex:LengthLimitDefault];
            }
        }
    }

    return YES;
}

@end
