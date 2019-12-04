//
//  ZSTool.h
//  ZSMoneytocar
//
//  Created by 武 on 16/7/5.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSTimeInterval DefaultDuration = 1.25f;//提示语展示的默认时长

typedef void(^FeeBlock)(NSMutableArray *feeArray,NSMutableArray *feeNameArray);
@interface ZSTool : NSObject

#pragma mark 初始化
+ (ZSTool*)shareInfo;

#pragma mark 获取本地版本号
+(NSString*)localVersionShort;

#pragma mark 获取UUID
+ (NSString *)uuidString;

#pragma mark判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

#pragma mark iOS限制输入表情(emoji)，出现九宫格不能输入的解决方法
+ (BOOL)isNineKeyBoard:(NSString *)string;

#pragma mark 拨打电话(修复ios10.2反应慢的问题)
+ (void)callPhoneStr:(NSString*)phoneString withVC:(UIViewController *)viewCtrl;

#pragma mark 时间比较大小
+ (BOOL)compareOneDay:(NSString *)beginTimeStr withAnotherDay:(NSString *)endTimeStr;

#pragma mark 获取当前年限
+ (NSInteger )getCurrentYear;

#pragma makr 获取当前时间
+ (NSString *)getCurrentTimes;

#pragma mark 日期格式转换
+ (NSString *)dateChange:(NSString *)validStr;

#pragma mark 获取时间段(早上好)
+ (NSString *)getTheTimeBucket;

#pragma mark 判断密码输入是否规范
+ (BOOL)isPassword:(NSString *)password;

#pragma mark 判断手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

#pragma mark 判断身份证号码
+ (BOOL)isIDCard:(NSString *)userID;

#pragma mark 判断身份证有效期
+ (NSString *)calcDays:(NSString *)validStr;

#pragma mark 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color;

#pragma mark 删除手机号里面的空格
+ (NSString *)filteringTheBlankSpace:(NSString *)string;

#pragma mark 往手机号里塞空格
+ (NSString *)addTheBlankSpace:(NSString *)string;

#pragma mark 获取普通label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font;

#pragma mark 获取普通label的宽度
+ (CGFloat)getStringWidth:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font;

#pragma mark 获取带行间距label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font
          winthLineSpacing:(CGFloat)lineSpacing;

#pragma mark label内容左右对齐
+ (NSAttributedString *)setTextString:(NSString *)text withSizeFont:(UIFont *)font;

#pragma mark 生成随机数, 用于图片上传的压缩系数
+ (double)configureRandomNumber;

#pragma mark 重新定义提示语的位置,ost
+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration;

#pragma mark 添加小星星(*)
+ (NSMutableAttributedString *)addStarWithString:(NSString *)string;

#pragma mark 从任何一个view中获得当前控制器
+ (UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView;

#pragma mark 生成长图
+ (UIImage *)saveLongImage:(UIScrollView *)scrollView;

#pragma mark 拉伸图片
+ (UIImage *)changeImage:(UIImage *)image Withview:(UIView *)view;

#pragma mark 获取行数
+ (int)getNumberOfLines:(NSInteger)Count;

#pragma mark 万元和元之间的转化
+ (NSString *)yuanIntoTenThousandYuanWithCount:(NSString *)count WithType:(BOOL)isYuan;//isYuan为yes表示元转化成万元,反之万元转成元

#pragma mark 判断金额数值大小
+ (BOOL)checkMaxNumWithInputNum:(NSString *)inputNum MaxNum:(NSString *)maxNum alert:(BOOL)isAlert;

@end
