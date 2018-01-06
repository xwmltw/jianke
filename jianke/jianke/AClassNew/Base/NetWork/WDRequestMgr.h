//
//  WDRequestMgr.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetHelper.h"
#import "RequestInfo.h"

@interface WDRequestMgr : NSObject

@property (atomic, assign) long seq;
@property (nonatomic, assign) BOOL bNetError;

+ (WDRequestMgr*)sharedInstance;

- (void)addRequest:(RequestInfo*)request;
- (void)onNetBack:(RequestInfo*)request;
- (void)reOnNetBack:(RequestInfo*)request;
- (void)reInitSession:(RequestInfo*)request isAutoLogin:(BOOL)isAutoLogin;
- (void)clear;
- (int)getReSendCount;
//- (void)initSession:(MKBlock)block;


//+ (NSString *)getAESKey;
//+ (NSString *)getSignKey;
//+ (NSString *)getChallenge;
//+ (NSString *)getToken;
//+ (NSData *)getTokenData;

- (NSString *)bytesToHexString:(NSData *)data;
- (NSData *)hexStringToBytes:(NSString *)string;

@end
