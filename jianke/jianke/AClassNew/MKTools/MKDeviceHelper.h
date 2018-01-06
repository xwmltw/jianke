//
//  MKDeviceHelper.h
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/15.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKDeviceHelper : NSObject

#pragma mark - ***** app 版本号 ******
/** 发布版本号 */
+ (NSString*)getAppBundleShortVersion;

/** 打包版本号 */
+ (NSString*)getAppBundleVersion;

/** 发布版本号 int */
+ (int)getAppIntVersion;

/** 获取bundle identifier */
+ (NSString *)getBundleIdentifier;

#pragma mark - ***** 系统信息 ******

/** 获取设备系统版本字符串 保留2位小数*/
+ (NSString*)getSysVersionString;

/** 获取设备系统版本 */
+ (float)getSysVersion;

/** 设备信息对应名称 */
+ (NSString *)getPlatformString;

/** 获取设备信息 */
+ (NSString *)getDevicePlatform;




@end
