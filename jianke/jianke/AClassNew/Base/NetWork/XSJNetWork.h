//
//  XSJNetWork.h
//  jianke
//
//  Created by xiaomk on 16/1/26.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetHelper.h"
#import "WDConst.h"

@interface XSJNetWork : NSObject

+ (XSJNetWork*)sharedInstance;

+ (NSString *)getAESKey;
+ (NSString *)getSignKey;
+ (NSString *)getChallenge;
+ (NSString *)getToken;
+ (NSData *)getTokenData;
+  (void)clearToken;

+ (void)changeToken;

- (void)createSession:(OnResponseBlock)block;

- (void)postASynRequestWitService:(NSString*)service andContent:(NSString*)content withResponseBlock:(OnResponseBlock)responseBlock;

- (void)autoLoginWithBlock:(OnResponseBlock)block;

@end


