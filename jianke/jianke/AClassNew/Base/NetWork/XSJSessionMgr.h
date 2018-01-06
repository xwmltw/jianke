//
//  XSJSessionMgr.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSJSessionMgr : NSObject

+ (instancetype)sharedInstance;

- (NSString *)getLatestSessionId;
- (void)setLatestSessionId:(NSString *)sessionId;

@end
