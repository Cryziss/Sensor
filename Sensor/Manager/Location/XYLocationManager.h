//
//  XYLocationManager.h
//  text-OC
//
//  Created by LX on 2018/2/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, LocationStateType) {
    LocationStateTypeNone,
    LocationStateTypeFail,
    LocationStateTypeSucceed,
};

@interface XYLocationManager : NSObject

#pragma mark - 其他方法
/**
 系统定位状态

 @return 是否开启
 */
+ (BOOL)locationServicesEnabled;
/**
 坐标转换
 卫星获取到地球坐标是球形的，转换成平面坐标
 
 @param coordinate 卫星定位获取到的地球坐标
 @return 转换后的平面坐标
 */
+ (CLLocationCoordinate2D)LocationCoordinate2DMarsFromEarthCoordinate2D:(CLLocationCoordinate2D)coordinate;
/**
 坐标间距离

 @param start 开始坐标点
 @param end 结束坐标点
 @return 距离（单位：m）
 */
+ (double)distanceWithStartLocation:(CLLocationCoordinate2D)start endLocation:(CLLocationCoordinate2D)end;

#pragma mark - 定位监听
/**
 开始定位

 @param desiredAccuracy 定位精确度越高, 越耗电, 而且, 定位时间越长
 @param distanceFilter 设置每隔多远定位一次
 */
- (void)startUpdatingLocationWith:(CLLocationAccuracy)desiredAccuracy DistanceFilter:(CLLocationDistance)distanceFilter;
- (void)stopUpdatingLocation;
//位置坐标
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//位置名称
@property (nonatomic, readonly, copy) NSString *name;
//所属街道
@property (nonatomic, readonly, copy) NSString *thoroughfare;
//子街道（门牌号。。。）
@property (nonatomic, readonly, copy) NSString *subThoroughfare;
//城市
@property (nonatomic, readonly, copy) NSString *locality;
//地区
@property (nonatomic, readonly, copy) NSString *subLocality;
//省，州（如果administrativeArea为空，可能为直辖市）
@property (nonatomic, readonly, copy) NSString *administrativeArea;
//县，郡
@property (nonatomic, readonly, copy) NSString *subAdministrativeArea;
//邮政编码
@property (nonatomic, readonly, copy) NSString *postalCode;
//国家代码  eg. US
@property (nonatomic, readonly, copy) NSString *ISOcountryCode;
//国家
@property (nonatomic, readonly, copy) NSString *country;
//水源，湖泊
@property (nonatomic, readonly, copy) NSString *inlandWater;
//海洋
@property (nonatomic, readonly, copy) NSString *ocean;
//关联的活利益相关的地标（不懂，网上看到的）  // eg. Golden Gate Park
@property (nonatomic, readonly, copy) NSArray<NSString *> *areasOfInterest;

#pragma mark - 方向监听
/**
 开始监听手机方向

 @param headingFilter 每隔多少度监听一次
 */
- (void)startUpdatingHeadingWith:(CLLocationDegrees)headingFilter;
- (void)stopUpdatingHeading;
//设备与磁北的相对方向
@property(readonly, nonatomic) CLLocationDirection magneticHeading;
//设备与真北的相对方向
@property(readonly, nonatomic) CLLocationDirection trueHeading;
//方向的精确度，负数为无效的
@property(readonly, nonatomic) CLLocationDirection headingAccuracy;
//方向上的三维中的三个要素。监听得到的原始磁力值，该磁力值的强度单位是微特斯拉。 
@property(readonly, nonatomic) CLHeadingComponentValue x;
@property(readonly, nonatomic) CLHeadingComponentValue y;
@property(readonly, nonatomic) CLHeadingComponentValue z;
//时间
@property(readonly, nonatomic, copy) NSDate * timestamp;

#pragma mark - 区域监听
/**
 区域监听
 
 @param center 区域中心
 @param radius 区域半径
 @param identifier 区域标志
 */
- (void)startMonitoringForRegion:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius identifier:(NSString *)identifier;
- (void)stopMonitoringVisits;
@end
