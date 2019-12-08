//
//  ZSURLManager.h
//  ZSMoneytocar
//
//  Created by 武 on 16/8/11.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSURLManager : NSObject

#pragma mark ********************************公共接口*******************************/
#pragma mark 获取接口地址
+(NSString*)getAppAccessURL;

#pragma mark 获取省份名称列表
+(NSString*)getProvincesList;

#pragma mark 获取城市名称列表
+(NSString*)getCitysList;

#pragma mark 获取区名称列表
+(NSString*)getAreasList;

#pragma mark 获取业务城市
+(NSString *)getOpenBusinessCity;

#pragma mark 版本更新
+(NSString *)getVersionUpdates;

#pragma mark ********************************多个产品通用*******************************/


#pragma mark ********************************个人相关*******************************/
#pragma mark 登录
+(NSString *)getLoginURL;

#pragma mark 注册
+(NSString *)getRegisteredURL;

#pragma mark 获取验证码
+(NSString *)getVerificationCode;

#pragma mark 验证验证码
+(NSString *)getVerificationCodeCompare;

#pragma mark 忘记密码重置密码
+(NSString *)getRsetPassword;

#pragma mark 修改密码
+(NSString *)getChangePassword;

#pragma mark 获取个人资料
+(NSString *)getUserInformation;

#pragma mark 修改个人资料
+(NSString *)getChangeUserInformation;

#pragma mark 提交资质认证
+(NSString *)getQualificationCertification;

#pragma mark 获取日签
+(NSString *)getDaySignUrl;

#pragma mark ********************************首页*******************************/
#pragma mark 获取首页轮播图
+(NSString *)getHomeCarousels;

#pragma mark 获取首页工具类
+(NSString *)getHomeToolList;

#pragma mark 获取首页新闻
+(NSString *)getHomeNewsList;

#pragma mark ********************************订单*******************************/
#pragma mark 获取在线产品列表
+(NSString *)getOnlineProducts;

#pragma mark 上传照片之后识别
+(NSString *)getOcrRecognition;

#pragma mark 创建订单(新增/修改人员信息)
+(NSString *)getAddOrUpdateCustomer;

#pragma mark 删除人员信息
+(NSString *)getDeleteCustomer;

#pragma mark 编辑房产信息
+(NSString *)getUpdateHouseInfo;

#pragma mark 编辑贷款信息
+(NSString *)getUpdateMortgageInfo;

#pragma mark 提交预授信
+(NSString *)getApplyPrecredit;

#pragma mark 获取订单列表
+(NSString *)getOrderList;

#pragma mark 获取订单详情
+(NSString *)getAgentOrderDetail;

#pragma mark 获取预授信报告
+(NSString *)getAgentPrecredit;

#pragma mark 提交贷款
+(NSString *)getSubmitLoan;

#pragma 实名认证
+ (NSString *)updateUserIdentityNo;

#pragma mark 获取订单还款计划
+ (NSString *)getOrderRepayment;

#pragma mark ********************************消息*******************************/
#pragma mark 获取消息列表
+(NSString *)getNotifacationList;

@end
