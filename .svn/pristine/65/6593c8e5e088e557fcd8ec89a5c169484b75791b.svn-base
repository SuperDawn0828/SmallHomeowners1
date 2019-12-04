//
//  ZSTool.m
//  ZSMoneytocar
//
//  Created by 武 on 16/7/5.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSTool.h"
#import <CoreText/CoreText.h>

@implementation ZSTool

#pragma mark 初始化
+ (ZSTool*)shareInfo
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark 获取本地版本号
+ (NSString*)localVersionShort
{
    NSDictionary *diction =[[NSBundle mainBundle] infoDictionary] ;
    NSString * localVersionShort=[diction objectForKey:@"CFBundleShortVersionString"];
    return  localVersionShort;
}

#pragma mark 获取UUID
+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}


#pragma mark判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string{
    
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         ZSLOG(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3|| ls ==0xfe0f) {
                 isEomji = YES;
             }
             //             ZSLOG(@"ls++++++++%04x",ls);
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
         
     }];
    return isEomji;
}


#pragma mark iOS限制输入表情(emoji)，出现九宫格不能输入的解决方法
+ (BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

#pragma mark 拨打电话(修复ios10.2反应慢的问题)
+ (void)callPhoneStr:(NSString*)phoneString withVC:(UIViewController *)viewCtrl
{
    if (phoneString.length >= 10) {
        NSString *str_version = [[UIDevice currentDevice] systemVersion];
        if ([str_version compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending ||//判断两对象值的大小(按字母顺序进行比较，str_version小于10.2为真)
            [str_version compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
        {
            NSString *PhoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr]
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"phone success");
                                     }];
        }
        else
        {
            NSMutableString *str1 = [[NSMutableString alloc]initWithString:phoneString];//存在堆区，可变字符串
            if (phoneString.length == 10) {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:7];// 把一个字符串插入另一个字符串中的某一个位置
            }else{
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:8];// 把一个字符串插入另一个字符串中的某一个位置
            }
            NSString *str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
            alert.popoverPresentationController.barButtonItem = viewCtrl.navigationItem.leftBarButtonItem;// 设置popover指向的item
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                NSLog(@"点击了呼叫按钮10.2下");
                NSString *PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneString];
                if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"])
                {
                    UIApplication *app = [UIApplication sharedApplication];
                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]])
                    {
                        [app openURL:[NSURL URLWithString:PhoneStr]];
                    }
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [viewCtrl presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - 时间比较大小
+ (BOOL)compareOneDay:(NSString *)beginTimeStr withAnotherDay:(NSString *)endTimeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-dd-MM"];
    NSDate *dateA = [dateFormatter dateFromString:beginTimeStr];
    NSDate *dateB = [dateFormatter dateFromString:endTimeStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", beginTimeStr, endTimeStr);
    if (result == NSOrderedDescending) {
        //beginTimeStr > endTimeStr
        return YES;
    }
    else if (result == NSOrderedAscending){
        //beginTimeStr < endTimeStr
        return NO;
    }else{
        return NO;
        //beginTimeStr = endTimeStr
    }
}

#pragma mark 获取当前年限
+ (NSInteger )getCurrentYear
{
    //获取当前年限
    NSDate * mydate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM";
    NSString *str_year = [dateFormatter stringFromDate:mydate];
    NSRange rang_year = NSMakeRange(0, 4);
    NSString *substring = [str_year substringWithRange:rang_year];
    NSInteger maxYear  = [substring integerValue];
    //最大年限
    return maxYear;
}

#pragma makr 获取当前时间
+ (NSString *)getCurrentTimes
{
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

#pragma mark 日期格式转换
+ (NSString *)dateChange:(NSString *)validStr
{
    validStr = [validStr substringFromIndex:9];
    NSString *year = [validStr substringToIndex:4];
    NSString *mouth = [validStr substringFromIndex:4];
    mouth = [mouth substringToIndex:2];
    NSString *day = [validStr substringFromIndex:6];
    validStr = [NSString stringWithFormat:@"%@-%@-%@",year,mouth,day];
    return validStr;
}

#pragma mark 获取时间段(早上好)
+ (NSString *)getTheTimeBucket
{
    NSDate * currentDate = [NSDate date];
    if ([currentDate compare:[ZSTool getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[ZSTool getCustomDateWithHour:9]] == NSOrderedAscending)
    {
        return @"早上好";
    }
    else if ([currentDate compare:[ZSTool getCustomDateWithHour:9]] == NSOrderedDescending && [currentDate compare:[ZSTool getCustomDateWithHour:11]] == NSOrderedAscending)
    {
        return @"上午好";
    }
    else if ([currentDate compare:[ZSTool getCustomDateWithHour:11]] == NSOrderedDescending && [currentDate compare:[ZSTool getCustomDateWithHour:13]] == NSOrderedAscending)
    {
        return @"中午好";
    }
    else if ([currentDate compare:[ZSTool getCustomDateWithHour:13]] == NSOrderedDescending && [currentDate compare:[ZSTool getCustomDateWithHour:18]] == NSOrderedAscending)
    {
        return @"下午好";
    }
    else
    {
        return @"晚上好";
    }
}

//将时间点转化成日历形式
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

#pragma mark 判断密码输入是否规范
+ (BOOL)isPassword:(NSString *)password
{
    NSString *Regex = @"^[0-9a-zA-Z_!@#$%^&*()+-:;',.?]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:password];
}

#pragma mark 判断手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *Regex = @"^[1][3,4,5,6,7,8,9][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" "withString:@""];//去除手机号里面的空格
    return [phoneTest evaluateWithObject:mobileNum];
}

#pragma mark 判断身份证号码
+ (BOOL)isIDCard:(NSString *)userID
{
    //判断是否为空
    if (userID==nil||userID.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:userID]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [userID substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(userID.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[userID substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[userID substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

#pragma mark 判断身份证有效期
+ (NSString *)calcDays:(NSString *)validStr
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //日期格式修正
    validStr = [validStr substringFromIndex:9];
    NSString *year = [validStr substringToIndex:4];
    NSString *mouth = [validStr substringFromIndex:4];
    mouth = [mouth substringToIndex:2];
    NSString *day = [validStr substringFromIndex:6];
    validStr = [NSString stringWithFormat:@"%@-%@-%@",year,mouth,day];
    
    //string转换成日期
    NSDate *validDate = [dateFormatter dateFromString:validStr];
    NSDate *currentDate = [NSDate date];
    
    //取两个日期对象的时间间隔：
    NSTimeInterval time = [validDate timeIntervalSinceDate:currentDate];
    int days = ((int)time)/(3600*24);
    days = days + 1;
    
    //判断身份证有效期
    if (days > 0 && days > 60) {
        return @"有效";
    }
    else if (days > 0 && days <= 60) {
        return [NSString stringWithFormat:@"身份证即将失效，有效期至%@",validStr];
    }
    else{
        return @"身份证已失效";
    }
}

#pragma mark 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 删除手机号里面的空格
+ (NSString *)filteringTheBlankSpace:(NSString *)string
{
    if (string.length >= 13) {
        string = [string stringByReplacingOccurrencesOfString:@" "withString:@""];//去除手机号里面的空格
        return string;
    }
    else {
        return string;
    }
}

#pragma mark 往手机号里塞空格
+ (NSString *)addTheBlankSpace:(NSString *)string
{
    //先把里面的空格去掉,然后再拆
    string = [string stringByReplacingOccurrencesOfString:@" "withString:@""];
    
    if (string.length >= 11)
    {
        NSString *first = [string substringToIndex:3];
        NSString *second = [string substringFromIndex:3];
        second = [second substringToIndex:4];
        NSString *third = [string substringFromIndex:7];
        
        NSString *newString = [NSString stringWithFormat:@"%@ %@ %@",first,second,third];
        return newString;
    }
    else {
        return string;
    }
}

#pragma mark 获取普通label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return labelsize.height;
}

#pragma mark 获取普通label的宽度
+ (CGFloat)getStringWidth:(NSString *)string
                withframe:(CGSize)size
             withSizeFont:(UIFont*)font
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return labelsize.width;
}

#pragma mark 获取带行间距label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font
          winthLineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@0.0f};
    CGSize labelsize = [string boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:dict
                                              context:nil].size;
    return labelsize.height;
}

#pragma mark label内容左右对齐
+ (NSAttributedString *)setTextString:(NSString *)text
                         withSizeFont:(UIFont *)font
{
    NSMutableAttributedString *mAbStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    npgStyle.alignment = NSTextAlignmentJustified;
    npgStyle.paragraphSpacing = 11.0;
    npgStyle.paragraphSpacingBefore = 10.0;
    npgStyle.firstLineHeadIndent = 0.0;
    npgStyle.headIndent = 0.0;
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          NSFontAttributeName           :font,
                          NSParagraphStyleAttributeName :npgStyle,
                          NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleNone]
                          };
    [mAbStr setAttributes:dic range:NSMakeRange(0, mAbStr.length)];
    NSAttributedString *attrString = [mAbStr copy];
    return attrString;
}

#pragma mark 生成随机数, 用于图片上传的压缩系数
+ (double)configureRandomNumber
{
    //获取一个随机数范围在：[600000,700000]
    srand((unsigned)time(0));
    int value = (arc4random() % 100000) + 600000;
    NSString *string = [NSString stringWithFormat:@"0.%i",value];
    double newValue = [string floatValue];
    return newValue;
}

#pragma mark 重新定义提示语的位置,ost
+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration
{
    //文字的宽高
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    CGSize labelsize = [message boundingRectWithSize:CGSizeMake(ZSWIDTH-50, ZSHEIGHT) options:NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin  |
                        NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    //label
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake((ZSWIDTH-labelsize.width-20)/2, (ZSHEIGHT-labelsize.height-20)/2, labelsize.width+20, labelsize.height+20)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.layer.cornerRadius = 5;
    [window addSubview:blackView];
    
    UILabel *whiteLabel =  [[UILabel alloc]initWithFrame:CGRectMake((ZSWIDTH-labelsize.width)/2, (ZSHEIGHT-labelsize.height)/2, labelsize.width, labelsize.height)];
    whiteLabel.backgroundColor = [UIColor clearColor];
    whiteLabel.text = message;
    whiteLabel.textColor = ZSColorWhite;
    whiteLabel.numberOfLines = 0;
    whiteLabel.textAlignment = NSTextAlignmentCenter;
    whiteLabel.font = [UIFont systemFontOfSize:15];
    [window addSubview:whiteLabel];
    
    //展示的时长
    [UIView animateWithDuration:duration animations:^{
        blackView.alpha = 0.7;
        whiteLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
        [whiteLabel removeFromSuperview];
    }];
}

#pragma mark 添加小星星(*)
+ (NSMutableAttributedString *)addStarWithString:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%@ *",string];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:ZSColorGolden range:NSMakeRange(str.length - 1, 1) ];
    return mutableStr;
}

#pragma mark 从任何一个view中获得当前控制器
+ (UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView
{
    for (UIView *next = currentView ; next ; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark 生成长图
+ (UIImage *)saveLongImage:(UIScrollView *)scrollView
{
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }
    return nil;
}

#pragma mark 拉伸图片
+ (UIImage *)changeImage:(UIImage *)image Withview:(UIView *)view;
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.f);
    [image drawInRect:view.bounds];
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return lastImage;
}

#pragma mark 获取行数
+ (int)getNumberOfLines:(NSInteger)Count
{
    int count=(int)Count;
    int numLines=(count-1)/4+1;
    return numLines;
}

#pragma mark 万元和元之间的转化
+ (NSString *)yuanIntoTenThousandYuanWithCount:(NSString *)count WithType:(BOOL)isYuan;//isYuan为yes表示元转化成万元,反之万元转成元
{
    //数据计算 https://www.jianshu.com/p/946c4c4aff33
    NSString *result;
    if (isYuan)
    {
        //除以
        NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:count];
        NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:@"10000"];
        result = [NSString stringWithFormat:@"%@", [a decimalNumberByDividingBy:b]];
    }
    else
    {
        //乘
        NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:count];
        NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:@"10000"];
        result = [NSString stringWithFormat:@"%@", [a decimalNumberByMultiplyingBy:b]];
    }
    return result;
}

#pragma mark 判断金额数值大小
+ (BOOL)checkMaxNumWithInputNum:(NSString *)inputNum MaxNum:(NSString *)maxNum alert:(BOOL)isAlert
{
    if (inputNum.length > 0 && maxNum.length > 0){
        NSDecimalNumber *numberBaseRate = [NSDecimalNumber decimalNumberWithString:inputNum];
        NSDecimalNumber *numberRateEnd = [NSDecimalNumber decimalNumberWithString:maxNum];
        /// 这里不仅包含Multiply还有加 减 除。
        NSComparisonResult numResult = [numberBaseRate compare:numberRateEnd];
        if (numResult == NSOrderedDescending){
            if (isAlert){
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
    return NO;
}

@end
