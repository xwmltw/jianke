//
//  NetHelper.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "NetBase.h"
#import "ResponseInfo.h"
#import "RequestInfo.h"
#import "XSJConst.h"


#define G_ENCTYPE 2           //0不加密不压缩   2加密压缩pkcs7padding

#ifdef DEBUG
#define OPEN_SERVER_LOG 1
#endif

//打包渠道 标识符
#define JKAPP_PLATFORM @"AppStore"
//#define JKAPP_PLATFORM @"thirdparty_91"
//#define JKAPP_PLATFORM @"thirdparty_tongBuTui"

#ifdef DEBUG
//外网正式
//static NSString * const URL_Server        = @"https://api.jianke.cc/openapi/1";
//static NSString * const URL_TscServer     = @"https://tsc.jianke.cc/openapi/1";
//static NSString * const URL_PicServer     = @"https://idc.jianke.cc/openapi/1";
//static NSString * const URL_IMServer      = @"https://im.jianke.cc/openapi/1";
//static NSString * const URL_HttpServer    = @"https://m.jianke.cc";
//static NSString * const URL_CRMServer     = @"https://crm.jianke.cc";
//static NSString * const URL_ZhaiTaskHttp  = @"https://zhongbao.jianke.cc";
//=============================================================

//外网测试
static NSString * const URL_Server          = @"http://www.shijianke.com/openapi/1";
static NSString * const URL_TscServer       = @"http://tsc.shijianke.com/openapi/1";
static NSString * const URL_PicServer       = @"http://idc.shijianke.com/openapi/1";
static NSString * const URL_IMServer        = @"http://im.shijianke.com/openapi/1";
static NSString * const URL_HttpServer      = @"http://www.shijianke.com";
static NSString * const URL_CRMServer       = @"http://crm.shijianke.com";
static NSString * const URL_ZhaiTaskHttp    = @"http://zhongbao.shijianke.com";
//=============================================================

//内网测试 153
//static NSString * const URL_Server          = @"http://192.168.5.153:8004/openapi/1";
//static NSString * const URL_TscServer       = @"http://192.168.5.153:8004/openapi/1";
//static NSString * const URL_PicServer       = @"http://192.168.5.153:8002/openapi/1";
//static NSString * const URL_IMServer        = @"http://192.168.5.153:8008/openapi/1";
//static NSString * const URL_HttpServer      = @"http://192.168.5.153:8004";
//static NSString * const URL_CRMServer       = @"http://192.168.5.153:8004";
//static NSString * const URL_ZhaiTaskHttp    = @"http://192.168.5.153:8004";
//=============================================================

//static NSString * const URL_ServerIP1   = @"http://121.40.90.159:7074/openapi/1";
//static NSString * const URL_ServerIP2   = @"http://121.40.90.159:8004/openapi/1";
//static NSString * const URL_TscServerIP = @"http://121.40.157.107:8001/openapi/1";
//static NSString * const URL_IMServerIP  = @"http://121.40.157.118:8008/openapi/1";
//static NSString * const URL_PicServerIP = @"http://121.40.157.107:8002/openapi/1";

//外网正式IP版本
//static NSString * const URL_Server      = @"http://121.40.90.159:7074/openapi/1";
//static NSString * const URL_TscServer   = @"http://121.40.157.109:8001/openapi/1";
//static NSString * const URL_PicServer   = @"http://121.40.157.107:8002/openapi/1";
//static NSString * const URL_IMServer    = @"http://121.40.157.118:8008/openapi/1";
//static NSString * const URL_HttpServer  = @"http://m.jianke.cc";

#else
/** 正式地址*/
static NSString * const URL_Server        = @"https://api.jianke.cc/openapi/1";
static NSString * const URL_TscServer     = @"https://tsc.jianke.cc/openapi/1";
static NSString * const URL_PicServer     = @"https://idc.jianke.cc/openapi/1";
static NSString * const URL_IMServer      = @"https://im.jianke.cc/openapi/1";
static NSString * const URL_HttpServer    = @"https://m.jianke.cc";
static NSString * const URL_CRMServer     = @"https://crm.jianke.cc";
static NSString * const URL_ZhaiTaskHttp  = @"https://zhongbao.jianke.cc";
#endif

@interface NetHelper : NetBase <NSURLConnectionDataDelegate>

+ (void)sendRequest:(RequestInfo*)request;

- (void)postRequest:(NSString*)urlStr andParam:(NSString*)param withResponseBlock:(OnResponseBlock)responseBlock;
- (void)postRequest:(NSString*)urlStr andData:(NSData*)data withResponseBlock:(OnResponseBlock)responseBlock;

+ (void)setErrorCode:(long)code;

@end
