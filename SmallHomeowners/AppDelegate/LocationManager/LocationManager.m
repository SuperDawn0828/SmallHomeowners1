//
//  LocationManager.m
//  SmallHomeowners
//
//  Created by 黄曼文 on 2018/7/2.
//  Copyright © 2018年 maven. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager  ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation LocationManager

+ (LocationManager *)shareInfo
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark 开始定位
- (void)startPositioning
{
    //判断定位权限
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways))
    {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //设置定位精确度到米
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置过滤器为无
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        //请求定位权限
        [self.locationManager requestWhenInUseAuthorization];
        //开始定位
        [self.locationManager startUpdatingLocation];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        //代理传值
        if (_delegate && [_delegate respondsToSelector:@selector(currentCityInfo:)]) {
            [_delegate currentCityInfo:@"请选择"];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    __weak typeof(self) weakSelf = self;
    
    [self.locationManager stopUpdatingLocation];

    CLLocation *newLocation = [locations lastObject];
    ZSLOG(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    //根据经纬度反向地理编译出地址信息
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array,NSError *error){
            if(array.count > 0){
                CLPlacemark *placemark = [array objectAtIndex:0];
                //获取城市
                NSString *city = placemark.locality;
                if(!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                ZSLOG(@"获取当前城市:%@",city);
                //存值
                [USER_DEFALT setObject:city forKey:KLocationInfo];
                //代理传值
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(currentCityInfo:)]) {
                    [weakSelf.delegate currentCityInfo:city];
                }
            }
            else
            {
                ZSLOG(@"定位失败");
                //存值
                [USER_DEFALT setObject:@"定位失败" forKey:KLocationInfo];
                //代理传值
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(currentCityInfo:)]) {
                    [weakSelf.delegate currentCityInfo:@"定位失败"];
                }
            }
    }];

    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

#pragma mark 开启定位权限
- (void)openAuthorizationStatus
{
    //跳到APP自身的设置页
    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:appSettings]) {
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

@end
