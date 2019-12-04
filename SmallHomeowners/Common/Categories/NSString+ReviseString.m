//
//  NSString+ReviseString.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/25.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "NSString+ReviseString.h"

@implementation NSString (ReviseString)

#pragma mark 数据处理(默认两位小数)
+ (NSString *)ReviseString:(NSString *)string
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 2;//表示最多保留两位小数
        formatter.minimumIntegerDigits = 1;//表示最少保留一位整数,防止像0.01出现.01的情况
    });
    return [formatter stringFromNumber:[formatter numberFromString:string]];
}

#pragma mark 数据处理(自定义小数位数)
+ (NSString *)ReviseString:(NSString *)string WithDigits:(NSInteger)count
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = count;//表示最多保留几位小数
        formatter.minimumIntegerDigits = 1;//表示最少保留一位整数,防止像0.01出现.01的情况
    });
    return [formatter stringFromNumber:[formatter numberFromString:string]];
}

#pragma mark 字典转字符串
+ (NSString *)dictoryToString:(id)theData
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:0 error:&parseError];
    NSString *jsonSting=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonSting;
}

#pragma mark 字符串转字典
+ (NSDictionary *)stringToDictory:(NSString *)jsonString
{
    NSError *parseError = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
    return dic;
}

#pragma makr 获取当前时间
+ (NSString *)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

@end
