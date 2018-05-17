//
//  XYCameraViewController.m
//  Sensor
//
//  Created by LX on 2018/5/17.
//  Copyright © 2018年 Sensor. All rights reserved.
//

#import "XYCameraViewController.h"
//相机
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
//相册
//#import <AssetsLibrary/AssetsLibrary.h>
//#import <Photos/PHPhotoLibrary.h>

@interface XYCameraViewController ()

@end

@implementation XYCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"XY_Camera", nil);
    // Do any additional setup after loading the view from its nib.
    
    //相机权限
//    typedef NS_ENUM(NSInteger, AVAuthorizationStatus) {
//        AVAuthorizationStatusNotDetermined = 0,// 系统还未知是否访问，第一次开启相机时
//        AVAuthorizationStatusRestricted    = 1,// 受限制的
//        AVAuthorizationStatusDenied        = 2,// 不允许
//        AVAuthorizationStatusAuthorized    = 3,// 允许状态
//    } NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
//        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if ([[UIApplication sharedApplication]canOpenURL:url]) {
//            [[UIApplication sharedApplication]openURL:url];
//        }
        NSLog(@"无权限");
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            [self loadImage:UIImagePickerControllerSourceTypeCamera];
            NSLog(@"开始");
            UIImagePickerController *ca = [[UIImagePickerController alloc] init];
            ca.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:ca animated:YES completion:nil];
        } else {
            NSLog(@"手机不支持相机");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
