//
//  WDConst.h
//  jianke
//
//  Created by admin on 15/9/2.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSObject++Json.h"
#import "UILabel+MKExtension.h"
#import "NSString+NSHash.h"
#import "UIColor+Extension.h"
#import "UIDeviceHardware.h"
#import "UIHelper.h"
#import "TalkingData.h"
#import "WDNotificationDefine.h"
#import "WDUserDefaultDefine.h"
#import "DateHelper.h"
#import "UserData.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "ResponseInfo.h"
#import "RequestInfo.h"
#import "NetHelper.h"
#import "Masonry.h"
#import "MainNavigation_VC.h"
#import "UIImageView+WebCache.h"
#import "WDRequestDefine.h"
#import "RsaHelper.h"
#import "ParamModel.h"
#import "UIButton+WebCache.h"
#import "WXApi.h"
#import "DLAVAlertView.h"
#import "ImConst.h"
#import "WDViewControllerBase.h"
#import "MKCommonHelper.h"
#import "ShareHelper.h"
#import "MKCacheHelper.h"
#import "XSJConst.h"
#import "MKUIHelper.h"
#import "MKOpenUrlHelper.h"
#import "MKActionSheet.h"
#import "WDRequestMgr.h"
#import "XSJNetWork.h"
#import "TalkingDataAppCpa.h"
#import "UIPickerHelper.h"

#define NavTitleViewBgHeight 54


#ifdef DEBUG
/** 融云 */
//#define RC_DEBUG 1
//13645055941   1d2ea9262601436184ecf6dfbca7a75d
#endif


#pragma mark - URL
static NSString * const kUrl_helpCenter         = @"/wap/toHelpCenterPage";   //帮助中心

static NSString * const kUrl_zaiFind            = @"/m/find/toFindListPage";  //兼客首页 发现
static NSString * const kUrl_zhaiTaskIntroduce  = @"/wap/toZhaiTaskIntroPage";              //雇主 个人中心  宅任务介绍
static NSString * const kUrl_zhaiMyTask         = @"/m/admin/toApplyTaskListPage";          //宅任务 我的任务
static NSString * const kUrl_baoxianIntor       = @"/wap/toSeekerInsurancePage";         /*!< 保险说明 */
static NSString * const kUrl_baoxianResponsibility   = @"/wap/toInsuranceResponsibilityPage";   /*!< 保险责任 */
static NSString * const kUrl_remitResponsibility   = @"/wap/toRemitResponsibilityPage";   /*!< 保险免除责任 */
static NSString * const kUrl_entPromise         = @"/wap/entPromise";    /*!< 认证承若书 */
static NSString * const kUrl_entrustEmpory      = @"/wap/toApplyRecruitmentServicePage?account_type=1&is_from_ios=1";  /*!< 委托招聘 */

static NSString * const kUrl_epHelper           = @"/wap/toEntGuide";    /*!< 雇主帮助 */
static NSString * const kUrl_jkHelper           = @"/wap/toStuGuide";    /*!< 兼客帮助 */

static NSString * const kUrl_socialActivister   = @"/wap/toApplySocialActivistPage?account_type=2&is_from_ios=1";    /*!< 人脉王申请 */
static NSString * const kUrl_socialActivistGuide = @"/wap/toSocialActivistGuide";    /*!< 人脉王介绍 */

static NSString * const kUrl_moneyBagTip        = @"/wap/toMoneyBagTipPage";    /*!< 钱袋子小贴士 */
static NSString * const kUrl_releaseAgree       = @"/wap/toJobPublishAgreementPage";    /*!< 发布须知 */
static NSString * const kUrl_aboutApp           = @"/wap/aboutResume?version=";    /*!< 关于兼客 */
static NSString * const kUrl_epPayAgree         = @"/wap/toEntServiceAgreementPage";    /*!< 企业服务协议 */

static NSString * const kUrl_pinganPay          = @"/web/admin/pingAnPayByToken.do?token=";   /*!< 平安付 */
static NSString * const kUrl_pinganRecharge     = @"/web/admin/moneyBagRechargeByPingAnPay.do?recharge_amount=";   /*!< 平安付充值 */

static NSString * const kUrl_applyForPartner    = @"/m/toPartnerApplyPage";   /*!< 兼客合伙人申请 */
static NSString * const kUrl_partnerIntroPage   = @"/m/toPartnerIntroPage";   /*!< 兼客合伙人介绍 */
static NSString * const KUrl_NoGetCodePage      = @"/m/toNoGetCodePage.html";   /*!< 无法获取验证码 */
static NSString * const KUrl_SocialAcIntrol     = @"/m/toSocialActivistIntro";  /*!< 人脉王介绍 */
static NSString * const KUrl_BDService          = @"/m/toRecruitServiceProviderPage";   /*!< 包招服务商入口 */
static NSString * const KUrl_toTeamApplyCaseListPage            = @"/m/serviceTeam/toTeamApplyCaseListPage?serviceApplyId=";    /*!< 跳转m端服务商案例列表页面 */
static NSString * const KUrl_ServicePersonalDetail          = @"/m/servicePersonal/toServicePersonalDetailPage";   /*!< 跳转个人服务商详情链接 */
static NSString * const KUrl_toServicePersonalJobDetailPage          = @"/m/servicePersonal/toServicePersonalJobDetailPage";   /*!< 跳转个人服务需求链接 */
static NSString * const KUrl_toHelpCenterPage          = @"/m/toHelpCenterPage?type=2";   /*!< 跳转众包任务帮助中心 */
static NSString * const KUrl_userAgreementPage = @"/wap/userAgreement"; /*!< 用户协议 */
static NSString * const KUrl_getServicePersonalJobDetail = @"/m/servicePersonal/getServicePersonalJobDetail"; /*!< 个人通告 */
static NSString * const KUrl_zhongbao = @"https://zhongbao.jianke.cc/m/?utm_source=jiankejianzhi&utm_medium=h5"; /*!< 众包首页 */

//#ifdef DEBUG
//static NSString * const kUrl_borrowday          = @"http://m.shijianke.com/wap/goto?url=http://wap.sdhoo.me/wap/loan/loan_index.html?isClearLogin=1";    /*!< 菠萝代，预支工资 */
//#else
///** 正式地址*/
//static NSString * const kUrl_borrowday          = @"http://m.jianke.cc/wap/goto?url=http://wap.borrowday.com/wap/loan/loan_index.html?isClearLogin=1";    /*!< 菠萝代，预支工资 */
//#endif



static NSString * const kJianke_appID = @"982754793";
#pragma mark - 第三方 全局静态常量

/** TalkingData */
#ifdef DEBUG
static NSString * const kTalkingData_AppID =        @"";
static NSString * const kTD_AdTrackingID =          @"";
#else
static NSString * const kTalkingData_AppID =    @"7853D30C5F1A69228A7BD54243BC16AD";
static NSString * const kTD_AdTrackingID =      @"544a7623bf14433a81fc0ee168449392";
#endif


/** 融云 */
#ifdef RC_DEBUG
static NSString * const kRC_AppKey =        @"sfci50a7cr27i";   //测试
#else
static NSString * const kRC_AppKey =        @"y745wfm84ix8v";
#endif

/** JPush极光 */
static NSString * const kJPush_AppKey =        @"d64c1fa35134632af2a24728";
static NSString * const kJPush_Channel =        @"AppStore";
#ifdef RC_DEBUG
static BOOL kJPush_IsProduction =        NO;
#else
static BOOL kJPush_IsProduction =        YES;
#endif

//微博
static NSString * const kWB_AppId = @"4150758351";
static NSString * const kWB_AppSecret =     @"3e40bd525309995c0c53608d2f94b088";
//友盟
static NSString * const kUM_Key =           @"5514b6d7fd98c592210004f2";

//QQ
static NSString * const kQQ_AppId =         @"1104202340";
static NSString * const kQQ_AppKey =        @"nSkiWilmIyrEuSWL";
static NSString * const kQQ_AppUrl =        @"http://www.umeng.com/social";

//微信
static NSString * const kWX_AppId =         @"wx8727f0ad6a42a2b4";
static NSString * const kWX_AppSecret =     @"10f312e9db60b155e51d30b76a9c419d";
static NSString * const kWX_AppUrl =        @"http://www.umeng.com/social";


//JSPatch
static NSString * const kJSPatch_AppKey =     @"e5ae5e862e232181";

//高德地图
static NSString * const kGDMAP_AppKey =     @"d5492e17371822e3527def07113e6122";

//常量
static NSString * const kKefuQQ = @"800061840";

//苹果规避审核账号
static NSString * const ReviewAccount = @"13799372584";

typedef void (^WdBlock_Id)(id select);

//添加的自定义字体
static NSString * const kFont_RSR = @"RobotoSlab-Regular";
static NSString * const kFont_ArvoBold = @"Arvo-Bold";  //Arvo-Bold

//====================================================================================================
#pragma mark - 全局枚举

/** tableView 上下拉 刷新 */
typedef NS_ENUM(NSInteger, WDTableViewRefreshType) {
    WdTableViewRefreshTypeNone = 1 << 0,        //不添加刷新
    WdTableViewRefreshTypeHeader = 1 << 1,      //头部
    WdTableViewRefreshTypeFooter = 1 << 2,      //尾部
};

/** 登录密码类型 */
typedef NS_ENUM(NSInteger, PwdAccountType) {
    PwdAccountType_Login = 1,       //登录账号
    PwdAccountType_MoneyBag = 2     //钱袋子账号
};

/** 支付方式 */
typedef NS_ENUM(NSInteger, WDPayType) {
    WDPayType_None      = 0,        //无选择
    WDPayType_MoneyBag  = 1,        //钱袋子
    WDPayType_AliPay    = 2,        //支付宝
    WDPayType_WeChat    = 3,        //微信
    WDPayType_Bank      = 5         //平安付
};

/** 用户身份 */
typedef NS_ENUM(NSInteger, WDLogin_type) {
    WDLoginType_Employer = 1,         //雇主
    WDLoginType_JianKe   = 2,          //兼客
};

/** 第三方登录类型 */
typedef NS_ENUM(NSInteger, WDThirdLogin_type) {
    WDThirdLogin_type_QQ        = 1,         //qq
    WDThirdLogin_type_WeiXin    = 2,         //wx
    WDThirdLogin_type_WeiBo     = 3          //微博
};

/** 学生简历认证结果 */
typedef NS_ENUM(NSInteger, JianKeIdentification_status) {
    JianKeIdentification_status_no = 1,         //未认证
    JianKeIdentification_status_ing = 2,         //正在认证
    JianKeIdentification_status_pass = 3,         //认证通过
    JianKeIdentification_status_fail = 4          //最近一次认证被驳回
};

/** 学生类型(user_type) */
typedef NS_ENUM(NSInteger, JianKeIsStudent_type) {
    JianKeIsStudent_type_no = 0,         //不是在校生
    JianKeIsStudent_type_yes = 1         //是在校生
};

/** 发布岗位类型 */
typedef NS_ENUM(NSInteger, PostJobType) {
    PostJobType_common          = 1,
    PostJobType_bd              = 2,
    PostJobType_fast            = 3,    //快招岗位
};

/** 企业认证状态 */
typedef NS_ENUM(NSInteger, Employer_status) {
    EmployerIdentification_status_no = 1,         //未认证
    EmployerIdentification_status_ing = 2,        //正在认证
    EmployerIdentification_status_pass = 3,       //认证通过
    EmployerIdentification_status_fail = 4        //最近一次认证被驳回
};

/** 管理者类型 */
typedef NS_ENUM(NSInteger, ManagerType) {
    ManagerTypeEP, // 雇主
    ManagerTypeBD  // BD
};


//====================================================================================================

static CGFloat kFontSize_1 = 12;
static CGFloat kFontSize_2 = 14;
static CGFloat kFontSize_3 = 16;
static CGFloat kFontSize_4 = 17;
static CGFloat kFontSize_5 = 20;

#define HHFontSys(size) [UIFont systemFontOfSize:size]


#define AddTableViewLineAdjust \
/*处理分割线没在最左边问题：ios8以后才有的问题*/\
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {\
        [tableView setSeparatorInset:UIEdgeInsetsZero];\
    }\
    \
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {\
        [tableView setLayoutMargins:UIEdgeInsetsZero];\
    }\
    \
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {\
        [cell setLayoutMargins:UIEdgeInsetsZero];\
    }\
}\
\
/*处理下面多余的线*/\
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{\
    return 0.1;\
}

#define AddTableViewLineAdjustOnly \
/*处理分割线没在最左边问题：ios8以后才有的问题*/\
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {\
[tableView setSeparatorInset:UIEdgeInsetsZero];\
}\
\
if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {\
[tableView setLayoutMargins:UIEdgeInsetsZero];\
}\
\
if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {\
[cell setLayoutMargins:UIEdgeInsetsZero];\
}\
}




#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


