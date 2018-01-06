//
//  XSJRequestHelper.h
//  jianke
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBaseModel.h"
#import "ClientGlobalInfoRM.h"
#import "ParamModel.h"
#import "RequestParamWrapper.h"


typedef NS_ENUM(NSInteger, WdVarifyCodeOptType) {
    WdVarifyCodeOptTypeRegist = 1,                  //注册
    WdVarifyCodeOptTypeFindPassword = 2,            //找回密码
    WdVarifyCodeOptTypeChgPhoneNum = 3,             //修改手机号码
    WdVarifyCodeOptTypePerfectInfo = 4,             //第三方登录完善资料
    WdVarifyCodeOptTypeFindMoneyBagPwd = 5,         //找回钱袋子密码
    WdVarifyCodeOptTypeDynamicPwdLogin = 7,         //动态密码登录
    WdVarifyCodeOptTypeEditResumeTel = 11,          //兼客修改简历联系方式
};

typedef NS_ENUM(NSInteger, LoginPwdType) {
    LoginPwdType_commonPassword = 1,                /*!< 普通密码 */
    LoginPwdType_dynamicPassword,                   /*!< 动态密码 */
    LoginPwdType_dynamicSmsCode,                    /*!< 动态验证码 */
};

@class MKBaseModel, ResumeExperienceModel;

@interface XSJRequestHelper : NSObject


@property (nonatomic, assign) BOOL isLostNetwork;   /*!< 网络是否断开过 */

+ (instancetype)sharedInstance;


#pragma mark - ***** 网络端开后从新 连接上网络 ******
- (void)connectNetworkAgain;

#pragma mark - ***** 登录 & 自动登录 ******

- (void)activateAutoLoginWithBlock:(MKBlock)block;
/*!< 自动登录 */
- (void)autoLogin:(MKBlock)block;
/** 默认普通密码登录 */
- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password bolck:(MKBlock)block;
/** 根据密码类型登录 */
- (void)loginWithUsername:(NSString *)userName pwd:(NSString *)password loginPwdType:(LoginPwdType)loginPwdType bolck:(MKBlock)block;


#pragma mark - ***** 获取验证码 ******
//"opt_type" :  操作类型  , 1 注册 , 2 找回密码 , 3 修改手机号码  -- 注册 (1) 判断 是否已经被注册 , (2): 判断 号码是否存在 , (3): 判断 是否已经被注册 .
//"user_type" : 用户类型 ,  1:企业 ，2:学生 , --}

- (void)getAuthNumWithPhoneNum:(NSString*)phoneNum andBlock:(MKBlock)block withOPT:(WdVarifyCodeOptType)optType userType:(NSNumber*)userType;


#pragma mark - ***** 获取全局配置信息 ******
/** 获取数据 */
- (void)getClientGlobalInfoWithBlock:(MKBlock)block;
/** 必须获取最新数据 */
- (void)getClientGlobalInfoMust:(BOOL)must withBlock:(MKBlock)block;
- (ClientGlobalInfoRM*)getClientGlobalModel;


/** 保存设备信息 */
- (void)postDeviceInfoWithBlock:(MKBlock)block;

/** 查询钱袋子账户信息 */
- (void)queryAccountMoneyWithBlock:(MKBlock)block;

/** 拨打免费电话 */
- (void)callFreePhoneWithCalled:(NSString *)called block:(MKBlock)block;

/** 雇主查询打卡请求接口 */
- (void)entQueryPunchRequestList:(EntQueryPunch *)punch block:(MKBlock)block;

/** 雇主发起点名接口 */
- (void)entIssuePunchRequest:(NSString *)job_id clockTime:(NSString *)date block:(MKBlock)block;

/** 雇主结束打卡接口 */
- (void)entClosePunchRequest:(NSString *)request_id block:(MKBlock)block;

/** 修改支付列表接口 */
- (void)entChangeSalaryUnConfirmStu:(NSString *)itemId withTel:(NSString *)telphone withTrueName:(NSString *)name block:(MKBlock)block;

/** 猜你喜欢接口 */
- (void)getJobListGuessYouLike:(GetJobLikeParam *)param block:(MKBlock)block;

/** 招聘余额接口 */
- (void)queryAcctVirtualDetailList:(QueryParamModel *)param block:(MKBlock)block;

/** 用户虚拟账户流水明细查询 */
- (void)queryAcctVirtualDetailItem:(DetailItmeParam *)param block:(MKBlock)block;

/** 收藏岗位 */
- (void)collectJob:(NSString *)jobId block:(MKBlock)block;

/** 取消收藏岗位 loading */
- (void)cancelCollectedJob:(NSString *)jobId isShowLoding:(BOOL)isShowLoding block:(MKBlock)block;

/** 取消收藏岗位 */
- (void)cancelCollectedJob:(NSString *)jobId block:(MKBlock)block;

/** 查询收藏岗位列表 */
- (void)getCollectedJobList:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 兼客获取自己的最新认证信息 */
- (void)getLatestVerifyInfo:(MKBlock)block;

/** 账户交易流水查询 */
- (void)queryAccDetail:(QueryParamModel *)queryParam withJobId:(NSString *)jobId block:(MKBlock)block;

/** 广告点击日志接口 */
- (void)queryAdClickLogRecordWithADId:(NSNumber *)AdId;

/** 人脉王岗位推送开关 */
- (void)openSocialActivistJobPush:(NSString *)optType block:(MKBlock)block;

/** 获取人脉王任务列表 */
- (void)getSocialActivistTaskList:(NSString *)inHistory queryParam:(QueryParamModel *)param block:(MKBlock)block;

/** 记录图文消息点击日志 */
- (void)graphicPushLogClickRecord:(NSString *)contentId block:(MKBlock)block;

/** 兼客联系岗位申请 */
- (void)postStuContactApplyJob:(NSString *)jobId resultType:(NSNumber *)resultType remark:(NSString *)remakr block:(MKBlock)block;

/** 查询电话联系岗位的兼客列表 */
- (void)queryContactApplyJobResumeList:(QueryParamModel *)queryParam jobId:(NSString *)jobId block:(MKBlock)block;

/** 记录通知栏消息点击日志 */
- (void)noticeBoardPushLogClickRecord:(NSString *)messageId block:(MKBlock)block;

/** 记录搜索关键字 */
- (void)recordSearchKeyWord:(NSString *)keyWord block:(MKBlock)block;

/** 查询增值服务列表 */
- (void)queryJobVasListLoading:(BOOL)isShowLoding block:(MKBlock)block;

/** 雇主购买岗位增值服务 */
- (void)entRechargeJobVas:(NSString *)jobId totalAmount:(NSNumber *)totalAmount orderType:(NSNumber *)orderType oderId:(NSNumber *)orderId block:(MKBlock)block;


/** 查询岗位订阅增值服务信息 */
- (void)queryJobVasInfo:(NSString *)jobId block:(MKBlock)block;

/** 兼客获取被邀约个人服务列表 */
- (void)stuQueryServicePersonalApplyJobListWithParam:(QueryParamModel *)queryParam inHistory:(NSNumber *)isHistory block:(MKBlock)block;

/** 兼客处理个人服务邀约 */
- (void)stuDealWithServicePersonalJobApplyWithOptType:(NSNumber *)optType applyId:(NSNumber *)applyId block:(MKBlock)block;

/** 获取个人服务需求详情 */
- (void)getServicePersonalJobDetailWithJobId:(NSNumber *)personaJobId block:(MKBlock)block;

/** 获取关注雇主列表 */
- (void)getFocusEntListWithQueryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 关注雇主 */
- (void)stuFocusEntWithAccountId:(NSNumber *)accountId block:(MKBlock)block;

/** 取消关注雇主 */
- (void)cancelFocusEntWithAccountId:(NSNumber *)accountId block:(MKBlock)block;

/** 获取已申请的团队服务列表 */
- (void)queryServiceTeamApplyListWithEntID:(NSString *)entId status:(NSNumber *)status block:(MKBlock)block;

/** 获取个人服务兼客列表 */
- (void)getServicePersonalStuList:(NSNumber *)serviceType cityId:(NSNumber *)cityId jobId:(NSNumber *)jobId param:(QueryParamModel *)param block:(MKBlock)block;

- (void)getServicePersonalStuList:(NSNumber *)serviceType cityId:(NSNumber *)cityId jobId:(NSNumber *)jobId orderType:(NSNumber *)orderType param:(QueryParamModel *)param block:(MKBlock)block;

/** 获取城市个人服务需求列表 */
- (void)queryServicePersonalJobListWithServiceType:(NSNumber *)serviceType cityId:(NSNumber *)cityId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 兼客报名个人服务需求 */
- (void)applyServicePersonalJobWithJobId:(NSNumber *)jobId block:(MKBlock)block;

/** 提交推送平台信息（极光推送） */
- (void)postThirdPushPlatInfo:(NSString *)push_id block:(MKBlock)block;

/** 查询宅任务列表 */
- (void)queryZhaiTaskListWithCityId:(NSNumber *)cityId queryParam:(QueryParamModel *)queryParam block:(MKBlock)block;

/** 查询服务类型申请信息 */
- (void)queryServiceApplyInfoWithServiceType:(NSNumber *)serviceType block:(MKBlock)block;

/** 检测用户登陆状态 */
- (void)checkUserLogin:(MKBlock)block;

/** 兼客查询普通岗位信息 */
- (void)queryJobListFromApp:(RequestParamWrapper *)param block:(MKBlock)block;

/** 兼客取消报名 */
- (void)cancelApplyJob:(NSNumber *)jobId reasonStr:(NSString *)reaseonStr block:(MKBlock)block;

/** 兼客修改简历其他信息 */
- (void)postResumeOtherInfoWithDes:(NSString *)des isPublick:(NSNumber *)isPublick block:(MKBlock)block;

/** 兼客查询简历工作经历信息 */
- (void)queryResumeExperienceList:(BOOL)isShowLoading block:(MKBlock)block;

/** 兼客提交简历工作经历信息 */
- (void)postResumeExperience:(ResumeExperienceModel *)model block:(MKBlock)block;

/** 兼客删除简历工作经历信息 */
- (void)deleteResumeExperience:(NSNumber *)resumeId block:(MKBlock)block;

#pragma mark - ***** 弃用 ******
/** 获取广告,兼客头条,雇主头条 */
- (void)getAdvertisementListWithAdSiteId:(NSString *)adSiteId cityId:(NSString *)cityId block:(MKBlock)block;

@end




