//
//  XSJNetWork.m
//  jianke
//
//  Created by xiaomk on 16/1/26.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJNetWork.h"
#import "GZIP.h"
#import "NSData+CommonCrypto.h"
#import "NSData+NSHash.h"
#import "WDRequestMgr.h"
#import "XSJSessionMgr.h"
#import "ThirdPartAccountModel.h"

@interface XSJNetWork(){

}

@end

@implementation XSJNetWork

Impl_SharedInstance(XSJNetWork);

static BOOL     s_isSessionInitSuccess = NO;
static NSString *s_publicKey    = nil;  /*!< 公钥 unused*/

static NSString *s_encrypt_key  = @"a6ba8c1d7aedced9";
static NSString *s_sign_key     = @"cf24406101e80edd";
static NSString *s_challenge    = nil;
static NSString *s_user_token   = nil;
static NSData   *s_token        = nil;  /** 报文加密用 */

#pragma mark - ***** static arg ******
+ (NSString *)getSignKey    {return s_sign_key;}
+ (NSString *)getChallenge  {return s_challenge;}
+ (NSString *)getToken      {return s_user_token;}
+ (NSData   *)getTokenData  {return s_token;}

+ (void)changeToken{
    s_user_token = @"77777777777777777";
}

+ (NSString *)getAESKey{
    if (s_encrypt_key.length == 16) {  //需要扩展成32位的key
        s_encrypt_key = [[NSString alloc] initWithFormat:@"%@%@", s_encrypt_key, s_encrypt_key];
    }
    return s_encrypt_key;
}
#pragma mark - ***** create session ******
- (void)initStaticArg{
    s_isSessionInitSuccess = NO;
    s_publicKey = nil; /*!< 公钥 unused*/
    
    s_encrypt_key = @"a6ba8c1d7aedced9";
    s_sign_key = @"cf24406101e80edd";
    s_challenge = nil;
    s_user_token = nil;
    s_token = nil;   /** 报文加密用 */
    
    [WDRequestMgr sharedInstance].seq = 0;
}

- (void)createSession:(WdBlock_Id)block{
    ELog(@"*******************initSession Begin**********");
    [self initStaticArg];
    
    NSMutableData *tokenDate = [[NSMutableData alloc] initWithData:[@"default" dataUsingEncoding:NSUTF8StringEncoding]];
    long zero = 0;
    for (NSInteger i = tokenDate.length; i < 16; i++) {
        [tokenDate appendBytes:&zero length:1];
    }
    s_token = [[NSData alloc] initWithData:tokenDate];
    
    NSString *dataStr = @"\"content\":{}";
    NSData *data = [self makeData:dataStr];
    NSMutableData *multableDataToServer = [self getRequestDataWithData:data type:1];

    WEAKSELF
    [self postASynRequestWithUrl:URL_TscServer andParam:multableDataToServer withResponseBlock:^(ResponseInfo* response) {
        ELog(@"******************* 请求公钥回调 *******************");
        if (response && [response success]) {
            GetPublicKeyModel* model = [GetPublicKeyModel objectWithKeyValues:response.originData];
            [RsaHelper setPublicKey:model.pub_key_base64];
            [weakSelf shockHand2:block];
        }else{
            if (block) {
                block(nil);
            }
        }
    }];
}


- (void)shockHand2:(WdBlock_Id)block{
    ELog(@"******************* 开始二次握手 *******************");
    NSString *str = @"0123456789abcdefghijklmnopqrstuvwxyz_";
    NSMutableData* clientRandom = [[NSMutableData alloc] initWithCapacity:16];
    for (int i = 0; i < 16; i++) {
        char a = [str characterAtIndex:arc4random() % str.length];
        [clientRandom appendBytes:&a length:1];
    }
    
    NSString *orgResult = [[NSString alloc] initWithData:clientRandom encoding:NSUTF8StringEncoding];
    NSString *result;
    
#if G_ENCTYPE == 2
    NSData* tmpData = [RsaHelper encryptString:orgResult publicKey:s_publicKey];
    result = [[WDRequestMgr sharedInstance] bytesToHexString:tmpData];
#else
    result = orgResult;
#endif
    
    // 客户端随机数，明文是16字节随机字符串，例如a6ba8c1d7aedced9，在这里使用上一阶段得到的公钥进行加密，传输加密后的十六进制字符串
    NSString* dataStr = [NSString stringWithFormat:@"{client_random:\"%@\"}", result];
    
    NSData* data = [self makeData:dataStr];
    NSMutableData* multableDataToServer = [self getRequestDataWithData:data type:2];

    WEAKSELF
    [self postASynRequestWithUrl:URL_TscServer andParam:multableDataToServer withResponseBlock:^(ResponseInfo* response) {
        ELog(@"******************* 二次握手回调 *******************");
        if (response && [response success]) {
            ShockHand2Model *model = [ShockHand2Model objectWithKeyValues:response.originData];
            [WDRequestMgr sharedInstance].seq = [model.seq longValue];
    
            s_token = [[WDRequestMgr sharedInstance] hexStringToBytes:model.token];
            
            NSData *serverData = [[WDRequestMgr sharedInstance] hexStringToBytes:model.server_random];
            
            
            NSMutableData *data = [[NSMutableData alloc] initWithData:[orgResult dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:serverData];
            NSData *md5 = [data MD5];

            NSString *md5String = [[WDRequestMgr sharedInstance] bytesToHexString:md5];
            ELog(@"******md5string:%@", md5String);
            
            s_encrypt_key = [[md5String substringToIndex:16] uppercaseString];
            s_sign_key = [[md5String substringFromIndex:16] uppercaseString];
            
            [weakSelf onShockHandEnd:block];
        }else{
            if (block) {
                block(nil);
            }
        }
    }];
}

- (void)onShockHandEnd:(WdBlock_Id)block{
    ELog(@"************* 握手完成 请求创建Session ******");
    
    [self postASynRequestWitService:@"shijianke_createSession" andContent:nil withResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            ELog(@"************ 请求创建Session回调 session初始化完毕 *************");
            if (response && [response success]) {
                
                CreatSessionModel *model = [CreatSessionModel objectWithKeyValues:response.content];
                
                s_user_token = model.userToken; // 保存用户user_token
                s_challenge = model.challenge;
                [RsaHelper setPublicKey:model.pub_key_base64];  // 公钥的base64编码
                [[XSJSessionMgr sharedInstance] setLatestSessionId:model.sessionId];
                s_isSessionInitSuccess = YES;

                // 保存第三放账号信息
                NSArray *thirdPartyAry = [ThirdPartAccountModel objectArrayWithKeyValuesArray:response.content[@"thridPartyAccountList"]];
                if (thirdPartyAry && thirdPartyAry.count) {
                    [ThirdPartAccountModel saveThirdpartAccountsWithArray:thirdPartyAry];
                }
                MKBlockExec(block, response);
            }else{
                MKBlockExec(block, nil);
                ELog(@"*****session初始化失败！")
            }
        }
    }];
}

- (void)autoLoginWithBlock:(OnResponseBlock)block{
    NSString* userName = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    NSString* password = [[XSJUserInfoData sharedInstance] getUserInfo].password;
    
    if (userName.length > 0 && password.length > 0) {
        NSNumber* loginType = [[UserData sharedInstance] getLoginType];
        if (loginType.intValue == 0) {
            loginType = [NSNumber numberWithInt:WDLoginType_JianKe];
        }
        NSString *pass = [[[NSString stringWithFormat:@"%@%@", password, [XSJNetWork getChallenge]] MD5] uppercaseString];
        
        UserLoginPM* model = [[UserLoginPM alloc] init];
        model.username = userName;
        model.password = pass;
        model.user_type = loginType;
        NSString* content = [model getContent];
        
        [self postASynRequestWitService:@"shijianke_userLogin" andContent:content withResponseBlock:^(ResponseInfo *response) {
            if (response && [response success]) {
                [[UserData sharedInstance] setLoginStatus:YES];
                [[UserData sharedInstance] setLogoutActive:NO];
                
                NSNumber *userId = [response.content objectForKey:@"id"];
                [[XSJUserInfoData sharedInstance] savePhone:userName password:password dynamicPassword:nil];
                [[UserData sharedInstance] setUserId:userId];
                [[UserData sharedInstance] setLoginType:loginType];
                MKBlockExec(block, response);
            }else{
                MKBlockExec(block, nil);
            }
        }];
    }else{
        MKBlockExec(block, nil);
    }
}


#pragma mark - ***** 非协议栈请求接口 ******
- (void)postASynRequestWitService:(NSString*)service andContent:(NSString*)content withResponseBlock:(OnResponseBlock)responseBlock{
    if (service == nil || service.length == 0) {
        return;
    }
    NSString *dataStr = [self getRequestParamWithService:service content:content];
    
    NSData *data = [self makeData:dataStr];
    [WDRequestMgr sharedInstance].seq += 1;
    ELog(@"*****向服务端请求 seq：%ld", [WDRequestMgr sharedInstance].seq);
    NSMutableData *multableDataToServer = [self getRequestDataWithData:data type:3];

    [self postASynRequestWithUrl:URL_Server andParam:multableDataToServer withResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            MKBlockExec(responseBlock, response);
        }
    }];
}

- (NSString*)getRequestParamWithService:(NSString*)service content:(NSString *)content{
    if (service == nil || service.length == 0) {
        return nil;
    }
    
    NSString *token = s_user_token;
    NSString *sessionId = [[XSJSessionMgr sharedInstance] getLatestSessionId];
    NSString *jsonString;
    
    NSString *platformStr = [NSString stringWithFormat:@"\"access_channel_code\":\"%@\",\"client_type\":\"%@\",\"app_version_code\":\"%d\",\"package_name\":\"%@\"", JKAPP_PLATFORM, [XSJUserInfoData getClientType],[MKDeviceHelper getAppIntVersion], [MKDeviceHelper getBundleIdentifier]];
    
    NSMutableString *contenStr;
    if (content && content.length > 0) {
        contenStr = [NSMutableString stringWithFormat:@"%@",content];
        [contenStr insertString:[NSString stringWithFormat:@"%@,",platformStr] atIndex:0];
    }else{
        contenStr = [NSMutableString stringWithString:@""];
        [contenStr insertString:platformStr atIndex:0];
    }

    jsonString = [NSString stringWithFormat:@"{\"service\":\"%@\",\"sessionId\":\"%@\",\"user_token\":\"%@\",\"content\":{%@}}", service, sessionId ? sessionId : @"", token?token:@"" ,contenStr];
    ELog(@"*****XSJNetWork 向服务端发送：\n%@", jsonString);
    return jsonString;
}

- (NSData*)makeData:(NSString*)dataStr{
#if G_ENCTYPE == 0
    NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
#elif G_ENCTYPE == 1
    NSData* data = [[dataStr dataUsingEncoding:NSUTF8StringEncoding] gzippedData];
#elif G_ENCTYPE == 2
    NSData* data = [[[dataStr dataUsingEncoding:NSUTF8StringEncoding] gzippedData] encryptTextUsingKey:[XSJNetWork getAESKey]];
#endif
    return data;
}

- (NSMutableData*)getRequestDataWithData:(NSData*)data type:(int)type{
    Byte encType = G_ENCTYPE;
    NSMutableData *baowen = [[NSMutableData alloc] init];
    
    [baowen appendBytes:&type length:1];        //type
    [baowen appendBytes:&encType length:1];     //encType
    
    unsigned long long seq;
    if (type == 1 || type == 2) {
        seq = 0;
    }else{
        seq = [WDRequestMgr sharedInstance].seq;
    }
    unsigned long long seqlong = htonl((unsigned long long)seq);
    [baowen appendBytes:&seqlong length:8];
    [baowen appendData:s_token];
    
    NSData *qm = [s_sign_key dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* baowenQm = [[NSMutableData alloc] initWithData:qm];
    [baowenQm appendData:baowen];
    [baowenQm appendData:data];
    NSData *sha1 = [baowenQm SHA1];
    
    NSMutableData *multableDataToServer = [[NSMutableData alloc] initWithData:baowen];
    [multableDataToServer appendData:sha1];
    [multableDataToServer appendData:data];
    
    return multableDataToServer;

}


#pragma mark - ***** 通讯 基础方法 ******
- (void)postASynRequestWithUrl:(NSString*)urlStr andParam:(NSData*)param withResponseBlock:(OnResponseBlock)responseBlock{
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    [request setHTTPBody:param];
    
//    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) { 
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (isShowLoading) {
//                [self hidesLoadingView];
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    ELog(@"*****http error:%@",error);
                    //                [UIHelper toast:@""];
                    MKBlockExec(responseBlock, nil);
                }else{
                    //                NSInteger responseCode = [(NSHTTPURLResponse*)response statusCode];
                    //                ELog(@"*****response statu code:%ld",(long)responseCode);
                    NSMutableData* receiveData = [NSMutableData data];
                    [receiveData appendData:data];
                    
                    if (receiveData.length < 30) {
                        ELog(@"*****收到的消息长度不够：%lu", (unsigned long)receiveData.length);
                        MKBlockExec(responseBlock, nil);
                        return;
                    }
                    
                    Byte errorCode;
                    [receiveData getBytes:&errorCode length:1];
                    if (errorCode != 0) {
                        ResponseInfo* info = [[ResponseInfo alloc] init];
                        NSString* errorStr = [[NSString alloc] initWithFormat:@"%hhu",errorCode];
                        info.errCode = @(errorStr.integerValue);
                        info.errMsg = [NSString stringWithFormat:@"服务端返回错误：%@",info.errCode];
                        ELog(@"*****协议栈错误,错误码:%@",info.errCode);
                        MKBlockExec(responseBlock, nil);
                        return;
                    }
                    
                    //解密
                    Byte seq[8];
                    [receiveData getBytes:&seq range:NSMakeRange(1, 8)];
                    
                    Byte sha1[20];
                    [receiveData getBytes:(sha1) range:NSMakeRange(9, 20)];
                    
                    NSInteger jsonLength = receiveData.length - 29;
                    Byte jsonArray[(int)jsonLength];
                    [receiveData getBytes:jsonArray range:NSMakeRange(29, jsonLength)];
                    
                    NSData* jsonData = [[NSData alloc] initWithBytes:jsonArray length:jsonLength];
                    
#if G_ENCTYPE == 2
                    NSData* decrpytData = [jsonData decryptTextUsingKey:[XSJNetWork getAESKey]];
                    NSData* unzipData = [decrpytData gunzippedData];
#endif
                    if ([URL_PicServer isEqualToString:urlStr]) {
                        MKBlockExec(responseBlock, unzipData);
                        return;
                    }
                    
                    ELog(@"*****收到返回的请求service:shijianke_createSession");
                    if (!unzipData) {
                        ELog(@"*****服务端返回的数据解析成空！！！");
                        MKBlockExec(responseBlock, nil);
                        return;
                    }
                    
                    NSError* error;
                    NSDictionary* dicResponse = [NSJSONSerialization JSONObjectWithData:unzipData options:NSJSONReadingMutableLeaves error:&error];
                    if (responseBlock) {
                        ResponseInfo* info = nil;
                        if (dicResponse) {
                            info = [[ResponseInfo alloc] init];
                            info.errCode = [dicResponse objectForKey:@"errCode"];
                            info.errMsg = [dicResponse objectForKey:@"errMsg"];
                            info.originData = dicResponse;
                            
                            if (info.success) {
                                info.content = [dicResponse objectForKey:@"content"];
                                ELog(@"*****服务端返回：\n%@", dicResponse);
                            }
                            //                        else{
                            //                            ELog(@"*****服务端返回错误：%@, 错误码:%@", info.errMsg, info.errCode);
                            //                            if (info.errCode.intValue == 2 || info.errCode.intValue == 3 || info.errCode.intValue == 15) {
                            //                                ELog("***** 开始重新初始化Session");
                            //                            }
                            //                        }
                        }
                        responseBlock(info);
                    }
                    if (error) {
                        ELog(@"*****请求返还错误信息：%@", error);
                        ELog(@"*****jsonData:%@",jsonData);
                    }
                }
            });
//        });
        
    }];
    
    [dataTask resume];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (error) {
//                ELog(@"*****http error:%@",error);
////                [UIHelper toast:@""];
//                MKBlockExec(responseBlock, nil);
//            }else{
////                NSInteger responseCode = [(NSHTTPURLResponse*)response statusCode];
////                ELog(@"*****response statu code:%ld",(long)responseCode);
//                NSMutableData* receiveData = [NSMutableData data];
//                [receiveData appendData:data];
//                
//                if (receiveData.length < 30) {
//                    ELog(@"*****收到的消息长度不够：%lu", (unsigned long)receiveData.length);
//                    MKBlockExec(responseBlock, nil);
//                    return;
//                }
//                
//                Byte errorCode;
//                [receiveData getBytes:&errorCode length:1];
//                if (errorCode != 0) {
//                    ResponseInfo* info = [[ResponseInfo alloc] init];
//                    NSString* errorStr = [[NSString alloc] initWithFormat:@"%hhu",errorCode];
//                    info.errCode = @(errorStr.integerValue);
//                    info.errMsg = [NSString stringWithFormat:@"服务端返回错误：%@",info.errCode];
//                    ELog(@"*****协议栈错误,错误码:%@",info.errCode);
//                    MKBlockExec(responseBlock, nil);
//                    return;
//                }
//                
//                //解密
//                Byte seq[8];
//                [receiveData getBytes:&seq range:NSMakeRange(1, 8)];
//                
//                Byte sha1[20];
//                [receiveData getBytes:(sha1) range:NSMakeRange(9, 20)];
//                
//                NSInteger jsonLength = receiveData.length - 29;
//                Byte jsonArray[(int)jsonLength];
//                [receiveData getBytes:jsonArray range:NSMakeRange(29, jsonLength)];
//                
//                NSData* jsonData = [[NSData alloc] initWithBytes:jsonArray length:jsonLength];
//                
//#if G_ENCTYPE == 2
//                NSData* decrpytData = [jsonData decryptTextUsingKey:[XSJNetWork getAESKey]];
//                NSData* unzipData = [decrpytData gunzippedData];
//#endif
//                if ([URL_PicServer isEqualToString:urlStr]) {
//                    MKBlockExec(responseBlock, unzipData);
//                    return;
//                }
//                
//                ELog(@"*****收到返回的请求service:shijianke_createSession");
//                if (!unzipData) {
//                    ELog(@"*****服务端返回的数据解析成空！！！");
//                    MKBlockExec(responseBlock, nil);
//                    return;
//                }
//                
//                NSError* error;
//                NSDictionary* dicResponse = [NSJSONSerialization JSONObjectWithData:unzipData options:NSJSONReadingMutableLeaves error:&error];
//                if (responseBlock) {
//                    ResponseInfo* info = nil;
//                    if (dicResponse) {
//                        info = [[ResponseInfo alloc] init];
//                        info.errCode = [dicResponse objectForKey:@"errCode"];
//                        info.errMsg = [dicResponse objectForKey:@"errMsg"];
//                        info.originData = dicResponse;
//                        
//                        if (info.success) {
//                            info.content = [dicResponse objectForKey:@"content"];
//                            ELog(@"*****服务端返回：\n%@", dicResponse);
//                        }
////                        else{
////                            ELog(@"*****服务端返回错误：%@, 错误码:%@", info.errMsg, info.errCode);
////                            if (info.errCode.intValue == 2 || info.errCode.intValue == 3 || info.errCode.intValue == 15) {
////                                ELog("***** 开始重新初始化Session");
////                            }
////                        }
//                    }
//                    responseBlock(info);
//                }
//                if (error) {
//                    ELog(@"*****请求返还错误信息：%@", error);
//                    ELog(@"*****jsonData:%@",jsonData);
//                }
//            }
//        });
//    }];
//    
}


@end
