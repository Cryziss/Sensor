//
//  XYBluetoothManager.h
//  Sensor
//
//  Created by LX on 2018/5/4.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//@protocol XYBluetoothManagerDelegate <NSObject>
//@optional
//
//
//@end

@interface XYBluetoothManager : NSObject

+ (instancetype)shareInstance;

//@property (nonatomic, weak) id<XYBluetoothManagerDelegate> delegate;

@property (nonatomic, strong) NSArray *bluetoothArray;

@property (nonatomic, strong) CBCentralManager *centralManager;

@end
