//
//  XYBluetoothViewController.m
//  Sensor
//
//  Created by LX on 2018/5/4.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import "XYBluetoothViewController.h"
#import "XYBluetoothManager.h"

@interface XYBluetoothViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *list;

@end

@implementation XYBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"XY_Bluetooth", nil);
    
    _list.delegate = self;
    _list.dataSource = self;
    @weakify(self);
    [RACObserve([XYBluetoothManager shareInstance], managerState) subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
        switch ([x integerValue]) {
            case XYBLEManagerStateResetting:
                NSLog(@"重置中");
                break;
            case XYBLEManagerStateUnsupported:
                NSLog(@"不支持");
                break;
            case XYBLEManagerStateUnauthorized:
                NSLog(@"未授权");
                break;
            case XYBLEManagerStatePoweredOff:
                NSLog(@"关闭中");
                break;
            case XYBLEManagerStatePoweredOn:
                NSLog(@"开启中");
                break;
            default:
                NSLog(@"未知");
                break;
        }
        
    }];
    [RACObserve([XYBluetoothManager shareInstance], bluetoothArray) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            [self.list reloadData];
        }
    }];
}

- (IBAction)searchAction:(UIButton *)sender {
    [[XYBluetoothManager shareInstance] searchSoftPeripherals:5];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [XYBluetoothManager shareInstance].bluetoothArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    if ([XYBluetoothManager shareInstance].bluetoothArray.count > indexPath.row) {
        CBPeripheral *peripheral = [XYBluetoothManager shareInstance].bluetoothArray[indexPath.row];
        cell.textLabel.text = peripheral.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)peripheral.state];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([XYBluetoothManager shareInstance].bluetoothArray.count > indexPath.row) {
        CBPeripheral *peripheral = [XYBluetoothManager shareInstance].bluetoothArray[indexPath.row];
        if (peripheral.state == CBPeripheralStateConnected) {
            [[XYBluetoothManager shareInstance] disconnect:peripheral];
        }else{
            [[XYBluetoothManager shareInstance] connect:peripheral];
        }
    }
}

- (void)dealloc
{
    NSLog(@"%@-dealloc",NSStringFromClass(self.class));
}

@end
