//
//  XSJNotifyHelper.h
//  jianke
//
//  Created by fire on 16/9/10.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSJNotifyHelper : NSObject

+ (void)handleLocalNotification:(NSDictionary *)userInfo;
+ (void)handleRemoteWithUrl:(NSDictionary *)userInfo;
+ (void)showNitifyOnWebWithUrl:(NSString *)url;

@end
