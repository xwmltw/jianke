//
//  XZOpenUrlHelper.m
//  jianke
//
//  Created by fire on 16/9/30.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XZOpenUrlHelper.h"
#import "UserData.h"
#import "WebView_VC.h"

@implementation XZOpenUrlHelper

+ (void)openJobDetailWithblock:(MKBlock)block{
//     [[UserData sharedInstance] setJobUuid:query];
    NSString *jobUuid = [UserData sharedInstance].jobUuid;
    if (jobUuid.length < 1) {
        return;
    }
    MKBlockExec(block, jobUuid);
    [UserData sharedInstance].jobUuid = nil;
}

+ (void)showNitifyOnWebWithUrl:(NSString *)url isAppOpen:(BOOL)isAppOpen{
    if (isAppOpen) {
        UIViewController *viewCtrl = [MKUIHelper getTopViewController];
        if (viewCtrl && viewCtrl.navigationController && url) {
            WebView_VC *webVc = [[WebView_VC alloc] init];
            webVc.url = url;
            webVc.hidesBottomBarWhenPushed = YES;
            [viewCtrl.navigationController pushViewController:webVc animated:YES];
        }
    }else{
        if (url.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    
}

@end
