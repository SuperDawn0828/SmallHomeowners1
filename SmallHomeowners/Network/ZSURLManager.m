//
//  ZSURLManager.m
//  ZSMoneytocar
//
//  Created by 武 on 16/8/11.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSURLManager.h"

@implementation ZSURLManager

#pragma mark****************************************************************公共接口***************************************************************/
#pragma mark 获取接口地址
+(NSString *)getAppAccessURL
{
    return [NSString stringWithFormat:@"%@/zs/baseData/getAppServicePath",APPDELEGATE.zsurlHead];
}

#pragma mark 版本更新
+(NSString *)getVersionUpdates
{
    return [NSString stringWithFormat:@"%@/zs/baseData/getVersionUpdate",APPDELEGATE.zsurlHead];
}

#pragma mark 获取省份名称列表
+(NSString *)getProvincesList
{
    return [NSString stringWithFormat:@"%@/zs/baseData/provinces",APPDELEGATE.zsurlHead];
}

#pragma mark 获取城市名称列表
+(NSString *)getCitysList
{
    return [NSString stringWithFormat:@"%@/zs/baseData/citys",APPDELEGATE.zsurlHead];
}

#pragma mark 获取区名称列表
+(NSString *)getAreasList
{
    return [NSString stringWithFormat:@"%@/zs/baseData/districts",APPDELEGATE.zsurlHead];
}

#pragma mark 获取业务城市
+(NSString *)getOpenBusinessCity
{
    return [NSString stringWithFormat:@"%@/zs/agentBizCity/getAgentBizCitys",APPDELEGATE.zsurlHead];
}

#pragma mark **************************************************************多个产品通用***************************************************************/


#pragma mark ****************************************************************个人相关***************************************************************/
#pragma mark 登录
+(NSString *)getLoginURL
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/login",APPDELEGATE.zsurlHead];
}

#pragma mark 注册
+(NSString *)getRegisteredURL
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/regist",APPDELEGATE.zsurlHead];
}

#pragma mark 获取验证码
+(NSString *)getVerificationCode
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/getValidateCode",APPDELEGATE.zsurlHead];
}

#pragma mark 验证验证码
+(NSString *)getVerificationCodeCompare
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/checkValidateCode",APPDELEGATE.zsurlHead];
}

#pragma mark 忘记密码重置密码
+(NSString *)getRsetPassword
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/resetPassword",APPDELEGATE.zsurlHead];
}

#pragma mark 修改密码
+(NSString *)getChangePassword
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/modifyPassword",APPDELEGATE.zsurlHead];
}

#pragma mark 获取个人资料
+(NSString *)getUserInformation
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/getPersonalInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 修改个人资料
+(NSString *)getChangeUserInformation
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/modifyPersonalInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 提交资质认证
+(NSString *)getQualificationCertification
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/submitAuth",APPDELEGATE.zsurlHead];
}

#pragma mark 获取日签
+(NSString *)getDaySignUrl
{
    return [NSString stringWithFormat:@"%@/zs/agentHomepageFunc/getDaySign",APPDELEGATE.zsurlHead];
}

#pragma 实名认证
+ (NSString *)updateUserIdentityNo
{
    return [NSString stringWithFormat:@"%@/zs/agentUser/updateUserIdentityNo",APPDELEGATE.zsurlHead];
}

#pragma mark **************************************************************首页***************************************************************/
#pragma mark 获取首页轮播图
+(NSString *)getHomeCarousels
{
    return [NSString stringWithFormat:@"%@/zs/carousel/getCarousels",APPDELEGATE.zsurlHead];
}

#pragma mark 获取首页工具类
+(NSString *)getHomeToolList
{
    return [NSString stringWithFormat:@"%@/zs/agentHomepageFunc/getAgentHomepageFuncs",APPDELEGATE.zsurlHead];
}

#pragma mark 获取首页新闻
+(NSString *)getHomeNewsList
{
    return [NSString stringWithFormat:@"%@/zs/agentHomepageFunc/getCaptureNews",APPDELEGATE.zsurlHead];
}

#pragma mark **************************************************************订单***************************************************************/
#pragma mark 获取在线产品列表
+(NSString *)getOnlineProducts
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/listOnlineProducts",APPDELEGATE.zsurlHead];
}

#pragma mark 上传照片之后识别
+(NSString *)getOcrRecognition;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/ocrRecognition",APPDELEGATE.zsurlHead];
}

#pragma mark 创建订单(新增/修改人员信息)
+(NSString *)getAddOrUpdateCustomer;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/addOrUpdateCustomer",APPDELEGATE.zsurlHead];
}

#pragma mark 删除人员信息
+(NSString *)getDeleteCustomer;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/deleteCustomer",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑房产信息
+(NSString *)getUpdateHouseInfo;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/updateHouseInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑贷款信息
+(NSString *)getUpdateMortgageInfo;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/updateMortgageInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 提交订单(预授信)
+(NSString *)getApplyPrecredit;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/applyPrecredit",APPDELEGATE.zsurlHead];
}

#pragma mark 获取订单列表
+(NSString *)getOrderList;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/listAgentOrders",APPDELEGATE.zsurlHead];
}

#pragma mark 获取订单详情
+(NSString *)getAgentOrderDetail;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/getAgentOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 获取预授信报告
+(NSString *)getAgentPrecredit;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/getAgentPrecredit",APPDELEGATE.zsurlHead];
}

#pragma mark 提交贷款
+(NSString *)getSubmitLoan;
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/submitLoan",APPDELEGATE.zsurlHead];
}

#pragma mark 获取订单还款计划
+ (NSString *)getOrderRepayment
{
    return [NSString stringWithFormat:@"%@/zs/agentOrder/getOrderRepayment", APPDELEGATE.zsurlHead];
}

#pragma mark **************************************************************消息***************************************************************/
#pragma mark 获取消息列表
+(NSString *)getNotifacationList
{
    return [NSString stringWithFormat:@"%@/zs/agentMsgNote/getMsgNotes",APPDELEGATE.zsurlHead];
}

@end
