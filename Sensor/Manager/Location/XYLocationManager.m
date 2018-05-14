//
//  XYLocationManager.m
//  text-OC
//
//  Created by LX on 2018/2/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "XYLocationManager.h"

void transform_earth_2_mars(double lat, double lng, double* tarLat, double* tarLng);

@interface XYLocationManager () <CLLocationManagerDelegate>
/**
 定位管理
 */
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation XYLocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark - 其他方法
//定位服务是否可用
+ (BOOL)locationServicesEnabled{
    return [CLLocationManager locationServicesEnabled];
}
//坐标转换
+ (CLLocationCoordinate2D)LocationCoordinate2DMarsFromEarthCoordinate2D:(CLLocationCoordinate2D)coordinate{
    double lat = 0.0;
    double lng = 0.0;
    transform_earth_2_mars(coordinate.latitude, coordinate.longitude, &lat, &lng);
    return CLLocationCoordinate2DMake(lat, lng);
}
//坐标间距离
+ (double)distanceWithStartLocation:(CLLocationCoordinate2D)start endLocation:(CLLocationCoordinate2D)end{
    CLLocation *send = [[CLLocation alloc]initWithLatitude:start.latitude longitude:start.longitude];
    CLLocation *receive = [[CLLocation alloc]initWithLatitude:end.latitude longitude:end.longitude];
    CLLocationDistance dis = [send distanceFromLocation:receive];
    return dis;
}

#pragma mark - 定位监听
//开始定位
- (void)startUpdatingLocationWith:(CLLocationAccuracy)desiredAccuracy DistanceFilter:(CLLocationDistance)distanceFilter{
    self.locationManager.desiredAccuracy = desiredAccuracy;
    self.locationManager.distanceFilter = distanceFilter;
}
- (void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

/*
 *  当新位置可用时调用
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    //表示水平准确度，这么理解，它是以coordinate为圆心的半径，返回的值越小，证明准确度越好，如果是负数，则表示corelocation定位失败。
    if (newLocation.horizontalAccuracy < 0) {
        NSLog(@"location.horizontalAccuracy:%f,定位失败!!!!",newLocation.horizontalAccuracy);
        return;
    }
    self.coordinate = newLocation.coordinate;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 反向地理编译出地址信息
    __weak typeof(self) weakSelf = self;
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * placemarks, NSError * error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!error) {
            if (placemarks && [placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                strongSelf.name = placemark.name;//位置名称
                strongSelf.thoroughfare = placemark.thoroughfare;//所属街道
                strongSelf.subThoroughfare = placemark.subThoroughfare;//子街道
                strongSelf.locality = placemark.locality;//城市
                strongSelf.subLocality = placemark.subLocality;//地区
                strongSelf.administrativeArea = placemark.administrativeArea;//省，州
                strongSelf.subAdministrativeArea = placemark.subAdministrativeArea;//县，郡
                strongSelf.postalCode = placemark.postalCode;//邮政编码
                strongSelf.ISOcountryCode = placemark.ISOcountryCode;//国家代码  eg. US
                strongSelf.country = placemark.country;//国家
                strongSelf.inlandWater = placemark.inlandWater;//水源，湖泊
                strongSelf.ocean = placemark.ocean;//海洋
                strongSelf.areasOfInterest = placemark.areasOfInterest;//关联的活利益相关的地标
            } else {
                NSLog(@"定位城市失败");
            }
        } else {
            NSLog(@"请检查您的网络");
        }
    }];
}

/*
 *  //定位失败了之后调用.
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}
/*
 *  改变里授权的状态
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined://用户“未授权”
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusRestricted://其他原因“无法授权定位”
            
            break;
        case kCLAuthorizationStatusDenied:// 用户“拒绝” ，系统定位为开启
            if ([CLLocationManager locationServicesEnabled]) {// 用户“拒绝”
                
            } else {//系统定位未开启
                
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways://用户允许“一直定位”
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse://用户允许“使用时定位”
            [self.locationManager startUpdatingLocation];
            break;
        default:
            
            break;
    }
}

/*
 *  用于判断是否显示方向的校对,返回yes的时候，将会校对正确之后才会停止，或者dismissheadingcalibrationdisplay方法解除
 */
//- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
//
//}

/*
 * 已经停止位置的更更新
 */
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    
}

/*
 *  位置定位重新开始定位位置的更新
 */
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager{
    
}

/*
 *  已经完成了推迟的更新
 */
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(nullable NSError *)error{
    
}

/*
 *  就是已经访问过的位置，就会调用这个表示已经访问过，这个在栅栏或者定位区域都是使用到的
 */
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit{
    
}
#pragma mark - 监听角度的改变
/**
 开始监听手机方向
 
 @param headingFilter 每隔多少度监听一次
 */
- (void)startUpdatingHeadingWith:(CLLocationDegrees)headingFilter{
    if (headingFilter > 0) {
        self.locationManager.headingFilter = headingFilter;
    }
    [self.locationManager startUpdatingHeading];
}
- (void)stopUpdatingHeading{
    [self.locationManager stopUpdatingHeading];
}
/*
 *  方向的更新以后调用
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.magneticHeading = newHeading.magneticHeading;//设备与磁北的相对方向
    self.trueHeading = newHeading.trueHeading;//设备与真北的相对方向
    self.headingAccuracy = newHeading.headingAccuracy;//方向的精确度，负数为无效的
    //方向上的三维中的三个要素，监听得到的原始磁力值，该磁力值的强度单位是微特斯拉。
    self.x = newHeading.x;
    self.y = newHeading.y;
    self.z = newHeading.z;
    self.timestamp = newHeading.timestamp;//时间
}
#pragma mark - 区域监听

////开始监听
//- (void)startMonitoringForRegion:(CLRegion *)region __OSX_AVAILABLE_STARTING(__MAC_TBD,__IPHONE_5_0);
////请求监听区域
//- (void)requestStateForRegion:(CLRegion *)region __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
////进入该区域会调用此代理方法
//- (void)locationManager:(CLLocationManager *)manager
//         didEnterRegion:(CLRegion *)region __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
////离开该区域是调用此代理方法
//- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
////判断状态（是否在该区域内）
//- (void)locationManager:(CLLocationManager *)manager
//      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);

/**
 区域监听

 @param center 区域中心
 @param radius 区域半径
 @param identifier 区域标志
 */
- (void)startMonitoringForRegion:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius identifier:(NSString *)identifier{
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
    //开始监听区域状态
    [self.locationManager startMonitoringForRegion:region];
    //开始请求区域状态
    [self.locationManager requestStateForRegion:region];
}
- (void)stopMonitoringVisits{
    [self.locationManager stopMonitoringVisits];
}
/*
 *  判断状态（是否在该区域内）
 */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
}

/*
 *  进入指定区域
 */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
}

/*
 *  离开指定的区域
 */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
}

/*
 *  Monitoring有错误产生时的回调
 */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region withError:(NSError *)error{
    
}

/*
 *  Monitoring成功对应回调函数
 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    
}
/*
 *  区域成功对应回调函数
 */
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
}
/*
 *   区域有错误产生时的回调
 */
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    
}

#pragma mark - get action
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    _coordinate = coordinate;
}
- (void)setName:(NSString *)name{
    _name = name;
}
- (void)setThoroughfare:(NSString *)thoroughfare{
    _thoroughfare = thoroughfare;
}
- (void)setSubThoroughfare:(NSString *)subThoroughfare{
    _subThoroughfare = subThoroughfare;
}
- (void)setLocality:(NSString *)locality{
    _locality = locality;
}
- (void)setSubLocality:(NSString *)subLocality{
    _subLocality = subLocality;
}
- (void)setAdministrativeArea:(NSString *)administrativeArea{
    _administrativeArea = administrativeArea;
}
- (void)setSubAdministrativeArea:(NSString *)subAdministrativeArea{
    _subAdministrativeArea = subAdministrativeArea;
}
- (void)setPostalCode:(NSString *)postalCode{
    _postalCode = postalCode;
}
- (void)setISOcountryCode:(NSString *)ISOcountryCode{
    _ISOcountryCode = ISOcountryCode;
}
- (void)setCountry:(NSString *)country{
    _country = country;
}
- (void)setInlandWater:(NSString *)inlandWater{
    _inlandWater = inlandWater;
}
- (void)setOcean:(NSString *)ocean{
    _ocean = ocean;
}
- (void)setAreasOfInterest:(NSArray<NSString *> *)areasOfInterest{
    _areasOfInterest = areasOfInterest;
}
- (void)setMagneticHeading:(CLLocationDirection)magneticHeading{
    _magneticHeading = magneticHeading;
}
- (void)setTrueHeading:(CLLocationDirection)trueHeading{
    _trueHeading = trueHeading;
}
- (void)setHeadingAccuracy:(CLLocationDirection)headingAccuracy{
    _headingAccuracy = headingAccuracy;
}
- (void)setX:(CLHeadingComponentValue)x{
    _x = x;
}
- (void)setY:(CLHeadingComponentValue)y{
    _y = y;
}
- (void)setZ:(CLHeadingComponentValue)z{
    _z = z;
}
- (void)setTimestamp:(NSDate *)timestamp{
    _timestamp = timestamp;
}

@end

// --- transform_earth_2_mars ---
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

bool transform_sino_out_china(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transform_earth_2_mars_lat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transform_earth_2_mars_lng(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

void transform_earth_2_mars(double lat, double lng, double* tarLat, double* tarLng)
{
    if (transform_sino_out_china(lat, lng))
    {
        *tarLat = lat;
        *tarLng = lng;
        return;
    }
    double dLat = transform_earth_2_mars_lat(lng - 105.0, lat - 35.0);
    double dLon = transform_earth_2_mars_lng(lng - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    *tarLat = lat + dLat;
    *tarLng = lng + dLon;
}
