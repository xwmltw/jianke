//
//  NetBase.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetBase.h"
#import "WDLoadingView.h"
#import "UIHelper.h"
#import "UserData.h"
#import "MKUIHelper.h"

@interface NetBase(){
    
}

@end

@implementation NetBase

- (instancetype)init{
    if (self = [super init]) {
        self.isShowLoading = NO;
        self.isShowServerErrorMsg = YES;
        self.loadingMessage = @"加载中...";
        self.isShowErrorMsgAlertView = NO;
        self.isShowNetworkErrorMsg = NO;
    }
    return self;
}

//static MBProgressHUD* HUD;
static WDLoadingView *loadView;

//转菊花
- (void)checkLoading:(BOOL)isEnd{
    if (!isEnd) {
        if (self.isShowLoading) {
            UIViewController *vc = [MKUIHelper getCurrentRootViewController];
            if (!vc) {
                return;
            }
            UIView *view = vc.view;
            if (!view) {
                return;
            }
            
            if (loadView == nil) {
                loadView = (WDLoadingView *)[WDLoadingView initAnimation];
            }
            [view addSubview:loadView];
            loadView.hidden = NO;
            if (self.loadingMessage) {
                loadView.labelText = self.loadingMessage;;
            }else{
                loadView.labelText = @"加载中...";
            }
        }
    }else{
        if (loadView) {
            [loadView removeFromSuperview];
            loadView = nil;
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)onBegin{
    [self checkLoading:NO];
}

- (void)onEnd{
    [self checkLoading:YES];
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.receiveData = [NSMutableData data];
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receiveData appendData:data];
}
@end
