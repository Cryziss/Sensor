//
//  XYBluetoothManager.m
//  Sensor
//
//  Created by LX on 2018/5/4.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import "XYBluetoothManager.h"

static XYBluetoothManager *BluetoothManager = nil;

@interface XYBluetoothManager () <CBCentralManagerDelegate>

//所有设备列表
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

//所有连接设备
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *connectPeripherals;

@end

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
        self.centralManager.delegate = self;
    }
    return self;
}

#pragma mark - action

// 开始扫描外设
- (XYBLEManagerState)searchSoftPeripherals:(NSInteger)timeout{
    if (self.managerState == XYBLEManagerStatePoweredOn) {
        if (timeout > 0) { // 倒计时大于0的时候执行
            [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimerOut:) userInfo:nil repeats:NO];
        }
        [self.centralManager scanForPeripheralsWithServices:self.UUIDs options:0];
    }
    return self.managerState;
}

// 停止扫描
- (void)stopScan{
    [self.centralManager stopScan];
    NSLog(@"%@",self.bluetoothArray);
}

// 倒计时结束
- (void)scanTimerOut:(NSTimer *)timer {
    [self stopScan];
    
}

#pragma mark - CBCentralManagerDelegate

// 中心设备的蓝牙状态发生变化之后会调用此方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateResetting: //重置中
            self.managerState = XYBLEManagerStateResetting;
            NSLog(@"重置中");
            break;
        case CBManagerStateUnsupported: //不支持
            self.managerState = XYBLEManagerStateUnsupported;
            NSLog(@"不支持");
            break;
        case CBManagerStateUnauthorized: //未授权
            self.managerState = XYBLEManagerStateUnauthorized;
            NSLog(@"未授权");
            break;
        case CBManagerStatePoweredOff: //关闭中
            self.managerState = XYBLEManagerStatePoweredOff;
            NSLog(@"关闭中");
            break;
        case CBManagerStatePoweredOn: //开启中
            self.managerState = XYBLEManagerStatePoweredOn;
            NSLog(@"开启中");
            break;
        default:    //CBManagerStateUnknown //未知
            self.managerState = XYBLEManagerStateUnknown;
            NSLog(@"未知");
            break;
    }
}

/*!
 *  应用从后台恢复到前台的时候,会和系统蓝牙进行同步,调用此方法
 
 *  @seealso            CBCentralManagerRestoredStatePeripheralsKey; // 返回一个中心设备正在连接的所有外设数组
 *  @seealso            CBCentralManagerRestoredStateScanServicesKey; // 返回一个中心设备正在扫描的所有服务UUID的数组
 *  @seealso            CBCentralManagerRestoredStateScanOptionsKey; // 返回一个字典包含正在被使用的外设的扫描选项
 *
 */
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    NSLog(@"应用从后台恢复到前台的时候,会和系统蓝牙进行同步,调用此方法");
}

// 中心设备发现外设的时候调用的方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if(peripheral.identifier == nil) { // identifier 为空 return
        return;
    }
    if (peripheral.name == nil || peripheral.name.length < 1) { // name 为空 return
        return;
    }
    __block BOOL duplicated = NO;
    //去重
    [self.peripherals enumerateObjectsUsingBlock:^(CBPeripheral * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:peripheral]) {
            [self.peripherals replaceObjectAtIndex:idx withObject:peripheral];
            duplicated = YES;
            *stop = YES;
        }
    }];
    if (!duplicated) {
        [self.peripherals addObject:peripheral];
        self.bluetoothArray = self.peripherals.copy;
    }
}

// 中心设备连接上外设时候调用的方法
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"中心设备连接上外设时候调用的方法");
}

// 中心设备连接外设失败时调用的方法
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"中心设备连接外设失败时调用的方法");
}

// 中心设备与已连接的外设断开连接时调用的方法
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"中心设备与已连接的外设断开连接时调用的方法");
}

#pragma mark - get action

// 建立中心设备
- (CBCentralManager *)centralManager{
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] init];
    }
    return _centralManager;
}

// 扫描到的设备数组
- (NSMutableArray *)peripherals{
    if (!_peripherals) {
        _peripherals = [NSMutableArray new];
    }
    return _peripherals;
}

- (void)setBluetoothArray:(NSArray *)bluetoothArray{
    _bluetoothArray = bluetoothArray;
}

- (void)setManagerState:(XYBLEManagerState)managerState{
    _managerState = managerState;
}

@end
