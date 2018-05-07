//
//  XYBluetoothManager.h
//  Sensor
//
//  Created by LX on 2018/5/4.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, XYBLEManagerState) {
    XYBLEManagerStateUnknown = 0,//未知
    XYBLEManagerStateResetting,//重置中
    XYBLEManagerStateUnsupported,//不支持
    XYBLEManagerStateUnauthorized,//未授权
    XYBLEManagerStatePoweredOff,//关闭中
    XYBLEManagerStatePoweredOn,//开启中
};

typedef NS_ENUM(NSUInteger, XYBLESearchState) {
    XYBLESearchStateStop,
    XYBLESearchStateSearchIng,
//    XYBLESearchState,
};

//@protocol XYBluetoothManagerDelegate <NSObject>
//@optional
//
//
//@end

@interface XYBluetoothManager : NSObject

+ (instancetype)shareInstance;

//@property (nonatomic, weak) id<XYBluetoothManagerDelegate> delegate;
//
@property (nonatomic, strong, readonly) NSArray<CBPeripheral *> *bluetoothArray;
//
@property (nonatomic, strong) CBCentralManager *centralManager;
//
@property (nonatomic, assign, readonly) XYBLEManagerState managerState;
//
@property (nonatomic, strong) NSArray<CBUUID *> *UUIDs;
//当前连接的设备
@property (nonatomic, strong) CBPeripheral *activePeripheral;
/**
 开始扫描设备

 @param timeout 倒计时时间 小于等于0 的时候不执行倒计时
 @return 蓝牙状态 只有 XYBLEManagerStatePoweredOn 才会开启扫描
 */
- (XYBLEManagerState)searchSoftPeripherals:(NSInteger)timeout;

/**
 停止扫描设备
 */
- (void)stopScan;

// 连接设备
- (void)connect:(CBPeripheral *)peripheral;

// 断开连接
- (void)disconnect:(CBPeripheral *)peripheral;

@end
