//
//  ZSAllListModel.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/10.
//  Copyright © 2018年 maven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSAllListModel : NSObject
@property(nonatomic,copy)NSString *order_no;        //订单号
@property(nonatomic,copy)NSString *cust_no;         //人员id
@property(nonatomic,copy)NSString *prd_type;        //产品类型
@property(nonatomic,copy)NSString *cust_name;       //人员姓名
@property(nonatomic,copy)NSString *identity_no;     //人员身份证
@property(nonatomic,copy)NSString *create_date;     //订单创建时间
@property(nonatomic,copy)NSString *order_state;     //订单状态(文字)
@property(nonatomic,copy)NSString *tid;             //订单id
//@property(nonatomic,copy)NSString *remain_time;     //订单停留时间
//@property(nonatomic,copy)NSString *state_result;    //订单类型 0待处理 1已处理
//@property(nonatomic,copy)NSString *process_date;    //订单流转到当前节点的时间
//@property(nonatomic,copy)NSString *sign_date;       //订单审批时间
@end
