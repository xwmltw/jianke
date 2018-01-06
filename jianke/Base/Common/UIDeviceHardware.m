//
//  UIDeviceHardware.m
//  ayzj
//
//  Created by 黄 良伟 on 14-10-20.
//  Copyright (c) 2014年 huang liangwei. All rights reserved.
//

#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import "UIHelper.h"
#import "SSKeychain.h"
#import "WDUserDefaultDefine.h"
#import <Photos/Photos.h>
#import "MKAlertView.h"

@implementation UIDeviceHardware

+ (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone4,2"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone4,3"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6+";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S+";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";

    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini3";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini4";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini4";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air2";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (float)getIOSVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString*)getIOSVersionWithString{
    return [NSString stringWithFormat:@"%.2lf ",[[[UIDevice currentDevice] systemVersion] floatValue]];
}

+ (void)getCameraAuthorization:(MKBlock)block{
    
    if ([UIDeviceHardware getIOSVersion] >= 7.0) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusAuthorized:
            {
                block(nil);
                break;
            }
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                [UIHelper showMsg:@"该功能需您请前往 “设置->隐私->相机->兼客兼职” 开启权限" andTitle:@"提示"];
                break;
            case AVAuthorizationStatusNotDetermined:{
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(nil);
                        });
                        
                    }else{
//                        [UIHelper showMsg:@"您已拒绝授权，如需使用该功能请前往 “设置->隐私->相机->兼客兼职” 开启权限" andTitle:@"提示"];
                    }
                }];
                break;
            }
            default:
                break;
        }
    }
}

+ (void)getPHAuthorization:(MKBlock)block{
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    switch (authorizationStatus) {
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getPHAuthorization:block];
                });
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:{
            [MKAlertView alertWithTitle:@"提示" message:@"该功能需您请前往 “设置->隐私->照片->兼客兼职” 开启权限" cancelButtonTitle:@"取消" confirmButtonTitle:@"设置" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:{
            MKBlockExec(block, nil);
        }
            break;
        default:
            break;
    }
}

+ (NSString *)getUUIDString {   //旧版im UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (NSString *)getUUID{
    NSString* retrieveuuid = [SSKeychain passwordForService:kSSToolkitUUIDString account:@"user"];
    if ([retrieveuuid isEqualToString:@""] || retrieveuuid == NULL) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        assert(uuidRef != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuidRef);
        retrieveuuid = [NSString stringWithFormat:@"%@", uuidStr];
        [SSKeychain setPassword:retrieveuuid forService:kSSToolkitUUIDString account:@"user"];
        CFRelease(uuidRef);
        CFRelease(uuidStr);
    }
    return retrieveuuid;
}

@end
