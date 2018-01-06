//
//  ImMessage.h
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ImMessage : NSObject
@property (nonatomic, copy) NSNumber *sendTime;     /*!< 发送时间 */
@property (nonatomic, copy) NSNumber *job_id;       /*!< 岗位ID */
@property (nonatomic, copy) NSString *name;         /*!< 用户的用户名 */
@property (nonatomic, copy) NSString *headUrl;      /*!< 用户的头像url */

@property (nonatomic, copy) NSString* groupName;        /*!< 群组名称 */
@property (nonatomic, copy) NSString* groupHeadUrl;     /*!< 群组头像 */
@property (nonatomic, copy) NSString* open_url;         /*!< 跳转URL */

@property (nonatomic, assign) CGFloat cellHeight;       /*!< cell height */
@end

//==================业务操作接口定义 begin==========
@interface ImAddFriendReq : ImMessage               //10001
@property (nonatomic, copy) NSString* accountId;     //A用户的accountId，String
@property (nonatomic, copy) NSString* uuid;          //A用户的UUID，String
@property (nonatomic, copy) NSString* message;       //A发送的请求消息，String
@property (nonatomic, copy) NSString* messageId;     //消息ID，String
@end


@interface ImAddFriendRsp : ImMessage               //10002
@property (nonatomic, copy) NSNumber* resultCode;    //响应结果 1:同意添加 2:拒绝添加
@property (nonatomic, copy) NSString* uuid;          //B用户的UUID，String
@property (nonatomic, copy) NSString* message;       //拒绝描述，String
@property (nonatomic, copy) NSString* accountId;     //B用户的accountId，String
@end


@interface ImAddToBlackList : ImMessage             //10003
@property (nonatomic, copy) NSString* accountId;     //A用户的accountId，String
@end


@interface ImFriendBeDeleted : ImMessage            //10004
@property (nonatomic, copy) NSString* accountId;     //A用户的accountId，String
@end


//5.2.5	粉丝列表已更新
@interface ImAttentionMsg : ImMessage               //10005
@property (nonatomic, copy) NSNumber* type;          //1:关注，2:取消关注
@property (nonatomic, copy) NSString* accountId;     //A用户的accountId，String
// 以下字段只有在“关注”时才会有
@property (nonatomic, copy) NSString* uuid;           //A用户的UUID，String
@property (nonatomic, copy) NSNumber* sex;            //int,1:男 0:女
@property (nonatomic, copy) NSNumber* resumeId;       //A用户的accountId，String
@property (nonatomic, copy) NSNumber* version;        //该用户当前最新版本,客户端用该版本替换本地版本,int
@end
//==================业务操作接口定义 end==========



//==================点对点消息定义  begin==========

@interface ImTextMessage : ImMessage                //20001
@property (nonatomic, copy) NSString* message;        //消息
@property (nonatomic, copy) NSString *MsgTip;   /*!< 消息标题 */
@end


@interface ImPhotoMessage : ImMessage               //20002
@property (nonatomic, copy) NSString* url;            //url
@end


@interface ImVoiceMessage : ImMessage               //20003
@property (nonatomic, copy) NSString* VoiceName;      //文件名1428565541056.amr
@property (nonatomic, copy) NSString* url;            //url
@property (nonatomic, copy) NSNumber* VoiceLong;      //声音长度
@property (nonatomic, copy) NSString* voicePath;      //本地路径
@property (nonatomic, copy) NSString* VoiceTime;      //声音时间，安卓那边用的
@end


@interface ImLocationMessage : ImMessage            //20004
@property (nonatomic, copy) NSString* address;        //地址
@property (nonatomic, copy) NSNumber* lat;            //经纬度
@property (nonatomic, copy) NSNumber* lon;
@end


@interface ImShareCompMessage : ImMessage           //20005
@property (nonatomic, copy) NSString* entName;        //企业C的名称
@property (nonatomic, copy) NSString* desc;           //简介
@property (nonatomic, copy) NSNumber* accountId;      //企业ID
@property (nonatomic, copy) NSNumber* entInfoId;      //企业信息ID
@end


@interface ImShareJobMessage : ImMessage            //20006
@property (nonatomic, copy) NSString* jobId;          //C岗位的jobId，String
@property (nonatomic, copy) NSString* title;          //C岗位标题
@property (nonatomic, copy) NSString* desc;           //C岗位说明
@property (nonatomic, copy) NSString *jobIcon;        //C岗位的图标
@end


@interface ImSystemMsg : ImMessage                  //20007
@property(nonatomic, copy) NSNumber* notice_type;     //消息类型
@property(nonatomic, copy) NSString* message;         //消息内容
@property(nonatomic, copy) NSString* job_title;       //岗位名称 , <字符串> ,当信息有涉及到岗位时有该属性
@property(nonatomic, copy) NSString* apply_job_id;    //岗位申请ID , <整形数字> , 当信息有涉及到申请时有该属性值.
@property (nonatomic, copy) NSString *MsgTip;   /*!< 消息标题 */
@property (nonatomic, copy) NSString *question_id; /*!< 岗位答疑ID */

@property (nonatomic, strong) NSNumber *punch_the_clock_request_id; /*!< 打卡请求id */
@property (nonatomic, strong) NSNumber *punch_the_clock_time; /*!< 打卡时间 */
@property (nonatomic, strong) NSNumber *isPunched; /*!< 是否已经打卡,本地新增属性,服务端未下发 -1 未打卡, 1 已打卡 */
@property (nonatomic, strong) NSNumber *account_money_detail_list_id; /*!< 人脉王跳转赏金详情时需要传的字段 */

@property (nonatomic, strong) NSNumber *job_bill_id; /*!< 账单id 2.3.1 add by yanqingbiao”//发送账单 */
@property (nonatomic, strong) NSNumber *is_bd_account; /*!< 如果字段为1，表示当前岗位是包招岗位 */

//个人服务需求相关
@property (nonatomic, copy) NSNumber *service_personal_job_id;  /*!< 个人服务需求Id */
@property (nonatomic, copy) NSNumber *service_personal_job_apply_id;    /*!< 个人服务需求订单Id */
@property (nonatomic, copy) NSNumber *apply_status; /*!< 状态 */
@property (nonatomic,copy) NSNumber *service_type_id;   /*!< 个人服务案例类型编辑Id */
@property (nonatomic,copy) NSNumber *service_personal_id;   /*!< 个人服务申请Id */

@property (nonatomic, copy) NSString *groupId;  //群ID
//@property (nonatomic, copy) NSString *name;  //群ID
//@property (nonatomic, copy) NSString *headUrl;  //头像
@property (nonatomic, copy) NSString *message_id;   //消息ID 统计用V3.0.7需求

@end


@interface ImImgAndTextMessage : ImMessage           //20008
@property (nonatomic, copy) NSArray* messageList;     // 存放ImImgAndTextMessageSub模型
@property (nonatomic, copy) NSNumber* displayType;    // 展示类型，展示类型定义
@end


@interface ImImgAndTextMessageSub : ImMessage          //20008
@property (nonatomic, copy) NSString* title;          //标题
@property (nonatomic, copy) NSString* message;        //内容描述
@property (nonatomic, copy) NSString* publish_time;   //发布时间的毫秒数
@property (nonatomic, copy) NSString* imageUrl;       //图片URL
@property (nonatomic, copy) NSNumber* type;           //类型，1：跳转网页类型，2：app内跳转
@property (nonatomic, copy) NSNumber* code;           //app内跳转code定义",  //type=2时，此参数必须有值
@property (nonatomic, copy) NSString* app_param;      //app内跳转的参数，type=2时必须有值，值的内容根据code不同而不同
@property (nonatomic, copy) NSString* linkUrl;        //点击图片后跳转的URL,type=1时此参数必须有值
@property (nonatomic, copy) NSNumber* displayType;    // 展示类型，展示类型定义
@property (nonatomic, copy) NSNumber* content_id;   //消息对应ID
@end

typedef NS_ENUM(int, WdSystemNoticeType){
    WdSystemNoticeType_JkApply = 1,                     //兼客申请岗位
    WdSystemNoticeType_JkCancelApply = 2,               //兼客取消申请岗位
    WdSystemNoticeType_GzAgree = 3,                     //雇主同意申请
    WdSystemNoticeType_GzRefuse = 4,                    //雇主拒绝申请
    WdSystemNoticeType_JkAgree = 5,                     //兼客同意录用
    WdSystemNoticeType_JkRefuse = 6,                    //兼客拒绝录用
    WdSystemNoticeType_JkHasEvaluation = 7,             //兼客已评介申请岗位
    WdSystemNoticeType_GzHasEvaluation = 8,             //雇主已评介申请岗位
    WdSystemNoticeType_QyrzVerifyPass = 9,              //企业认证审核通过
    WdSystemNoticeType_QyrzVerifyFaild = 10,            //企业认证审核未通过
    WdSystemNoticeType_JkrzVerifyPass = 11,             //兼客认证审核已通过
    WdSystemNoticeType_JkrzVerifyFaild = 12,            //兼客认证审核未通过
    WdSystemNoticeType_OpenImSucess = 13,               //成功开通IM功能
    WdSystemNoticeType_JobVerifySuccess = 14,           //岗位审核通过
    WdSystemNoticeType_JobVerifyFail = 15,              //岗位审核未通过
    WdSystemNoticeType_JobApplyComplain = 16,           //岗位申请被投诉
    WdSystemNoticeType_ReplyAdvice = 17,                //建议反馈答复
    WdSystemNoticeType_GzComplaintFgz = 18,             //雇主投诉兼客放鸽子
    WdSystemNoticeType_JkComplaintGzPost = 19,          //兼客投诉雇主岗位
    
    WdSystemNoticeType_EpPayNotification = 20,          //系统给雇主发送付款提醒
    WdSystemNoticeType_JkMoneyAdd = 21,                 //系统给兼客发的到账提醒
    WdSystemNoticeType_JkWorkTomorrow = 22,             //系统提醒兼客明天上岗
    WdSystemNoticeType_ChangePhoneSuccess = 23,         //手机号修改成功
    WdSystemNoticeType_ChangePwdSuccess = 24,           //密码修改成功
    WdSystemNoticeType_IdAuthSuccess = 25,              //身份认证成功
    WdSystemNoticeType_IdAuthFail = 26,                 //身份认证失败
    WdSystemNoticeType_GetApplyFitst = 27,              //获得首个报名
    WdSystemNoticeType_GetSnagFitst = 28,               //获得首个抢单
    WdSystemNoticeType_JobApplyFull = 29,               //岗位已报满
    WdSystemNoticeType_JobSnagEnd = 30,                 //岗位已抢完
    WdSystemNoticeType_EpCertificateAuthSuccess = 31,   //营业执照认证成功
    WdSystemNoticeType_EpCertificateAuthFail = 32,      //营业执照认证失败
    WdSystemNoticeType_JopAnswerQuestion = 33,          //关于岗位的提问和答复
    WdSystemNoticeType_RechargeMoneySuccess = 34,       //充值成功
    WdSystemNoticeType_GetMoneySuccess = 35,            //取现成功
    WdSystemNoticeType_JobBackouted = 36,               //岗位被下架
    WdSystemNoticeType_PaySuccess = 37,                 //付款成功
    WdSystemNoticeType_EpLookResume = 38,               //雇主查看简历
    WdSystemNoticeType_EpCheckJobOver = 39,             //雇主确认工作完成
    
    WdSystemNoticeType_EpEvaluationJk = 40,             //40：雇主评论兼客
    WdSystemNoticeType_JkNotWorkConsultToEp = 41,       //兼客未到岗(与雇主沟通一致)
    WdSystemNoticeType_DeductRecognizance = 42,         //扣除保证金
    WdSystemNoticeType_JobMoveToComplete = 43,           //岗位已移到已完成
    
    WdSystemNoticeType_EPRequestReport = 44,            // 雇主发起打卡请求
    WdSystemNoticeType_JKReceiveReportRequest = 45,     // 兼客打卡通知(兼客收到雇主打卡通知)
    WdSystemNoticeType_PersonPoolPush = 46,             // 人才库推送通知
    WdSystemNoticeType_JKResponseReport = 47,           // 兼客打卡应答(雇主接收到兼客打卡通知)
    
    WdSystemNoticeType_JkApply_Ep = 48,                  // 48：兼客申请岗位(雇主)
    WdSystemNoticeType_SysRefuseJk_Ep = 49,              // 49：系统拒绝兼客(雇主)
    WdSystemNoticeType_AlipayGetMoney = 50,              // 50:申请支付宝取现
    WdSystemNoticeType_AlipayGetMoneySuccess = 51,       // 51：支付宝取现成功
    WdSystemNoticeType_AlipayGetMoneyFail = 52,          // 52：支付宝取现失败
    WdSystemNoticeType_SocialActivistBroadcast = 53,     // 53：人脉王跳岗位详情广播消息
    WdSystemNoticeType_Reward = 54,                      // 54：人脉王赏金消息
    WdSystemNoticeType_EPAdjustDate = 55,                // 55: 雇主调整上岗日期
    WdSystemNoticeType_SocialActivistAuth = 56,          // 56: 人脉王认证审核
    WdSystemNoticeType_EPNotDealJKApply = 57,            // 57: 雇主长时间未处理投递第兼客的IM提醒
    WdSystemNoticeType_BDAddEP = 58,                     // 58: BD添加客户后通知客户已开通委托招聘服务
    WdSystemNoticeType_BDSetLeader = 59,                 // 59: BD设置兼客为岗位领队后通知兼客
    WdSystemNoticeType_BDSendBillForPayToEP = 60,        // 60: bd发送账单给雇主支付
    WdSystemNoticeType_UnAuthLeaderGetMoney = 61,        // 61: 未认证兼客获取领队薪资通知
    WdSystemNoticeType_BDSendBillForCheckToEp = 62,      // 62: bd发送对账单给雇主
    WdSystemNoticeType_RequireOpenBDService = 63,        // 63: 申请开通委托招聘服务
    WdSystemNoticeType_SuccessOpenBDService = 64,        // 64: 成功开通委托招聘服务
    WdSystemNoticeType_JkBuyInsurance = 65,              // 65: 兼客投保
    WdSystemNoticeType_JoinImGroup = 66,                 // 66: 加入群组
    WdSystemNoticeType_quitImGroup = 67,                 // 67: 退出群组
    WdSystemNoticeType_removeFormGroup = 68,             // 68: 将成员移除群组
    WdSystemNoticeType_dismissGroup = 69,                // 69: 解散群组
    WdSystemNoticeType_CRMMessage = 70,                  // 70: CRM消息提醒
    WdSystemNoticeType_EPZaiTaskVerifyPast = 71,         // 71: 雇主通过宅任务审核提醒
    WdSystemNoticeType_EPZaiTaskVerifyFail = 72,         // 72: 雇主未通过宅任务审核提醒
    WdSystemNoticeType_missionTimeoutRemind = 73,        // 73: 兼客提交任务截止时间前通知兼客提交任务
    WdSystemNoticeType_ZaiTaskBackouted = 74,            // 74: 宅任务被下架
    WdSystemNoticeType_WeChatBindingSuccess = 75,        // 75: 微信公众号绑定成功
    WdSystemNoticeType_ZaiTaskVerifyPast = 76,           // 76: 宅任务审核通过
    WdSystemNoticeType_ZaiTaskVerifyFail = 77,           // 77: 宅任务审核不通过
    WdSystemNoticeType_openUrlMessage = 78,              // 78: 文本消息及url链接。客户端展示message的内容，点击 查看详情 是app浏览器打开（open_url）地址。
    WdSystemNoticeType_textMessage = 79,                 // 79: 纯文本消息，客户端只是展示下发的message消息即可
    WdSystemNoticeType_confirWork = 80,                  // 80: 确认上岗
    WdSystemNoticeType_interestJob = 81,                 // 81: 意向岗位推送通知
    WdSystemNoticeType_advanceSalary = 82,               // 82: 预支工资推送通知
    WdSystemNoticeType_activistJobBroadcast = 83,        // 83: 人脉王岗位推送
    WdSystemNoticeType_noticeBoardMessage = 84,           // 84: 通知栏消息
    WdSystemNoticeType_jobVasPushMessage = 85,             // 85:跳转客户端岗位详情通知
    WdSystemNoticeType_topJobTimeOver = 86,                // 86:岗位置顶过期通知
    WdSystemNoticeType_ServicePersonalAuditPass = 87,       // 87:个人服务申请审核通过
    WdSystemNoticeType_ServicePersonalAuditFail = 88,       // 88:个人服务申请审核不通过
    WdSystemNoticeType_ServicePersonalInvite = 89,       // 89:雇主个人服务邀约
    WdSystemNoticeType_AgreeServicePersonalInvite = 90,      // 90:兼客同意个人服务邀约
    WdSystemNoticeType_ApplyServiceTeam = 91,       // 91:雇主预约团队服务
    WdSystemNoticeType_RedirectJobVasPage = 92,       // 92:跳转客户端付费推广页面
    WdSystemNoticeType_ServicePersonalImpoveWorkExperienceNotice = 93,       // 93:个人服务更新案例消息提醒
    WdSystemNoticeType_InsuranceOrderFail = 94,       // 94:兼职保险存在失败保单
    WdSystemNoticeType_PersonalServiceBackouted = 95,       // 95:个人服务被下架
    WdSystemNoticeType_PersonalServiceOrderBackouted = 96,       // 96:个人服务需求被下架
};

//==================点对点消息定义  end==========
