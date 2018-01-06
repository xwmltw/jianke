//
//  WDChatView_VC.h
//  jianke
//
//  Created by xiaomk on 15/10/17.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTableViewController.h"
#import "ImConst.h"
#import "IMGroupModel.h"

@class ImUserInfo;
@class RCConversation;

@interface WDChatView_VC : XHMessageTableViewController


@property (nonatomic, copy) NSString* accountId;
@property (nonatomic, assign) int accountType;
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, copy) NSString *jobId;


@property (nonatomic, assign) BOOL isGroupChat; /*!< 是否是群组聊天 */
@property (nonatomic, assign) BOOL isShareJob; /*!< 是否是分享岗位 */
@property (nonatomic, strong) JobModel *jobModel; /*!< 岗位模型, 分享岗位时使用 */
@property (nonatomic, assign) BOOL shouldShowShareJobAlertView; /*!< 是否需要显示分享岗位弹窗 */
@property (nonatomic, copy) NSString *resumeId; /*!< 简历ID */
@property (nonatomic, assign) BOOL isFromIM;    /*!< 是否来自IM界面 */

//打开聊天界面，根据对方的 ImUserInfo  没用到先删了 有需要看旧版
//打开聊天界面， 根据对方的 accountId accountType
+ (void)openPrivateChatOn:(UIViewController*)vc accountId:(NSString*)accountId withType:(int)accountType jobTitle:(NSString *)jobTitle jobId:(NSString *)jobId resumeId:(NSString *) resumeId hideTabBar:(BOOL)isHideTabBar;
+ (void)openPrivateChatOn:(UIViewController*)vc accountId:(NSString*)accountId withType:(int)accountType jobTitle:(NSString *)jobTitle jobId:(NSString *)jobId;
+ (void)openPrivateChatOn:(UIViewController*)vc accountId:(NSString*)accountId withType:(int)accountType jobTitle:(NSString *)jobTitle jobId:(NSString *)jobId hideTabBar:(BOOL)isHideTabBar;

/** 打开群组聊天界面并分享岗位 */
+ (void)shareJob:(JobModel *)jobModel toImGroupVc:(UIViewController*)vc IMGroupModel:(IMGroupModel*)model isBackToRootView:(BOOL)isBackToRootView;


@end
