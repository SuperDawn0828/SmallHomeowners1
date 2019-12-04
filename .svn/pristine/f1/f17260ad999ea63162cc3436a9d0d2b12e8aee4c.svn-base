//
//  LocationManager.h
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/2.
//  Copyright © 2018年 maven. All rights reserved.
//  定位Manager(目前只需要单次定位)

#import <Foundation/Foundation.h>

@class LocationManager;
@protocol LocationManagerDelegate <NSObject>
@optional
- (void)currentCityInfo:(NSString *)string;//当前城市信息
@end

@interface LocationManager : NSObject

@property(nonatomic, weak) id<LocationManagerDelegate> delegate;

+ (LocationManager *)shareInfo;

- (void)startPositioning;//开始定位

- (void)openAuthorizationStatus;//开启定位权限以后重新开始定位

@end
