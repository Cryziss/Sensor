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

/**
 search Peripherals

 @param timeout time out
 @return Bluetooth State
 */
- (XYBLEManagerState)searchSoftPeripherals:(NSInteger)timeout;

@end
