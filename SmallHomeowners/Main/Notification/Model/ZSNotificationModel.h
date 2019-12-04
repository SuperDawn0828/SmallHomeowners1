//
//  ZSNotificationModel.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSNotificationModel : NSObject
@property(nonatomic,copy) NSString *tid;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *serialNo;
@property(nonatomic,copy) NSString *title;        //消息标题
@property(nonatomic,copy) NSString *content;      //消息内容
@property(nonatomic,copy) NSString *msgStatus;
@property(nonatomic,copy) NSString *createDate;   //消息创建时间
@property(nonatomic,copy) NSString *prdType;      //产品类型
@property(nonatomic,copy) NSString *orderState;   //订单状态(文字)
@end
