//
//  LocalMessageModel.h
//  jianke
//
//  Created by fire on 15/12/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//  本地缓存IM消息模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class RCMessage;
@interface LocalMessageModel : NSObject

// 消息ID, 本地会话ID, 消息模型

@property (nonatomic, strong) NSString *messageId; /*!< 消息ID */         //自增字段不用管
@property (nonatomic, strong) NSString *LocalConverSationId; /*!< 本地会话ID */
@property (nonatomic, strong) NSNumber *isUnRead; /*!< 是否未读: 1未读, 0已读 */
@property (nonatomic, strong) RCMessage *RcMessage;

@end
