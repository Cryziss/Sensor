//
//  ViewController.m
//  Sensor
//
//  Created by LX on 2018/5/4.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import "ViewController.h"
#import "XYBluetoothViewController.h"
#import "XYBluetoothManager.h"

@interface ViewController () <UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    NSString *text = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    switch (indexPath.row) {
        case 0:
            text = NSLocalizedString(@"XY_Bluetooth", nil);
            break;
        case 1:
            text = NSLocalizedString(@"XY_Location", nil);
            break;
        case 2:
            text = NSLocalizedString(@"XY_Accelerometer_Gyroscope", nil);
            break;
        case 3:
            text = NSLocalizedString(@"XY_Compass_Magnetometer", nil);
            break;
        case 4:
            text = NSLocalizedString(@"XY_Camera", nil);
            break;
        case 5:
            text = NSLocalizedString(@"XY_Voice", nil);
            break;
        case 6:
            break;
        default:
            break;
    }
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        XYBluetoothViewController *bluetoothVC = [[XYBluetoothViewController alloc] initWithNibName:@"XYBluetoothViewController" bundle:nil];
        [self.navigationController pushViewController:bluetoothVC animated:YES];
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        
    } else if (indexPath.row == 5) {
        
    } else if (indexPath.row == 6) {
        
    }
}
@end
