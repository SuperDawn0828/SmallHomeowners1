//
//  ZSGlobalModel.m
//  ZSMoneytocar
//
//  Created by 武 on 2016/10/13.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSGlobalModel.h"

@implementation ZSGlobalModel

+ (ZSGlobalModel*)shareInfo
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark 预生产环境下为了审核, 所有"贷款"字段改成"订单"
+ (NSString *)changeLoanString:(NSString *)string
{
    NSString *newString;
    if ([APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl] || [APPDELEGATE.zsurlHead isEqualToString:KPreProductionUrl_port])
    {
        if ([string containsString:@"贷款"]) {
            newString = [string stringByReplacingOccurrencesOfString:@"贷款" withString:@"订单"];
        }
        else if ([string containsString:@"贷"]) {
            newString = [string stringByReplacingOccurrencesOfString:@"贷" withString:@"单"];
        }
        else
        {
            newString = string;
        }
    }
    else
    {
        newString = string;
    }
    return newString;
}

#pragma mark 产品类型 1081星速贷 1080赎楼宝 1084抵押贷 1083车位分期
+ (NSString *)getProductStateWithCode:(NSString *)product
{
    if ([product isEqualToString:kProduceTypeStarLoan])
    {
        return [ZSGlobalModel changeLoanString:@"星速贷"];
    }
    else if ([product isEqualToString:kProduceTypeRedeemFloor])
    {
        return @"赎楼宝";
    }
    else if ([product isEqualToString:kProduceTypeMortgageLoan])
    {
        return [ZSGlobalModel changeLoanString:@"抵押贷"];
    }
    else if ([product isEqualToString:kProduceTypeCarHire])
    {
        return @"车位分期";
    }
    else if ([product isEqualToString:kProduceTypeAgencyBusiness])
    {
        return @"代办业务";
    }
    else
    {
        return @"安居贷";
    }
}

+ (NSString *)getProductCodeWithState:(NSString *)product
{
    if ([product isEqualToString:[ZSGlobalModel changeLoanString:@"星速贷"]]) {
        return kProduceTypeStarLoan;
    }
    else if ([product isEqualToString:@"赎楼宝"]) {
        return kProduceTypeRedeemFloor;
    }
    else if ([product isEqualToString:@"抵押贷"]) {
        return kProduceTypeMortgageLoan;
    }
    else if ([product isEqualToString:@"车位分期"]) {
        return kProduceTypeCarHire;
    }
    else if ([product isEqualToString:@"代办业务"]) {
        return kProduceTypeAgencyBusiness;
    }
    else
    {
        return kProduceTypeEasyLoans;
    }
}

#pragma mark 婚姻状况 1未婚 2已婚 3离异 4丧偶
+ (NSArray *)getMarrayStateArray
{
    return @[@"未婚",@"已婚",@"离异",@"丧偶"];
}

+ (NSString *)getMarrayStateWithCode:(NSString *)beMarrage
{
    if (beMarrage.intValue == 1) {
        return @"未婚";
    }
    else if (beMarrage.intValue == 2) {
        return @"已婚";
    }
    else if (beMarrage.intValue == 3) {
        return @"离异";
    }
    else{
        return @"丧偶";
    }
}

+ (NSString *)getMarrayCodeWithState:(NSString *)beMarrage
{
    if ([beMarrage isEqualToString:@"未婚"]) {
        return @"1";
    }
    else if ([beMarrage isEqualToString:@"已婚"]) {
        return @"2";
    }
    else if ([beMarrage isEqualToString:@"离异"]) {
        return @"3";
    }
    else{
        return @"4";
    }
}

#pragma mark 人员角色 1本人(贷款人) 2配偶(贷款人配偶) 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶
+ (NSString *)getReleationStateWithCode:(NSString *)releation
{
    if (releation.intValue == 1) {
        return [ZSGlobalModel changeLoanString:@"贷款人"];
    }
    else if (releation.intValue == 2) {
        return [NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]];
    }
    else if (releation.intValue == 3 || releation.intValue == 4) {
        return @"共有人";
    }
    else if (releation.intValue == 5) {
        return @"担保人";
    }
    else if (releation.intValue == 6) {
        return @"担保人配偶";
    }
    else if (releation.intValue == 7) {
        return @"卖方";
    }
    else{
        return @"卖方配偶";
    }
}

+ (NSString *)getReleationCodeWithState:(NSString *)releation
{
    if ([releation isEqualToString:[ZSGlobalModel changeLoanString:@"贷款人"]] ||
        [releation isEqualToString:[NSString stringWithFormat:@"%@信息",[ZSGlobalModel changeLoanString:@"贷款人"]]]) {
        return @"1";
    }
    else if ([releation isEqualToString:[NSString stringWithFormat:@"%@配偶",[ZSGlobalModel changeLoanString:@"贷款人"]]] ||
             [releation isEqualToString:[NSString stringWithFormat:@"%@配偶信息",[ZSGlobalModel changeLoanString:@"贷款人"]]]) {
        return @"2";
    }
    else if ([releation isEqualToString:@"共有人"] || [releation isEqualToString:@"共有人信息"]) {
        return @"4";
    }
    else if ([releation isEqualToString:@"担保人"] || [releation isEqualToString:@"担保人信息"]) {
        return @"5";
    }
    else if ([releation isEqualToString:@"担保人配偶"] || [releation isEqualToString:@"担保人配偶信息"]) {
        return @"6";
    }
    else if ([releation isEqualToString:@"卖方"] || [releation isEqualToString:@"卖方信息"]) {
        return @"7";
    }
    else{
        return @"8";
    }
}

#pragma mark 是否可贷 1可贷 2不可贷
+ (NSString *)getCanLoanStateWithCode:(NSString *)canLoan
{
    if (canLoan.intValue == 1) {
        return @"可贷";
    }
    else{
        return @"不可贷";
    }
}

+ (NSString *)getCanLoanCodeWithState:(NSString *)canLoan
{
    if ([canLoan isEqualToString:@"可贷"]) {
        return @"1";
    }
    else{
        return @"2";
    }
}

#pragma mark 用户资质 1A类 2B类 3C类
+ (NSString *)getCustomerQualificationStateWithCode:(NSString *)custQualification
{
    if (custQualification.intValue == 1) {
        return @"A类";
    }
    else if (custQualification.intValue == 2) {
        return @"B类";
    }
    else if (custQualification.intValue == 3) {
        return @"C类";
    }
    else {
        return @"D类";
    }
}

+ (NSString *)getCustomerQualificationCodeWithState:(NSString *)custQualification
{
    if ([custQualification isEqualToString:@"A"] || [custQualification isEqualToString:@"A类"]) {
        return @"1";
    }
    else if ([custQualification isEqualToString:@"B"] || [custQualification isEqualToString:@"B类"]) {
        return @"2";
    }
    else if ([custQualification isEqualToString:@"C"] || [custQualification isEqualToString:@"C类"]) {
        return @"3";
    }
    else {
        return @"4";
    }
}

#pragma mark 房屋状况
+ (NSArray *)getHousingFunctionArray
{
    return @[@"住宅",@"商铺",@"车位",@"写字楼",@"公寓"];
}

#pragma mark 首页产品简介图
+ (NSArray *)getHomeProductImgArray
{
    return @[@"星速贷样式",@"抵押贷样式"];
}

#pragma mark 首页产品详情图
+ (NSArray *)getHomeProductDetailImgArray
{
    return @[@"星速贷详情",@"抵押贷详情"];
}

#pragma mark 判断订单是否是信息录入中的状态
+ (BOOL)orderStateIsInTheInformationRecorded
{
    if ([global.pcOrderDetailModel.order.orderState isEqualToString:@"信息录入中"])
    {
        return YES;
    }
    else {
        return NO;
    }
}


@end
