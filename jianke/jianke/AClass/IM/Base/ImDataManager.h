//
//  ImDataManager.h
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImUserInfo.h"
#import "WdMessage.h"
#import "WDConst.h"

@class ImPacket;
@class ImMessage;
@class RCMessageContent;

@interface ImDataManager : NSObject

@property (nonatomic, strong) ImUserInfo* selfInfo;
@property (nonatomic, strong) ImUserInfo* systemInfo;

+ (ImDataManager*)sharedInstance;

- (BOOL)isUserLogin;
- (void)loginOutRCIM;
- (void)tryLogin;

//- (ImUserInfo*)getUserInfoById:(NSString*)userId;
//- (void)updateAccountUserMap:(ImUserInfo*)user;
- (void)reloadUnReadCount;
- (void)checkPlaySoundOfMessage:(RCMessage *)message;
- (void)checkPlaySoundOfMessage:(RCMessage *)message isGroup:(BOOL)isGroup;
- (NSInteger)getUnreadMsgCount;


+ (void)getUserInfoById:(NSString*)accountId withType:(int)type allowCache:(BOOL)bAllowCache completion:(MKBlock)completion;
+ (ImPacket*)packetFromRCMessage:(RCMessage*)rcmsg;
//+ (ImPacket*)packetFromRCMessage:(RCMessage *)rcmsg checkSign:(BOOL)isCheckSign;
+ (ImPacket*)packetFromRCMessage:(RCMessage *)rcmsg withUuid:(NSString*)uuid checkSign:(BOOL)isCheckSign;

+ (ImMessage*)messageFromRCMessage:(RCMessage*)rcmsg;
+ (WdMessage*)getMessageByRCMessage:(RCMessage*)rcmsg;
+ (NSArray*)getConversationTypes;
+ (id)getKeFuChatVC;

//- (void)saveImConversationWithMsgArray:(NSArray*)msgArray andUsrtype:(WDLogin_type)type andConversation:(RCConversation*)conversation isHaveFirst:(BOOL)isHaveFirst block:(void(^)(BOOL isSuccess))block;




- (void)updateLocalMsgDataWithRCConversation:(MKBoolBlock)block;


- (void)saveImConversationWithRCC:(RCConversation*)conversation Usertype:(WDLogin_type)type msgArray:(NSArray*)msgArray isFirst:(BOOL)isFirst unreadCount:(NSInteger)unreadCount block:(MKBoolBlock)block;
- (void)saveLocalMsgWithRCMsg:(RCMessage*)msg andUnRead:(BOOL)unRead andLocalConversationId:(NSString*)localConversationId;
- (NSString*)getKefuLocalConversationId;
- (NSString*)getKefuLocalConversationIdwhitUsertype:(NSInteger)usertype;

- (NSString*)makeGroupLocalConversationIdSignWithUuid:(NSString*)groupUuid;



- (void)saveFuncInfoWithId:(GlobalFeatureInfo*)info;


@end
