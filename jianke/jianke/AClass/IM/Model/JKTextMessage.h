//
//  JKTextMessage.h
//  jianke
//
//  Created by fire on 16/1/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "MJExtension.h"

#define JKTextMessageTypeIdentifier @"JK:TxtMsg"

/**
 *  自定义文本消息类定义
 */
@interface JKTextMessage : RCMessageContent


/** 文本消息内容 */
@property(nonatomic, strong) NSString *content;

/**
 *  附加信息
 */
@property(nonatomic, strong) NSString *extra;

/**
 *  根据参数创建文本消息对象
 *
 *  @param content  文本消息内容
 */
+ (instancetype)messageWithContent:(NSString *)content;


@end
