//
//  ImBusiDataObject.h
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImBusiDataObject : NSObject

// 发送消息的用户userId
@property (nonatomic, copy) NSString* fromUser;
// 来源类型 , 1:雇主，2兼客，3:功能号
@property (nonatomic, copy) NSNumber* fromType;
// 目标用户
@property (nonatomic, copy) NSString* toUser;
// 目标类型,  1:雇主，2兼客，3:功能号 -> IMconst ->WDImUserType
@property (nonatomic, copy) NSNumber* toType;
// 业务类型
@property (nonatomic, copy) NSNumber* bizType;
// 通知标题
@property (nonatomic, copy) NSString* nodifyTitle;
// 通知内容
@property (nonatomic, copy) NSString* notifyContent;
// 通知头像
@property (nonatomic, copy) NSString* notifyUrl;
// 消息内容 - >JSON -> 转换后为 IMMessage
@property (nonatomic, copy) NSString* content;




//发送时间,longlong格式表示
@property (nonatomic, copy) NSNumber* sendTime;

- (BOOL)isSystemMessage;

- (id)getMessageContent;
@end

//{
//    "fromUser" : "x",  // 发送消息的用户userId
//    "fromType" : "int 1:兼客，2雇主,3：功能号",
//    "toUser" : "xxx",  // 接收消息的用户userId
//    "toType":"int 1:兼客，2雇主,3：功能号",，4:雇主+兼客
//    "bizType" : xxx,  // 业务类型
//    "notifyTitle" : "xxx", // 通知标题
//    "notifyContent" : "xxx", // 通知内容
//    "notifyUrl" : "", // 通知头像
//    "sendTime":long,//发送时间,long格式表示1.02版本新增字段
//    "content" : "建议用json格式字符串" // 消息内容

//}