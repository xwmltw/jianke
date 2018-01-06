//
//  ConversationModel.h
//  jianke
//
//  Created by fire on 15/12/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//  本地存储会话模型

#import <Foundation/Foundation.h>
#import "WDConst.h"
#import "MJExtension.h"

@class RCConversation;
@interface ConversationModel : NSObject

// 本地会话ID, 用户ID, 融云会话ID, 自己的身份, 未读消息数量, job_id, 会话模型
@property (nonatomic, copy) NSString *jobId; /*!< 岗位ID */

@property (nonatomic, copy) NSString *userId; /*!< 用户自己的ID */
@property (nonatomic, assign) NSInteger userType; /*!< 用户自己的类型 */
@property (nonatomic, copy) NSString* targetId;     /*!< 对方ID */
@property (nonatomic, assign) NSInteger targetType;   /*!< 对方类型 */
@property (nonatomic, copy) NSString* targetShowName; /*!< 对方名字 */
@property (nonatomic, copy) NSString* targetHeadUrl;  /*!< 对方头像URL */

@property (nonatomic, copy) NSNumber *unReadMsgCount; /*!< 当前会话的未读消息数量 */
@property (nonatomic, strong) RCConversation *conversation; /*!< 融云会话模型 */
@property (nonatomic, copy) NSString *rcConversationId; /*!< 融云会话ID */
@property (nonatomic, copy) NSString *localConversationId; /*!< 本地会话ID */     //userId_userType_targetId_targetType    //======
@property (nonatomic, copy) NSString *lastModifiedTime; /*!< 最后一条消息的时间戳, 1970至今秒数 */ //======
@property (nonatomic, assign) BOOL isSoundOff;  /*!< 是否静音 默认NO 开启静音YES */
@property (nonatomic, assign) BOOL isHide; /*!< 是否隐藏会话 */

@property (nonatomic, assign) BOOL isGroupManage; /*!< 是否是群管理员 */
@property (nonatomic, assign) BOOL isGroupConversation; /*!< 是否是群聊会话 */
@property (nonatomic, copy) NSString *groupConversationId; /*!< 群会话标识ID: 用户ID_群组ID */
@property (nonatomic, copy) NSString* groupName; /*!< 群组名称 就是岗位名称*/
@property (nonatomic, copy) NSString *localConversationType; /*!< 群组会话类型:显示在 兼客 端还是 雇主端 */

@end
