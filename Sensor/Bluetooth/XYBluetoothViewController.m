//
//  XYBluetoothViewController.m
//  Sensor
//
//  Created by LX on 2018/5/4.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import "XYBluetoothViewController.h"
#import "XYBluetoothManager.h"

@interface XYBluetoothViewController ()

@end

@implementation XYBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"XY_Bluetooth", nil);
    [XYBluetoothManager shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchAction:(UIButton *)sender {
    [[XYBluetoothManager shareInstance] searchSoftPeripherals:5];
}

- (void)dealloc
{
    NSLog(@"%@-dealloc",NSStringFromClass(self.class));
}

@end
