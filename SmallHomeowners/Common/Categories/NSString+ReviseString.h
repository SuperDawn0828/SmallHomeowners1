//
//  NSString+ReviseString.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/25.
//  Copyright © 2018年 maven. All rights reserved.
//  对于数据做处理

#import <Foundation/Foundation.h>

@interface NSString (ReviseString)

#pragma mark 数据处理(默认两位小数)
+ (NSString *)ReviseString:(NSString *)string;

#pragma mark 数据处理(自定义小数位数)
+ (NSString *)ReviseString:(NSString *)string WithDigits:(NSInteger)count;

#pragma mark 字典转字符串
+ (NSString *)dictoryToString:(id)theData;

#pragma mark 字符串转字典
+ (NSDictionary *)stringToDictory:(NSString *)jsonString;

#pragma makr 获取当前时间
+ (NSString *)getCurrentTimes;

@end
