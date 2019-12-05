//
//  ZSGlobalModel.h
//  ZSMoneytocar
//
//  Created by 武 on 2016/10/13.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZSDynamicDataModel.h"
#import "ZSProvinceModel.h"
#import "ZSPCOrderDetailModel.h"

#pragma mark 服务器地址
//测试服务器
static NSString *const KTestServerUrl             = @"http://120.79.255.107:6083/house-agent-api";
static NSString *const KTestServerImgUrl          = @"http://test.xiaofangzhu.com:4869/";
static NSString *const KTestServerImgUploadUrl    = @"http://120.79.255.107:4869/upload";//图片上传地址
//预生产服务器(带端口号)
static NSString *const KPreProductionUrl          = @"http://www.xiaofangzhu.com:8083/house-agent-api";
static NSString *const KPreProductionUrl_port     = @"http://39.108.66.81:8083/house-agent-api";
static NSString *const KPreProductionImgUrl       = @"http://39.108.66.81:4869/";
static NSString *const KPreProductionImgUploadUrl = @"http://39.108.66.81:4869/upload";//图片上传地址(预生产和生产一样)
//正式服务器(不带端口号)
static NSString *const KFormalServerUrl           = @"http://www.xiaofangzhu.com/house-agent-api";
static NSString *const KFormalServerUrl_port      = @"http://39.108.66.81/house-agent-api";
static NSString *const KFormalServerImgUrl        = @"http://39.108.66.81:4869/";


#pragma mark 无数据
typedef NS_ENUM(NSUInteger, ZSErrorStyle)
{
    ZSErrorWithoutOrder = 0,          //订单列表无订单
    ZSErrorWithoutNoti,               //消息列表无数据
//    ZSErrorWithoutNetworkPermission,  //网络未授权
    ZSErrorWithoutNetwork,            //网络断开连接
    ZSErrorWithoutHomePage,           //首页无数据
};

static NSString *const KErrorWithoutOrder = @"快去创建第一笔订单吧 >>";
static NSString *const KErrorWithoutNoti = @"暂无消息";
//static NSString *const KErrorWithoutNetworkPermission = @"无法连接网络，点击去授权 >>";
static NSString *const KErrorWithoutNetwork = @"网络跑丢了，点击屏幕重试";
static NSString *const KErrorWithoutHomePageData = @"哎呀请求失败了, 点击屏幕重试";

#pragma mark 添加资料样式
typedef NS_ENUM(NSUInteger, ZSAddResourceDataStyle)
{
    ZSAddResourceDataOne = 0, //每种细分资料只能添加一张照片
    ZSAddResourceDataTwo,     //每种细分资料只能添加两张照片
    ZSAddResourceDataCountless,   //每种细分资料能添加无数张照片
};

#pragma mark 创建订单页面类型
typedef NS_ENUM(NSUInteger, ZSPersonInfoType)
{
    ZSFromCreateOrderWithAdd = 0,   //创建订单
    ZSFromExistingOrderWithAdd,     //现有订单新增人员信息
    ZSFromExistingOrderWithEditor,  //现有订单编辑人员信息
    ZSFromOrderList,                //订单列表过来,或者通知列表
};

#pragma mark 缓存路径
static NSString *KCurrentUserInfo       = @"Documents/userInfo.plist";            //当前登录用户的信息
static NSString *KAllListSearch         = @"Documents/allListSearch.text";        //主首页订单列表搜索

#pragma mark 默认提示
static NSString *KPlaceholderChoose = @"请选择";
static NSString *KPlaceholderInput  = @"请输入";
static NSString *KMaxAmount         = @"100000000.00";

#pragma mark 产品类型
static NSString *const kProduceTypeWitnessServer             = @"1001";            //新房见证
static NSString *const kProduceTypeRedeemFloor               = @"1080";            //赎楼宝
static NSString *const kProduceTypeStarLoan                  = @"1081";            //星速贷
static NSString *const kProduceTypeMortgageLoan              = @"1084";            //抵押贷
static NSString *const kProduceTypeCarHire                   = @"1083";            //车位分期
static NSString *const kProduceTypeAgencyBusiness            = @"1085";            //代办业务
static NSString *const kProduceTypeEasyLoans                 = @"0000";            //容易贷

#pragma mark 通知名称
static NSString *const KgotoCreateOrderNoti                            = @"KgotoCreateOrderNoti";                //显示创建订单的弹窗
static NSString *const KgotoCreateOrderViewCtrlNoti                    = @"KgotoCreateOrderViewCtrlNoti";        //跳转到创建订单页面
static NSString *const KuploadPhotoWithTimeout                         = @"uploadPhotoWithTimeout";              //图片上传超时
static NSString *const KSCheckNoitfication                             = @"checkNoitfication";                   //是否开启推送
static NSString *const KSSendUserAliasToJpush                          = @"sendUserAliasToJpush";                //登录成功后把用户的tid发送给极光,作为用户的alias
static NSString *const KClearUserAliasToJpush                          = @"clearUserAliasToJpush";               //退出时清空推送别名
static NSString *const KSCheckVerisonUpdate                            = @"checkVerisonUpdate";                  //检测版本更新
static NSString *const KSChekTokenState                                = @"chekTokenState";                      //token失效提醒
static NSString *const KSUpdateAllOrderListNotification                = @"KSUpdateAllOrderListNotification";    //所有订单列表
static NSString *const KSUpdateAllOrderDetailNotification              = @"KSUpdateAllOrderDetailNotification";  //订单详情
static NSString *const KSUpdateNotiList                                = @"KSUpdateNotiList";                    //通知列表
static NSString *const KToReposition                                   = @"KToReposition";                       //重新定位
static NSString *const KcheckNetWorkPermissionNoti                     = @"KcheckNetWorkPermissionNoti";         //检查网络授权状况
static NSString *const KRequestNetwork                                 = @"KRequestNetwork";                     //未联网重新请求接口
static NSString *const KUpdateHomePageData                             = @"KUpdateHomePageData";                 //请求刷新首页

#pragma mark 数据模型
@interface ZSGlobalModel : NSObject

@property (nonatomic,assign)long netStatus; //联网状态 0没网

@property (nonatomic,copy  )NSString             *prdType;            //当前产品类型
@property (nonatomic,strong)NSArray              *productArray;       //可创建的产品list
@property (nonatomic,strong)ZSProvinceModel      *provinceModel;      //省市区model
@property (nonatomic,strong)ZSPCOrderDetailModel *pcOrderDetailModel; //订单详情model
@property (nonatomic,strong)CustomersModel       *currentCustomer;    //人员信息model
@property (nonatomic,strong)OrderModel           *currentOrder;       //订单信息model


+ (ZSGlobalModel*)shareInfo;

#pragma mark 预生产环境下为了审核, 所有"贷款"字段改成"订单"
+ (NSString *)changeLoanString:(NSString *)string;

#pragma mark 产品类型 1081星速贷 1080赎楼宝 1084抵押贷 1083车位分期
+ (NSString *)getProductStateWithCode:(NSString *)product;
+ (NSString *)getProductCodeWithState:(NSString *)product;

#pragma mark 婚姻状况 1未婚 2已婚 3离异 4丧偶
+ (NSArray *)getMarrayStateArray;
+ (NSString *)getMarrayStateWithCode:(NSString *)beMarrage;
+ (NSString *)getMarrayCodeWithState:(NSString *)beMarrage;

#pragma mark 人员角色 1本人(贷款人) 2配偶(贷款人配偶) 3配偶&共有人 4共有人 5担保人 6担保人配偶 7卖方 8卖方配偶
+ (NSString *)getReleationStateWithCode:(NSString *)releation;
+ (NSString *)getReleationCodeWithState:(NSString *)releation;

#pragma mark 是否可贷 1可贷 2不可贷
+ (NSString *)getCanLoanStateWithCode:(NSString *)canLoan;
+ (NSString *)getCanLoanCodeWithState:(NSString *)canLoan;

#pragma mark 用户资质 1A类 2B类 3C类
+ (NSString *)getCustomerQualificationStateWithCode:(NSString *)custQualification;
+ (NSString *)getCustomerQualificationCodeWithState:(NSString *)custQualification;

#pragma mark 房屋状况
+ (NSArray *)getHousingFunctionArray;

#pragma mark 首页产品简介图
+ (NSArray *)getHomeProductImgArray;

#pragma mark 首页产品详情图
+ (NSArray *)getHomeProductDetailImgArray;

#pragma mark 判断订单是否是信息录入中的状态
+ (BOOL)orderStateIsInTheInformationRecorded;

@end
