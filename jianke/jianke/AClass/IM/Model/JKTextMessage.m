//
//  JKTextMessage.m
//  jianke
//
//  Created by fire on 16/1/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKTextMessage.h"
#import <RongIMLib/RCConversation.h>
#import "MKCategoryHead.h"

@implementation JKTextMessage
MJCodingImplementation

/**
 *  编码将当前对象转成JSON数据
 *  @return 编码后的JSON数据
 */
- (NSData *)encode{
    
    NSDictionary* dic = [self keyValues];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:kNilOptions
                                                         error:&error];
    
    return jsonData;
    
//    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    [dataDict setObject:self.content forKey:@"content"];
//    if (self.extra) {
//        [dataDict setObject:self.extra forKey:@"extra"];
//    }
//    
//    if (self.senderUserInfo) {
//        NSMutableDictionary *__dic = [[NSMutableDictionary alloc]init];
//        if (self.senderUserInfo.name) {
//            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
//        }
//        if (self.senderUserInfo.portraitUri) {
//            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
//        }
//        if (self.senderUserInfo.userId) {
//            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
//        }
//        [dataDict setObject:__dic forKey:@"user"];
//    }
//    
//    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
//                                                   options:kNilOptions
//                                                     error:nil];    
//    return data;
    
}

/**
 *  根据给定的JSON数据设置当前实例
 *  @param data 传入的JSON数据
 */
- (void)decodeWithData:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.content = dic[@"content"];
    self.extra = dic[@"extra"];
}

/**
 *  应返回消息名称，此字段需个平台保持一致
 *  @return 消息体名称
 */
+ (NSString *)getObjectName
{
    return JKTextMessageTypeIdentifier;
}


/**
 *  根据参数创建文本消息对象
 *
 *  @param content  文本消息内容
 */
+ (instancetype)messageWithContent:(NSString *)content
{
    
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    JKTextMessage *jkTextMessage = [JKTextMessage objectWithKeyValues:dic];
    
    return jkTextMessage;
}



+ (RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED;
}

@end
