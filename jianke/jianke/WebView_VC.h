//
//  WebView_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"
#import "WDConst.h"

// 从本地获取 NSURL 显示WebViewUIType_ZhaiTask
typedef NS_ENUM(NSInteger, WebViewURLCacheType) {
    WebViewURLCacheType_JianKeAgreement = 1    //用户协议
    
};

typedef NS_ENUM(NSInteger, WebViewUIType) {
    WebViewUIType_ZhaiTask = 1,     //宅任务
    WebViewUIType_Feature = 2,      //兼客首页 特色入口
    WebViewUIType_Banner = 3,        //兼客首页 广告条
    WebViewUIType_PersonalServiceDetail,        //兼客 个人服务详情
};

typedef NS_ENUM(NSInteger, JSFlagType) {
    JSFlagType_viewPersonalService = 7, //查看个人服务商列表（兼客兼职）
    JSFlagType_getShareContent = 9,     //设置分享出去的内容，前端页面加载完成后调用（兼客兼职，兼客优聘）
    JSFlagType_shareAction = 10,    //调用客户端分享的方法（兼客兼职，兼客优聘）
    JSFlagType_uploadVideo = 11,    //调用客户端上传视频方法 （兼客兼职）
    JSFlagType_playVideo =12,   //12、调用客户端播放视频方法 （兼客兼职，兼客优聘）
    JSFlagType_acceptMission = 13,  //13、宅任务接任务成功后调用js方法（兼客兼职）
    JSFlagType_jkVertifySuccess = 15,   //15、实名认证提交成功后调用（兼客兼职）
};

@interface WebView_VC : WDViewControllerBase

@property (nonatomic, copy) NSString* fixednessTitle;   /*!< 固定不变的 title, 否则会根据 web 的显示 改变title */
@property (nonatomic, copy) NSString* url;              /*!< 访问的URL */
@property (nonatomic, assign) WebViewURLCacheType urlCacheType; /*!< 显示本地界面类型 */
@property (nonatomic, assign) WebViewUIType uiType;     /*!< 显示界面类型 */
@property (nonatomic, assign) BOOL notScalesPageToFit;  /*!< 默认为 no */
@property (nonatomic, assign) BOOL isSocialActivist;    /*!< 是否是人脉王页面 */
@property (nonatomic, assign) BOOL isHelperCenter;      /*!< 帮助中心页面 */
@property (nonatomic, assign) BOOL isFenQiLe;   /*!< 分期乐页面 */

@property (nonatomic, copy) MKBlock block;


@end
