//
//  ImDataManager.m
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ImDataManager.h"
#import "WDConst.h"
#import "WDCache.h"
#import "WDChatView_VC.h"
#import "KefuChatView_VC.h"
#import "ConversationModel.h"
#import "DataBaseTool.h"
#import "IMGroupDetailModel.h"
#import "JKTextMessage.h"
#import "XSJLocalNotificationMgr.h"
#import "XZNotifyView.h"
#import "WeChatBinding_VC.h"
#import "XSJUserNotificationMgr.h"
#import "UITabBar+MKExtension.h"

@interface ImDataManager()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource, RCIMConnectionStatusDelegate>{
//@interface ImDataManager()<RCIMClientReceiveMessageDelegate,RCIMUserInfoDataSource, RCConnectionStatusChangeDelegate>{
    NSArray* _imGroups;
}
@end

static UIImage* _locationDefaultImage;

@implementation ImDataManager

Impl_SharedInstance(ImDataManager);


#pragma mark - 类方法

+ (id)getKeFuChatVC{
    KefuChatView_VC* vc = [[KefuChatView_VC alloc] init];
    vc.title = KEFU_NAME;
    KefuChatView_VC* __weak weakVC = vc;
    return weakVC;
}

+ (ImMessage*)messageFromRCMessage:(RCMessage *)rcmsg{
    ImPacket* packet = [self packetFromRCMessage:rcmsg];
    if (packet) {
        ImMessage* imMsg = [packet.dataObj getMessageContent];
        return imMsg;
    }
    return nil;
}

+ (ImPacket*)packetFromRCMessage:(RCMessage *)rcmsg{
    return [self packetFromRCMessage:rcmsg withUuid:nil checkSign:NO];
}

+ (ImPacket*)packetFromRCMessage:(RCMessage *)rcmsg withUuid:(NSString*)uuid checkSign:(BOOL)isCheckSign{
    RCMessageContent *content = rcmsg.content;
    
    if (!rcmsg || !content || ![content isKindOfClass:[RCMessageContent class]]) {
        return nil;
    }
    
    RCTextMessage* textContent = (RCTextMessage*)content;
    if (!uuid) {
        uuid = [ImDataManager sharedInstance].selfInfo.uuid;
    }
    ImPacket* packet = [ImPacket objectFromServerStr:textContent.extra checkSign:isCheckSign signKey:uuid];
    if (packet) {
        return packet;
    }else{
        ELog(@"====融云发来的包解析失败");
        return nil;
    }
}


#pragma mark - 获取消息  对应类型
+ (WdMessage *)getMessageByRCMessage:(RCMessage *)rcmsg{
    NSString* sender = @"";
    WdMessage* message;
    if (rcmsg.conversationType == ConversationType_CUSTOMERSERVICE) {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:rcmsg.sentTime/1000];
        if ([rcmsg.content isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage* textContent = (RCTextMessage*)rcmsg.content;
            
            NSMutableString *msgStr = [[NSMutableString alloc] initWithString:textContent.content];
            
            NSRange range1 = [msgStr rangeOfString:@"   → 雇主"];
            NSRange range2 = [msgStr rangeOfString:@"   → 兼客"];
            if (range1.location != NSNotFound) {
                [msgStr deleteCharactersInRange:range1];
            }else if (range2.location != NSNotFound){
                [msgStr deleteCharactersInRange:range2];
            }
        
            message = [[WdMessage alloc] initWithText:msgStr sender:KEFU_NAME arg:nil timestamp:date];
        }else if ([rcmsg.content isKindOfClass:[RCImageMessage class]]){
            RCImageMessage* textContent = (RCImageMessage*)rcmsg.content;
            message = [[WdMessage alloc] initWithPhoto:textContent.originalImage thumbnailUrl:textContent.imageUrl originPhotoUrl:textContent.imageUrl sender:KEFU_NAME timestamp:date];
        }
    }else{
        ImPacket* packet = [self packetFromRCMessage:rcmsg];
        if (!packet) {
            return nil;
        }
        //    ELog(@"==获取消息  对应类型==packet:%@",[packet simpleJsonString]);
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:packet.dataObj.sendTime.longLongValue/1000];
        ImMessage* imMsg = [packet.dataObj getMessageContent];
        
        if ([imMsg isKindOfClass:[ImTextMessage class]]) {                      //20001
            ImTextMessage* msg = (ImTextMessage*)imMsg;
            message = [[WdMessage alloc] initWithText:msg.message sender:sender arg:msg timestamp:date];
            
        }else if ([imMsg isKindOfClass:[ImPhotoMessage class]]){                //20002
            ImPhotoMessage* msg = (ImPhotoMessage*)imMsg;
            message = [[WdMessage alloc] initWithPhoto:nil thumbnailUrl:msg.url originPhotoUrl:msg.url sender:sender timestamp:date];
            
        } else if([imMsg isKindOfClass:[ImVoiceMessage class]]) {               //20003
            ImVoiceMessage* msg = (ImVoiceMessage*)imMsg;
            NSString* duration = [NSString stringWithFormat:@"%.01f", msg.VoiceLong.floatValue/1000];
            message = [[WdMessage alloc] initWithVoicePath:msg.voicePath voiceUrl:msg.url voiceDuration:duration sender:sender timestamp:date isRead:NO];
            
        } else if([imMsg isKindOfClass:[ImLocationMessage class]]) {            //20004
            ImLocationMessage* msg = (ImLocationMessage*)imMsg;
            message = [[WdMessage alloc] initWithLocalPositionPhoto:_locationDefaultImage geolocations:msg.address location:[[CLLocation alloc] initWithLatitude:msg.lat.doubleValue longitude:msg.lon.doubleValue] sender:sender timestamp:date];
            
        } else if([imMsg isKindOfClass:[ImShareCompMessage class]]){            //20005
            ImShareCompMessage* msg = (ImShareCompMessage*)imMsg;
            //安卓端写accountId，所以只能跟随了。
            NSNumber* objId = [NSNumber numberWithLongLong:msg.accountId.longLongValue];
            message = [[WdMessage alloc] initWithEnterprise:msg.entName obj_id:objId sender:sender timestamp:date];
            
        } else if([imMsg isKindOfClass:[ImShareJobMessage class]]){             //20006
            ImShareJobMessage* msg = (ImShareJobMessage*)imMsg;
            NSNumber* objId = [NSNumber numberWithLongLong:msg.jobId.longLongValue];
            message = [[WdMessage alloc] initWithJob:msg.title obj_id:objId sender:sender timestamp:date];
            
        }  else if([imMsg isKindOfClass:[ImSystemMsg class]]){                  //20007
            ImSystemMsg* msg = (ImSystemMsg*)imMsg;
            if (msg.message == nil || msg.message.length < 1) {
                msg.message = packet.dataObj.notifyContent;
            }
            message = [[WdMessage alloc] initWithSystem:msg.message arg:msg sender:sender timestamp:date];
            
        } else if ([imMsg isKindOfClass:[ImImgAndTextMessage class]]){     //20008
            __unused ImImgAndTextMessage* msg = (ImImgAndTextMessage*)imMsg;
//            message = [[WdMessage alloc]initWithImgTextTitle:msg.title text:msg.message thumbnailUrl:msg.imageUrl linkUrl:msg.linkUrl type:msg.type code:msg.code app_param:msg.app_param timestamp:date];
        }
    }
    
    if (message) {
        //        if (rcmsg.conversationType == ConversationType_CUSTOMERSERVICE && rcmsg.content) {
        ////            message.avatar = [UIImage imageNamed:@"msg_type_2"];
        //        }else{
        //
        //        }
        message.avatar = [UIHelper getDefaultHead];
        switch (rcmsg.messageDirection) {       //发送接收
            case MessageDirection_SEND:
            {
                message.bubbleMessageType = XHBubbleMessageTypeSending;
            }
                break;
            case MessageDirection_RECEIVE:
            {
                message.bubbleMessageType = XHBubbleMessageTypeReceiving;
                if (rcmsg.conversationType == ConversationType_CUSTOMERSERVICE && rcmsg.content) {
                    message.avatar = [UIImage imageNamed:@"msg_type_2"];
                }
            }
                break;
            default:
                break;
        }
        message.rcMsg = rcmsg;
        message.bShowTimeLine = YES;
    }
    
    return message;
}




#pragma mark - init=========
- (instancetype)init{
    self = [super init];
    if (self) {
        _locationDefaultImage = [UIImage imageNamed:@"chat_map"];
        [WDNotificationCenter addObserver:self selector:@selector(onUserLogout:) name:WDNotifi_setLoginOut object:nil];
    }
    return self;
}

#pragma mark -  开通&登录&退出 IM
- (void)onUserLogout:(NSNotification*)notify{
    ELog(@"===通知 退出IM 断开连接");
    [self loginOutRCIM];
}

- (BOOL)isUserLogin{
    if (self.selfInfo) {
        if (self.selfInfo.account_type.integerValue == [[UserData sharedInstance] getLoginType].integerValue) {
            return YES;
        }else{
            self.selfInfo.account_type = [[UserData sharedInstance] getLoginType];
            [WDNotificationCenter postNotificationName:OnImLoginSuccessNotify object:nil];  //发送给IMHome 界面的
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateLocalMsgDataWithRCConversation:^(BOOL isSuccess) {
                    [self reloadUnReadCount];
                }];
            });
            return YES;
//            [self loginOutRCIM];
        }
    }
    return NO;
}

- (void)loginOutRCIM{
    ELog(@"====== IM 退出登录");
    [[RCIMClient sharedRCIMClient] disconnect:YES];
    self.selfInfo = nil;
}

- (void)tryLogin{
    [self requestOpenIM];
}

- (void)requestOpenIM{
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_openImFunction" andContent:nil];
    request.isShowNetworkErrorMsg = NO;
    WEAKSELF
    [request sendRequestToImServer:^(ResponseInfo* response) {
        if (response && [response success]) {
            OpenImFunModel* openModel = [OpenImFunModel objectWithKeyValues:response.content];
            NSString* token = openModel.im_account_info.im_token;
            
            //IM账号信息:
            ImUserInfo* info = [[ImUserInfo alloc] init];
            info.accountId = [NSString stringWithFormat:@"%@", openModel.im_account_info.account_id];
            info.accountName = openModel.im_account_info.account_name;
            info.account_type = openModel.im_account_info.account_type;
            info.headUrl = openModel.im_account_info.account_img_url;
            info.telephone = openModel.im_account_info.account_phone_num;
            info.uuid = openModel.im_account_info.uuid;
            info.accountEntInfoId = openModel.im_account_info.account_ent_info_id;
            info.resumeId = openModel.im_account_info.account_resume_id;
            weakSelf.selfInfo = info;

            if (token && token.length > 1) {
                [weakSelf loginRongCloudWithToken:token];
            }
        }
    }];
}

- (void)loginRongCloudWithToken:(NSString*)token {
#ifdef RC_DEBUG
    token = @"O7GPsBD5MwppBnnuO/2GpwWdvQSPV5/ttb3LqpZF/JcrD9kQRL37z4fL9GCuWQo8/Bro0krLZI7IODLxZgCT1v1x1Uke/4Zizs4/EsALANI2OvaFy+93rv3sCUbJt2a+";
#endif
    // 用token 连接融云服务器。
    WEAKSELF
    [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *userId) {
        [XSJUserInfoData sharedInstance].openStamp = [NSDate date].timeIntervalSince1970;
        weakSelf.selfInfo.uuid = userId;
        ELog(@"IM==========Login successfully with userId: %@.", userId);
        //此处存放初始化信息
        //        [FriendListMgr sharedInstance];
        //        [EmployerListMgr sharedInstance];
        //IM==========设置融云 消息通知 监听 & 代理
        [RCIM sharedRCIM].receiveMessageDelegate = weakSelf;
        [RCIM sharedRCIM].connectionStatusDelegate = weakSelf;
//        [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:weakSelf object:nil];
//        [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:weakSelf];
        //设置用户信息提供者
        //        [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
        [WDNotificationCenter postNotificationName:OnImLoginSuccessNotify object:nil];  //发送给IMHome 界面的
        [WDNotificationCenter postNotificationName:LoginSuccessNoticeBindWechat object:nil];    //发送给JK or EP 端提示绑定微信
        if (![WDUserDefaults boolForKey:NewFeatureAboutBindWechat] && ![WDUserDefaults boolForKey:LoginSuccessNoticeBindWechat]) {
            [WDUserDefaults setBool:YES forKey:LoginSuccessNoticeBindWechat];
            [WDUserDefaults synchronize];
            
            if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
                JKModel *jkInfo = [[UserData sharedInstance] getJkModelFromHave];
                if (jkInfo) {
                    if (jkInfo.bind_wechat_public_num_status.integerValue == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MKAlertView alertWithTitle:@"提示" message:@"绑定微信可即时获取录用通知" cancelButtonTitle:@"知道了" confirmButtonTitle:@"去绑定" viewController:[MKUIHelper getTopViewController] completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
                                    if (viewCtrl && viewCtrl.navigationController) {
                                        WeChatBinding_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_wechatBinding"];
                                        vc.hidesBottomBarWhenPushed = YES;
                                        [viewCtrl.navigationController pushViewController:vc animated:YES];
                                    }
                                }
                            }];
                        });
                    }
                }else{
                    [[UserData sharedInstance] getJKModelWithBlock:^(JKModel* obj) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (obj.bind_wechat_public_num_status.integerValue == 0) {
                                [MKAlertView alertWithTitle:@"提示" message:@"绑定微信可即时获取录用通知" cancelButtonTitle:@"知道了" confirmButtonTitle:@"去绑定" viewController:[MKUIHelper getTopViewController] completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                    if (buttonIndex == 1) {
                                        UIViewController *viewCtrl = [MKUIHelper getTopViewController];
                                        if (viewCtrl && viewCtrl.navigationController) {
                                            WeChatBinding_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_wechatBinding"];
                                            vc.hidesBottomBarWhenPushed = YES;
                                            [viewCtrl.navigationController pushViewController:vc animated:YES];
                                        }
                                    }
                                }];
                            }
                            
                        });
                    }];
                }
                
            }else if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_Employer){
                EPModel *epInfo = [[UserData sharedInstance] getEpModelFromHave];
                if (epInfo) {
                    if (epInfo.bind_wechat_public_num_status.integerValue == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MKAlertView alertWithTitle:@"提示" message:@"绑定微信可即时获取兼客报名通知" cancelButtonTitle:@"知道了" confirmButtonTitle:@"去绑定" viewController:[MKUIHelper getTopViewController] completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    UIViewController *viewCtrl = [MKUIHelper getTopViewController];
                                    if (viewCtrl && viewCtrl.navigationController) {
                                        WeChatBinding_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_wechatBinding"];
                                        vc.hidesBottomBarWhenPushed = YES;
                                        [viewCtrl.navigationController pushViewController:vc animated:YES];
                                    }
                                }
                            }];
                        });
                    }
                }else{
                    [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *obj) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (obj) {
                                if (obj.bind_wechat_public_num_status.integerValue == 0){
                                    [MKAlertView alertWithTitle:@"提示" message:@"绑定微信可即时获取兼客报名通知" cancelButtonTitle:@"知道了" confirmButtonTitle:@"去绑定" viewController:[MKUIHelper getTopViewController] completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                        if (buttonIndex == 1) {
                                            UIViewController *viewCtrl = [MKUIHelper getTopViewController];
                                            if (viewCtrl && viewCtrl.navigationController) {
                                                WeChatBinding_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_wechatBinding"];
                                                vc.hidesBottomBarWhenPushed = YES;
                                                [viewCtrl.navigationController pushViewController:vc animated:YES];
                                            }
                                        }
                                    }];
                                }
                            }
                        });
                    }];

                }
            }
        }
            
        

        //是否第一次使用IM 已经导入IM历史消息?
        if (![XSJUserInfoData getisHaveIMHistoryWithUserId:weakSelf.selfInfo.accountId]) {
            [XSJUserInfoData setisHaveIMHistortWithUserId:weakSelf.selfInfo.accountId];
            DLog(@"=======first setisHaveIMHistortWithUserId=");
            [weakSelf updateMsgDataFromRCHistory];
            [weakSelf reloadUnReadCount];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateLocalMsgDataWithRCConversation:^(BOOL isSuccess) {
                    [weakSelf reloadUnReadCount];
                }];
            });
        }

    } error:^(RCConnectErrorCode status) {
        ELog(@"IM=====RCConnectErrorCode:%ld", (long)status);
    } tokenIncorrect:^{
        ELog(@"IM====token 失效，换取 token");
    }];
}

#pragma mark - =======================================================================================
#pragma mark - 第一次启动    从融云获取历史会话 保存前50条消息 并写入数据库  判断是否有客服消息，写入首条默认客服消息
- (void)updateMsgDataFromRCHistory{
    NSArray* conversationType = [ImDataManager getConversationTypes];
    NSArray* convArray = [[RCIMClient sharedRCIMClient] getConversationList:conversationType];
    BOOL _haveKefu = NO;
    for (RCConversation* conversation in convArray) {
        if (conversation.lastestMessage == nil) {
            ELog(@"======error===continue 1");
            continue;
        }
        if (conversation.conversationType == ConversationType_CUSTOMERSERVICE) {
            
            ELog(@"====有客服");
            _haveKefu = YES;
            
            int unreadCount = conversation.unreadMessageCount;
            NSArray* msgArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:unreadCount];
            
            NSMutableArray* saveMsgArray = [[NSMutableArray alloc] initWithCapacity:msgArray.count];
            for (RCMessage* msg in msgArray.reverseObjectEnumerator) {
                [saveMsgArray addObject:msg];
            }
            
            [self saveImConversationWithRCC:conversation Usertype:WDLoginType_JianKe msgArray:saveMsgArray block:^(BOOL isSuccess) {
                if (!isSuccess) DLog(@"=====保存信息到数据库失败");
            }];
            [self saveImConversationWithRCC:conversation Usertype:WDLoginType_Employer msgArray:saveMsgArray block:^(BOOL isSuccess) {
                if (!isSuccess) DLog(@"=====保存信息到数据库失败");
            }];
        }else if (conversation.conversationType == ConversationType_PRIVATE ){
            int unreadCount = conversation.unreadMessageCount;
            if (unreadCount > PageNum) {
                unreadCount = PageNum;
            }
            NSArray* msgArray;
            NSArray* unreadArray;
            ImPacket* packet;
            
            msgArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:PageNum];
            unreadArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:unreadCount];
            
            NSMutableArray* msgToJKArray = [[NSMutableArray alloc] init];
            NSMutableArray* msgToEPArray = [[NSMutableArray alloc] init];
            
            NSMutableArray* unreadJKAry = [[NSMutableArray alloc] init];
            NSMutableArray* unreadEPAry = [[NSMutableArray alloc] init];
            
            NSInteger unreadJKCount = 0;
            NSInteger unreadEPCount = 0;
            
            for (RCMessage* msg in msgArray.reverseObjectEnumerator) {
                packet = [ImDataManager packetFromRCMessage:msg];
                if (packet) {
                    //区分JK EP 端消息
                    if ([packet.dataObj.toUser isEqualToString:self.selfInfo.accountId]) {
                        if (packet.dataObj.toType.intValue == WDImUserType_Jianke) {
                            [msgToJKArray addObject:msg];
                        }else if (packet.dataObj.toType.intValue == WDImUserType_Employer){
                            [msgToEPArray addObject:msg];
                        }else if (packet.dataObj.toType.intValue == WDImUserType_EpJk){
                            [msgToJKArray addObject:msg];
                            [msgToEPArray addObject:msg];
                        }
                    }else if ([packet.dataObj.fromUser isEqualToString:self.selfInfo.accountId]){
                        if (packet.dataObj.fromType.intValue == WDImUserType_Jianke) {
                            [msgToJKArray addObject:msg];
                        }else if (packet.dataObj.fromType.intValue == WDImUserType_Employer){
                            [msgToEPArray addObject:msg];
                        }
                    }
                }
            }
            for (RCMessage* msg in unreadArray.reverseObjectEnumerator) {
                packet = [ImDataManager packetFromRCMessage:msg];
                if (packet) {
                    //区分JK EP 端消息
                    if ([packet.dataObj.toUser isEqualToString:self.selfInfo.accountId]) {
                        if (packet.dataObj.toType.intValue == WDImUserType_Jianke) {
                            [unreadJKAry addObject:msg];
                        }else if (packet.dataObj.toType.intValue == WDImUserType_Employer){
                            [unreadEPAry addObject:msg];
                        }else if (packet.dataObj.toType.intValue == WDImUserType_EpJk){
                            [unreadJKAry addObject:msg];
                            [unreadEPAry addObject:msg];
                        }
                    }else if ([packet.dataObj.fromUser isEqualToString:self.selfInfo.accountId]){
                        if (packet.dataObj.fromType.intValue == WDImUserType_Jianke) {
                            [unreadJKAry addObject:msg];
                        }else if (packet.dataObj.fromType.intValue == WDImUserType_Employer){
                            [unreadEPAry addObject:msg];
                        }
                    }
                }
            }
            unreadJKCount = unreadJKAry.count;
            unreadEPCount = unreadEPAry.count;
            
            __unused BOOL bSuccess =[[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:conversation.conversationType targetId:conversation.targetId];
            ELog(@"======清除未读消息:%@ , %d 条",bSuccess ? @"成功" : @"失败" , unreadCount);
            
            if (msgToJKArray.count > 0) {
                WEAKSELF
                [self saveImConversationWithRCC:conversation Usertype:WDLoginType_JianKe msgArray:msgToJKArray isFirst:YES unreadCount:unreadJKCount block:^(BOOL isSuccess) {
                    if (msgToEPArray.count > 0) {
                        [weakSelf saveImConversationWithRCC:conversation Usertype:WDLoginType_Employer msgArray:msgToEPArray isFirst:YES unreadCount:unreadEPCount block:^(BOOL isSuccess) {
                            if (!isSuccess) ELog(@"=====保存消息到数据库失败");
                        }];
                    }
                }];
            }else{
                if (msgToEPArray.count > 0) {
                    [self saveImConversationWithRCC:conversation Usertype:WDLoginType_Employer msgArray:msgToEPArray isFirst:YES unreadCount:unreadEPCount block:^(BOOL isSuccess) {
                        if (!isSuccess) ELog(@"=====保存消息到数据库失败");
                    }];
                }
            }
        }else if (conversation.conversationType == ConversationType_GROUP){
            int unreadCount = conversation.unreadMessageCount;
            if (unreadCount > PageNum) {
                unreadCount = PageNum;
            }
            NSArray* msgArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:PageNum];
            NSArray* unreadArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:unreadCount];
            NSInteger unreadMsgCount = unreadArray.count;
            
            NSMutableArray* saveMsgArray = [[NSMutableArray alloc] initWithCapacity:msgArray.count];
            for (RCMessage* msg in msgArray.reverseObjectEnumerator) {
                [saveMsgArray addObject:msg];
            }
            
            ImPacket* packet = [ImDataManager packetFromRCMessage:saveMsgArray.lastObject];
            
            if (saveMsgArray.count > 0) {
                NSString* localConversationIdSign = [self makeGroupLocalConversationIdSignWithUuid:conversation.targetId];
                ConversationModel* lcModel = [DataBaseTool conversationWithGroupConversationId:localConversationIdSign];
                if (!lcModel) {
                    NSString* groupId = packet.dataObj.toUser;
                    WEAKSELF
                    [[UserData sharedInstance] imGetGroupInfoWithGroupId:groupId block:^(IMGroupDetailModel* groupDetail) {
                        if (groupDetail) {
                            WDLogin_type lcType;
                            if ([groupDetail.groupOwnerEnt.stringValue isEqualToString:weakSelf.selfInfo.accountId] || [groupDetail.groupOwnerBd.stringValue isEqualToString:weakSelf.selfInfo.accountId]) {
                                lcType = WDLoginType_Employer;
                            }else{
                                lcType = WDLoginType_JianKe;
                            }
                            [weakSelf saveImConversationWithRCC:conversation Usertype:lcType msgArray:saveMsgArray isFirst:YES unreadCount:unreadMsgCount block:^(BOOL isSuccess) {
                                if (!isSuccess) ELog(@"=====保存消息到数据库失败");
                            }];
                        }
                    }];
                }else{
                    ELog(@"==error===应该不会走到这里");
                    [self saveImConversationWithRCC:conversation Usertype:lcModel.localConversationType.integerValue msgArray:saveMsgArray isFirst:YES unreadCount:unreadMsgCount block:^(BOOL isSuccess) {
                        if (!isSuccess) ELog(@"=====保存消息到数据库失败");
                    }];
                }
            }
        }else{
            ELog("=====还有其他类型 ？？？？？？？？？？？？？？？？？？");
        }
    }
    if (!_haveKefu) {
        //如果没有 客服消息  强制插入 2 条会话 和客服消息
        NSString* kefuLcId = [[ImDataManager sharedInstance] getKefuLocalConversationId];
        ConversationModel* kefuModel = [DataBaseTool conversationModelWithLocalConversationId:kefuLcId];
        if (!kefuModel) {
            RCTextMessage* lastMsg = [[RCTextMessage alloc] init];
            lastMsg.content = kefuFistText;
            
            //仿造 客服 发给自己的 RCMessage
            RCMessage* rcMsg = [[RCMessage alloc] init];
            rcMsg.conversationType = ConversationType_CUSTOMERSERVICE;
            rcMsg.targetId = self.selfInfo.accountId;
            rcMsg.messageDirection = MessageDirection_RECEIVE;
            rcMsg.senderUserId = KeFuMMId;
            rcMsg.receivedStatus = ReceivedStatus_UNREAD;
            rcMsg.receivedTime = [DateHelper getTimeStamp];
            rcMsg.sentTime = [DateHelper getTimeStamp];
            rcMsg.content = lastMsg;
            rcMsg.objectName = @"RC:TxtMsg";
            
            //仿造 RCConversation
            RCConversation* kefuRCC = [[RCConversation alloc] init];
            kefuRCC.unreadMessageCount = 1;
            kefuRCC.conversationType = ConversationType_CUSTOMERSERVICE;
            kefuRCC.targetId = KeFuMMId;
            kefuRCC.objectName = @"RC:TxtMsg";
            kefuRCC.sentTime = [DateHelper getTimeStamp];
            kefuRCC.lastestMessage = lastMsg;
            
            //创建 会话模型
            ConversationModel* lcModel = [[ConversationModel alloc] init];
            lcModel.userId = self.selfInfo.accountId;
            lcModel.targetId = KeFuMMId;
            lcModel.targetType = ConversationType_CUSTOMERSERVICE;
            lcModel.targetShowName = KEFU_NAME;
            lcModel.targetHeadUrl = KEFU_IMG;
            
            lcModel.unReadMsgCount = [NSNumber numberWithInteger:1];
            lcModel.conversation = kefuRCC;
            lcModel.rcConversationId = kefuRCC.targetId;
            
            lcModel.lastModifiedTime = [NSString stringWithFormat:@"%lld",kefuRCC.sentTime];
            lcModel.isSoundOff = NO;
            
            //保存到 JK 端
            lcModel.userType = WDImUserType_Jianke;
            lcModel.localConversationId = [[ImDataManager sharedInstance] getKefuLocalConversationIdwhitUsertype:lcModel.userType];
            [DataBaseTool saveImConversation:lcModel];
            [[ImDataManager sharedInstance] saveLocalMsgWithRCMsg:rcMsg andUnRead:YES andLocalConversationId:lcModel.localConversationId];
            
            //保存到 EP 端
            lcModel.userType = WDImUserType_Employer;
            lcModel.localConversationId = [[ImDataManager sharedInstance] getKefuLocalConversationIdwhitUsertype:lcModel.userType];
            [DataBaseTool saveImConversation:lcModel];
            [[ImDataManager sharedInstance] saveLocalMsgWithRCMsg:rcMsg andUnRead:YES andLocalConversationId:lcModel.localConversationId];
            
        }
    }
}


#pragma mark - 接收到 融云 消息后执行=====================================
/**
 接收到消息后执行。
 @param message 接收到的消息。
 @param left    剩余消息数.
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
//- (void)onReceived:(RCMessage *)message left:(int)left object:(id)object{
    ELog(@"=========收到消息：%@，还剩%d条消息", message, left);
    
#pragma mark - ***** 接收到融云消息，需要区别 兼客雇主的 类型，分别处理  做缓存  小红点通知 等等 ******

    ELog(@"=======targetId:%@",message.targetId);
    if (message.conversationType == ConversationType_GROUP) {
        ELog(@"=======ConversationType_GROUP");
    }else if (message.conversationType == ConversationType_PRIVATE){
        ELog(@"=======ConversationType_PRIVATE");
    }else if (message.conversationType == ConversationType_CUSTOMERSERVICE){
        ELog(@"=======ConversationType_CUSTOMERSERVICE");
    }else{
        ELog(@"=======没用到的 融云 消息类型");
    }

    ImPacket* packet = [ImDataManager packetFromRCMessage:message withUuid:message.targetId checkSign:NO]; //额外字段里的数据

//    ELog(@"===packet:%@",[packet simpleJsonString]);
    if (!packet && message.conversationType != ConversationType_CUSTOMERSERVICE) {  //客服专用
        return;
    }
    
    // 发送通知用于更新各种小红点 和 UI刷新
    [[ImDataManager sharedInstance] postReflushNotification:message];   //zs 只有服务端通知消息里的某些消息类型才刷新
    
    // 判断若是不显示的业务消息,就返回  (删了 有需要看旧版)
    if (message.conversationType == ConversationType_PRIVATE) {
        ImMessage *messaqge = [packet.dataObj getMessageContent];
        if (![self isShowInIm:messaqge]) {
            [RCIM sharedRCIM].disableMessageAlertSound = YES;
            if (([NSDate date].timeIntervalSince1970 - [XSJUserInfoData sharedInstance].openStamp) > 30) { //app打开的30秒之内不处理收到的通知栏消息(因为有伪造通知原因)
                [self pushLocalNotification:packet isShowInIM:NO notifType:LocalNotifTypeUrl];
            }
            return;
        }
    }
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
//    ELog(@"====packet:%@",[packet simpleJsonString]);
    //区分发给 兼客还是雇主的如果  不是现在的状态 就不提示 声音和振动
    if (message.conversationType == ConversationType_PRIVATE) {
        if (packet.dataObj.toType.intValue == self.selfInfo.account_type.intValue || packet.dataObj.toType.intValue == WDImUserType_EpJk) {
            [self checkPlaySoundOfMessage:message];
        }
    }else if (message.conversationType == ConversationType_GROUP){
        [self checkPlaySoundOfMessage:message isGroup:YES];
        
    } else if (message.conversationType == ConversationType_CUSTOMERSERVICE){
        [self checkPlaySoundOfMessage:message];
    }
    
    //从融云获取消息  更新本地数据库
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateLocalMsgDataWithRCConversation:^(BOOL ishaveHave) {
            id targetObject = message;
            NSString* targetMsg = OnNewRCMessageNotify;
//            if (packet && packet.dataObj) {
//                ELog(@"========packet.dataObj.bizType.intValue:%i:",packet.dataObj.bizType.intValue);
//                switch (packet.dataObj.bizType.intValue) {
//                    case ImBizType_NewFriend:           // 添加好友请求
//                        targetMsg = OnAddFriendRequestNotify;
//                        targetObject = packet;
//                        [WDNotificationCenter postNotificationName:OnNewRCMessageNotify object:message];
//                        break;
//                    case ImBizType_NewFriendResponse:   // 添加好友响应
//                        targetMsg = OnAddFriendResponsetNotify;
//                        targetObject = packet;
//                        [WDNotificationCenter postNotificationName:OnNewRCMessageNotify object:message];
//                        break;
//                    case ImBizType_InBlackListNotify:   // 添加黑名单
//                        targetMsg = OnAddToBlacklistNotify;
//                        targetObject = packet;
//                        break;
//                    case ImBizType_DelByFriend:         // 删除好友
//                        targetMsg = OnDeleteFriendNotify;
//                        targetObject = packet;
//                        break;
//                    case ImBizType_FansListUpdate:      //粉丝列表更新
//                        targetMsg = OnAttentionChangeNotify;
//                        targetObject = packet;
//                        break;
//                    default:
//                        break;
//                }
//            }
            //全局通知
            [WDNotificationCenter postNotificationName:targetMsg object:targetObject];
            [weakSelf reloadUnReadCount];
            
            [weakSelf pushLocalNotification:packet isShowInIM:YES notifType:LocalNotifTypeText];
        }];
    });
}

#pragma mark - 通知小红点========
/** 发送各种用于更新小红点的通知 */
- (void)postReflushNotification:(RCMessage*)message{
    ImPacket *packet = [ImDataManager packetFromRCMessage:message];
    if (packet.dataObj.bizType.intValue == ImBizType_ServerNotifyMessage) {
        ImSystemMsg *sysMsg = [packet.dataObj getMessageContent];
        switch (sysMsg.notice_type.integerValue) {
                // 兼客 && 雇主
                // 兼客待办事项大红点 && 雇主正在招人卡片左上角带数字大红点 && 雇主已报名 &&
            case WdSystemNoticeType_JkApply : // = 1         //兼客申请岗位
            {
                [WDNotificationCenter postNotificationName:IMPushJKWaitTodoNotification object:nil];
            }
                break;
                // 钱袋子
            case WdSystemNoticeType_JkMoneyAdd:                 //系统给兼客发的到账提醒
            case WdSystemNoticeType_RechargeMoneySuccess :      // = 34 //充值成功
            case WdSystemNoticeType_GetMoneySuccess :           // = 35 //取现成功
            case WdSystemNoticeType_PaySuccess :                // = 37 //付款成功
            case WdSystemNoticeType_DeductRecognizance:         // = 42 //扣除保证金
            {
                [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = YES;
                [WDNotificationCenter postNotificationName:IMPushWalletNotification object:nil];
            }
                break;
                // 兼客
                // 兼客待办事项大红点
            case WdSystemNoticeType_GzAgree : // =3,         //雇主同意申请
            case WdSystemNoticeType_GzRefuse: // = 4,        //雇主拒绝申请
            case WdSystemNoticeType_EpLookResume : // = 38   //雇主查看简历
            case WdSystemNoticeType_EpCheckJobOver : // = 39      //雇主确认工作完成
            {
                [XSJUserInfoData sharedInstance].isShowMyApplyRedPoint = YES;
                [WDNotificationCenter postNotificationName:IMPushJKWaitTodoNotification object:nil];
            }
                break;
                
                // 兼客工作经历小红点
            case WdSystemNoticeType_GzComplaintFgz : // = 18,     //雇主投诉兼客放鸽子
            case WdSystemNoticeType_EpEvaluationJk: // = 40,      //雇主评论兼客
            case WdSystemNoticeType_JkNotWorkConsultToEp:// = 41, //兼客未到岗(与雇主沟通一致)
            {
                [WDNotificationCenter postNotificationName:IMPushJKWorkHistoryNotification object:nil];
            }
                break;
                
                // 雇主
                // 雇主正在招人列表卡片左上角大红点
            case WdSystemNoticeType_JobVerifySuccess : // = 14,     //岗位审核通过
            case WdSystemNoticeType_JobVerifyFail : // = 15,      //岗位审核未通过
            case WdSystemNoticeType_JkApply_Ep:                  // 48：兼客申请岗位(雇主)
            {
                [WDNotificationCenter postNotificationName:IMNotification_EPMainUpdate object:nil];
            }
                break;
            case WdSystemNoticeType_removeFormGroup:             // 68: 将成员移除群组
            case WdSystemNoticeType_dismissGroup:                // 69: 解散群组
            {
//                [packet.dataObj getMessageContent];
//                {"message":"你被群管理员移出【辣辣】群组","groupId":2889,"name":"兼客团队","notice_type":68,"headUrl":"http://wodan-idc.oss-cn-hangzhou.aliyuncs.com/shijianke-im/System2.png"}
                [DataBaseTool hideConversationWithGroupId:sysMsg.groupId];
                [WDNotificationCenter postNotificationName:IMNotification_updateConversationList object:nil];
            }
                break;
            case WdSystemNoticeType_WeChatBindingSuccess:{      // 75: 微信公众号绑定成功
//                [WDNotificationCenter postNotificationName:IMNotification_WeChatBindingSuccess object:nil];
                break;
            }
            case WdSystemNoticeType_BDSendBillForPayToEP:{       // 60: bd发送账单给雇主支付
                [XSJUserInfoData sharedInstance].isShowEpBaozhaoCheckRedPoint = YES;
                [WDNotificationCenter postNotificationName:IMNotification_BDSendBillForPayToEP object:nil];
            }
                break;
            case WdSystemNoticeType_JkrzVerifyPass:             //11：兼客认证审核已通过
            case WdSystemNoticeType_JkrzVerifyFaild :{          //12：兼客认证审核未通过
                [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
            }
                break;
            case WdSystemNoticeType_ServicePersonalAuditPass:{  //个人服务审核通过
                JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
                jkModel.is_apply_service_personal = @1;
                [WDNotificationCenter postNotificationName:UpdateIsPersonaService object:nil];
            }
                break;
            case WdSystemNoticeType_PersonalServiceBackouted:{  //个人服务被下架
                JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
                jkModel.is_apply_service_personal = @0;
                [WDNotificationCenter postNotificationName:UpdateIsPersonaService object:nil];
            }
                break;
            case WdSystemNoticeType_ServicePersonalInvite:{ //个人服务邀约通知
                [XSJUserInfoData sharedInstance].isShowPersonalServiceRedPoint = YES;
                [WDNotificationCenter postNotificationName:IMPushGetPersonaServiceJobNotification object:nil];
            }
                break;
            case WdSystemNoticeType_openUrlMessage:{    //78: 文本消息及url链接。客户端展示message的内容，点击 查看详情 是app浏览器打开（open_url）地址。
                if (sysMsg.open_url.length && [sysMsg.open_url rangeOfString:@"toMoneyBagPage"].location != NSNotFound) {
                    [WDNotificationCenter postNotificationName:WDNotifi_updateMyInfo object:nil];
                }
            }
                break;
            case WdSystemNoticeType_GetApplyFitst :      // = 27        //获得首个报名
            case WdSystemNoticeType_GetSnagFitst :       // = 28        //获得首个抢单
            case WdSystemNoticeType_JobApplyFull :       // = 29    //岗位已报满
            case WdSystemNoticeType_JobSnagEnd :         // = 30    //岗位已抢完
            case WdSystemNoticeType_JobBackouted :       // = 36       //岗位被下架
            case WdSystemNoticeType_JobMoveToComplete:   // = 43      //岗位已移到已完成
            case WdSystemNoticeType_JkHasEvaluation :    // = 7,     //兼客已评介申请岗位
            case WdSystemNoticeType_GzHasEvaluation :    // = 8,     //雇主已评介申请岗位
            case WdSystemNoticeType_QyrzVerifyPass :     // =9,      //企业认证审核通过
            case WdSystemNoticeType_QyrzVerifyFaild :    // = 10,    //企业认证审核未通过
            case WdSystemNoticeType_JobApplyComplain :   // = 16,   //岗位申请被投诉
            case WdSystemNoticeType_JkComplaintGzPost :  // = 19   //兼客投诉雇主岗位
            case WdSystemNoticeType_EpPayNotification :  // = 20        //系统给雇主发送付款提醒
            case WdSystemNoticeType_JkWorkTomorrow :     // = 22        //系统提醒兼客明天上岗
            case WdSystemNoticeType_ChangePhoneSuccess : // = 23        //手机号修改成功
            case WdSystemNoticeType_ChangePwdSuccess :   // = 24        //密码修改成功
            case WdSystemNoticeType_IdAuthSuccess :      // = 25        //身份认证成功
            case WdSystemNoticeType_IdAuthFail :         // = 26        //身份认证失败
            case WdSystemNoticeType_EpCertificateAuthSuccess :  // = 31 //营业执照认证成功
            case WdSystemNoticeType_EpCertificateAuthFail :     // = 32 //营业执照认证失败
            case WdSystemNoticeType_JopAnswerQuestion :         // = 33 //关于岗位的提问和答复
            default:
                break;
        }
    }
}

#pragma mark - 检查是否要播放声音
- (void)checkPlaySoundOfMessage:(RCMessage *)message{
    [self checkPlaySoundOfMessage:message isGroup:NO];
}

- (void)checkPlaySoundOfMessage:(RCMessage *)message isGroup:(BOOL)isGroup{
    
    // 全局静音
    if ([[UserData sharedInstance] getUserImNoticeQuietState]) {
        return;
    }
    
    // 是客服消息
    if ([message.targetId isEqualToString:KeFuMMId]) {
        NSString* localConversationId = [[ImDataManager sharedInstance] getKefuLocalConversationId];
        ConversationModel *lcModel = [DataBaseTool conversationModelWithLocalConversationId:localConversationId];
        if (!lcModel || !lcModel.isSoundOff) {
            ELog(@"playSound === 1")
            [UIHelper playSound];
        }
        return;
    }
    
    ImPacket* packet = [ImDataManager packetFromRCMessage:message];
    
    if (self.selfInfo && packet) {
        ConversationModel* lcModel;
        if (isGroup) {
            if (packet.dataObj.bizType.intValue == ImBizType_ServerNotifyMessage) {
                ImSystemMsg* sysMsg = [packet.dataObj getMessageContent];
                //入群 退群 不做提醒
                if (sysMsg.notice_type.intValue == WdSystemNoticeType_JoinImGroup || sysMsg.notice_type.intValue == WdSystemNoticeType_quitImGroup) {
                    return;
                }
            }
            
            NSString* localConversationIdSign = [self makeGroupLocalConversationIdSignWithUuid:message.targetId];
            lcModel = [DataBaseTool conversationWithGroupConversationId:localConversationIdSign];
        }else{
            NSString* localConversationId = [NSString stringWithFormat:@"%@_%@_%@_%@", self.selfInfo.accountId,self.selfInfo.account_type,packet.dataObj.fromUser,packet.dataObj.fromType];
            lcModel = [DataBaseTool conversationModelWithLocalConversationId:localConversationId];
        }
        if (!lcModel || !lcModel.isSoundOff) {
            ELog(@"playSound === 2")
            [UIHelper playSound];
        }
    }
    //    NSString *key = [NSString stringWithFormat:@"Sound_%@", message.targetId];
    //    BOOL isClose = [WDUserDefaults boolForKey:key];
    
    //    if (!isClose) {
    //        [UIHelper playSound];
    //    }
}

#pragma mark - 从融云获取消息 并写入数据库
- (void)updateLocalMsgDataWithRCConversation:(MKBoolBlock)block{
    ELog(@"=====updateLocalMsgDataWithRCConversation");
//    BOOL isNeedRequest = NO;
//    NSArray* conversationType = [ImDataManager getConversationTypes];
//    NSArray* rccArray = [[RCIMClient sharedRCIMClient] getConversationList:conversationType];
    //遍历是否有新的群组 有的话需要 请求 新群组的 数据
//    for (RCConversation* conversation in rccArray) {
//        if (conversation.conversationType == ConversationType_GROUP) {
//            NSString* sign = [self makeGroupLocalConversationIdSignWithUuid:conversation.targetId];
//            ConversationModel* cModel = [DataBaseTool conversationWithGroupConversationId:sign];
//            if (!cModel) {
//                isNeedRequest = YES;
//                break;
//            }
//        }
//    }
//    if (isNeedRequest) {
//        WEAKSELF
//        [[UserData sharedInstance] imGetMgrGroupsWithBlock:^(NSArray *imGroups) {
//            _imGroups = imGroups;
//            [weakSelf updateLocalMsgDataWithRCC:block];
//        }];
//    }else{
        [self updateLocalMsgDataWithRCC:block];
//    }
}

- (void)updateLocalMsgDataWithRCC:(MKBoolBlock)block{
    //获取会话列表
    NSArray* conversationType = [ImDataManager getConversationTypes];
    NSArray* rccArray = [[RCIMClient sharedRCIMClient] getConversationList:conversationType];
    
    for (RCConversation* conversation in rccArray) {
        if (conversation.lastestMessage == nil) {
            ELog(@"========continue 1");
            continue;
        }
        
        switch (conversation.conversationType) {
            case ConversationType_CUSTOMERSERVICE:
            {
                int unreadCount = conversation.unreadMessageCount;
                NSArray* msgArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:unreadCount];
                
                NSMutableArray* saveMsgArray = [[NSMutableArray alloc] initWithCapacity:msgArray.count];
                for (RCMessage* msg in msgArray.reverseObjectEnumerator) {
//                    ImMessage *message = [ImDataManager messageFromRCMessage:msg];
//                    if ([self isShowInIm:message]) {
                        [saveMsgArray addObject:msg];
//                    }
                }
                
                [self saveImConversationWithRCC:conversation Usertype:WDLoginType_JianKe msgArray:saveMsgArray block:^(BOOL isSuccess) {
                    if (!isSuccess) DLog(@"=====保存信息到数据库失败");
                }];
                [self saveImConversationWithRCC:conversation Usertype:WDLoginType_Employer msgArray:saveMsgArray block:^(BOOL isSuccess) {
                    if (!isSuccess) DLog(@"=====保存信息到数据库失败");
                }];
            }
                break;
            case ConversationType_PRIVATE:
            {
                int unreadCount = conversation.unreadMessageCount;
                if (unreadCount > 0) {
                    NSMutableArray* msgToJKArray = [[NSMutableArray alloc] init];
                    NSMutableArray* msgToEpArray = [[NSMutableArray alloc] init];
                    NSArray* msgArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:unreadCount];
                    ImPacket* packet;
                    for (RCMessage* msg in msgArray.reverseObjectEnumerator) {
                        packet = [ImDataManager packetFromRCMessage:msg];
                        if (packet) {
                            //区分JK EP 端消息
                            if ([packet.dataObj.toUser isEqualToString:self.selfInfo.accountId]) {
                                if (packet.dataObj.toType.intValue == WDImUserType_Jianke) {
                                    [msgToJKArray addObject:msg];
                                }else if (packet.dataObj.toType.intValue == WDImUserType_Employer){
                                    [msgToEpArray addObject:msg];
                                }else if (packet.dataObj.toType.intValue == WDImUserType_EpJk){
                                    if ([self isShowInIm:[packet.dataObj getMessageContent]]) {
                                        [msgToJKArray addObject:msg];
                                        [msgToEpArray addObject:msg];
                                    }
                                }
                            }else if ([packet.dataObj.fromUser isEqualToString:self.selfInfo.accountId]){
                                if (packet.dataObj.fromType.intValue == WDImUserType_Jianke) {
                                    [msgToJKArray addObject:msg];
                                }else if (packet.dataObj.fromType.intValue == WDImUserType_Employer){
                                    [msgToEpArray addObject:msg];
                                }
                            }else if (packet.dataObj.bizType.intValue == ImBizType_ImageAndTextMessage){
                                if (packet.dataObj.toType.intValue == WDImUserType_Jianke) {
                                    [msgToJKArray addObject:msg];
                                }else if (packet.dataObj.toType.intValue == WDImUserType_Employer){
                                    [msgToEpArray addObject:msg];
                                }
                            }
                        }else{
                            ELog(@"========continue 3");
                            continue;
                        }
                    }
                    __unused BOOL bSuccess =[[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:conversation.conversationType targetId:conversation.targetId];
                    ELog(@"======清除未读消息:%@， %d 条，msgToJKArray:%lu ,msgToEpArray:%lu",bSuccess ? @"成功" : @"失败", unreadCount,(unsigned long)msgToJKArray.count, (unsigned long)msgToEpArray.count );
                    
                    if (msgToJKArray.count > 0) {
                        WEAKSELF
                        [self saveImConversationWithRCC:conversation Usertype:WDLoginType_JianKe msgArray:msgToJKArray block:^(BOOL isSuccess) {
                            if (!isSuccess) DLog(@"=====保存信息到数据库失败");
                            if (msgToEpArray.count > 0) {
                                [weakSelf saveImConversationWithRCC:conversation Usertype:WDLoginType_Employer msgArray:msgToEpArray block:^(BOOL isSuccess) {
                                    if (!isSuccess) DLog(@"=====保存信息到数据库失败");
                                }];
                            }
                        }];
                    }else{
                        if (msgToEpArray.count > 0) {
                            [self saveImConversationWithRCC:conversation Usertype:WDLoginType_Employer msgArray:msgToEpArray block:^(BOOL isSuccess) {
                                if (!isSuccess) DLog(@"=====保存信息到数据库失败");
                            }];
                        }
                    }
                }
            }
                break;
            case ConversationType_GROUP:
            {
                int unreadCount = conversation.unreadMessageCount;
                if (unreadCount > 0) {
                    NSArray* msgArray = [[RCIMClient sharedRCIMClient] getLatestMessages:conversation.conversationType targetId:conversation.targetId count:unreadCount];
                    
                    NSMutableArray* groupMsgArray = [[NSMutableArray alloc] initWithCapacity:msgArray.count];
                    for (RCMessage* msg in msgArray.reverseObjectEnumerator) {
                        [groupMsgArray addObject:msg];
                    }
                    
                    __unused BOOL bSuccess = [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:conversation.conversationType targetId:conversation.targetId];
                    ELog(@"======清除未读消息:%@, %lu 条",bSuccess ? @"成功" : @"失败", (unsigned long)groupMsgArray.count);
                    
                    NSString* localConversationIdSign = [self makeGroupLocalConversationIdSignWithUuid:conversation.targetId];
                    ConversationModel* lcModel = [DataBaseTool conversationWithGroupConversationId:localConversationIdSign];
                    
                    if (lcModel) {
                        if (groupMsgArray.count > 0) {
                            [self saveImConversationWithRCC:conversation Usertype:lcModel.localConversationType.integerValue msgArray:groupMsgArray block:^(BOOL isSuccess) {
                                if (!isSuccess) DLog(@"=====保存信息到数据库失败");
                            }];
                        }
                    }else{
                        if (groupMsgArray.count > 0) {
                            RCMessage* lastMsg = [groupMsgArray objectAtIndex:0];
                            
                            ImPacket* packet = [ImDataManager packetFromRCMessage:lastMsg];
                            if (!packet) {
                                continue;
                            }

                            WEAKSELF
                            [[UserData sharedInstance] imGetGroupInfoWithGroupId:packet.dataObj.toUser isSimple:YES block:^(IMGroupDetailModel* groupDetail) {
                                if (groupDetail) {
                                    WDLogin_type lcType = WDLoginType_JianKe;
                                    if (weakSelf.selfInfo.accountId.integerValue == groupDetail.groupOwnerBd.integerValue
                                        || weakSelf.selfInfo.accountId.integerValue == groupDetail.groupOwnerEnt.integerValue) {
                                        lcType = WDLoginType_Employer;
                                    }
                                    [weakSelf saveImConversationWithRCC:conversation Usertype:lcType msgArray:groupMsgArray block:^(BOOL isSuccess) {
                                        if (!isSuccess) DLog(@"=====保存信息到数据库失败");
                                    }];
                                }
                            }];
                        }
                    }
                }
            }
            default:
                break;
        }
    }
    if (block) {
        block(YES);
    }

}



#pragma mark - 根据消息 数组 保存 会话 和 消息 到数据库=============================
- (void)saveImConversationWithRCC:(RCConversation *)conversation Usertype:(WDLogin_type)type msgArray:(NSArray *)msgArray block:(MKBoolBlock)block{
    [self saveImConversationWithRCC:conversation Usertype:type msgArray:msgArray isFirst:NO unreadCount:0 block:block];
}

// 传入 消息数组 和 融云会话   将会话 和 数组内的 消息保存到 本地数据库
- (void)saveImConversationWithRCC:(RCConversation*)conversation Usertype:(WDLogin_type)type msgArray:(NSArray*)msgArray isFirst:(BOOL)isFirst unreadCount:(NSInteger)unreadCount block:(MKBoolBlock)block{

    //如果是 客服  只存会话
    if (conversation.conversationType == ConversationType_CUSTOMERSERVICE ) {
        
        NSString* kefuLocalConversationId = [self getKefuLocalConversationIdwhitUsertype:type];
        ConversationModel* kefuModel = [[ConversationModel alloc] init];
        kefuModel.userId = self.selfInfo.accountId;
        kefuModel.userType = type;
        kefuModel.targetId = KeFuMMId;
        kefuModel.targetType = ConversationType_CUSTOMERSERVICE;
        kefuModel.targetShowName = KEFU_NAME;
        kefuModel.targetHeadUrl = KEFU_IMG;
        kefuModel.localConversationType = [NSString stringWithFormat:@"%ld",(long)type];
        kefuModel.rcConversationId = conversation.targetId;
        kefuModel.localConversationId = kefuLocalConversationId;
        
        kefuModel.conversation = conversation;
        kefuModel.lastModifiedTime = [NSString stringWithFormat:@"%lld",conversation.sentTime];
        if (msgArray.count) {
            kefuModel.unReadMsgCount = @(msgArray.count);
        }else{
            kefuModel.unReadMsgCount = @(0);
        }
        [DataBaseTool saveImConversation:kefuModel];
        if (block) {
            block(YES);
        }
    }else if(conversation.conversationType == ConversationType_PRIVATE || conversation.conversationType == ConversationType_GROUP){
        if (msgArray.count > 0) {

            ConversationModel* lcModel = [[ConversationModel alloc] init];
            lcModel.userId = self.selfInfo.accountId;
            lcModel.userType = type;
//            lcModel.targetShowName
//            lcModel.targetHeadUrl
            lcModel.conversation = conversation;
            lcModel.rcConversationId = conversation.targetId;
            lcModel.localConversationType = [NSString stringWithFormat:@"%ld",(long)type];
            //获取最后一条消息
            RCMessage* lastMsg = [msgArray lastObject];
            ImPacket* packet = [ImDataManager packetFromRCMessage:lastMsg];
            ImMessage *msgContent = [packet.dataObj getMessageContent];

            lcModel.lastModifiedTime = [NSString stringWithFormat:@"%lld",lastMsg.sentTime];

            if (conversation.conversationType == ConversationType_GROUP) {
                lcModel.isGroupConversation = YES;
                lcModel.groupConversationId = [self makeGroupLocalConversationIdSignWithUuid:conversation.targetId];
                if (type == WDLoginType_Employer) {
                    lcModel.isGroupManage = YES;
                }else{
                    lcModel.isGroupManage = NO;
                }
                if (packet) {
                    lcModel.targetId = packet.dataObj.toUser;
                    lcModel.targetType = packet.dataObj.toType.integerValue;
                }
                if (msgContent.groupName) {lcModel.groupName = msgContent.groupName;}

            }else if (conversation.conversationType == ConversationType_PRIVATE){
                lcModel.isGroupConversation = NO;
                lcModel.isGroupManage = NO;
                if (packet) {
                    if ([packet.dataObj.fromUser isEqualToString:self.selfInfo.accountId]) {
                        lcModel.targetId = packet.dataObj.toUser;
                        lcModel.targetType = packet.dataObj.toType.intValue;
                    }else{
                        lcModel.targetId = packet.dataObj.fromUser;
                        lcModel.targetType = packet.dataObj.fromType.intValue;
                    }
                }
            }
//            if (packet.dataObj.bizType.intValue == ImBizType_ServerNotifyMessage) {
            if (msgContent.job_id) {lcModel.jobId = msgContent.job_id.stringValue;}
            if (msgContent.headUrl) {lcModel.targetHeadUrl = msgContent.headUrl;}
            if (msgContent.name) {lcModel.targetShowName = msgContent.name;}
//            }

            //拼凑本地 会话ID
            lcModel.localConversationId = [NSString stringWithFormat:@"%@_%@_%@_%@",lcModel.userId,@(lcModel.userType),lcModel.targetId,@(lcModel.targetType)];

            //入群 退群 不做 消息数量提醒
            if (!isFirst) {
                unreadCount = msgArray.count;
            }
            if (conversation.conversationType == ConversationType_GROUP) {
                for (RCMessage* msg in msgArray) {
                    ImPacket* msgPacket = [ImDataManager packetFromRCMessage:msg];
                    if (msgPacket.dataObj.bizType.intValue == ImBizType_ServerNotifyMessage) {
                        ImSystemMsg* sysMsg = [msgPacket.dataObj getMessageContent];
                        if (sysMsg.notice_type.intValue == WdSystemNoticeType_JoinImGroup || sysMsg.notice_type.intValue == WdSystemNoticeType_quitImGroup) {
                            unreadCount--;
                        }
                    }
                }
            }
          
            if (isFirst) {      //第一次导入  传进来的msgArray 是所有消息的  未读数量要使用传进来的
                lcModel.unReadMsgCount = @(unreadCount);
            }else{              //不是第一次   传进来的 未读消息数组 数量  加上  数据中的 未读数量
                lcModel.unReadMsgCount = [NSNumber numberWithInteger:unreadCount];
                ConversationModel* tempLcModel = [DataBaseTool conversationModelWithLocalConversationId:lcModel.localConversationId];
                if (tempLcModel) {
                    lcModel.unReadMsgCount = @(unreadCount + tempLcModel.unReadMsgCount.integerValue);
                    lcModel.isSoundOff = tempLcModel.isSoundOff;
                }
            }
            
            //存会话
            [DataBaseTool saveImConversation:lcModel];
            
            for (RCMessage* msg in msgArray) {
                //存消息
                [self saveLocalMsgWithRCMsg:msg andUnRead:!isFirst andLocalConversationId:lcModel.localConversationId];
            }
            
            if (block) {
                block(YES);
            }
        }
    }
}

#pragma mark - 保存消息  到数据库
- (void)saveLocalMsgWithRCMsg:(RCMessage*)msg andUnRead:(BOOL)unRead andLocalConversationId:(NSString*)localConversationId{
    LocalMessageModel* msgModel = [[LocalMessageModel alloc] init];
    msgModel.LocalConverSationId = localConversationId;
    msgModel.isUnRead = unRead ? @(1) : @(0);
    msgModel.RcMessage = msg;
    [DataBaseTool saveImMessageWith:msgModel];
}

#pragma mark - 从数据库中获取未读消息 总数量
- (void)reloadUnReadCount{
    NSInteger count = [DataBaseTool unReadMessageCountWithUserId:self.selfInfo.accountId userType:self.selfInfo.account_type.integerValue];
    //    NSInteger count = [[RCIMClient sharedRCIMClient] getUnreadCount:[ImDataManager getConversationTypes]];
    ELog(@"======通知首页 修改消息数量 msg count:%ld",(long)count);
    NSMutableDictionary* msgCountDic = [NSMutableDictionary dictionary];
    msgCountDic[@"msgCount"] = [NSNumber numberWithInteger:count];
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe) {
            [WDNotificationCenter postNotificationName:WDNotification_JK_homeUpdateMsgNum object:weakSelf userInfo:msgCountDic];
        }else if ([[UserData sharedInstance] getLoginType].integerValue == WDLoginType_Employer){
            [WDNotificationCenter postNotificationName:WDNotification_EP_homeUpdateMsgNum object:weakSelf userInfo:msgCountDic];
        }
    });
}

- (NSInteger)getUnreadMsgCount{
    NSInteger count = [DataBaseTool unReadMessageCountWithUserId:self.selfInfo.accountId userType:self.selfInfo.account_type.integerValue];
    return count;
}

#pragma mark - 拼凑 会话ID
// 拼凑 群租 会话标识
- (NSString*)makeGroupLocalConversationIdSignWithUuid:(NSString*)groupUuid{
    NSString* sign = [NSString stringWithFormat:@"%@_%@", self.selfInfo.accountId, groupUuid];
    return sign;
}

//获取  客服本地会话ID
- (NSString*)getKefuLocalConversationId{
    return [self getKefuLocalConversationIdwhitUsertype:self.selfInfo.account_type.integerValue];
}

//获取  客服本地会话ID 根据 usertype
- (NSString*)getKefuLocalConversationIdwhitUsertype:(NSInteger)usertype{
    NSString* kefuLocalConversationId = [NSString stringWithFormat:@"%@_%ld_%@_%lu",self.selfInfo.accountId,(long)usertype,KeFuMMId,(unsigned long)ConversationType_CUSTOMERSERVICE];
    return kefuLocalConversationId;
}


- (BOOL)isShowInIm:(ImMessage *)message{
    if (!message) {
        return NO;
    }
    
    if ([message isKindOfClass:[ImSystemMsg class]]) {
        ImSystemMsg *msg = (ImSystemMsg *)message;
        if (msg.notice_type.integerValue == WdSystemNoticeType_noticeBoardMessage) {
            return NO;
        }
    }
    return YES;
}

- (void)pushLocalNotification:(ImPacket *)packet isShowInIM:(BOOL)isShowInIM notifType:(LocalNotifType)notifType{
    if ([XSJUserInfoData sharedInstance].isDidEnterBackground) {    //isshow用于刷新图标budge的 因为取自数据库之类的
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            [XSJUserNotificationMgr registerLoaclNotificationWithImMessage:packet isShowInIM:isShowInIM notifType:notifType];
        }else{
            [XSJLocalNotificationMgr registerLocalNotificationWithImMessage:packet isShowInIM:isShowInIM notifType:notifType];
        }
    }else if (!isShowInIM){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            ImSystemMsg *msg = (ImSystemMsg *)[packet.dataObj getMessageContent];
//            [XZNotifyView showWithContent:packet.dataObj.notifyContent url:msg.open_url clickBlock:^(id result) {
//                [[XSJRequestHelper sharedInstance] noticeBoardPushLogClickRecord:msg.message_id block:^(id result) {
//                    
//                }];
//            }];
//        });
    }
}

#pragma mark - 获取用户信息的方法。
- (ImUserInfo*)systemInfo{
    ELog(@"======系统消息");
    if (!_systemInfo) {
        _systemInfo = [[ImUserInfo alloc] init];
        _systemInfo.accountId = SystemUserId;
        _systemInfo.accountName = @"系统通知";
    }
    return _systemInfo;
}

//从融云获取用户信息  好像没有用到
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
//    if ([userId isEqualToString:self.selfInfo.uuid]) {
//        if (!self.selfInfo.userPublicInfo) {
//            ImUserPublicInfo* info = [[ImUserPublicInfo alloc] init];
//            info.name = self.selfInfo.nickname;
//            info.portraitUri = self.selfInfo.headUrl;
//            info.userId = userId;
//            self.selfInfo.userPublicInfo = info;
//        }
//        return completion(self.selfInfo.userPublicInfo);
//    }
//    ImUserInfo* userInfo = [self getUserInfoById:userId];
//    return completion(userInfo.userPublicInfo);
//}
//
////根据 id 从本地 获取 用户信息     好像也没用到
//- (ImUserInfo*)getUserInfoById:(NSString *)userId{
//    ImUserInfo* info;
//    info = [self getImUserInfoById:userId];
//    if (info) {
//        return info;
//    }
//    info = [self getEpInfoById:userId];
//    if (info) {
//        return info;
//    }
//    info = [self getFuncInfoById:userId];
//    if (info) {
//        return info;
//    }
//    return nil;
//}

+ (void)getUserInfoById:(NSString *)accountId withType:(int)type allowCache:(BOOL)bAllowCache completion:(MKBlock)completion{
    ELog(@"====type:%i ====accountId:%@", type, accountId);
    switch (type) {
        case WDImUserType_Jianke:
        {
            ELog(@"=========WDImUserType_Jianke");
            if (bAllowCache) {
                ImUserInfo* info = [[ImDataManager sharedInstance] getImUserInfoById:accountId];
                if (info) {
                    MKBlockExec(completion,info)
                    return ;
                }
            }
            NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", accountId];
            RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
            request.isShowLoading = NO;
            [request sendRequestToImServer:^(ResponseInfo* response) {
                if (response && [response success]) {
                    ImUserInfo* userInfo = [ImUserInfo objectWithKeyValues:response.content[@"friend"]];
                    userInfo.account_type = [NSNumber numberWithInt:WDImUserType_Jianke];
                    userInfo.accountName = userInfo.nickname;
                    [[ImDataManager sharedInstance] saveUserInfoWithId:userInfo];
                    MKBlockExec(completion,userInfo)
                }else{
                    MKBlockExec(completion,nil);
                }
            }];
        }
            break;
        case WDImUserType_Employer:
        {
            ELog(@"=========WDImUserType_Employer");
            if (bAllowCache) {
                EmployerInfo* info = [[ImDataManager sharedInstance] getEpInfoById:accountId];
                if (info) {
                    MKBlockExec(completion,info)
                    return;
                }
            }
            NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", accountId];
            RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getEnterprisePublicInfo" andContent:content];
            request.isShowLoading = NO;
            [request sendRequestToImServer:^(ResponseInfo* response) {
                if (response && [response success]) {
                    EmployerInfo* userInfo = [EmployerInfo objectWithKeyValues:response.content[@"friend"]];
                    userInfo.account_type = [NSNumber numberWithInt:WDImUserType_Employer];
                    userInfo.accountName = userInfo.nickname;
                    [[ImDataManager sharedInstance] saveEpInfoWithId:userInfo];
                    MKBlockExec(completion,userInfo)
                }else{
                    MKBlockExec(completion,nil)
                }
            }];
        }
            break;
        case WDImUserType_Func:         //功能号， 必须关注的功能号， 自身关注的功能号
        {
            ELog(@"=======WDImUserType_Func");
            if (bAllowCache) {
                GlobalFeatureInfo* info = [[ImDataManager sharedInstance] getFuncInfoById:accountId];
                if (info) {
                    MKBlockExec(completion,info)
                    return ;
                }
            }
            NSString* content = [NSString stringWithFormat:@"globalVersion:%d,version:%d", 0, 0];
            RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getFunctionList" andContent:content];
            request.isShowLoading = NO;
            [request sendRequestToImServer:^(ResponseInfo* response) {
                if (response && [response success]) {
                    GlobalFeatureInfo* funcInfo;
                    NSNumber* result = [response.content objectForKey:@"globalVersionResult"];
                    //1:版本一致,无需更新 2:版本滞后，需要更新
                    if (result.intValue != 1) {
                        NSDictionary* globalFocusFun = [response.content objectForKey:@"globalFocusFun"];
                        NSArray* list = [GlobalFeatureInfo objectArrayWithKeyValuesArray:globalFocusFun[@"list"]];
                        for (GlobalFeatureInfo* info in list) {
                            info.account_type = [NSNumber numberWithInt:WDImUserType_Func];
                            info.accountName = info.nickname;
                            if ([info.accountId isEqualToString:accountId]) {
                                funcInfo = info;
                            }
                            [[ImDataManager sharedInstance] saveFuncInfoWithId:info];
                        }
                    }
                    result = [response.content objectForKey:@"versionResult"];
                    //1:版本一致,无需更新 2:版本滞后，需要更新 mark to do 服务端暂时不支持；
                    if (result.intValue != 1) {
                        NSDictionary* friends = [response.content objectForKey:@"focusFun"];
                        NSArray* list = [GlobalFeatureInfo objectArrayWithKeyValuesArray:friends[@"list"]];
                        for (GlobalFeatureInfo* info in list) {
                            info.account_type = [NSNumber numberWithInt:WDImUserType_Func];
                            info.accountName = info.nickname;
                            if ([info.accountId isEqualToString:accountId]) {
                                funcInfo = info;
                            }
                            [[ImDataManager sharedInstance] saveFuncInfoWithId:info];
                        }
                    }
                    MKBlockExec(completion,funcInfo)
                    return;
                    
                }else if (response){
                    [UIHelper toast:response.errMsg];
                }
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 获取||保存  JK EP FUNC 信息 到本地缓存
- (ImUserInfo*)getImUserInfoById:(NSString*)accoutId{
    return [WDCache getCacheFromFile:[NSString stringWithFormat:@"%@_%@",Cache_IM_UserMap, accoutId] withClass:[ImUserInfo class]];
}

- (EmployerInfo*)getEpInfoById:(NSString*)accoutId{
    return [WDCache getCacheFromFile:[NSString stringWithFormat:@"%@_%@",Cache_IM_UserMapEmployer, accoutId] withClass:[EmployerInfo class]];
}

- (GlobalFeatureInfo*)getFuncInfoById:(NSString*)accoutId{
    return [WDCache getCacheFromFile:[NSString stringWithFormat:@"%@_%@",Cache_IM_FuncMap, accoutId] withClass:[GlobalFeatureInfo class]];
}

- (void)saveUserInfoWithId:(ImUserInfo*)info{
    [WDCache saveCacheToFile:info fileName:[NSString stringWithFormat:@"%@_%@",Cache_IM_UserMap, info.accountId]];
}

- (void)saveEpInfoWithId:(EmployerInfo*)info{
    [WDCache saveCacheToFile:info fileName:[NSString stringWithFormat:@"%@_%@",Cache_IM_UserMapEmployer, info.accountId]];
}

- (void)saveFuncInfoWithId:(GlobalFeatureInfo*)info{
    [WDCache saveCacheToFile:info fileName:[NSString stringWithFormat:@"%@_%@",Cache_IM_FuncMap, info.accountId]];
}

#pragma mark - 获取 融云 会话类型列表                      //为兼容旧版，只开启当前版本使用的类型
+ (NSArray*)getConversationTypes{
    NSArray* conversationTypes = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:ConversationType_PRIVATE],                //私聊
                                  [NSNumber numberWithInteger:ConversationType_GROUP],                  //群组
                                  //                                  [NSNumber numberWithInteger:ConversationType_CHATROOM],               //聊天室
                                  [NSNumber numberWithInteger:ConversationType_SYSTEM],                 //系统
                                  [NSNumber numberWithInteger:ConversationType_CUSTOMERSERVICE],      //客服消息
                                  //                                  [NSNumber numberWithInteger:ConversationType_DISCUSSION],           //讨论组
                                  //                                  [NSNumber numberWithInteger:ConversationType_APPSERVICE],           //订阅号  Custom
                                  //                                  [NSNumber numberWithInteger:ConversationType_PUBLICSERVICE],        //订阅号 Public
                                  nil];
    return conversationTypes;
}

#pragma mark - 融云 链接状态监测=====================
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
//- (void)onConnectionStatusChanged:(RCConnectionStatus)status{
    switch (status) {
        {
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT:       //用户账户在其他设备登录，本机会被踢掉线。
            ELog(@"====被踢下线");
            [WDNotificationCenter postNotificationName:WDNotifi_clearTabbarRedPoint object:nil];
            DLAVAlertView* alert = [[DLAVAlertView alloc] initWithTitle:@"提示" message:@"您已在其他设备登录!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
            [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                [[UserData sharedInstance] loginOutUpdateData];
                [WDNotificationCenter postNotificationName:WDNotifi_setLoginOut object:nil];
                if (buttonIndex == 1) {
                    [[XSJUserInfoData sharedInstance] clearStaticObj];
                    [UIHelper hideCustomWindow];
                    [UIHelper showLoginVCWithBlock:^(id result) {
                        if (result) {
                            
                        }else{
                            [UIHelper loginOutToView];
                        }
                    }];
                }else if (buttonIndex == 0){
                    [UIHelper loginOutToView];
                }
            }];
            break;
        }
        case ConnectionStatus_UNKNOWN:              //未知状态
            ELog(@"==im status=====未知状态");
            break;
        case ConnectionStatus_Connected:            //连接成功
            ELog(@"==im status=====连接成功");
            break;
        case ConnectionStatus_NETWORK_UNAVAILABLE:  //网络不可用。
            ELog(@"==im status=====网络不可用");
            break;
        case ConnectionStatus_AIRPLANE_MODE:        //设备处于飞行模式。。
            ELog(@"==im status=====设备处于飞行模式");
            break;
        case ConnectionStatus_Cellular_2G:          //设备处于 2G（GPRS、EDGE）低速网络下。
            ELog(@"==im status=====设备处于 2G（GPRS、EDGE）低速网络下");
            break;
        case ConnectionStatus_Cellular_3G_4G:       //设备处于 3G 或 4G（LTE）高速网络下。
            ELog(@"==im status=====设备处于 3G 或 4G（LTE）高速网络下");
            break;
        case ConnectionStatus_WIFI:                 //设备网络切换到 WIFI 网络。
            ELog(@"==im status=====设备网络切换到 WIFI 网络");
            break;
        case ConnectionStatus_LOGIN_ON_WEB:         //用户账户在 Web 端登录。
            ELog(@"==im status=====用户账户在 Web 端登录");
            break;
        case ConnectionStatus_SERVER_INVALID:         //服务器异常或无法连接。
            ELog(@"==im status=====服务器异常或无法连接");
            break;
        case ConnectionStatus_VALIDATE_INVALID:         //验证异常(可能由于user验证、版本验证、auth验证)。
            ELog(@"==im status=====验证异常(可能由于user验证、版本验证、auth验证");
            break;
        case ConnectionStatus_Connecting:         //开始发起连接。
            ELog(@"==im status=====开始发起连接");
            break;
        case ConnectionStatus_Unconnected:         // 连接失败和未连接
            ELog(@"==im status=====连接失败和未连接");
            break;
        case ConnectionStatus_SignUp:           // 注销
            ELog(@"==im status=====注销");
            break;
        case ConnectionStatus_TOKEN_INCORRECT:         // Token无效，可能是token错误，token过期或者后台刷新了密钥等原因
            ELog(@"==im status=====Token无效，可能是token错误，token过期或者后台刷新了密钥等原因");
            break;
        case ConnectionStatus_DISCONN_EXCEPTION:         // 服务器断开连接
            ELog(@"==im status===== 服务器断开连接");
            break;
        default:
            break;
    }
}

#pragma mark - RCIMUserInfoDataSource delegate
/**
 *  获取用户信息。
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
}
@end
