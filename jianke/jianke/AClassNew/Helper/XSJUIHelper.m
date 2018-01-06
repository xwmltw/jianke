//
//  XSJUIHelper.m
//  jianke
//
//  Created by xiaomk on 16/4/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJUIHelper.h"
#import <StoreKit/StoreKit.h>
#import "MKUIHelper.h"
#import "XSJConst.h"
#import "XSJUIHelper.h"
#import "UIHelper.h"
#import "TalkToBoss_VC.h"
#import "WdLoadingView.h"

#import "JKHome_VC.h"
#import "IMHome_VC.h"
#import "JobDetailMgr_VC.h"

#import "MainTabBarCtlMgr.h"

@interface XSJUIHelper()<SKStoreProductViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation XSJUIHelper
Impl_SharedInstance(XSJUIHelper)

#pragma mark - ***** JK EP switch ******

+ (void)showMainScene:(BOOL)isNewMethod block:(MKBlock)block{
    NSNumber *loginType = [[UserData sharedInstance] getLoginType];
    if (loginType.integerValue == WDLoginType_Employer) {
        if (isNewMethod) {
            [[UserData sharedInstance] setLoginType:[NSNumber numberWithInteger:WDLoginType_Employer]];
            [[MainTabBarCtlMgr sharedInstance] creatEPTabbar:block];
        }else{
            [self switchIsToEP:YES];
        }
    }else{
        if (isNewMethod) {
            [[UserData sharedInstance] setLoginType:[NSNumber numberWithInteger:WDLoginType_JianKe]];
            [[MainTabBarCtlMgr sharedInstance] creatJKTabbar:block];
        }else{
            [self switchIsToEP:NO];
        }
    }
}

+ (void)showMainScene{
    [self showMainScene:NO block:nil];
}

+ (void)switchIsToEP:(BOOL)isToEP{
    if (isToEP) {
        [[UserData sharedInstance] setLoginType:[NSNumber numberWithInteger:WDLoginType_Employer]];
        [[MainTabBarCtlMgr sharedInstance] creatEPTabbar];
    }else{
        [[UserData sharedInstance] setLoginType:[NSNumber numberWithInteger:WDLoginType_JianKe]];
        [[MainTabBarCtlMgr sharedInstance] creatJKTabbar];
    }

}

+ (void)switchRequestIsToEP:(BOOL)isToEP{
    if ([[UserData sharedInstance] isLogin]) {
        NSInteger toType = isToEP ? WDLoginType_Employer : WDLoginType_JianKe;
        NSString* content = [NSString stringWithFormat:@"user_type:\"%ld\"",(long)toType];
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_switchUserType" andContent:content];
        request.isShowLoading = NO;
        WEAKSELF
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            [weakSelf switchAnimationToEP:isToEP];
        }];
    }else{
        [self switchAnimationToEP:isToEP];
    }
}

+ (void)switchAnimationToEP:(BOOL)isToEP{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self switchIsToEP:isToEP];
        [UIHelper showSwitchAnimationWindowIsToEP:isToEP];
    });
}






















#pragma mark - ***** toast alert ******

+ (void)showToast:(NSString*)message{
    [self showToast:message inView:[MKUIHelper getCurrentRootViewController].view];
}

+ (void)showToast:(NSString *)message inView:(UIView *)view{
    if (!view) {
        return;
    }
    [view makeToast:message];
}


+ (void)showConfirmWithView:(UIView*)view msg:(NSString*)msg title:(NSString*)title cancelBtnTitle:(NSString*)cancelTitle okBtnTitle:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion{
    
    DLAVAlertView* exportAlertView = [[DLAVAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    exportAlertView.contentView = view;
    [exportAlertView showWithCompletion:completion];
}

+ (void)showDatePickerConfirmTitle:(NSString*)title msg:(NSString*)msg  cancelBtnTitle:(NSString*)cancelTitle okBtnTitle:(NSString*)okTitle DPCompletion:(HHDatePickerAlertViewCompletionHandler)DPCompletion{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置 为中文
    datePicker.locale = locale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [datePicker setDate:[NSDate date]];
    
    DLAVAlertView* exportAlertView = [[DLAVAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    exportAlertView.contentView = datePicker;
    [exportAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (DPCompletion) {
            DPCompletion(alertView, buttonIndex, datePicker);
        }
    }];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message okBtnTitle:(NSString *)btnTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:btnTitle
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - ***** 显示 引导评价 弹窗 ******
- (void)showCommentAlertWithVC:(UIViewController*)rootVc{
    
    NSInteger showTime = [WDUserDefaults integerForKey:WDUserDefault_openAppTime];
    
    if (showTime == 4) {     //已经评价过
        if (showTime) {
            showTime += 1;
        }else{
            showTime = 1;
        }
        [WDUserDefaults setInteger:showTime forKey:WDUserDefault_openAppTime];
        [WDUserDefaults synchronize];
        
        DLAVAlertView* alertView = [[DLAVAlertView alloc] initWithTitle:@"意见反馈" message:@"新版兼客体验如何?\n我们十分在意您的反馈，告诉我们吧！\n感谢您的支持。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我要吐槽", @"以后再说",nil];
        [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            ELog(@"buttonIndex:%ld",(long)buttonIndex);
            
            if (buttonIndex == 1) {
                return ;
            }else if (buttonIndex == 0){
                TalkToBoss_VC *talkVc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_TalkToBoss"];
                talkVc.hidesBottomBarWhenPushed = YES;
                [rootVc.navigationController pushViewController:talkVc animated:YES];
            }
        }];
    }
}


- (void)showAppCommentAlertWithViewController:(UIViewController*)rootVc{
    
    NSInteger showTime = [WDUserDefaults integerForKey:WDUserDefault_jobDetailTime];
    if (showTime) {
        showTime += 1;
    }else{
        showTime = 1;
    }
    [WDUserDefaults setInteger:showTime forKey:WDUserDefault_jobDetailTime];
    [WDUserDefaults synchronize];

    if (showTime == 9) {
        WEAKSELF
        DLAVAlertView* alertView = [[DLAVAlertView alloc] initWithTitle:@"我们十分在意您的反馈，我们一定会最大程度的去满足您的需求，请给我们一点点鼓励" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"以后再说",@"我要吐槽",@"五星好评鼓励一下", nil];
        [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            ELog(@"buttonIndex:%ld",(long)buttonIndex);
            
            if (buttonIndex == 0) {
                return ;
            }else if (buttonIndex == 1){
                TalkToBoss_VC *talkVc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_TalkToBoss"];
                [rootVc.navigationController pushViewController:talkVc animated:YES];
            }else if (buttonIndex == 2){
                [weakSelf evaluateWithViewController:rootVc];
            }
        }];
    }
}

#pragma mark - ***** AppStore 给软件评分 ******
- (void)evaluateWithViewController:(UIViewController*)rootVc{

    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil) {
        //低于iOS6的系统版本没有这个类,不支持这个功能
        WDLoadingView* loadView = (WDLoadingView *)[WDLoadingView initAnimation];
        loadView.labelText = @"加载中...";
        [rootVc.view addSubview:loadView];
        
        SKStoreProductViewController *spVC = [[SKStoreProductViewController alloc] init];
        [spVC.view setFrame:SCREEN_BOUNDS];
        spVC.delegate = self;
        [spVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : kJianke_appID} completionBlock:^(BOOL result, NSError * _Nullable error) {
            [loadView removeFromSuperview];
            if(error){
                [UIHelper toast:@"请重试"];
                ELog(@"error %@ with userInfo %@",error,[error userInfo]);
            }else{
                //模态弹出appstore
                [rootVc presentViewController:spVC animated:YES completion:nil];
            }
        }];
    }else{
        NSString *string = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@?l=zh&mt=8",kJianke_appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

#pragma mark - ***** SKStoreProductViewControllerDelegate ******
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

//static UIWindow * warnWindow;
//+ (UIView*)getShowView{
//    if (!warnWindow) {
//        warnWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        warnWindow.windowLevel = UIWindowLevel_myInfo;
//    }
//    warnWindow.hidden = NO;
//    return warnWindow;
//    //    return [MKUIHelper getCurrentRootViewController].view;
//    //    return [MKUIHelper getCurrentRootViewController].navigationController.view;
//}
@end
