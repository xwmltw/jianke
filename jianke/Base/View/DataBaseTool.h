//
//  DataBaseTool.h
//  jianke
//
//  Created by fire on 15/12/9.
//  Copyright © 2015年 xianshijian. All rights reserved.
//  数据库工具

#import <Foundation/Foundation.h>
#import "WDConst.h"
#import "FMDB.h"
#import "ConversationModel.h"
#import "WDConst.h"
#import "LocalMessageModel.h"
#import "ParamModel.h"

@class  ConversationModel, LocalMessageModel;

@interface DataBaseTool : NSObject

#pragma mark - GroupMessage


#pragma mark - IM
/** 保存会话 */
+ (void)saveImConversation:(ConversationModel *)conversation;

/** 获取指定用户的会话列表 */
+ (NSArray *)conversationArrayWithUserId:(NSString *)userId userType:(NSInteger)userType withQueryParam:(QueryParamModel *)queryParamModel;

/** 获取指定的会话 */
+ (ConversationModel *)conversationModelWithLocalConversationId:(NSString *)aLocalConversationId;

/** 获取指定用户总的未读消息数量 */
+ (NSInteger)unReadMessageCountWithUserId:(NSString *)userId userType:(NSInteger)userType;

/** 清除指定会话的未读消息数量 */
//+ (void)clearUnreadMessageCountWithUserId:(NSString *)userId userType:(NSInteger)userType rcId:(NSString *)rcId;
/** 删除单聊会话 */
+ (BOOL)deletePrivateConversationWithId:(NSString *)conversationId;

/** 通过会话ID清除指定会话的未读消息数量 */
+ (void)clearUnreadMessageWithLocalConversationId:(NSString *)aLocalConversationId;

/** 保存消息 */
+ (void)saveImMessageWith:(LocalMessageModel *)aLocalMessageModel;

/** 获取指定会话ID的消息 */
+ (NSArray *)messagesWithLocalConversationId:(NSString *)aLocalConversationId withQueryParam:(QueryParamModel *)queryParamModel;

/** 获取指定会话ID的消息并清零该会话的未读消息数量 */
+ (NSArray *)messagesWithLocalConversationId:(NSString *)aLocalConversationId withQueryParam:(QueryParamModel *)queryParamModel clearUnreadMsg:(BOOL)isClearUnreadMsg;

/** 获取指定会话的最后一条消息 */
+ (LocalMessageModel *)lastMessageOfConversationWithLocalConversationId:(NSString *)aLocalConversationId;

/** 通过groupConversationId查询本地会话 */
+ (ConversationModel *)conversationWithGroupConversationId:(NSString *)aGroupConversationId;

/** 隐藏指定的会话 */
+ (void)hideConversationWithGroupConversationId:(NSString *)aGroupConversationId;
+ (void)hideConversationWithGroupId:(NSString *)aGroupId;

/** >=2.4版本的数据补偿 */
+ (void)fixImDataBaseConversationTableData;

#pragma mark - 岗位相关
/** 保存已读岗位 */
+ (void)saveReadedJobId:(NSString *)aJobId;

/** 查询所有已读岗位ID */
+ (NSArray *)readedJobIdArray;

#pragma mark - 众包任务相关
/** 保存已读众包任务 */
+ (void)saveReadedTaksId:(NSString *)taskId withEndTime:(NSString *)overTime;

/** 查询所有已读的宅任务taskID */
+ (NSArray *)queryAllReadedTask;
@end
