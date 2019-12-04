//
//  AppDelegate.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/6/25.
//  Copyright © 2018年 maven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,copy  ) NSString *zsurlHead; //前端接口
@property (nonatomic,copy  ) NSString *zsImageUrl;//图片服务器
@end

