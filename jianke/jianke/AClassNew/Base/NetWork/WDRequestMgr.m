//
//  WDRequestMgr.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WDRequestMgr.h"
#import "WDConst.h"
#import "XSJSessionMgr.h"

#import "RsaHelper.h"
#import "NSData+NSHash.h"
#import "ThirdPartAccountModel.h"

#import "XSJNetWork.h"

@interface WDRequestMgr(){
    int reSendCount;
}

@property (nonatomic, strong)NSMutableArray *requestArray;

@end


//static BOOL s_isSessionInitSuccess = NO;
//static NSString *s_publicKey = nil; /*!< 公钥 unused*/
//
//static NSString *s_encrypt_key = @"a6ba8c1d7aedced9";
//static NSString *s_sign_key = @"cf24406101e80edd";
//static NSString *s_challenge = nil;
//static NSString *s_user_token = nil;
//static NSData   *s_token = nil;   /** 报文加密用 */

@implementation WDRequestMgr
#pragma mark - ***** static arg ******

//+ (NSString *)getAESKey{
//    if (s_encrypt_key.length == 16) {  //需要扩展成32位的key
//        s_encrypt_key = [[NSString alloc] initWithFormat:@"%@%@", s_encrypt_key, s_encrypt_key];
//    }
//    return s_encrypt_key;
//}
//
//+ (NSString *)getSignKey    {return s_sign_key;}
//+ (NSString *)getChallenge  {return s_challenge;}
//+ (NSString *)getToken      {return s_user_token;}
//+ (NSData *)getTokenData    {return s_token;}


#pragma mark - ***** instance method ******
Impl_SharedInstance(WDRequestMgr);

- (instancetype)init{
    self = [super init];
    if (self) {
        self.requestArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRequest:(RequestInfo*)request{
    [self.requestArray addObject:request];
    ELog(@"*****requestArray:%lu",(unsigned long)self.requestArray.count);
    ELog(@"*****re%@", request.service);
    if (self.requestArray.count <= 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self send:request];
        return;
    }
}

- (void)send:(RequestInfo*)request{
    reSendCount = 0;
    if (self.bNetError) {
        __block RequestInfo* lastRequest = request;
        [self.requestArray removeObjectAtIndex:0];
        WEAKSELF
        self.bNetError = NO;
        [[XSJNetWork sharedInstance] createSession:^(id response){
            if (response) {
                [weakSelf addRequest:lastRequest];
            }else{
                if (lastRequest.resBlock) {
                    lastRequest.resBlock(nil);
                }
            }
        }];
        return;
    }
    request.seq = ++self.seq;
    if (![request.url isEqualToString:URL_PicServer]) {
        [request fillData];
    }
    [NetHelper sendRequest:request];
}

/** 请求返回 发送吓一跳 */
- (void)onNetBack:(RequestInfo *)request{
    NSAssert(self.requestArray.count > 0,  @"网络请求回来了，但是当前没有保存请求的信息");
    if (self.requestArray.count <= 0) {
        return;
    }
    
    RequestInfo* requestBak = [self.requestArray objectAtIndex:0];
    if (request == requestBak) {
        [self.requestArray removeObjectAtIndex:0];
    }else{
        NSAssert(NO, @"回来的请求和保存的请求不一致。。。");
        return;
    }
    if (self.requestArray.count > 0) {
        RequestInfo* requestNew = [self.requestArray objectAtIndex:0];
        [self send:requestNew];
    }
}

- (void)reOnNetBack:(RequestInfo *)request{
    NSAssert(self.requestArray.count > 0,  @"网络请求回来了，但是当前没有保存请求的信息");
    if (self.requestArray.count <= 0) {
        return;
    }
    
    RequestInfo* requestBak = [self.requestArray objectAtIndex:0];
    if (request == requestBak && reSendCount < 2) {
        reSendCount++;
        [NetHelper sendRequest:requestBak];
    }
}

/** creat session */
- (void)reInitSession:(RequestInfo *)request isAutoLogin:(BOOL)isAutoLogin{
    if (self.requestArray.count <= 0) {
        return;
    }
    RequestInfo *requestBak = [self.requestArray objectAtIndex:0];
    if (request == requestBak) {
        __block RequestInfo* lastRequest = requestBak;
        WEAKSELF
        [[XSJNetWork sharedInstance] createSession:^(id response){
            if (response) {
                if (isAutoLogin) {
                    [[XSJNetWork sharedInstance] autoLoginWithBlock:^(id response) {
                        if (response) {
                            [weakSelf send:lastRequest];
                        }else{
                            MKBlockExec(lastRequest.resBlock, nil);
                        }
                    }];
                }else{
                    [weakSelf send:lastRequest];
                }
            }else{
                MKBlockExec(lastRequest.resBlock, nil);
            }
        }];
        return;
    }else{
        NSAssert(NO, @"回来的请求和保存的请求不一致。。。");
        return;
    }
}



- (void)clear{
    ELog(@"*****清空了%ld个消息", (unsigned long)self.requestArray.count);
    [UIHelper toast:@"网络异常，请刷新重试"];
    [self.requestArray removeAllObjects];
}

- (int)getReSendCount{
    return reSendCount;
}



#pragma mark - ***** bytes - HexString ******
//Byte数组－>16进制数
- (NSString *)bytesToHexString:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for (NSUInteger i = 0; i < data.length; i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    //    ELog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}

//16进制数－>Byte数组
- (NSData *)hexStringToBytes:(NSString *)string{
    NSString *hexString = [[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2 != 0) {
        return nil;
    }
    Byte tempbyt[1] = {0};
    NSMutableData *bytes = [NSMutableData data];
    for (int i = 0; i < [hexString length]; i++){
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if (hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1 - 48) * 16;   //// 0 的Ascll - 48
        else if (hex_char1 >= 'A' && hex_char1 <= 'F')
            int_ch1 = (hex_char1 - 55) * 16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <= '9')
            int_ch2 = (hex_char2 - 48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <= 'F')
            int_ch2 = hex_char2 - 55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1 + int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

//将十进制转化为十六进制
- (NSString *)ToHex:(uint16_t)tmpid{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig) {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

@end
