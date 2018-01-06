//
//  ImPacket.h
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImBusiDataObject.h"

@interface ImPacket : NSObject

//长度1：版本号	版本,默认 “1”
@property (nonatomic, copy) NSString* version;
//长度1：协议类型	预留，默认 “1” (MD5签名 ,AES/ECB/PKCS5Padding 加密 , )“2” (MD5签名,AES/ECB/PKCS7Padding 加密)
@property (nonatomic, copy) NSString* encType;
//长度32：MD5签名	对其余所有信息按顺序进行签名，使用UUID作为key
@property (nonatomic, copy) NSString* md5Sign;
//长度1：消息类型	0：系统消息 1：业务处理 2：点对点消息 3：群组消息   --add|4:广播消息|-08.23-mk
@property (nonatomic, copy) NSString* type;
//长度32：消息UUID
@property (nonatomic, copy) NSString* msgUuid;
//长度2：编码code	一个字节的十六进制表示（即两个字符）。
//第一位：是否回执 0: 否 1: 是
//第二位：是否服务端校验真伪 0: 否 1: 是
//第三位：是否显示通知栏 0: 否 1: 是
@property (nonatomic, copy) NSString* code;
//长度无限制	具体业务数据，JSON格式
//{
//    "fromUser" : "x",  // 发送消息的用户userId
//    "fromType" : "int 1:兼客，2雇主,3：功能号",
//    "toUser" : "xxx",  // 接收消息的用户userId
//    "toType":"int 1:兼客，2雇主,3：功能号",
//    "bizType" : xxx,  // 业务类型
//    "notifyTitle" : "xxx", // 通知标题
//    "notifyContent" : "xxx", // 通知内容
//    "notifyUrl" : "", // 通知头像
//    "sendTime":long,//发送时间,long格式表示1.02版本新增字段
//    "content" : "建议用json格式字符串" // 消息内容
//}
@property (nonatomic, copy) NSString* data;



//上面data转换后的
@property (nonatomic, strong) ImBusiDataObject* dataObj;

+ (instancetype)objectFromServerStr:(NSString*)requestStr signKey:(NSString*)signKey;
+ (instancetype)objectFromServerStr:(NSString *)requestStr checkSign:(BOOL)isCheckSign signKey:(NSString *)signKey;
- (NSString*)getRequestStrWithSignKey:(NSString*)signKey;

@end
