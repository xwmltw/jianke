//
//  ImConst.h
//  ShiJianKe
//
//  Created by hlw on 15/4/7.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#ifndef ShiJianKe_ImConst_h
#define ShiJianKe_ImConst_h

#import <UIKit/UIKit.h>
#import "ImPacket.h"
#import "ImMessage.h"
#import "WdMessage.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMKit/RCPublicServiceChatViewController.h>
//#import <RongIMLib/RongIMLib.h>

#define PageNum 50

typedef NS_ENUM(int, ImBizType){
    ImBizType_NewFriend         = 10001,        //5.2.1	新增好友请求
    ImBizType_NewFriendResponse = 10002,        //5.2.2	新增好友请求响应
    ImBizType_InBlackListNotify = 10003,        //5.2.3	被加入黑名单通知
    ImBizType_DelByFriend       = 10004,        //5.2.4	被好友删除通知
    ImBizType_FansListUpdate    = 10005,        //5.2.5	粉丝列表已更新
    
    ImBizType_TextMessage       = 20001,        //5.3.1	文本或者文字表情
    ImBizType_ImageMessage      = 20002,        //5.3.2	图片
    ImBizType_VoiceMessage      = 20003,        //5.3.3	语音消息
    ImBizType_LocationMessage   = 20004,        //5.3.4	地理位置
    ImBizType_ShareCompMessage   = 20005,       //5.3.5	分享企业
    ImBizType_SharePostMessage   = 20006,       //5.3.6	分享岗位 
    ImBizType_ServerNotifyMessage = 20007,       //5.3.7	服务端消息通知
    ImBizType_ImageAndTextMessage= 20008,       //5.3.8	图文消息
};

typedef NS_ENUM(int, WDImUserType) {
    WDImUserType_Employer = 1,      //雇主
    WDImUserType_Jianke = 2,        //兼客
    WDImUserType_Func = 3,          //功能号
    WDImUserType_EpJk = 4,          //兼客和雇主
    WDImUserType_Group = 5          // 群组
};

static NSString * const GROUP_IMG = @"msg_type_1";
static NSString * const KEFU_IMG = @"msg_type_2_1";
static NSString * const KEFU_NAME = @"客服牛傲天";
static NSString * const KeFuMMId = @"KEFU1428306964429";
static NSString * kefuFistText = @"您好，欢迎接入兼客客服牛傲天。在这里您可以咨询一切关于兼客兼职的问题哦。客服牛傲天的上班时间为9:00-18:00,联系电话400-168-9788，如果您在其他时间有问题可以进行留言，客服牛傲天会在上班后第一时间回复您。";
static NSString * const SystemUserId = @"-101";
static NSString * const CRMUserId = @"-108";
static NSString * const SystemName = @"系统通知";

//Im登录成功的时候发出的消息
static NSString * const OnImLoginSuccessNotify = @"_on_im_login_success_notify_";
//Im退出登录
//static NSString * const NotifycationOnUserLogOut = @"NotifycationOnUserLogOut";
//通知首页修改铃铛数量
static NSString * const WDNotification_JK_homeUpdateMsgNum = @"WDNotification_JK_homeUpdateMsgNum";
static NSString * const WDNotification_EP_homeUpdateMsgNum = @"WDNotification_EP_homeUpdateMsgNum";
//收到新的融云消息
static NSString * const OnNewRCMessageNotify = @"OnNewRCMessageNotify";

// 添加好友通知
#define OnAddFriendRequestNotify            @"_on_add_friend_request_notify_"
// 添加好友响应
#define OnAddFriendResponsetNotify          @"_on_add_friend_response_notify_"
// 添加黑名单通知
#define OnAddToBlacklistNotify              @"_on_addto_blacklist_notify_"
//粉丝列表更新
#define OnAttentionChangeNotify             @"_on_attention_change_notify_"
// 删除好友通知
#define OnDeleteFriendNotify                @"_on_delete_friend_notify_"



/** 兼客刷新tabBar小红点通知 */
#define JKReflushRedPointNotification @"JKReflushRedPointNotification"
/** 雇主刷新tabBar小红点通知 */
#define EPReflushRedPointNotification @"EPReflushRedPointNotification"

/** IM相关 */
// 兼客刷新个人简历页面
#define JKReflushResumeNotification @"JKReflushResumeNotification"
// 兼客刷新个人中心
#define JKReflushCenterNotification @"JKReflushCenterNotification"
// 雇主刷新首页
#define EPReflushHomeNotification @"EPReflushHomeNotification"
// 雇主刷新个人中心
#define EPReflushCenterNotification @"EPReflushCenterNotification"

/** 雇主刷新首页tabBar大红点通知 */
#define EPReflushHomeRedPointNotification @"EPReflushHomeRedPointNotification"

/** 刷新岗位列表通知 */
#define EPReflushJobListNotification @"EPReflushJobListNotification"

/** 登录成功提示绑定微信 */
#define LoginSuccessNoticeBindWechat @"LoginSuccessNoticeBindWechat"

#define NotifycationNameOnAddFriendSuccess @"NotifycationNameOnAddFriendSuccess"
#define NotifycationOnDelFriend @"NotifycationOnDelFriend"
// 好友信息修改
#define NotifycationOnFriendInfoChange @"NotifycationOnFriendInfoChange"


#define NotifycationEpHome @"NotifycationEpHome"

#endif
