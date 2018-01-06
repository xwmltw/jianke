//
//  LocalConversationModel.h
//  jianke
//
//  Created by fire on 16/1/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class RCConversation;
@interface LocalConversationModel : NSObject
// 本地会话ID, 用户ID, 融云会话ID, 自己的身份, 未读消息数量, job_id, 会话模型
@property (nonatomic, copy) NSString *jobId; /*!< 岗位ID */

@property (nonatomic, copy) NSString *userId; /*!< 用户ID */
@property (nonatomic, assign) NSInteger userType; /*!< 用户类型 */      //======
@property (nonatomic, copy) NSNumber *unReadMsgCount; /*!< 当前会话的未读消息数量 */  //======
@property (nonatomic, strong) RCConversation *conversation; /*!< 融云会话模型 */
@property (nonatomic, copy) NSString *rcConversationId; /*!< 融云会话ID */
@property (nonatomic, copy) NSString *localConversationId; /*!< 本地会话ID */     //userId_userType_rcConversationId    //======
@property (nonatomic, copy) NSString *lastModifiedTime; /*!< 最后更新时间戳, 1970至今秒数 */ //======

@property (nonatomic, copy) NSString* targetId;     /*!< 对方ID */
@property (nonatomic, assign) NSInteger targetType;   /*!< 对方类型 */
@property (nonatomic, assign) BOOL isSoundOff;  /*!< 是否静音 默认NO 开启静音YES */

@end
