//
//  ImBusiDataObject.m
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ImBusiDataObject.h"
#import "ImMessage.h"
#import "ImConst.h" 
#import "WDConst.h"

@interface ImBusiDataObject(){
    ImMessage* _msgContent;
}

@end

@implementation ImBusiDataObject

- (BOOL)isSystemMessage{
    return [self.fromUser isEqualToString:SystemUserId];
}

- (id)getMessageContent{
    if (_msgContent) {
        return _msgContent;
    }
    
    if (self.content == nil) {
        return nil;
    }
    
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:[self.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        ELog(@"======IM 消息解析 出现错误： %@", error);
        return nil;
    }
    
    switch (self.bizType.intValue) {
        case ImBizType_NewFriend:           //= 10001,        //5.2.1	新增好友请求
            _msgContent = [ImAddFriendReq objectWithKeyValues:dic];
            break;
        case ImBizType_NewFriendResponse:   //= 10002,        //5.2.2	新增好友请求响应
            _msgContent = [ImAddFriendReq objectWithKeyValues:dic];
            break;
        case ImBizType_InBlackListNotify:   //= 10003,        //5.2.3	被加入黑名单通知
            _msgContent = [ImAddToBlackList objectWithKeyValues:dic];
            break;
        case ImBizType_DelByFriend:         //= 10004,        //5.2.4	被好友删除通知
            _msgContent = [ImFriendBeDeleted objectWithKeyValues:dic];
            break;
        case ImBizType_FansListUpdate:      //= 10005,        //5.2.5	粉丝列表已更新
            _msgContent = [ImAttentionMsg objectWithKeyValues:dic];
            break;
            
        case ImBizType_TextMessage:         //= 20001,        //5.3.1	文本或者文字表情
            _msgContent = [ImTextMessage objectWithKeyValues:dic];
            break;
        case ImBizType_ImageMessage:        //= 20002,        //5.3.2	图片
            _msgContent = [ImPhotoMessage objectWithKeyValues:dic];
            break;
        case ImBizType_VoiceMessage:        //= 20003,        //5.3.3	语音消息
            _msgContent = [ImVoiceMessage objectWithKeyValues:dic];
            break;
        case ImBizType_LocationMessage:     //= 20004,        //5.3.4	地理位置
            _msgContent = [ImLocationMessage objectWithKeyValues:dic];
            break;
        case ImBizType_ShareCompMessage:    //= 20005,       //5.3.5	分享企业
            _msgContent = [ImShareCompMessage objectWithKeyValues:dic];
            break;
        case ImBizType_SharePostMessage:    //= 20006,       //5.3.6	分享岗位
            _msgContent = [ImShareJobMessage objectWithKeyValues:dic];
            break;
        case ImBizType_ServerNotifyMessage: //= 20007,       //5.3.7	服务端消息通知
            _msgContent = [ImSystemMsg objectWithKeyValues:dic];
            break;
        case ImBizType_ImageAndTextMessage: //= 20008,       //5.3.8	图文消息
        {
            NSArray* array = [NSJSONSerialization JSONObjectWithData:[self.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            
            NSMutableArray* msgList = [[NSMutableArray alloc] init];
            for (NSDictionary* info in array) {
                ImImgAndTextMessageSub* model = [ImImgAndTextMessageSub objectWithKeyValues:info];
                [msgList addObject:model];
            }
            ImImgAndTextMessage* msgModel = [[ImImgAndTextMessage alloc] init];
            msgModel.messageList = msgList;
            _msgContent = msgModel;
            break;
        }
        default:
            break;
    }
    
    return _msgContent;
}

@end
