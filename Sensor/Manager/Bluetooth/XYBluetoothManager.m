//
//  XYBluetoothManager.m
//  Sensor
//
//  Created by LX on 2018/5/4.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import "XYBluetoothManager.h"

static XYBluetoothManager *BluetoothManager = nil;

@implementation XYBluetoothManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (BluetoothManager == nil ) {
            BluetoothManager = [[XYBluetoothManager alloc] init];
        }
    });
    return BluetoothManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (CBCentralManager *)centralManager{
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

@end
