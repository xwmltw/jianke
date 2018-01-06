//
//  UIDeviceHardware.h
//  ayzj
//
//  Created by 黄 良伟 on 14-10-20.
//  Copyright (c) 2014年 huang liangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define iOSVersion [UIDeviceHardware getIOSVersion];

@interface UIDeviceHardware : NSObject
+ (NSString *)platform;
+ (NSString *)platformString;

+ (float)getIOSVersion;
+ (NSString *)getIOSVersionWithString;

+ (void)getCameraAuthorization:(MKBlock)block;
+ (void)getPHAuthorization:(MKBlock)block;

+ (NSString *)getUUIDString;
+ (NSString *)getUUID;

@end
