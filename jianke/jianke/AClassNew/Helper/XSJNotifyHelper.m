//
//  XSJNotifyHelper.m
//  jianke
//
//  Created by fire on 16/9/10.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJNotifyHelper.h"
#import "AppDelegate.h"
#import "WebView_VC.h"
#import "XSJLocalNotificationMgr.h"
#import "MainTabBarCtlMgr.h"
#import "MKUIHelper.h"
#import "Login_VC.h"

@implementation XSJNotifyHelper

+ (void)handleLocalNotification:(NSDictionary *)userInfo{
    if (userInfo) {
        NSInteger type = [[userInfo valueForKey:@"localNotificationType"] integerValue];
        if (type) {
            switch (type) {
                case LocalNotifTypeText:{
                    NSString *toType = [userInfo valueForKey:@"toType"];
                    if (toType.integerValue == [[UserData sharedInstance] getLoginType].integerValue) {
                        [[MainTabBarCtlMgr sharedInstance] setSelectMsgTab];
                    }else{
                        if (toType.integerValue == WDLoginType_Employer) {
                            [XSJUIHelper switchRequestIsToEP:YES];
                        }else{
                            [XSJUIHelper switchRequestIsToEP:NO];
                        }
                        [UserData delayTask:2 onTimeEnd:^{
                            [[MainTabBarCtlMgr sharedInstance] setSelectMsgTab];
                        }];
                    }
                }
                    break;
                case LocalNotifTypeUrl:{    //处理URL
                    ELog(@"处理链接");
                    [self handleRemoteWithUrl:userInfo];
                }
                    break;
                case LocalNotifTypeJustOpen:{   //打开app 不处理
                    
                }
                    break;
                case LocalNotifTypeZhongBao:{   //跳转众包
                    [self showNitifyOnWebWithUrl:KUrl_zhongbao block:nil];
                }
                    break;
                case LocalNotifTypeJKhire:{
                    ELog(@"跳转到个人服务页面");
                    [self showNitifyOnWebWithUrl:@"http://m.shijianke.com/m/servicePersonal/toServicePersonalPage.html" block:nil];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

+ (void)handleRemoteWithUrl:(NSDictionary *)userInfo{
    if (!userInfo) {
        return;
    }
    //jpush推送
    NSString *jpushExtrasFlag = [userInfo valueForKey:@"flg"];
    if (jpushExtrasFlag) {
        switch (jpushExtrasFlag.integerValue) {
            case 1:{
                NSString *jpushExtrasUrl = [userInfo valueForKey:@"url"];
                [self showNitifyOnWebWithUrl:jpushExtrasUrl block:nil];
            }
                break;
        }
        return;
    }
    
    [self handleRemoteWithUrl:userInfo clickBlock:^(NSString *messageId) {
        ELog(@"发送message_id");
        [[XSJRequestHelper sharedInstance] noticeBoardPushLogClickRecord:messageId block:^(id result) {
            
        }];
    }];
    
}

+ (void)handleRemoteWithUrl:(NSDictionary *)userInfo clickBlock:(MKBlock)clickBlock{
    if (!userInfo) {
        return;
    }
    //rc推送 app内打开
    [self updateBudgeIcon:1];
    NSString *response = [userInfo objectForKey:@"appData"]; //融云扩展字段,不可改
    if (!response) {
        return;
    }
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return;
    }
    NSNumber *noticeType = [dic objectForKey:@"notice_type"];
    switch (noticeType.integerValue) {
        case WdSystemNoticeType_noticeBoardMessage:{
            NSString *url = [dic objectForKey:@"open_url"];
            NSString *messageId = [dic objectForKey:@"message_id"];
            [self showNitifyOnWebWithUrl:url block:^(id result) {
                if (messageId) {
                    MKBlockExec(clickBlock, messageId);
                }
            }];
            
        }
            break;
        default:{
            [self switchToImPage];
        }
            break;
    }

}

+ (void)showNitifyOnWebWithUrl:(NSString *)url block:(MKBlock)block{
    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
    if (viewCtrl && viewCtrl.navigationController && url) {
        WebView_VC *webVc = [[WebView_VC alloc] init];
        webVc.url = url;
        webVc.hidesBottomBarWhenPushed = YES;
        [viewCtrl.navigationController pushViewController:webVc animated:YES];
        MKBlockExec(block, nil);
    }
}

+ (void)showNitifyOnWebWithUrl:(NSString *)url{
    [self showNitifyOnWebWithUrl:url block:nil];
}

+ (void)switchToImPage{
    [[XSJRequestHelper sharedInstance] activateAutoLoginWithBlock:^(id result) {
        if (result) {
            [[MainTabBarCtlMgr sharedInstance] setSelectMsgTab];
        }else{
            if (![[UserData sharedInstance] isLogin]) {
                [self showLoginVC];
            }
        }
    }];
}

+ (void)showLoginVC{
    Login_VC* loginVC = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
    MainNavigation_VC* vc = [[MainNavigation_VC alloc] initWithRootViewController:loginVC];
    loginVC.blcok = ^(id result){
        if (result) {
            [[MainTabBarCtlMgr sharedInstance] setSelectMsgTab];
        }
    };
    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
    if (viewCtrl) {
        [viewCtrl presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

//+ (UIViewController *)getCurrentVC{
////    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
////    if (appDelegate.currentViewCtrl && appDelegate.currentViewCtrl.navigationController) {
////        return appDelegate.currentViewCtrl;
////    }else{
////        return appDelegate.currentViewCtrl;
////    }
//    UIViewController *viewCtrl = [MKUIHelper getCurrentRootViewController];
//    if ([viewCtrl isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabVC = (UITabBarController *)viewCtrl;
//        UIViewController *VC = [tabVC selectedViewController];
//    }
//    return nil;
//}

+ (void)updateBudgeIcon:(NSInteger)count{
    NSInteger budgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber - count;
    if (budgeCount < 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = budgeCount;
    }
}

@end
