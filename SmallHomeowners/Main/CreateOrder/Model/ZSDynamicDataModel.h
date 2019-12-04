//
//  ZSDynamicDataModel.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/3.
//  Copyright © 2018年 maven. All rights reserved.
//  输入框/请选择的cell需要的model

#import <Foundation/Foundation.h>
#import "ZSPCOrderDetailModel.h"

@interface ZSDynamicDataModel : NSObject

@property (nonatomic,copy )NSString *fieldMeaning;   //需要填写资料的资料名
@property (nonatomic,copy )NSString *fieldUnit;      //单位
@property (nonatomic,copy )NSString *isNecessary;    //是否是必填 0否 1是
@property (nonatomic,copy )NSString *fieldType;      //展示类型  1文本 2多行文本 3图片 4数字 5选择按钮',

//本地的数据
@property (nonatomic,copy  )NSString *rightData;     //右侧数据
@property (nonatomic,assign)CGFloat  cellHeight;     //高度
@property (nonatomic,strong)NSArray  *imageDataArray;//本地图片资源
@property (nonatomic,copy  )NSString *addressID;     //当前存在的省市区,用于修改地址时展示
@end
