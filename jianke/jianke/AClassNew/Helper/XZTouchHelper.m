//
//  XZTouchHelper.m
//  jianke
//
//  Created by yanqb on 2017/3/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "XZTouchHelper.h"
#import "MKUIHelper.h"

#import "WebView_VC.h"
#import "ParttimeJobList_VC.h"
#import "Login_VC.h"

@implementation XZTouchHelper

+ (void)openWithApplicationcutItem:(UIApplicationShortcutItem *)shortcutItem{
    if (!shortcutItem) {
        return;
    }
    
    if ([shortcutItem.type isEqualToString:@"one"]) {
        ELog(@"进入找通告");
        [self openWithTouchActionType:UITouchActionType_findNotice];
    }else if ([shortcutItem.type isEqualToString:@"two"]){
        ELog(@"进入在家兼职");
        [self openWithTouchActionType:UITouchActionType_zhongbao];
    }else if ([shortcutItem.type isEqualToString:@"three"]){
        ELog(@"进入全部兼职");
        [self openWithTouchActionType:UITouchActionType_allParttimeJob];
    }else if ([shortcutItem.type isEqualToString:@"four"]){
        ELog(@"进入长期兼职");
    }
}

+ (void)openWithTouchActionType:(UITouchActionType)actionType{
    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
    if (!viewCtrl || !viewCtrl.navigationController) {
        return;
    }
    switch (actionType) {
        case UITouchActionType_zhongbao:{
            WebView_VC *vc = [[WebView_VC alloc] init];
            vc.url = KUrl_zhongbao;
            vc.hidesBottomBarWhenPushed = YES;
            [viewCtrl.navigationController pushViewController:vc animated:NO];
        }
            break;
        case UITouchActionType_allParttimeJob:{
            ParttimeJobList_VC *vc = [[ParttimeJobList_VC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [viewCtrl.navigationController pushViewController:vc animated:NO];
        }
            break;
        case UITouchActionType_findNotice:{
            void (^openWebView)() = ^() {
                [[UserData sharedInstance] handleGlobalRMUrlWithType:GlobalRMUrlType_findServiceEntry block:^(UIViewController *vc) {
                    [viewCtrl.navigationController pushViewController:vc animated:NO];
                }];
            };
            [[UserData sharedInstance] getUserStatus:^(UserLoginStatus loginStatus) {
                switch (loginStatus) {
                    case UserLoginStatus_canAutoLogin:
                    case UserLoginStatus_loginSuccess:{
                        openWebView();
                    }
                        break;
                    case UserLoginStatus_needManualLogin:{
                        [self showLoginVC:^(id result) {
                            openWebView();
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }];
            
        }
        default:
            break;
    }
}

+ (void)showLoginVC:(MKBlock)block{
    Login_VC* loginVC = [UIHelper getVCFromStoryboard:@"Main" identify:@"sid_main_login"];
    MainNavigation_VC* vc = [[MainNavigation_VC alloc] initWithRootViewController:loginVC];
    loginVC.blcok = ^(id result){
        if (result) {
            MKBlockExec(block, nil);
        }
    };
    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
    if (viewCtrl) {
        [viewCtrl presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

@end
