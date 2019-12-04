//
//  ZSTabBar.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/23.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "ZSTabBar.h"

@implementation ZSTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //1.将背景色设成图片,盖住细线
        [self setBackgroundImage:[ZSTool createImageWithColor:UIColorFromRGB(0xFAFAFA)]];
        [self setShadowImage:[ZSTool createImageWithColor:UIColorFromRGB(0xFAFAFA)]];
        
        
        //2.字体位置/大小/颜色
        //    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -12)];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: UIColorFromRGB(0x4F4F4F), NSForegroundColorAttributeName,[UIFont systemFontOfSize:10], NSFontAttributeName,nil] forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZSColorGolden, NSForegroundColorAttributeName,[UIFont systemFontOfSize:10], NSFontAttributeName,nil] forState:UIControlStateSelected];
        
        //3.创建按钮
        self.createOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_iPhoneX) {
            self.createOrderBtn.frame = CGRectMake((ZSWIDTH-50)/2, (49-40)/2+3, 50, 40);
        }
        else{
            self.createOrderBtn.frame = CGRectMake((ZSWIDTH-50)/2, (49-40)/2, 50, 40);
        }
        self.createOrderBtn.backgroundColor = ZSColorGolden;
        self.createOrderBtn.layer.cornerRadius = 5;
        self.createOrderBtn.layer.masksToBounds = YES;
        [self.createOrderBtn setImage:[UIImage imageNamed:@"bottom_add"] forState:UIControlStateNormal];
        [self addSubview:self.createOrderBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
//    CGPoint temp = self.createOrderBtn.center;
//    temp.x = self.frame.size.width/2;
//    temp.y = self.frame.size.height/2;
//    self.createOrderBtn.center = temp;
    
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1 = child.frame;
            temp1.size.width = tabbarButtonW;
            temp1.origin.x = tabbarButtonIndex * tabbarButtonW;
            child.frame = temp1;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}


@end
