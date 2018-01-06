//
//  XSJUserNotificationMgr.m
//  jianke
//
//  Created by yanqb on 2016/11/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJUserNotificationMgr.h"
#import <UserNotifications/UserNotifications.h>
#import "NSDate+DateTools.h"
#import "DateHelper.h"
#import "UserData.h"
#import "ImDataManager.h"

@implementation XSJUserNotificationMgr
+ (void)registerLoaclNotificationWithImMessage:(ImPacket *)packet isShowInIM:(BOOL)isShowInIm notifType:(LocalNotifType)notifType{
    
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    NSDictionary *msgDic = [packet.dataObj keyValues];
    ELog(@"===msgDic : %@", msgDic);
    if (msgDic && packet.dataObj.content) {
        [msgDic setValue:@(notifType) forKey:@"localNotificationType"];
        if (notifType == LocalNotifTypeUrl) {
            ImSystemMsg *message = [packet.dataObj getMessageContent];
            [msgDic setValue:message.open_url forKey:@"openUrl"];
            [msgDic setValue:message.message_id forKey:@"messageId"];
        }
        //设置通知属
        notificationContent.body = packet.dataObj.notifyContent;
        notificationContent.userInfo = msgDic;              //绑定到通知上的其他附加信息
        
        //注册通知
        
    }
    
    //通知显示时间
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    
    if ([[ImDataManager sharedInstance] getUnreadMsgCount] > 0) {
        if (isShowInIm) {
            notificationContent.badge = @([[ImDataManager sharedInstance] getUnreadMsgCount]);
        }else{
            notificationContent.badge = @([[ImDataManager sharedInstance] getUnreadMsgCount] + 1);
        }
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"IMLocalNotification" content:notificationContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}


+ (void)registerLoaclNotification{
    NSDate *todayDate = [DateHelper zeroTimeOfToday];
    todayDate = [todayDate dateByAddingHours:21];
    
    if (![[UserData sharedInstance] getIsHasOpen]) { //第一次打开app
        [[UserData sharedInstance] setIsHasOpen:YES];
        
        NSDate *date1 = [todayDate dateByAddingDays:1];
        NSDate *date2 = [todayDate dateByAddingDays:2];
        NSDate *date3 = [todayDate dateByAddingDays:3];
        
        [self addNotificationWithDate:date1 withTitle:@"兼客兼职" body:@"在线找兼职，高薪不是梦" type:LocalNotifTypeJustOpen identifier:@"localNotificationInstalledAfter1"];
        [self addNotificationWithDate:date2 withTitle:@"兼客众包" body:@"有部手机，动动手指赚点零花钱" type:LocalNotifTypeZhongBao  identifier:@"localNotificationInstalledAfter1"];
        [self addNotificationWithDate:date3 withTitle:@"高端兼职通告" body:@"礼仪、模特、商演，只给合适的你" type:LocalNotifTypeJKhire identifier:@"localNotificationInstalledAfter1"];
    }
    
    NSDate *date1 = [todayDate dateByAddingDays:7];
    NSDate *date2 = [todayDate dateByAddingDays:15];
    NSDate *date3 = [todayDate dateByAddingDays:30];
    NSDate *date4 = [todayDate dateByAddingDays:45];
    NSDate *date5 = [todayDate dateByAddingDays:60];
    
    [self addLocalNotificationWithFireDate:date1 withIdentifier:@"repeatNotify111"];
    [self addLocalNotificationWithFireDate:date2 withIdentifier:@"repeatNotify222"];
    [self addLocalNotificationWithFireDate:date3 withIdentifier:@"repeatNotify333"];
    [self addLocalNotificationWithFireDate:date4 withIdentifier:@"repeatNotify444"];
    [self addLocalNotificationWithFireDate:date5 withIdentifier:@"repeatNotify555"];
}

+ (void)addLocalNotificationWithFireDate:(NSDate *)fireDate withIdentifier:(NSString *)identifier{
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.title = @"兼客兼职";
    notificationContent.body = [self randomMsg];
    NSInteger budgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    notificationContent.badge = @((budgeNum++));
    
    notificationContent.userInfo = @{@"localNotificationType":@(LocalNotifTypeRepeatNotify)};
    
    NSTimeInterval timeInterval = fireDate.timeIntervalSinceNow;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:notificationContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

+ (void)addNotificationWithDate:(NSDate *)date withTitle:(NSString *)title body:(NSString *)body type:(LocalNotifType)type identifier:(NSString *)identifier{
    
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.title = title;
    notificationContent.body = body;
    NSInteger budgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    notificationContent.badge = @((budgeNum++));
    
    notificationContent.userInfo = @{@"localNotificationType":@(type)};
    
    NSTimeInterval timeInterval = date.timeIntervalSinceNow;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:notificationContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

+ (NSString *)randomMsg{
    u_int32_t random = arc4random();
    int i = random%6;
    //    ELog(@"random : %d  -  i : %d",random, i);
    switch (i) {
        case 0:
            return @"全新的兼职体验等你来！";
        case 1:
            return @"雇主想你了，回来看看吧！";
        case 2:
            return @"5分钟？够赚2个宅任务的钱了！";
        case 3:
            return @"有雇主在你附近发布了新的岗位，来看看吧！";
        case 4:
            return @"月光了？不怕！来兼客先领钱后兼职！";
        case 5:
            return @"兼职，我和你，最美好的相遇。";
        default:
            return @"闲暇时间，去兼职吧！";
    }
}

@end
