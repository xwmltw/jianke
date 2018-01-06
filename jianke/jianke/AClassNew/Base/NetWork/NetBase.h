//
//  NetBase.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetBase : NSObject

@property (nonatomic, copy) NSString *loadingMessage;       /*!< loading显示的文本 */
@property (nonatomic, assign) BOOL isShowLoading;           /*!< 是否显示loading */
@property (nonatomic, assign) BOOL isShowServerErrorMsg;    /*!< 是否显示服务端返回的错误消息 */
@property (nonatomic, assign) BOOL isShowErrorMsgAlertView; /*!< 错误消息是否弹窗提醒 */
@property (nonatomic, assign) BOOL isShowNetworkErrorMsg;   /*!< 是否显示网络异常弹窗 */
@property (nonatomic, copy) NSString *requestStr;           /*!< 测试用的，打印请求时的信息 */

@property NSMutableData* receiveData;   /*!< 网络返回的数据 */
@property (nonatomic, assign) long seq;

- (void)checkLoading:(BOOL)isEnd;
- (void)onBegin;
- (void)onEnd;

@end


//======================服务端  错误码  枚举    暂时丢这里 后期 优化 网络
/** 协议栈 级别报错 */
//SUCCESS((byte) 0x00, "成功"),
//ERROR_DECRYPT((byte) 0x01, "报文解密失败"),
//ERROR_SIGN((byte) 0x02, "签名计算错误"),
//ERROR_TOKEN((byte) 0x03, "Token已失效或不存在"),
//ERROR_STRUCTURE((byte) 0x04, "报文结构错误"),
//ERROR_TOKEN_TYPE((byte) 0x05, "token值和type类型冲突"),
//ERROR_TOKEN_ENCTYPE((byte) 0x06, "token值和encType类型冲突"),
//ERROR_SEQUENCE((byte) 0x07, "seq值不合法"),
//@Deprecated
//ERROR_BUSINESS((byte) 0x08, "业务方法错误"),
//ERROR_RSADECODE((byte) 0x09, "RSA解密错误"),
//ERROR_RSAENCODE((byte) 0x0A, "RSA加密错误"),
//ERROR_UNKNOWN_VERSION((byte) 0x0B, "协议版本不存在"),
//ERROR_METHOD_NOT_EXISTS((byte) 0x0C, "服务端异常"),
//ERROR_SEQ_SIGN_DISMATCH((byte) 0x0D, "报文序列号和签名不一致"),
//ERROR_UNKNOWN((byte) 0xFF, "未知错误");


//SUCCESS(0, "成功"),
//ERROR(1, "失败"),
//ERROR_SESSION_NOT_EXIST(2, "session不存在或已超时"),
//ERROR_SESSION(3,"sessionId不符合"),
//ERROR_PHONE_EXIST(4,"手机号码已存在"),
//ERROR_PHONE(5,"手机号码格式错误"),
//ERROR_SMS(6,"验证码错误"),
//ERROR_SMS_NOT_SEND(7,"发送验证码失败"),
//ERROR_USERNAME_NOT_EXIST(8,"用户不存在"),
//ERROR_PASSWORD(9,"密码错误"),
//ERROR_OLDPASSWORD(10,"旧密码错误"),
//ERROR_USER_TYPE(11,"用户类型错误"),
//ERROR_ENTERPRISE_INFO_ID(12,"企业ID格式错误"),
//ERROR_INSERT_FAILD(13,"注册失败"),
//ERROR_CONTENT_IS_NULL(14,"客户端请求信息缺少content内容"),
//ERROR_USER_NOT_LOGIN(15,"未登录或登录已过期"),
//ERROR_POST_ENTERPRISE_BASIC_INFO(16,"填写企业/团队基本信息失败"),
//ERROR_ENTERPRISE_CHARACTER_ID(17,"企业机构性质不合法"),
//ERROR_REQUEST_INFO(18,"请求信息不合法"),
//ERROR_POST_ENTERPRISE_VERIFYINFO(19,"企业认证信息入库失败"),
//ERROR_USER_IS_FREEZE(20,"用户被冻结"),
//ERROR_ENTERPRISE_VERIFY_SUCCESS(21,"认证已通过"),
//ERROR_INSUFFICIENT_PERMISSIONS(22,"权限不足"),
//ERROR_PARTTIMEJOB_NOTEXIST(23,"岗位不存在"),
//ERROR_CANNOT_REPEAT_APPLY_JOB(24,"不能重复申请同一岗位"),
//ERROR_CANDIDATE_APPLY_JOB_FAILD(25,"申请岗位信息入库失败"),
//ERROR_SELECT_APPLY_JOB_FAILD(26,"查询用户岗位信息失败"),
//ERROR_CANCEL_APPLY_JOB_FAILD(27,"学生取消岗位申请失败"),
//ERROR_THE_SAME_PHONE_NUM(28,"不能使用相同手机号"),
//ERROR_UPDATE_PHONE_NUM(29,"更新手机号失败"),
//ERROR_OPT_TYPE(30,"操作类型错误"),
//ERROR_MINPATTIMEJOBTO(31,"不好意思，每天最多只能发布5条信息"),
//ERROR_JOBCLASSIFY_EXIST(32,"岗位分类存在"),
//ERROR_ACCOUNT_NO_BIND(33,"验证成功,需要完善信息"),
//ERROR_SALARYUNIT(34,"薪资单位格式不对"),
//ERROR_SETTLEMENTWAY(35,"结算方式格式不对"),
//ERROR_DEADLINETIME(36,"截至时间不能为空"),
//ERROR_ISSHOWTELPHONE(37,"联系方式是否公开格式错误"),
//ERROR_APPLYBYSMS(38,"是否接受短信申请格式错误"),
//ERROR_RESUME_READED_BY_PARTTIMEJOB(38,"企业查看投递某个岗位的简历格式错误"),
//ERROR_JOB_ID_NOT_NULL(39,"岗位id不能为空"),
//ERROR_BUSIPOWERLIMIT_STATUS(40,"限制状态格式不对"),
//
//ERROR_NO_READ_RESUMEPHONE_POWER(41,"没有提取电话号码的权限"),
//ERROR_NO_UPDATEJOB_RANKING_POWER(42,"没有刷新岗位排名的权限"),
//ERROR_BUSIPOWERINFO_STATUS(43,"权限状态格式不对"),
//ERROR_CONTAIN_ACCOUNT_LIMIT(44,"包含账号限制信息格式不对"),
//ERROR_ENTERPRISE_VERITY_STATUS(45,"认证状态格式不对"),
//ERROR_TRANSACT_TYPE(46,"交易类型格式不对"),
//ERROR_IS_FAMOUS(47,"名企格式不对"),
//ERROR_ENTERPRISEBASICINFO_IS_NOT_PERFECT(48,"企业基本信息不完善"),
//ERROR_HTML_SENSITIVE_WORD(49,"提交请求中包含不允许提交的字符, '<'和'>'"),
//
//ERROR_PRICE_NOT_CONSISTENT(51,"价格不一致"),
//ERROR_MONEY_FREEZE(52,"金额被冻结"),
//ERROR_MONEY_NOT_ENOUGH(53,"余额不足"),
//ERROR_ENT_EMPLOY_STATUS(54,"企业录用状态不合法"),
//ERROR_STU_AGREE_STATUS(55,"学生同意状态不合法"),
//ERROR_STU_EVALU_STATUS(56,"学生评价状态不合法"),
//ERROR_ENT_EVALU_STATUS(56,"学生评价状态不合法"),
//ERROR_USE_NEW_PHONE(57,"该号码以前未发布过岗位哦，您确定使用该号码？"),
//ERROR_MODULETYPE(58,"模块类型异常"),
//ERROR_TIMEMIN(59,"获取时间间隔小于50秒"),
//
//ERROR_ENTERPRISE_VERIFY_ING(60,"您的信息已在认证中,请您耐心等待"),
//ERROR_STU_RESUME_HEIGHT(61,"请输入真实身高哦"),
//ERROR_NAME_LENGTH(62,"名称请控制在30个字符以内"),
//ERROR_PHONE_IN_BLACK_LIST(63,"亲爱的雇主，您被某个兼客投诉咯，暂时无法发送岗位。赶快找客服MM解决这个问题！"),
//ERROR_WECHAT_THIRD_ACCOUNT_NOEXIST(64,"您绑定的微信账号已解绑"),
//ERROR_WECHAT_THIRD_ACCOUNT_HAS_BANDOTHER(65,"当前微信账号已经绑定过其他的兼客账号"),
//ERROR_ACCOUNT_HAS_BAND_WECHAT(66,"当前兼客账号已经绑定过其他微信账号"),
//ERROR_ACCOUNT_MONEY_NOT_ENOUGH(67,"钱袋子可用余额不足"),
//ERROR_HAS_EVALU_STAR(68,"评级超过2分钟，不可以重新评级"),
//ERROR_PHONE_HAS_BAND_WECHAT(69,"当前手机号已经绑定过其他微信账号"),
//ERROR_DAY_WITHDRAW_MONEY_OVER(70,"当天取现金额超出限额"),
//ERROR_MONTH_WITHDRAW_MONEY_OVER(71,"当月取现金额超出限额"),
//
//ERROR_PUSH_TIME_OVER_LIMIT(72,"推送次数过多"),
//ERROR_EMPTY_TALENT_POOL(73,"人才库暂时没人"),
//
//ERROR_PUNCK_CLOCK_NUM_OVER(74,"目前支持您每天最多发 6 条打卡命令。"),
//ERROR_PUNCK_CLOCK_TIME(75,"请在正常时间段（6:00~22:00）内发送打卡命令。"),
//ERROR_NO_NEED_PUNCK_CLOKC_STU(76,"咦？今天似乎没有需要上岗的兼客。"),

