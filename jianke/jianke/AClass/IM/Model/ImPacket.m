//
//  ImPacket.m
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ImPacket.h"
#import "WDConst.h"

@implementation ImPacket

- (instancetype)init{
    self = [super init];
    if (self) {
        self.version = @"1";
        self.encType = @"0";
        self.type = @"2";
        self.code = @"00";
    }
    return self;
}

static const int PROTO_VERSION_STR_LENGTH = 1;
static const int PROTO_TYPE_STR_LENGTH = 1;
static const int SIGN_MD5_STR_LENGTH = 32;
static const int MSG_TYPE_STR_LENGTH = 1;
static const int MSG_UUID_STR_LENGTH = 32;
static const int CODE_STR_LENGTH = 2;
//static const int SIGN_KEY_STR_LENGTH = 32;
static const int PKGSTR_MIN_LENGTH = PROTO_VERSION_STR_LENGTH + PROTO_TYPE_STR_LENGTH + SIGN_MD5_STR_LENGTH; // 数据包最小长度


+ (instancetype)objectFromServerStr:(NSString *)requestStr checkSign:(BOOL)isCheckSign signKey:(NSString *)signKey
{
    ImPacket* obj = [[self alloc] init];
    NSUInteger strIndex = 0;
    if (requestStr == nil || requestStr.length < PKGSTR_MIN_LENGTH) {
        return nil;
    }
    
    // 版本号
    NSString* in_protoVersion = [requestStr substringWithRange:NSMakeRange(strIndex, PROTO_VERSION_STR_LENGTH)];
    strIndex += PROTO_VERSION_STR_LENGTH;
    
    // 协议类型
    NSString* in_protoType = [requestStr substringWithRange:NSMakeRange(strIndex, PROTO_TYPE_STR_LENGTH)];
    strIndex += PROTO_TYPE_STR_LENGTH;
    
    // MD5值的16进制表示法
    NSString* in_signMd5 = [requestStr substringWithRange:NSMakeRange(strIndex, SIGN_MD5_STR_LENGTH)];
    strIndex += SIGN_MD5_STR_LENGTH;
    
    // 消息类型
    NSString* in_msgType = [requestStr substringWithRange:NSMakeRange(strIndex, MSG_TYPE_STR_LENGTH)];
    strIndex += MSG_TYPE_STR_LENGTH;
    
    // 消息UUID,32字符
    NSString* in_msgUuid = [requestStr substringWithRange:NSMakeRange(strIndex, MSG_UUID_STR_LENGTH)];
    strIndex += MSG_UUID_STR_LENGTH;
    
    // 编码的16进制表示
    NSString* in_code = [requestStr substringWithRange:NSMakeRange(strIndex, CODE_STR_LENGTH)];
    strIndex += CODE_STR_LENGTH;
    
    // 剩余所有信息均为业务数据.(加密处理后的密文)
    NSString* in_busiJsonStrHex = [requestStr substringFromIndex:strIndex];
    
    // 签名校验
    if (isCheckSign) {
        NSMutableString* strForMd5 = [NSMutableString stringWithString:signKey];
        [strForMd5 appendString:in_protoVersion];
        [strForMd5 appendString:in_protoType];
        [strForMd5 appendString:in_msgType];
        [strForMd5 appendString:in_msgUuid];
        [strForMd5 appendString:in_code];
        [strForMd5 appendString:in_busiJsonStrHex];
        NSString* out_signMd5 = [[strForMd5 MD5] uppercaseString];
        
        if (![out_signMd5 isEqualToString:in_signMd5]) {
            DLog(@"签名校验失败");
            return nil;
        } else {
            DLog(@"签名校验成功");
        }
    }
    
    obj.version = in_protoVersion;
    obj.encType = in_protoType;
    obj.md5Sign = in_signMd5;
    obj.type = in_msgType;
    obj.msgUuid = in_msgUuid;
    obj.code = in_code;
    
    NSData* dataContent = [in_busiJsonStrHex dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* dicContent = [NSJSONSerialization JSONObjectWithData:dataContent options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        ELog(@"========解析json返还错误信息：%@，原字符串是:%@", error, in_busiJsonStrHex);
        DLog(@"================原始报文Start=============");
        DLog(@"%@", requestStr);
        DLog(@"================原始报文ENd=============");
    }else{
        obj.dataObj = [ImBusiDataObject objectWithKeyValues:dicContent];
    }
    return obj;
}


+ (instancetype)objectFromServerStr:(NSString *)requestStr signKey:(NSString *)signKey{
    
    return [self objectFromServerStr:requestStr checkSign:NO signKey:signKey];
}

- (NSString*)getRequestStrWithSignKey:(NSString *)signKey{
    NSAssert(signKey, @"");
    NSAssert(self.version, @"");
    NSAssert(self.encType, @"");
    NSAssert(self.type, @"");
    NSAssert(self.msgUuid, @"");
    NSAssert(self.code, @"");
    NSAssert(self.dataObj, @"");
    NSMutableString* strForMd5 = [NSMutableString stringWithString:signKey];
    [strForMd5 appendString:self.version];
    [strForMd5 appendString:self.encType];
    [strForMd5 appendString:self.type];
    [strForMd5 appendString:self.msgUuid];
    [strForMd5 appendString:self.code];
    [strForMd5 appendString:[self.dataObj simpleJsonString]];
    
    NSString* out_signMd5 = [[strForMd5 MD5] uppercaseString];
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:self.version];
    [str appendString:self.encType];
    [str appendString:out_signMd5];
    [str appendString:self.type];
    [str appendString:self.msgUuid];
    [str appendString:self.code];
    
    NSString* strData = [self.dataObj simpleJsonString];
//    strData = [strData stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    strData = [strData stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\\\\\"];
    [str appendString:strData];
    
    return str;
}



@end
