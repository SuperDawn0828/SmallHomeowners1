//
//  ZSWSFileCollectionModel.m
//  ZSMoneytocar
//
//  Created by 武 on 2017/5/22.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSWSFileCollectionModel.h"

@implementation ZSWSFileCollectionModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"spdDocInfoVos" : [SpdDocInfoVos class],
             @"propitems"    : [Propitems class],
             };
}
@end



@implementation Propitems
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"fileList" : [ZSWSFileCollectionModel class],
             @"itemtitle" : [Itemtitle class],
             };
}
@end



@implementation FileList

@end



@implementation Itemtitle

@end



@implementation SpdDocInfoVos

@end
