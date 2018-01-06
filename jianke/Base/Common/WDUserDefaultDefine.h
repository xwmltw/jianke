//
//  WDUserDefaultDefine.h
//  jianke
//
//  Created by admin on 15/9/2.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *====================================================================================================
 *=====UserDefault===== NSString 全部加在这里  用全局 静态常量
 *命名规范 WDUserDefault_xxxxxx
 *列：
 *static NSString * const WDUserDefault_UserLoginType = @"xxxxxxxxx";
 *====================================================================================================
 */

/** 沙盒 app 版本号 */
static NSString* const WDUserDefault_CFBundleVersion    = @"WDUserDefault_CFBundleVersion";
static NSString* const UserDefault_ActivateDevice       = @"UserDefault_ActivateDevice";

/** 评论的版本 */
static NSString* const WDUserDefault_evaluateVersion    = @"WDUserDefault_evaluateVersion";
static NSString* const WDUserDefault_jobDetailTime      = @"WDUserDefault_jobDetailTime";
static NSString* const WDUserDefault_openAppTime        = @"WDUserDefault_openAppTime";


//电话密码
static NSString* const WDUserDefault_UserPhone          = @"WDUserDefault_UserPhone";
static NSString* const WDUserDefaults_Password          = @"WDUserDefaults_Password";

static NSString* const WDUserDefaults_TureName          = @"WDUserDefaults_TureName"; //真名
static NSString* const WDUserDefaults_Identity          = @"WDUserDefaults_Identity"; //身份证

//uudi
static NSString* const kSSToolkitUUIDString             = @"kSSToolkitUUID";

//登录类型 1雇主 2兼客
static NSString* const WdUserDefault_UserLoginType      = @"WdUserDefault_UserLoginType";

//第三方信息
static NSString* const QQAccountKey                     = @"QQAccountKey";
static NSString* const WechatAccountKey                 = @"WechatAccountKey";
static NSString* const WeiboAccountKey                  = @"WeiboAccountKey";
static NSString* const WechatAppAccountKey              = @"WechatAppAccountKey";


//是否第一次登陆IM 导入历史消息用
static NSString* const WDUserDefault_firstLoginIm       = @"WDUserDefault_firstLoginIm";

//第一次 显示引导
static NSString* const WDUserDefault_JkFirst_Guide      = @"WDUserDefault_JkFirst_Guide";

static NSString* const WDUserDefault_isLogoutActive     = @"WDUserDefault_isLogoutActive";


static NSString* const UserDefault_sjk_localInfo        = @"UserDefault_sjk_localInfo";
static NSString* const UserDefault_sjk_cityInfo         = @"UserDefault_sjk_cityInfo";
static NSString* const UserDefault_sjk_jobListInfo      = @"UserDefault_sjk_jobListInfo";
static NSString* const UserDefault_sjk_jobListMD5Info   = @"UserDefault_sjk_jobListMD5Info";
static NSString* const UserDefault_sjk_grabJobClassListInfo = @"UserDefault_sjk__grabJobClassListInfo";
static NSString* const UserDefault_sjk_grabJobClassListMD5Info = @"UserDefault_sjk__grabJobClassListMD5Info";
static NSString* const UserDefault_sjk_JobTopicListInfo = @"UserDefault_sjk_JobTopicListInfo";
static NSString* const UserDefault_sjk_JobTopicListMD5Info = @"UserDefault_sjk_JobTopicListMD5Info";

static NSString* const EPHideNewsViewKey                = @"EPHideNewsViewKey";

static NSString* const UserImNoticeQuietStateKey        = @"UserImNoticeQuietStateKey";
static NSString* const UserImHideHelpViewKey            = @"UserImHideHelpViewKey";

//新功能提醒（小红点）只在新功能首次使用显示
static NSString* const NewFeatureAboutApprecite         = @"NewFeatureAboutApprecite";

static NSString* const NewFeatureAboutBindWechat         = @"NewFeatureAboutBindWechat";

static NSString* const WDUserDefault_isFirstOpenWithNotify     = @"WDUserDefault_isFirstOpenWithNotify";


//记录用户的登录状态，是学生登录还是企业登录，用于无感知登录
//static NSString * const WdUserDefault_UserLoginType = @"WdUserDefault_UserLoginType";
//static NSString * const Notification_OnLocationComplate = @"Notification_OnLocationComplate";






