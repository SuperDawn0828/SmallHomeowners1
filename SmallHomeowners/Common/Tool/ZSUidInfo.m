//
//  ZSUidInfo.m
//  ZSMoneytocar
//
//  Created by cong on 16/7/26.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSUidInfo.h"

@implementation ZSUidInfo

#pragma mark 初始化
+ (ZSUidInfo *)shareInfo
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//编码方法，当对象被编码成二进制数据时调用。
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //在编码方法中，需要对对象的每一个属性进行编码。
    [aCoder encodeObject:_createDate                  forKey:@"createDate"];
    [aCoder encodeObject:_lastVisitTime               forKey:@"lastVisitTime"];
    [aCoder encodeObject:_state                       forKey:@"state"];
    [aCoder encodeObject:_tid                         forKey:@"tid"];
    [aCoder encodeObject:_updateDate                  forKey:@"updateDate"];
    [aCoder encodeObject:_userid                      forKey:@"userid"];
    [aCoder encodeObject:_username                    forKey:@"username"];
    [aCoder encodeObject:_version                     forKey:@"version"];
    [aCoder encodeObject:_userType                    forKey:@"userType"];
    [aCoder encodeObject:_authState                   forKey:@"authState"];
    [aCoder encodeObject:_headPhoto                   forKey:@"headPhoto"];
    [aCoder encodeObject:_telphone                    forKey:@"telphone"];
    [aCoder encodeObject:_visitingCard                forKey:@"visitingCard"];
    [aCoder encodeObject:_company                     forKey:@"company"];
    [aCoder encodeObject:_position                    forKey:@"position"];
    [aCoder encodeObject:_city                        forKey:@"city"];
    [aCoder encodeObject:_cityId                      forKey:@"cityId"];
    [aCoder encodeObject:_customerManager             forKey:@"customerManager"];
    [aCoder encodeObject:_customerManagerName         forKey:@"customerManagerName"];
    [aCoder encodeObject:_customerManagerPhone        forKey:@"customerManagerPhone"];
}

//解码方法，当把二进制数据转成对象时调用。
- (id)initWithCoder:(NSCoder *)aDecoder
{
    //如果父类也遵守NSCoding协议，那么需要写self = [super initWithCoder]
    self = [super init];
    if (self) {
        _createDate           = [aDecoder decodeObjectForKey:@"createDate"];
        _lastVisitTime        = [aDecoder decodeObjectForKey:@"lastVisitTime"];
        _state                = [aDecoder decodeObjectForKey:@"state"];
        _tid                  = [aDecoder decodeObjectForKey:@"tid"];
        _updateDate           = [aDecoder decodeObjectForKey:@"updateDate"];
        _userid               = [aDecoder decodeObjectForKey:@"userid"];
        _username             = [aDecoder decodeObjectForKey:@"username"];
        _version              = [aDecoder decodeObjectForKey:@"version"];
        _userType             = [aDecoder decodeObjectForKey:@"userType"];
        _authState            = [aDecoder decodeObjectForKey:@"authState"];
        _headPhoto            = [aDecoder decodeObjectForKey:@"headPhoto"];
        _telphone             = [aDecoder decodeObjectForKey:@"telphone"];
        _visitingCard         = [aDecoder decodeObjectForKey:@"visitingCard"];
        _company              = [aDecoder decodeObjectForKey:@"company"];
        _position             = [aDecoder decodeObjectForKey:@"position"];
        _city                 = [aDecoder decodeObjectForKey:@"city"];
        _cityId               = [aDecoder decodeObjectForKey:@"cityId"];
        _customerManager      = [aDecoder decodeObjectForKey:@"customerManager"];
        _customerManagerName  = [aDecoder decodeObjectForKey:@"customerManagerName"];
        _customerManagerPhone = [aDecoder decodeObjectForKey:@"customerManagerPhone"];
    }
    return self;
}

#pragma mark 根据角色状态码获取角色类型
+ (NSString *)getRoleType:(NSString *)typeCode
{
    if (typeCode.intValue == 5) {
        return @"中介";
    }
    else {
        return @"个人";
    }
}

#pragma mark 根据认证状态码获取认证状态
+ (NSString *)getAuthState:(NSString *)stateCode
{
    if (stateCode.intValue == 0) {
        return @"未认证";
    }
    else if (stateCode.intValue == 1) {
        return @"认证中";
    }
    else if (stateCode.intValue == 2) {
        return @"认证通过";
    }
    else if (stateCode.intValue == 3) {
        return @"认证失败";
    }
    else{
        return @"认证过期失效";
    }
}

@end
