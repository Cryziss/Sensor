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

//peripheral list
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

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
//建立中心设备
- (CBCentralManager *)centralManager{
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] init];
    }
    return _centralManager;
}

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

#pragma mark - action
//扫描外设
- (XYBLEManagerState)searchSoftPeripherals:(NSInteger)timeout{
    if (self.managerState == XYBLEManagerStatePoweredOn) {
        [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimerOut:) userInfo:nil repeats:NO];
        [self.centralManager scanForPeripheralsWithServices:self.UUIDs options:0];
    }
    return self.managerState;
}

/*
 * 倒计时结束
 */
- (void)scanTimerOut:(NSTimer *)timer {
    [self.centralManager stopScan];
    NSLog(@"%@",self.bluetoothArray);
}

#pragma mark - CBCentralManagerDelegate
/*!
 *  状态更新
 */
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
 *  @method centralManager:willRestoreState:
 *
 *  @param central      The central manager providing this information.
 *  @param dict            A dictionary containing information about <i>central</i> that was preserved by the system at the time the app was terminated.
 *
 *  @discussion            For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
 *                        the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
 *                        Bluetooth system.
 *
 *  @seealso            CBCentralManagerRestoredStatePeripheralsKey;
 *  @seealso            CBCentralManagerRestoredStateScanServicesKey;
 *  @seealso            CBCentralManagerRestoredStateScanOptionsKey;
 *
 */
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}

//当扫描到设备时回调
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

/*!
 *  @method centralManager:didConnectPeripheral:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
 *
 */
//当外设与中心设备连接成功回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
}

/*!
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
 *  @param error        The cause of the failure.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
 *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
 *
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}

/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
 *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}

@end
