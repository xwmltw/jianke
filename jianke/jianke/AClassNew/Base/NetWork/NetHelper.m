//
//  NetHelper.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "NetHelper.h"
#import "WDConst.h"
#import "WDRequestMgr.h"
#import "NSData+CommonCrypto.h"
#import "GZIP.h"
#import "UIHelper.h"
#import "NSData+NSHash.h"
#import "RsaHelper.h"
#import "ThirdPartAccountModel.h"


@interface NetHelper(){
    OnResponseBlock _responseBlock;
    NSString        *_url;
    NSData          *_postData;
    NSMutableString *_netErrorStr;
}
@property (nonatomic, strong)RequestInfo *requestInfo;

@end


@implementation NetHelper
static long debugErrorCode = -1;
+ (void)sendRequest:(RequestInfo*)request{
    NetHelper* helper               = [[NetHelper alloc] init];
    helper.loadingMessage           = request.loadingMessage;
    helper.isShowLoading            = request.isShowLoading;
    helper.isShowServerErrorMsg     = request.isShowErrorMsg;
    helper.isShowErrorMsgAlertView  = request.isShowErrorMsgAlertView;
    helper.isShowNetworkErrorMsg    = request.isShowNetworkErrorMsg;
    helper.requestStr = [[NSString alloc] initWithData:request.data encoding:NSUTF8StringEncoding];
    
    Byte encType = G_ENCTYPE;
    NSMutableData *baowen = [[NSMutableData alloc] init];
    int type = request.type;
    [baowen appendBytes:&type length:1];        //type
    [baowen appendBytes:&encType length:1];     //encType
    
    if (request.forceSeq) {
        request.seq = 0;
    }
    
    unsigned long long seqlong = htonl((unsigned long long)request.seq);
    
    [baowen appendBytes:&seqlong length:8];
    [baowen appendData:[XSJNetWork getTokenData]];    //token
    
    NSData *qm = [[XSJNetWork getSignKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *baowenQm = [[NSMutableData alloc] initWithData:qm];
    [baowenQm appendData:baowen];
    [baowenQm appendData:request.data];
    NSData *sha1 = [baowenQm SHA1];
    
    NSMutableData *multableDataToServer = [[NSMutableData alloc] initWithData:baowen];
    [multableDataToServer appendData:sha1];
    [multableDataToServer appendData:request.data];
    
    helper.seq = request.seq;
    helper.requestInfo = request;
    [helper postRequest:request.url ? request.url : URL_Server andData:multableDataToServer withResponseBlock:request.resBlock];
}


- (instancetype)init{
    self = [super init];
    if (self) {
        self.isShowLoading = NO;
    }
    return self;
}

- (void)postRequest:(NSString*)urlStr andParam:(NSString*)param withResponseBlock:(OnResponseBlock)responseBlock{
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    [self postRequest:urlStr andData:data withResponseBlock:responseBlock];
}

- (void)postRequest:(NSString*)urlStr andData:(NSData*)data withResponseBlock:(OnResponseBlock)responseBlock{
    _responseBlock = responseBlock;
    _url = urlStr;
    _postData = data;
    [self send];
    
//    NSString *str = [[NSString alloc] initWithData:_postData encoding:NSUTF8StringEncoding];
//    ELog(@"&&&&&&&&&&&&&&&&&&&输出是:%@", str);
}

- (void)send{
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:_url];
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:_postData];
    //第三步，连接服务器
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [connection start];
    ELog("*****正在发送 seq：%ld", self.seq);
    [self onBegin];
}

#pragma mark - ***** 数据传完之后调用此方法 ******
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self onEnd];

#pragma mark - ***** 开启日志,上线后续需要关闭 ******
    if (self.receiveData.length < 30) {
        ELog(@"*****收到的消息长度不够：%lu", (unsigned long)self.receiveData.length);
        [[WDRequestMgr sharedInstance] onNetBack:self.requestInfo];
        if (_responseBlock) {
            _responseBlock(nil);
        }
        return;
    }
    
    
    Byte errorCode;
    [self.receiveData getBytes:&errorCode length:1];
#ifdef DEBUG
    if (debugErrorCode > 0) {
        errorCode = debugErrorCode;
        debugErrorCode = -1;
    }
#endif
    if (errorCode != 0) {
        /** 协议栈 级别报错 */
        //SUCCESS((byte) 0x00, "成功"),
        //ERROR_DECRYPT((byte) 0x01, "报文解密失败"),
        //ERROR_SIGN((byte) 0x02, "签名计算错误"),
        //ERROR_TOKEN((byte) 0x03, "Token已失效或不存在"),
        //ERROR_STRUCTURE((byte) 0x04, "报文结构错误"),
        //ERROR_TOKEN_TYPE((byte) 0x05, "token值和type类型冲突"),
        //ERROR_TOKEN_ENCTYPE((byte) 0x06, "token值和encType类型冲突"),
        //ERROR_SEQUENCE((byte) 0x07, "seq值不合法"),
        //@Deprecated
        //ERROR_BUSINESS((byte) 0x08, "业务方法错误"),
        //ERROR_RSADECODE((byte) 0x09, "RSA解密错误"),
        //ERROR_RSAENCODE((byte) 0x0A, "RSA加密错误"),
        //ERROR_UNKNOWN_VERSION((byte) 0x0B, "协议版本不存在"),
        //ERROR_METHOD_NOT_EXISTS((byte) 0x0C, "服务端异常"),
        //ERROR_SEQ_SIGN_DISMATCH((byte) 0x0D, "报文序列号和签名不一致"),
        //ERROR_UNKNOWN((byte) 0xFF, "未知错误");
        
        ResponseInfo *info = [[ResponseInfo alloc] init];
        NSString *errorStr = [[NSString alloc] initWithFormat:@"%hhu",errorCode];
        info.errCode = @(errorStr.integerValue);
        info.errMsg = [NSString stringWithFormat:@"服务端返回错误：%@",info.errCode];
        
        ELog(@"*****协议栈错误, 错误码:%@", info.errCode);
        if (info.errCode.intValue == 60 || info.errCode.intValue == 12) {
            if (info.errCode.intValue == 12) {
                [UIHelper toast:@"服务端异常。"];
            }else if (info.errCode.intValue == 60){
                [UIHelper toast:@"服务端异常。。"];
//                [[XSJNetWork sharedInstance] createSession:^(id response) {
//                    
//                }];
            }

            [[WDRequestMgr sharedInstance] onNetBack:self.requestInfo];
            if (_responseBlock) {
                _responseBlock(nil);
            }
        }else{
            ELog(@"*****开始重新初始化Session");
            [[WDRequestMgr sharedInstance] reInitSession:self.requestInfo isAutoLogin:NO];
        }
        return;
    }
#pragma mark - ***** 网络异常,请重新登录,,,错误诊断点========== ******

    Byte seq[8];
    [self.receiveData getBytes:&seq range:NSMakeRange(1, 8)];
    
    Byte sha1[20];
    [self.receiveData getBytes:(sha1) range:NSMakeRange(9, 20)];
    
    NSInteger jsonLength = self.receiveData.length - 29;
    Byte jsonArray[(int)jsonLength];
    [self.receiveData getBytes:jsonArray range:NSMakeRange(29, jsonLength)];
    
    NSData* jsonData = [[NSData alloc] initWithBytes:jsonArray length:jsonLength];
    
#if G_ENCTYPE == 2
    //解密
    NSData* decrpytData = [jsonData decryptTextUsingKey:[XSJNetWork getAESKey]];
    //解压缩
    NSData* unzipData = [decrpytData gunzippedData];
#endif
    
    if ([URL_PicServer isEqualToString:_url]) {
        [[WDRequestMgr sharedInstance] onNetBack:self.requestInfo];
        if (_responseBlock) {
            _responseBlock(unzipData);
        }
        return;
    }
    ELog(@"*****收到返回的请求：seq:%ld,server seq:%s service:%@ reqStr:%@", self.seq, seq, self.requestInfo.service , self.requestStr);
    
    if (!unzipData) {
        ELog("*****服务端返回的数据解析成空！！！");
        [UIHelper toast:@"数据异常，请重试"];
        [[WDRequestMgr sharedInstance] onNetBack:self.requestInfo];
        MKBlockExec(_responseBlock, nil);
        return;
    }
    
    NSError *error;
    NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:unzipData options:NSJSONReadingMutableLeaves error:&error];
    if (_responseBlock) {
        ResponseInfo *info = nil;
        if (dicResponse) {
            info = [[ResponseInfo alloc] init];
            info.errCode = [dicResponse objectForKey:@"errCode"];
            info.errMsg = [dicResponse objectForKey:@"errMsg"];
            info.originData = dicResponse;
            
            if ([info success]) {
                info.content = [dicResponse objectForKey:@"content"];
                ELog(@"*****服务端返回：\n%@", dicResponse);
            }else{
                ELog(@"*****服务端返回错误：%@, 错误码:%@", info.errMsg, info.errCode);
                if (info.errCode.intValue == 2 || info.errCode.intValue == 3 || info.errCode.intValue == 15) {
                    ELog("***** 开始重新初始化Session");
                    if (info.errCode.intValue == 15) {
                        [[WDRequestMgr sharedInstance] reInitSession:self.requestInfo isAutoLogin:YES];
                    }else{
                        [[WDRequestMgr sharedInstance] reInitSession:self.requestInfo isAutoLogin:NO];
                    }
                    return;
                }else if (self.isShowServerErrorMsg) {
                    if (!info.errMsg || info.errMsg.length == 0) {
                        info.errMsg = @"请求数据失败，请重试";
                    }
                    //请求数据后的提示语
                    if (self.isShowErrorMsgAlertView) {
                        [UIHelper showMsg:info.errMsg];
                    } else {
//                        [UIHelper toast:info.errMsg];
                    }
                }
            }
        }
        [[WDRequestMgr sharedInstance] onNetBack:self.requestInfo];
        MKBlockExec(_responseBlock, info);
    }
    if (error) {
        ELog(@"*****请求返还错误信息：%@", error);
        ELog(@"*****jsonData:%@",jsonData);
    }
}



//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self onEnd];
    
    ELog(@"***** error 返回错误的请求：seq:%ld, service:%@ reqStr:%@", self.seq, self.requestInfo.service , self.requestStr);
    ELog(@"***** error 返回的错误:%@" ,[error localizedDescription]);
    
    if (_netErrorStr == nil) {
        _netErrorStr = [[NSMutableString alloc] init];
    }
    [_netErrorStr appendFormat:@"%@\r\n--------------------------------------------\r\n", error];
    
//    [self checkNetErrorLog:DebugStatus];
    if (self.isShowNetworkErrorMsg) {
        [UIHelper showMsg:@"网络超时，请检查您的网络是否正常"];
    }

    int count = [[WDRequestMgr sharedInstance] getReSendCount];
    if (count >= 2) {
        [[WDRequestMgr sharedInstance] clear];
        [WDRequestMgr sharedInstance].bNetError = YES;
        MKBlockExec(_responseBlock, nil);
    }else{
        [[WDRequestMgr sharedInstance] reOnNetBack:self.requestInfo];
    }
}






#pragma mark - ***** error log ******
- (void)checkNetErrorLog:(BOOL)isShowErrorTip{
    if (_netErrorStr == nil) {
        return;
    }
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString* currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSString* fileName = [NSString stringWithFormat:@"%@-netError.log", currentDateStr];
    
    NSString* recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileName = [NSString stringWithFormat:@"%@/%@", recorderPath, fileName];
    
    ELog(@"===========错误日志位置 %@ ==========", fileName);
    
    if (isShowErrorTip) {
        [_netErrorStr insertString:@"弹出错误提示：\r\n\r\n" atIndex:0];
    }else{
        NSString* text = [NSString stringWithFormat:@"网络出现错误，但是最终成功了，成功时url：%@：\r\n\r\n", _url];
        [_netErrorStr insertString:text atIndex:0];
    }
    
    [_netErrorStr writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
}

+ (void)setErrorCode:(long)code{
    debugErrorCode = code;
}

@end
