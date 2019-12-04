//
//  ZSRequestManager.m
//  ZSMoneytocar
//
//  Created by 武 on 16/8/3.
//  Copyright © 2016年 Wu. All rights reserved.
//
#import "ZSRequestManager.h"

#define Boundary @"tarena"
#define Encode(string) [string dataUsingEncoding:NSUTF8StringEncoding]
#define NewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
static NSTimeInterval TimeOut = 5.0f;//普通的

@interface ZSRequestManager()

@end

@implementation ZSRequestManager

+ (ZSRequestManager*)shareManager
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark http异步请求
+ (void)requestWithParameter:(NSMutableDictionary*)parameter
                         url:(NSString*)url
                SuccessBlock:(SuccessBlock)successBlock
                  ErrorBlock:(ErrorBlock)errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//请求数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//接收的数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    //固定入参
    if (parameter == nil) {
        parameter = @{}.mutableCopy;
    }
    [parameter setObject:@"ios" forKey:@"edition"];
    [parameter setObject:@"ios" forKey:@"deviceType"];
    //设置userID(没登录的情况下"signature"字段传"xiaofangzhu"即可绕过token验证)
    if ([ZSLogInManager readUserInfo].tid) {
        [parameter setObject:[ZSLogInManager readUserInfo].tid forKey:@"userId"];
        [parameter setObject:@"ios" forKey:@"signature"];
    }
    else {
        [parameter setObject:@"xiaofangzhu" forKey:@"userId"];
        [parameter setObject:@"xiaofangzhu" forKey:@"signature"];
    }
    //设置token
    NSString *token = [USER_DEFALT objectForKey:tokenForApp];
    if (token && token.length > 0) {
        [parameter setObject:token forKey:@"token"];
    }
    ZSLOG(@"请求的url==%@ 请求参parameter==%@",url,parameter);
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TimeOut;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
  
    //开始请求
    [manager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZSLOG(@"请求成功:%@",responseObject);
        NSString *respCode = [responseObject objectForKey:@"respCode"];
        if ([respCode intValue] == 1) {
            successBlock ([self removeNSNullObjectFromeData:responseObject]);//清除null
        }
        else
        {
            if ([[responseObject objectForKey:@"respMsg"]length] > 0) {
                //1.token校验不通过
                if ([[responseObject objectForKey:@"respMsg"] isEqualToString:@"token验证不通过"]) {
                    [NOTI_CENTER postNotificationName:KSChekTokenState object:nil];
                }
                else {
                    [ZSTool showMessage:[responseObject objectForKey:@"respMsg"] withDuration:DefaultDuration];
                }
            }
            
            //报异常的时候隐藏转圈按钮
            if (errorBlock){
                [MBProgressHUD hideLoadingView];
                [LSProgressHUD hide];
                errorBlock(nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZSLOG(@"请求失败:%@",error);
        if (global.netStatus == 0) {//0,没网
            [ZSTool showMessage:@"网络已断开,请稍后重试" withDuration:DefaultDuration];
        }
        errorBlock(error);
    }];
}

#pragma mark ios原生方法上传图片(直传ZImg服务器)
#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
+ (void)uploadImageWithNativeAPI:(NSData *)data
                    SuccessBlock:(SuccessBlock)successBlock
                      ErrorBlock:(ErrorBlock)errorBlock;
{
    // 记录image的类型和data
    NSString *name = @"file";
    NSString *filename = [ZSRequestManager getImageFileName];
    NSString *mimeType = @"image/jpeg";
   
    // 设置请求的url
    NSString *stringUrl = APPDELEGATE.zsurlHead;
    if ([stringUrl isEqualToString:KTestServerUrl]) {
        stringUrl = KTestServerImgUploadUrl;
    }
    else{
        stringUrl = KPreProductionImgUploadUrl;
    }
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
   
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
   
    // 设置文件参数
    [body appendData:YYEncode(@"--YY\r\n")];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:YYEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:YYEncode(type)];
    [body appendData:YYEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:YYEncode(@"\r\n")];
    
    // 参数结束
    [body appendData:YYEncode(@"--YY--\r\n")];
    request.HTTPBody = body;
    
    // 设置请求头
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length]forHTTPHeaderField:@"Content-Length"];
    // 设置上传类型 post
    [request setValue:@"multipart/form-data; boundary=YY"forHTTPHeaderField:@"Content-Type"];
   
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError) {
        if (data) {
            NSString *newString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //截取图片url
            NSArray *array = [newString componentsSeparatedByString:@"<h1>"];
            array = [array[1] componentsSeparatedByString:@"</h1>"];
            NSString *urlString = [array[0] substringFromIndex:5];
            successBlock(@{@"MD5":urlString});
            ZSLOG(@"上传成功的url==%@",urlString);
        }else {
            ZSLOG(@"上传失败");
            [ZSTool showMessage:@"图片上传失败,请重试" withDuration:DefaultDuration];
            errorBlock(connectionError);
        }
    }];
}

#pragma mark 设置时间格式
+ (NSString *)getImageFileName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    return fileName;
}

#pragma mark 清除nsnull数据
+ (id)removeNSNullObjectFromeData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]) {
                //将NSNull型的数据换成空字符串@""
                [resultDic setValue:@"" forKey:key];
            }
            else {
                //如果是非NSNull型的数据进入递归
                obj = [self removeNSNullObjectFromeData:obj];
                [resultDic setValue:obj forKey:key];
            }
        }];
        return resultDic;
    }
    else if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *resultArr = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]) {
                //将NSNull型的数据换成空字符串@""
                [resultArr addObject:@""];
            }
            else {
                //如果是非NSNull型的数据进入递归
                obj = [self removeNSNullObjectFromeData:obj];
                [resultArr addObject:obj];
            }
        }];
        return resultArr;
    }else {
        return data;
    }
}

@end
