//
//  WDNotification.h
//  jianke
//
//  Created by admin on 15/9/2.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *====================================================================================================
 *=====Notification=====通知 NSString 全部加在这里  用全局 静态常量
 *命名规范 WDNotification_xxxxxx
 *列：
 *static NSString * const WDNotification_UserLogin = @"WDNotification_UserLogin";
 *====================================================================================================
 */

// 微博登陆时获取code后发送通知
static NSString * const WBLoginGetRespNotification = @"WBLoginGetRespNotification";
static NSString * const WBLoginGetRespInfo = @"WBLoginGetRespInfo";

// 微信登陆时获取code后发送通知
static NSString * const WXLoginGetCodeNotification = @"WXLoginGetCodeNotification";
static NSString * const WXLoginGetCodeInfo = @"WXLoginGetCodeInfo";

// 微信取钱时获取code后发送通知
static NSString * const WXGetMoneyGetCodeNotification = @"WXGetMoneyGetCodeNotification";
static NSString * const WXGetMoneyGetCodeInfo = @"WXGetMoneyGetCodeInfo";

// 微信支付回调 获取code后发通知
static NSString * const WXPayGetCodeNotification = @"WXPayGetCodeNotification";
static NSString * const WXPayGetCodeInfo = @"WXPayGetCodeInfo";

// 雇主绑定微信时获取微信code后发送通知
static NSString * const EPGetWXCodeNotification = @"EPGetWXCodeNotification";
static NSString * const EPGetWXCodeInfo = @"EPGetWXCodeInfo";

// 兼客绑定微信时获取微信code后发送通知
static NSString * const JKGetWXCodeNotification = @"JKGetWXCodeNotification";
static NSString * const JKGetWXCodeInfo = @"JKGetWXCodeInfo";

// 支付宝支付回调通知
static NSString * const AlipayResponseNotification = @"AlipayResponseNotification";
static NSString * const AlipayGetResultInfo = @"AlipayGetResultInfo";



/** 我的报名,cell展开通知 */
static NSString * const JKApplyJobCellMiddleViewOpenNotification = @"JKApplyJobCellMiddleViewOpenNotification";
static NSString * const JKApplyJobCellMiddleViewOpenNotificationIndex = @"index";

/** 我的报名,取消报名通知 */
static NSString * const JKApplyJobCancellApplyNotification = @"JKApplyJobCancellApplyNotification";
static NSString * const JKApplyJobCancellApplyInfo = @"JKApplyJobCancellApplyInfo";

/** 我的报名,有问题通知 */
static NSString * const JKApplyJobHasQuestionNotification = @"JKApplyJobHasQuestionNotification";
static NSString * const JKApplyJobHasQuestionInfo = @"JKApplyJobHasQuestionInfo";

/** 我的报名,给雇主发送消息通知 */
static NSString * const JKApplyJobChatWithEPNotification = @"JKApplyJobChatWithEPNotification";
static NSString * const JKApplyJobChatWithEPInfo = @"JKApplyJobChatWithEPInfo";

static NSString * const JKApplyJobWXWithNotification = @"JKApplyJobWXWithNotification";
static NSString * const JKApplyJobWXWithInfo = @"JKApplyJobWXWithInfo";

/** 发布岗位,cell刷新通知 */
static NSString *const PostJobTableViewShouldReflushNotification = @"PostJobTableViewShouldReflushNotification";
static NSString *const PostJobTableViewShouldReflushInfo = @"PostJobTableViewShouldReflushInfo";

/** 注册成功，完善简历通知*/
static NSString *const PerfectResumeAlertViewNotification = @"PerfectResumeAlertViewNotification";

//被踢下线通知 刷新 个人中心UI
static NSString *const WDNotifi_setLoginOut = @"WDNotifi_setLoginOut";
static NSString *const WDNotifi_LoginSuccess = @"WDNotifi_LoginSuccess";
static NSString *const WDNotifi_updateEPResume = @"WDNotifi_updateEPResume";
static NSString *const WDNotifi_JkrzVerifyFaild = @"WDNotifi_JkrzVerifyFaild";
static NSString *const WDNotifi_updateMyInfo = @"WDNotifi_updateMyInfo";
static NSString *const WDNotifi_clearTabbarRedPoint = @"WDNotifi_clearTabbarRedPoint";

/***************************IM推送小红点通知************************/
static NSString * const IMPushWalletNotification = @"IMPushWalletNotification"; // 钱袋子通知小红点通知

static NSString * const IMPushJKWaitTodoNotification = @"IMPushJKWaitTodoNotification"; // 兼客待办事项大红点通知
static NSString * const IMPushJKWorkHistoryNotification = @"IMPushJKWorkHistoryNotification"; // 兼客工作经历小红点通知
static NSString * const IMNotification_EPMainUpdate = @"IMNotification_EPMainUpdate";    //岗位通过审核 通知 雇主首页 刷新
static NSString * const IMNotification_updateConversationList = @"IMNotification_updateConversationList";   //刷新会话列表
static NSString * const IMNotification_BDSendBillForPayToEP = @"IMNotification_BDSendBillForPayToEP";

static NSString * const IMPushGetPersonaServiceJobNotification = @"IMPushJKWorkHistoryNotification"; // 兼客个人服务邀约通知
static NSString * const WDNotification_updateRedPoint = @"WDNotification_updateRedPoint";   // 雇主首页 刷新 去除小红点

static NSString * const WDNotification_backFromMoneyBag = @"WDNotification_backFromMoneyBag";   //从钱袋子返回通知(支付用)
static NSString * const ClearPersonaServiceJobNotification = @"ClearPersonaServiceJobNotification"; // 兼客个人服务邀约 删除小红点 通知
static NSString * const clearMyApplyRedPointNotification = @"clearMyApplyRedPointNotification"; // 代办 删除相关小红点 通知
static NSString * const clearMyMoneyBagNotification = @"clearMyMoneyBagNotification"; // 钱袋子 删除相关小红点 通知
static NSString * const UpdateIsPersonaService = @"UpdateIsPersonaService"; // 更新JKModel数据

/***************************IM推送小红点通知************************/
//static NSString * const IMNotification_WeChatBindingSuccess = @"IMNotification_WeChatBindingSuccess";   // 雇主首页 刷新 去除小红点

static NSString * const JKWaitTodoHideRedDotNotification = @"JKWaitTodoHideRedDotNotification"; // 兼客待办事项大红点隐藏通知
static NSString * const JKWorkHistoryRedDotNotification = @"JKWorkHistoryRedDotNotification"; // 兼客工作经历小红点隐藏通知
static NSString * const UpdateUserTelphoneWithAutoLoginNotification = @"UpdateUserTelphoneWithAutoLoginNotification"; // 更改手机号后，发登录通知

static NSString * const AppWillBecomeBeforeground = @"appWillBecomeBeforeground"; // app切换到前台

