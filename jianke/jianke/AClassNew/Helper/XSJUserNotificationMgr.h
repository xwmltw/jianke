//
//  XSJUserNotificationMgr.h
//  jianke
//
//  Created by yanqb on 2016/11/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSJLocalNotificationMgr.h"

@interface XSJUserNotificationMgr : NSObject

+ (void)registerLoaclNotification;
+ (void)registerLoaclNotificationWithImMessage:(ImPacket *)packet isShowInIM:(BOOL)isShowInIm notifType:(LocalNotifType)notifType;
@end
