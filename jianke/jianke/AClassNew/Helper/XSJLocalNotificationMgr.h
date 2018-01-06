//
//  XSJLocalNotificationMgr.h
//  jianke
//
//  Created by xiaomk on 16/7/29.
//  Copyright © 2016年 xianshijian. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LocalNotifType) {
    LocalNotifTypeText = 1,
    LocalNotifTypeUrl,
    LocalNotifTypeJustOpen, //以下三种是3.1.2首次安装的需求
    LocalNotifTypeZhongBao,
    LocalNotifTypeJKhire,
    LocalNotifTypeRepeatNotify,
};

@class ImPacket;
NS_CLASS_DEPRECATED_IOS(4_0, 10_0, "10系统请使用新API:XSJUserNotificationMgr类")
@interface XSJLocalNotificationMgr : NSObject

+ (void)registerLoaclNotification;
+ (void)registerLocalNotificationWithImMessage:(ImPacket *)packet;
+ (void)registerLocalNotificationWithImMessage:(ImPacket *)packet isShowInIM:(BOOL)isShowInIm notifType:(LocalNotifType)type;
+ (void)removeAllLocalNotification;


@end
