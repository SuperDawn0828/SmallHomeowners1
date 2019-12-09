//
//  ZSUidInfo.h
//  ZSMoneytocar
//
//  Created by cong on 16/7/26.
//  Copyright © 2016年 Wu. All rights reserved.
//  当前登录用户的信息

#import <Foundation/Foundation.h>

@interface ZSUidInfo : NSObject<NSCoding>

@property(nonatomic,copy )NSString *createDate;
@property(nonatomic,copy )NSString *lastVisitTime;
@property(nonatomic,copy )NSString *state;
@property(nonatomic,copy )NSString *tid;              //用户id
@property(nonatomic,copy )NSString *updateDate;
@property(nonatomic,copy )NSString *userid;           //用户名(登录的账号)
@property(nonatomic,copy )NSString *username;         //真实姓名
@property(nonatomic,copy )NSString *version;
@property(nonatomic,copy )NSString *userType;         //用户类型 1中介 2个人
@property(nonatomic,copy )NSString *authState;        //资质认证状态 0未认证 1认证中 2认证通过 3认证失败 4认证过期失效
@property(nonatomic,copy )NSString *headPhoto;        //头像
@property(nonatomic,copy )NSString *telphone;         //手机号
@property(nonatomic,copy )NSString *visitingCard;     //名片url
@property(nonatomic,copy )NSString *company;          //手机号
@property(nonatomic,copy )NSString *position;         //职位
@property(nonatomic,copy )NSString *city;             //所在城市
@property(nonatomic,copy )NSString *cityId;           //所在城市id
@property(nonatomic,copy )NSString *customerManager;     //专属客户经理id
@property(nonatomic,copy )NSString *customerManagerName; //专属客户经理姓名
@property(nonatomic,copy )NSString *customerManagerPhone;//专属客户经理电话
@property (nonatomic, copy) NSString *identityNo;          //身份证号

+ (ZSUidInfo *)shareInfo;

#pragma mark 根据角色状态码获取角色类型
+ (NSString *)getRoleType:(NSString *)typeCode;

#pragma mark 根据认证状态码获取认证状态
+ (NSString *)getAuthState:(NSString *)stateCode;

@end
