//
//  XSJLocalNotificationMgr.m
//  jianke
//
//  Created by xiaomk on 16/7/29.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJLocalNotificationMgr.h"
#import "DateHelper.h"
#import "ImDataManager.h"

@implementation XSJLocalNotificationMgr

+ (void)registerLoaclNotification{
    
//    1、	兼客用户未打开兼客兼职APP，已有7天、15天、30天、45天、60天。
//    兼客兼客APP在第8天、第16天、第31天、第46天、第61天的晚上21：00进行本地推送。
    
    NSDate *todayDate = [DateHelper zeroTimeOfToday];
    todayDate = [todayDate dateByAddingHours:21];
    
    NSDate *date1 = [todayDate dateByAddingDays:7];
    NSDate *date2 = [todayDate dateByAddingDays:15];
    NSDate *date3 = [todayDate dateByAddingDays:30];
    NSDate *date4 = [todayDate dateByAddingDays:45];
    NSDate *date5 = [todayDate dateByAddingDays:60];
    
    [self addLocalNotificationWithFireDate:date1];
    [self addLocalNotificationWithFireDate:date2];
    [self addLocalNotificationWithFireDate:date3];
    [self addLocalNotificationWithFireDate:date4];
    [self addLocalNotificationWithFireDate:date5];

//    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:60.f];
//    [self addLocalNotificationWithFireDate:fireDate];
    
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    dateStr = [NSString stringWithFormat:@"%@ 00:00:00", dateStr];
//    return [formatter dateFromString:dateStr];
    
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *testDate = [formatter dateFromString:dateStr];
//    NSAssert(testDate != nil, @"testDate = nil");
//    
//    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
//    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:testDate];
    
//    [dateComponents setHour:7];
//    
//    NSDate *fireDate = [calender dateFromComponents:dateComponents];

}

+ (void)addLocalNotificationWithFireDate:(NSDate *)fireDate{
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //设置调用时间
    notification.fireDate = fireDate;
//    ELog(@"fireDate : %@",fireDate);
    
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    
    // 设置重复的间隔
//    notification.repeatInterval = kCFCalendarUnitSecond;
//    notification.repeatCalendar = [NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
//    notification.repeatInterval = 3;//通知重复次数
//    notification.repeatInterval = kCFCalendarUnitWeekOfMonth;//循环通知的周期

    if ([[ImDataManager sharedInstance] getUnreadMsgCount] > 0) {
        notification.applicationIconBadgeNumber = [[ImDataManager sharedInstance] getUnreadMsgCount];
    }else{
        notification.applicationIconBadgeNumber = 1;
    }
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    //设置通知属
    notification.alertBody = [self randomMsg];
    notification.alertAction = @"打开应用";                          //待机界面的滑动动作提示
    notification.userInfo = @{@"localNotificationType":@(LocalNotifTypeRepeatNotify)};              //绑定到通知上的其他附加信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

}

+ (NSString *)randomMsg{
    u_int32_t random = arc4random();
    int i = random%6;
//    ELog(@"random : %d  -  i : %d",random, i);
    switch (i) {
        case 0:
            return @"［兼客兼职］全新的兼职体验等你来！";
        case 1:
            return @"［兼客兼职］雇主想你了，回来看看吧！";
        case 2:
            return @"［兼客兼职］5分钟？够赚2个宅任务的钱了！";
        case 3:
            return @"［兼客兼职］有雇主在你附近发布了新的岗位，来看看吧！";
        case 4:
            return @"［兼客兼职］月光了？不怕！来兼客先领钱后兼职！";
        case 5:
            return @"［兼客兼职］兼职，我和你，最美好的相遇。";
        default:
            return @"［兼客兼职］闲暇时间，去兼职吧！";
    }
}




+ (void)registerLocalNotificationWithImMessage:(ImPacket *)packet{
    [self registerLocalNotificationWithImMessage:packet isShowInIM:YES notifType:LocalNotifTypeText];
}

//
//+ (void)registerLocalNotificationWithImMessage:(ImPacket *)packet isShowInIM:(BOOL)isShowInIm{
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.soundName = UILocalNotificationDefaultSoundName;
//
//    if ([[ImDataManager sharedInstance] getUnreadMsgCount] > 0) {
//        if (isShowInIm) {
//            notification.applicationIconBadgeNumber = [[ImDataManager sharedInstance] getUnreadMsgCount];
//        }else{
//            notification.applicationIconBadgeNumber = [[ImDataManager sharedInstance] getUnreadMsgCount] + 1;
//        }
//    }
//    
//    NSDictionary *msgDic = [packet.dataObj keyValues];
//    ELog(@"===msgDic : %@", msgDic);
//    if (msgDic && packet.dataObj.content) {
//        [msgDic setValue:@"ImMessage" forKey:@"localNotificationType"];
//        //设置通知属
//        notification.alertBody = packet.dataObj.notifyContent;
//        notification.alertAction = @"打开应用";                          //待机界面的滑动动作提示
//        notification.userInfo = msgDic;              //绑定到通知上的其他附加信息
//        
//        //调用通知
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }
//}

+ (void)registerLocalNotificationWithImMessage:(ImPacket *)packet isShowInIM:(BOOL)isShowInIm notifType:(LocalNotifType)type{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    if ([[ImDataManager sharedInstance] getUnreadMsgCount] > 0) {
        if (isShowInIm) {
            notification.applicationIconBadgeNumber = [[ImDataManager sharedInstance] getUnreadMsgCount];
        }else{
            notification.applicationIconBadgeNumber = [[ImDataManager sharedInstance] getUnreadMsgCount] + 1;
        }
    }
    
    NSDictionary *msgDic = [packet.dataObj keyValues];
    ELog(@"===msgDic : %@", msgDic);
    if (msgDic && packet.dataObj.content) {
        [msgDic setValue:@(type) forKey:@"localNotificationType"];
        if (type == LocalNotifTypeUrl) {
            ImSystemMsg *message = [packet.dataObj getMessageContent];
            [msgDic setValue:message.open_url forKey:@"openUrl"];
            [msgDic setValue:message.message_id forKey:@"messageId"];
        }
        //设置通知属
        notification.alertBody = packet.dataObj.notifyContent;
        notification.alertAction = @"打开应用";                          //待机界面的滑动动作提示
        notification.userInfo = msgDic;              //绑定到通知上的其他附加信息
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - ***** 移除本地通知 ******
/** 移除指定的本地通知 */
+ (void)cancelLocalNotificationWithKey:(NSString *)key{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}
/** 移除全部的本地通知 */
+ (void)removeAllLocalNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
