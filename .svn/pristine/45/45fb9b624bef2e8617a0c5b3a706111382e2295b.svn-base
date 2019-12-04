//
//  ZSRequestManager.h
//  ZSMoneytocar
//
//  Created by 武 on 16/8/3.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Block)(NSDictionary * dic);
typedef void (^SuccessBlock)(NSDictionary *dic);
typedef void (^ErrorBlock)(NSError *error);

@interface ZSRequestManager : NSObject

@property (nonatomic, copy)  Block block;

+ (ZSRequestManager*)shareManager;

#pragma mark http异步请求
+(void)requestWithParameter:(NSMutableDictionary*)parameter
                        url:(NSString*)url
               SuccessBlock:(SuccessBlock)successBlock
                 ErrorBlock:(ErrorBlock)errorBlock;

#pragma mark ios原生方法上传图片(直传ZImg服务器)
+ (void)uploadImageWithNativeAPI:(NSData *)data
                    SuccessBlock:(SuccessBlock)successBlock
                      ErrorBlock:(ErrorBlock)errorBlock;
@end
