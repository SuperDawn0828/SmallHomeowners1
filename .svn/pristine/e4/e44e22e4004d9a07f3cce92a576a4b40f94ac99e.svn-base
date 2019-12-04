//
//  ZSPositionViewController.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/29.
//  Copyright © 2018年 maven. All rights reserved.
//  首页--定位

#import "ZSBaseViewController.h"

typedef void(^PositionBlock)(NSString *cityName);
typedef void(^CityIDBlock)(NSString *cityID);

@interface ZSPositionViewController : ZSBaseViewController
@property (nonatomic,strong) NSMutableArray         *dataArray;       //数据源(可从上个页面传递过来)
@property (nonatomic,copy  ) PositionBlock          postionBlock;     //选中的城市名block返回传值
@property (nonatomic,copy  ) CityIDBlock            cityIDBlock;      //选中的城市ID block返回传值
@property (nonatomic,assign) BOOL                   isFromCreateOrder;//编辑罚款信息的时候
@end
