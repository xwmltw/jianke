//
//  MKOpenUrlHelper.h
//  HHDevelopSolutions
//
//  Created by xiaomk on 16/4/7.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKOpenUrlHelper : NSObject

+ (instancetype)sharedInstance;

+ (void)openQQWithNumber:(NSString*)qqNumber onViewController:(UIViewController*)vc block:(MKBoolBlock)block;

/** 拨打电话 */
- (void)callWithPhone:(NSString *)phone;
/** 拨打电话 -- NSURL */
- (void)callWithPhoneUrl:(NSURL *)phoneUrl;

/** 拨打电话（系统） */
- (void)makeAlertCallWithPhone:(NSString *)phone block:(MKBlock)block;

- (void)makeCallWithPhone:(NSString *)phone;

/** 打开itunes */
- (void)openItunesWithUrl:(NSURL *)url;

@end
