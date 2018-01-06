//
//  DataBaseTool.m
//  jianke
//
//  Created by fire on 15/12/9.
//  Copyright © 2015年 xianshijian. All rights reserved.
//  数据库工具

#import "DataBaseTool.h"
#import "LocalConversationModel.h"
#import "ImDataManager.h"

static FMDatabase *_groupMessageDB;
static FMDatabase *_iMDB;
static FMDatabase *_jobDB;
static FMDatabase *_zhaiDB;

const NSInteger kNumPerPage = 10;

@implementation DataBaseTool

+ (void)initialize
{
    [super initialize];
    
    // 初始化群发消息
    [self initGroupMessageDB];
    
    // 初始化IM消息
    [self initIMDB];
    
    // 初始化岗位相关
    [self initJobDB];
    
    // 初始化宅任务相关
    [self initZhaiDB];
}


#pragma mark - 群发消息
/** 初始化群发消息数据库 */
+ (void)initGroupMessageDB
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *groupMsgDBPath = [docPath stringByAppendingPathComponent:@"groupMsg.sql"];
    DLog(@"%@", groupMsgDBPath);
    
    _groupMessageDB = [FMDatabase databaseWithPath:groupMsgDBPath];
    
    if (![_groupMessageDB open]) {
        
        DLog(@"打开数据库失败!!!");
        return;
    }
    
    NSString *sqlCmd = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_group_message (id integer PRIMARY KEY, job_id integer, post_time text, post_content blob);"];
    
    if (![_groupMessageDB executeUpdate:sqlCmd]) {
        DLog(@"创建表格失败!!!");
    }
}




#pragma mark - IM消息
/** 初始化IM消息数据库 */
+ (void)initIMDB
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *iMDBPath = [docPath stringByAppendingPathComponent:@"iM.sql"];
    DLog(@"%@", iMDBPath);
    
    _iMDB = [FMDatabase databaseWithPath:iMDBPath];
    
    if (![_iMDB open]) {
        
        DLog(@"打开数据库失败!!!");
        return;
    }
    
    // 会话表
    // 本地会话ID, 用户ID, 融云会话ID, 自己的身份, 未读消息数量, job_id, lastModifiedTime, ImConversation会话模型, 是否是群组管理员, 是否是群组会话, groupConversationId (用户ID_融云会话ID), 是否隐藏会话
    if (![_iMDB tableExists:@"t_conversation"]) {
        
        NSString *sqlCmd1 = [NSString stringWithFormat:@"CREATE TABLE t_conversation (id text PRIMARY KEY, user_id text, rc_id text, user_type integer, unread_msg_count integer, job_id text, last_modified_time text, isGroupManage integer, isGroupConversation integer, groupConversationId text, conversation_model blob, isHide integer DEFAULT 0);"];
        
        if (![_iMDB executeUpdate:sqlCmd1]) {
            DLog(@"创建会话表失败!!!");
        }
    }
    
    // 消息表
    // 消息ID, 本地会话ID, 消息模型
    if (![_iMDB tableExists:@"t_message"]) {
    
        NSString *sqlCmd2 = [NSString stringWithFormat:@"CREATE TABLE t_message (id integer PRIMARY KEY, conversation_id text, is_unread integer, message_model blob);"];
        
        if (![_iMDB executeUpdate:sqlCmd2]) {
            DLog(@"创建消息表失败!!!");
        }
    }
    
//    // 群组信息表
//    // 群组ID, 群组Uuid
//    if (![_iMDB tableExists:@"t_groupInfo"]) {
//        
//        NSString *sqlCmd3 = [NSString stringWithFormat:@"CREATE TABLE t_groupInfo (id integer PRIMARY KEY, groupId text, groupUuid text);"];
//        
//        if (![_iMDB executeUpdate:sqlCmd3]) {
//            DLog(@"创建群组信息表失败!!!");
//        }
//    }
}

#pragma mark - 会话
/** 保存会话 */
+ (void)saveImConversation:(ConversationModel *)conversation
{
//    NSDictionary *dic = [conversation keyValues];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:conversation];
    if (![self isExistImConversationWithLocalConversationId:conversation.localConversationId]) {
        
        // 保存
        if (![_iMDB executeUpdateWithFormat:@"insert into t_conversation(id, user_id, rc_id, user_type, unread_msg_count, job_id, last_modified_time, isGroupManage, isGroupConversation, groupConversationId, conversation_model) values(%@, %@, %@, %ld, %ld, %@, %@, %d, %d, %@, %@)", conversation.localConversationId ,conversation.userId, conversation.rcConversationId, (long)conversation.userType, (long)conversation.unReadMsgCount.integerValue, conversation.jobId, conversation.lastModifiedTime, conversation.isGroupManage, conversation.isGroupConversation, conversation.groupConversationId, data]) {
            
            DLog(@"保存会话到数据库失败:%@",conversation.localConversationId);
        }else{
            DLog(@"=保存会话到数据库成功:%@",conversation.localConversationId);
        }

    } else {
        
        // 更新
        if (conversation.jobId && conversation.jobId.length && conversation.jobId.integerValue != 0) { // 有job_id更新job_id
            
            if (![_iMDB executeUpdate:@"update t_conversation set unread_msg_count = ?, job_id = ?, last_modified_time = ?, conversation_model = ? where id = ?", conversation.unReadMsgCount, conversation.jobId, conversation.lastModifiedTime, data, conversation.localConversationId]) {
                
                DLog(@"更新会话到数据库失败");
            }
            
        } else { // 没job_id不更新job_id
            
            if (![_iMDB executeUpdate:@"update t_conversation set unread_msg_count = ?, last_modified_time = ?, conversation_model = ? where id = ?", conversation.unReadMsgCount, conversation.lastModifiedTime, data, conversation.localConversationId]) {
                
                DLog(@"更新会话到数据库失败");
            }
        }
    }
    
//    FMResultSet *set = [_iMDB executeQuery:@"select * from t_conversation where user_id = ?", conversation.userId];
//    while ([set next]) {
//        NSData *data1 = [set dataForColumn:@"conversation_model"];
//        if (data1) {
//            ConversationModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//            ELog(@"姓名:**:%@", model.targetShowName);
//        }else{
//            ELog(@"错误没数据~");
//        }
//    }
}

/** 查询表中当前是否存在指定的会话 */
+ (BOOL)isExistImConversationWithLocalConversationId:(NSString *)aLocalConversationId;
{
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from t_conversation where id = '%@'", aLocalConversationId];
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    if ([set next]) {
        return YES;
    }
    
    return NO;
}

/** 获取指定用户的会话列表 */
+ (NSArray *)conversationArrayWithUserId:(NSString *)userId userType:(NSInteger)userType withQueryParam:(QueryParamModel *)queryParamModel{
    NSMutableArray *conversationArray = [NSMutableArray array];
    
    NSString *limitStr = @"";
    
    if (queryParamModel) {
        
        limitStr = [NSString stringWithFormat:@"limit %d,%d", queryParamModel.page_num.intValue * queryParamModel.page_size.intValue, queryParamModel.page_size.intValue];
    }
    
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from t_conversation where user_id = '%@' and user_type = '%ld' and isHide = '0' order by last_modified_time DESC %@", userId, (long)userType, limitStr];
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    while ([set next]) {

        NSString *jobId = [set stringForColumn:@"job_id"];
        NSInteger unReadMsgCount = [set intForColumn:@"unread_msg_count"];
        NSData *data = [set dataForColumn:@"conversation_model"];
        NSString *locId = [set stringForColumn:@"id"];
//        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        ConversationModel *model = [ConversationModel objectWithKeyValues:dic];
        
        
        
        ConversationModel *model;
        id info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([info isKindOfClass:[NSDictionary class]]) {
            model = [ConversationModel objectWithKeyValues:info];
        }else if ([info isKindOfClass:[ConversationModel class]]){
            model = (ConversationModel*)info;
        }
        if (model) {
            model.jobId = jobId;
            model.unReadMsgCount = @(unReadMsgCount);
            [conversationArray addObject:model];
        }
    }
    
    return conversationArray;
}



/** 获取指定的会话 */
+ (ConversationModel *)conversationModelWithLocalConversationId:(NSString *)aLocalConversationId
{
    ConversationModel *model = nil;
    
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from t_conversation where id = '%@'", aLocalConversationId];
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    if ([set next]) {
        
        NSString *jobId = [set stringForColumn:@"job_id"];
        NSInteger unReadMsgCount = [set intForColumn:@"unread_msg_count"];
        NSData *data = [set dataForColumn:@"conversation_model"];
//        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        model = [ConversationModel objectWithKeyValues:dic];
        
        id info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([info isKindOfClass:[NSDictionary class]]) {
            model = [ConversationModel objectWithKeyValues:info];
        }else if ([info isKindOfClass:[ConversationModel class]]){
            model = (ConversationModel*)info;
        }
        

        model.jobId = jobId;
        model.unReadMsgCount = @(unReadMsgCount);
    }
    
    return model;
}

/** 获取指定用户总的未读消息数量 */
+ (NSInteger)unReadMessageCountWithUserId:(NSString *)userId userType:(NSInteger)userType
{
    NSInteger count = 0;
    
    NSString *sqlCmd = [NSString stringWithFormat:@"select SUM(unread_msg_count) as total_unread_msg_count from t_conversation where user_id = '%@' and user_type = '%ld'", userId, (long)userType];
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    if ([set next]) {
        
        count = [set intForColumn:@"total_unread_msg_count"];
    }
    
    return count;
}



/** 通过会话ID清除指定会话的未读消息数量 */
+ (void)clearUnreadMessageWithLocalConversationId:(NSString *)aLocalConversationId
{
    if (![_iMDB executeUpdate:@"update t_conversation set unread_msg_count = 0 where id = ?", aLocalConversationId]) {
        
        DLog(@"更新会话到数据库失败");
    }
}


/** 通过groupConversationId查询本地会话 */
+ (ConversationModel *)conversationWithGroupConversationId:(NSString *)aGroupConversationId
{
    ConversationModel *model = nil;
    
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from t_conversation where groupConversationId = '%@'", aGroupConversationId];
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    if ([set next]) {
        
        NSString *jobId = [set stringForColumn:@"job_id"];
        NSInteger unReadMsgCount = [set intForColumn:@"unread_msg_count"];
        NSData *data = [set dataForColumn:@"conversation_model"];
//        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        model = [ConversationModel objectWithKeyValues:dic];

        id info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([info isKindOfClass:[NSDictionary class]]) {
            model = [ConversationModel objectWithKeyValues:info];
        }else if ([info isKindOfClass:[ConversationModel class]]){
            model = (ConversationModel*)info;
        }
        model.jobId = jobId;
        model.unReadMsgCount = @(unReadMsgCount);
    }
    
    return model;
}

/** 删除单聊会话 */
+ (BOOL)deletePrivateConversationWithId:(NSString *)conversationId{
    
    NSString *exeParam = [NSString stringWithFormat:@"delete from t_conversation where id = '%@'", conversationId];
    
    return [_iMDB executeUpdate:exeParam];
    
}

///** 通过groupId获取groupUuid */
//+ (NSString *)groupUuidWithGroupId:(NSString *)aGroupId
//{
//    NSString *groupUuid = nil;
//    
//    NSString *sqlCmd = [NSString stringWithFormat:@"select * from t_groupInfo where groupId = '%@'", aGroupId];
//    
//    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
//    
//    if ([set next]) {
//        
//        groupUuid = [set stringForColumn:@"groupUuid"];
//    }
//    
//    return groupUuid;
//}
//
///** 保存groupInfo信息 */
//+ (void)saveGroupInfoWithGroupId:(NSString *)aGroupId groupUuid:(NSString *)aGroupUuid
//{
//    if ([self groupUuidWithGroupId:aGroupId]) {
//        DLog(@"组信息已存在");
//        return;
//    }
//    
//    if (![_iMDB executeUpdateWithFormat:@"insert into t_groupInfo(groupId, groupUuid) values(%@, %@)", aGroupId, aGroupUuid]) {
//        
//        DLog(@"保存组信息到数据库失败:%@",aGroupId);
//    }else{
//        DLog(@"保存组信息到数据库失败:%@",aGroupId);
//    }
//}


#pragma mark - 消息
/** 保存消息 */
+ (void)saveImMessageWith:(LocalMessageModel *)aLocalMessageModel
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aLocalMessageModel];
    
    if (![_iMDB executeUpdateWithFormat:@"insert into t_message(conversation_id, is_unread, message_model) values(%@, %ld, %@)", aLocalMessageModel.LocalConverSationId, (long)aLocalMessageModel.isUnRead.integerValue ,data]) {
        
        DLog(@"保存消息到消息表失败");
    }
}


/** 获取指定会话ID的消息 */
+ (NSArray *)messagesWithLocalConversationId:(NSString *)aLocalConversationId withQueryParam:(QueryParamModel *)queryParamModel
{
    NSMutableArray *messageArray = [NSMutableArray array];
    
    NSString *limitStr = @"";
    
    if (queryParamModel) {
        
        limitStr = [NSString stringWithFormat:@"limit %d,%d", queryParamModel.page_num.intValue * queryParamModel.page_size.intValue, queryParamModel.page_size.intValue];
    }
    
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from t_message where conversation_id = '%@' order by id DESC %@", aLocalConversationId, limitStr];
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    while ([set next]) {
        
        NSData *data = [set dataForColumn:@"message_model"];
        LocalMessageModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (model) {
            [messageArray addObject:model];
        }
    }
    
    return messageArray;
}


/** 获取指定会话ID的消息并清零该会话的未读消息数量 */
+ (NSArray *)messagesWithLocalConversationId:(NSString *)aLocalConversationId withQueryParam:(QueryParamModel *)queryParamModel clearUnreadMsg:(BOOL)isClearUnreadMsg
{
    if (isClearUnreadMsg) {
        
        [self clearUnreadMessageWithLocalConversationId:aLocalConversationId];
    }
    
    return [self messagesWithLocalConversationId:aLocalConversationId withQueryParam:queryParamModel];
}



/** 获取指定会话的最后一条消息 */
+ (LocalMessageModel *)lastMessageOfConversationWithLocalConversationId:(NSString *)aLocalConversationId
{
    LocalMessageModel *model = nil;
    
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from t_message where conversation_id = '%@' order by id DESC", aLocalConversationId];
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    if ([set next]) {
        
        NSData *data = [set dataForColumn:@"message_model"];
        model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return model;
}

/** >=2.4版本的数据补偿 */
+ (void)fixImDataBaseConversationTableData{
    NSString *key = @"Shijianke_FixImDataFor24";
    if ([WDUserDefaults boolForKey:key]) {
        return;
    }
    
    // 添加字段isGroupManage, isGroupConversation, groupConversationId
    NSString *sqlCmd1 = [NSString stringWithFormat:@"ALTER TABLE t_conversation ADD isGroupManage integer DEFAULT 0;"];
    if (![_iMDB executeUpdate:sqlCmd1]) {
        DLog(@"为会话表增加isGroupManage字段失败");
    }
    
    NSString *sqlCmd2 = [NSString stringWithFormat:@"ALTER TABLE t_conversation ADD isGroupConversation integer DEFAULT 0;"];
    if (![_iMDB executeUpdate:sqlCmd2]) {
        DLog(@"为会话表增加isGroupConversation字段失败");
    }
    
    NSString *sqlCmd3 = [NSString stringWithFormat:@"ALTER TABLE t_conversation ADD groupConversationId text;"];
    if (![_iMDB executeUpdate:sqlCmd3]) {
        DLog(@"为会话表增加groupConversationId字段失败");
    }
    
    NSString *sqlCmd4 = [NSString stringWithFormat:@"ALTER TABLE t_conversation ADD isHide integer DEFAULT 0;"];
    if (![_iMDB executeUpdate:sqlCmd4]) {
        DLog(@"为会话表增加isHide字段失败");
    }
    
    // 获取所有会话模型
    NSMutableArray *localConversationArray = [NSMutableArray array];
    
    NSString *sqlCmd = @"select * from t_conversation";
    
    FMResultSet *set = [_iMDB executeQuery:sqlCmd];
    
    while ([set next]) {
        
        NSString *jobId = [set stringForColumn:@"job_id"];
        NSInteger unReadMsgCount = [set intForColumn:@"unread_msg_count"];
        NSData *data = [set dataForColumn:@"conversation_model"];
        
//        LocalConversationModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        LocalConversationModel *model;
        id info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([info isKindOfClass:[NSDictionary class]]) {
            model = [LocalConversationModel objectWithKeyValues:info];
        }else if ([info isKindOfClass:[ConversationModel class]]){
            model = (LocalConversationModel*)info;
        }
        
        model.jobId = jobId;
        model.unReadMsgCount = @(unReadMsgCount);
        
        if (model) {
            [localConversationArray addObject:model];
        }
    }
    
    // 模型 -> 字典 -> NSData存数据库
    for (LocalConversationModel *model in localConversationArray) {
        
        NSDictionary *localConversationDic = [model keyValues];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localConversationDic];
        
//        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        ConversationModel *model = [ConversationModel objectWithKeyValues:dic];
        ConversationModel *model;
        id info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([info isKindOfClass:[NSDictionary class]]) {
            model = [ConversationModel objectWithKeyValues:info];
        }else if ([info isKindOfClass:[ConversationModel class]]){
            model = (ConversationModel*)info;
        }
        DLog(@"xxxxx===========%@", model);
        
        if (![_iMDB executeUpdate:@"update t_conversation set conversation_model = ? where id = ?", data, model.localConversationId]) {
            DLog(@"更新会话到数据库失败");
        }
    }
    
    // 设置已修复标志
    [WDUserDefaults setBool:YES forKey:key];
}


/** 隐藏指定的会话 */
+ (void)hideConversationWithGroupConversationId:(NSString *)aGroupConversationId{
    if (![_iMDB executeUpdate:@"update t_conversation set isHide = 1 where groupConversationId = ?", aGroupConversationId]) {
        DLog(@"隐藏指定会话,更新到数据库失败");
    }
}

/** 通过groupId隐藏指定的会话(两端都隐藏) */
+ (void)hideConversationWithGroupId:(NSString *)aGroupId
{
    NSString *selfId = [ImDataManager sharedInstance].selfInfo.accountId;
    NSString *Id1 = [NSString stringWithFormat:@"%@_1_%@_5", selfId, aGroupId];
    NSString *Id2 = [NSString stringWithFormat:@"%@_2_%@_5", selfId, aGroupId];
    if (![_iMDB executeUpdate:@"update t_conversation set isHide = 1 where id = ?", Id1]) {
        DLog(@"隐藏指定会话,更新到数据库失败");
    }
    if (![_iMDB executeUpdate:@"update t_conversation set isHide = 1 where id = ?", Id2]) {
        DLog(@"隐藏指定会话,更新到数据库失败");
    }
}


#pragma mark - 兼客首页已读岗位
/** 初始化岗位相关 */
+ (void)initJobDB
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *jobDBPath = [docPath stringByAppendingPathComponent:@"job.sqlite"];
    DLog(@"%@", jobDBPath);
    
    _jobDB = [FMDatabase databaseWithPath:jobDBPath];
    
    if (![_jobDB open]) {
        
        DLog(@"打开数据库失败!!!");
        return;
    }
    
    // 首页已读岗位
    // 自增ID, 岗位ID, 保存时间
    
    if (![_jobDB tableExists:@"t_readed_job"]) {
        
        NSString *sqlCmd = [NSString stringWithFormat:@"CREATE TABLE t_readed_job (id integer PRIMARY KEY, job_id text, read_time text);"];
        
        if (![_jobDB executeUpdate:sqlCmd]) {
            DLog(@"创建首页已读岗位表失败!!!");
        }
    }
}

/** 保存已读岗位 */
+ (void)saveReadedJobId:(NSString *)aJobId
{
    if (!aJobId) {
        return;
    }
    
    [self deleteJobIdWithJobId:aJobId];
    
    if ([self isReadedJobCountOver200]) {
        [self deleteLastJobId];
    }
    
    NSString *readTime = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970];
    if (![_jobDB executeUpdate:@"insert into t_readed_job(job_id, read_time) values(?, ?)", aJobId, readTime]) {
        
        DLog(@"保存指定JobId到已读岗位表失败");
    }
}


/** 查询所有已读岗位ID */
+ (NSArray *)readedJobIdArray
{
    FMResultSet *result = [_jobDB executeQuery:@"select job_id from t_readed_job order by id DESC limit 0, 200"];
    
    NSMutableArray *jobIdArray  = [NSMutableArray array];
    
    while ([result next]) {
        
        NSString *jobId = [result objectForColumnName:@"job_id"];
        
        if (jobId) {
            [jobIdArray addObject:jobId];
        }
    }
    
    return jobIdArray;
}


/** 检查已读岗位是否超过200条 */
+ (BOOL)isReadedJobCountOver200
{
    FMResultSet *result = [_jobDB executeQuery:@"select count(job_id) as job_id_count from t_readed_job"];
    
    NSInteger count = 0;
    
    if ([result next]) {
        
        count = [result intForColumn:@"job_id_count"];
    }
    
    if (count >= 200) {
        return YES;
    } else {
        return NO;
    }
}

/** 删除最早的已读岗位ID */
+ (BOOL)deleteLastJobId
{
    NSString *lastJobId = [self lastJobId];
    
    if (!lastJobId) {
        return NO;
    }
    
    [self deleteJobIdWithJobId:lastJobId];
    return NO;
}


/** 删除指定的岗位Id */
+ (void)deleteJobIdWithJobId:(NSString *)aJobId
{
    if (![_jobDB executeUpdate:@"delete from t_readed_job where job_id = ?", aJobId]) {
        
        DLog(@"删除指定的岗位Id失败");
    }
}


/** 查询最早的已读岗位Id */
+ (NSString *)lastJobId
{
    NSString *lastJobId = nil;
    
    FMResultSet *result = [_jobDB executeQuery:@"select job_id from t_readed_job order by id ASC limit 0, 1"];
    
    if ([result next]) {
        
        lastJobId = [result objectForColumnName:@"job_id"];
    }
    
    return lastJobId;
}

#pragma mark - 众包任务相关
/** 创建宅任务数据库 */
+ (void)initZhaiDB{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *zhaiPath = [docPath stringByAppendingPathComponent:@"zhaiTask.sqlite"];
    DLog(@"%@", zhaiPath);
    _zhaiDB = [FMDatabase databaseWithPath:zhaiPath];
    if (![_zhaiDB open]) {
        DLog(@"宅任务数据库打开失败");
        return;
    }
    
    // 已读宅任务
    // 自增ID, 宅任务ID, 保存时间
    
    if (![_zhaiDB tableExists:@"t_readed_task"]) {
        
        NSString *sqlCmd = [NSString stringWithFormat:@"CREATE TABLE t_readed_task (id integer PRIMARY KEY, task_id text, read_time text, over_time text);"];
        
        if (![_zhaiDB executeUpdate:sqlCmd]) {
            DLog(@"创建已读宅任务表失败!!!");
        }
    }
    
    [_zhaiDB close];
}

/** 保存已读众包任务 */
+ (void)saveReadedTaksId:(NSString *)taskId withEndTime:(NSString *)overTime{
    if (!taskId || !overTime) {
        NSAssert(NO, @"taskId和overTime都不能为空！！！！！！");
        return;
    }
    
    if (![_zhaiDB open]) {
        DLog(@"宅任务数据库打开失败");
        return;
    }
    
    if (![self queryExistZhaiWithTaskId:taskId]) { //没有保存的历史记录
        NSString *readTime = [NSString stringWithFormat:@"%.f", [NSDate date].timeIntervalSince1970 * 1000];
        if ([_zhaiDB executeUpdate:@"INSERT INTO t_readed_task (task_id, read_time, over_time) VALUES (?, ?, ?)", taskId, readTime, overTime]) {
            DLog(@"保存宅任务数据失败");
        }
    }
    
    [_zhaiDB close];
}

/** 查询是否保存有指定的宅任务 */
+ (BOOL)queryExistZhaiWithTaskId:(NSString *)taskId{
    
    FMResultSet *result = [_zhaiDB executeQuery:@"select count(task_id) as task_id_count from t_readed_task where task_id = ?", taskId];
    
    NSInteger count = 0;
    
    if ([result next]) {
        
        count = [result intForColumn:@"task_id_count"];
    }
    
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}

/** 查询所有已读的宅任务taskID */
+ (NSArray *)queryAllReadedTask{
    NSMutableArray *array = [NSMutableArray array];
    
    if (![_zhaiDB open]) {
        DLog(@"宅任务数据库打开失败");
        return [array copy];
    }
    
    //先删除过期的任务
    [self deleteOverTask];
    
    FMResultSet *resultSet = [_zhaiDB executeQuery:@"select * from t_readed_task"];
    
    NSString *taskId = nil;
    while ([resultSet next]) {
        taskId = [resultSet objectForColumnName:@"task_id"];
        if (taskId) {
            [array addObject:taskId];
        }
    }
    
    [_zhaiDB close];
    
    return [array copy];
}

/** 删除已过期的任务 */
+ (void)deleteOverTask{
    NSString *currentTime = [NSString stringWithFormat:@"%.f", [NSDate dateWithTimeIntervalSinceNow:-86400].timeIntervalSince1970 * 1000];
    if (![_zhaiDB executeUpdate:@"delete from t_readed_task where over_time < ?", currentTime]) {
        DLog(@"删除已过期的任务失败");
    }
}

@end
