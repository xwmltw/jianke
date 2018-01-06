//
//  XSJSessionMgr.m
//  Jiankeplus
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "XSJSessionMgr.h"
#import "XSJConst.h"

#define NSUSerDefaults_WdCacheMgr_latestSessionId @"NSUSerDefaults_WdCacheMgr_latestSessionId"

@interface XSJSessionMgr(){
    
}
@property (nonatomic, copy) NSString *latestSessionId;

@end

@implementation XSJSessionMgr
Impl_SharedInstance(XSJSessionMgr);


- (NSString *)getLatestSessionId{
    if (!_latestSessionId || _latestSessionId.length == 0) {
        _latestSessionId = [WDUserDefaults stringForKey:NSUSerDefaults_WdCacheMgr_latestSessionId];
    }
    return _latestSessionId;
}

- (void)setLatestSessionId:(NSString *)sessionId{
    _latestSessionId = sessionId;
    [WDUserDefaults setObject:_latestSessionId forKey:NSUSerDefaults_WdCacheMgr_latestSessionId];
    [WDUserDefaults synchronize];
}



@end
