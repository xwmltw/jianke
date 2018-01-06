//
//  RequestInfo.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ResponseInfo;

typedef void (^OnResponseBlock)(id response);

@interface RequestInfo : NSObject

@property (nonatomic, copy) NSString *loadingMessage;
@property (nonatomic, assign) BOOL isShowLoading;
@property (nonatomic, assign) BOOL isShowErrorMsg;
@property (nonatomic, assign) BOOL isShowErrorMsgAlertView;
@property (nonatomic, assign) BOOL isShowNetworkErrorMsg;

@property (nonatomic, assign) BOOL isContentContainBracket;

@property (nonatomic, copy) NSString *service;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSData      *data;
@property (nonatomic, copy) NSString    *url;
@property (nonatomic, strong) OnResponseBlock resBlock;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) long seq;
@property (nonatomic, assign) BOOL forceSeq;    /*!< 协商阶段seq为0 */

/** 协议栈 */
@property (nonatomic, assign) BOOL isToStackServer;
@property (nonatomic, copy) NSString *stackParam;


- (instancetype)initWithService:(NSString*)service andContent:(NSString*)content;
- (void)sendRequestToImServer:(OnResponseBlock)block;
- (void)sendRequestWithResponseBlock:(OnResponseBlock)block;
- (void)fillData;
- (NSString *)getRequestParam;



- (void)uploadData:(NSData *)upLoadData andBlock:(OnResponseBlock)block suffix:(NSString*)suffix;
- (void)uploadImage:(UIImage*)image andBlock:(OnResponseBlock)block;
- (void)uploadImage:(UIImage*)image isShowLoding:(BOOL)isShowLoading andBlock:(OnResponseBlock)block;
- (void)uploadVoice:(NSData*)data andBlock:(OnResponseBlock)block;
- (void)uploadVideo:(NSData *)video isShowLoding:(BOOL)isShowLoading andBlock:(OnResponseBlock)block;

/**
 * 下载文件
 *
 * @param string aUrl 请求文件地址
 * @param string aSavePath 保存地址
 * @param string aFileName 文件名
 * @param int aTag tag标识
 */
+ (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName andBlock:(OnResponseBlock)block;

@end
