//
//  CCPRestSDK.h
//  CCPRestSDK SDK
//
//  Created by wang ming on 14-4-24.
//  Copyright (c) 2014年 cloopen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    EType_XML,
    EType_JSON
}EBodyType;

typedef enum
{
    ECloopenRestSDK_NetErr = 172001,//网络错误
    ECloopenRestSDK_NoResNull,//172002 无返回包体
    ECloopenRestSDK_BodyErr, //172003 返回包体错误
    ECloopenRestSDK_IPNull,//172004 IP为空
    ECloopenRestSDK_PortErr,//172005 端口错误（小于等于0）
    ECloopenRestSDK_AccountNull,//172006 主帐号为空
    ECloopenRestSDK_AccountTokenNull,//172007 主帐号令牌为空
    ECloopenRestSDK_SubAccountNull,//172008 子帐号为空
    ECloopenRestSDK_SubAccountTokenNull,//172009 子帐号令牌为空
    ECloopenRestSDK_VoIPAccountNull,//172010 VoIP帐号为空
    ECloopenRestSDK_VoIPPassWordNull,//172011 VoIP密码为空
    ECloopenRestSDK_AppIDNull,//172012 应用ID为空
}ECloopenRestSDKErr;

@interface CCPRestSDK : NSObject<NSURLConnectionDelegate>
@property (nonatomic,retain) NSString* server_IP;
@property (nonatomic,assign) NSInteger server_Port;
@property (nonatomic,assign) EBodyType bodyType;//EType_XML 0 xml,EType_JSON 1 json
@property (nonatomic,retain) NSString* app_ID;
@property (nonatomic,retain) NSString* main_Account;
@property (nonatomic,retain) NSString* main_Token;
@property (nonatomic,retain) NSString* sub_AccountSid;
@property (nonatomic,retain) NSString* sub_AccountToken;
@property (nonatomic,retain) NSString* voip_Account;
@property (nonatomic,retain) NSString* voip_Password;


/*
 注意事项：
 使用我们的Rest SDK及Demo需要先获得帐号及应用信息，并使用这些信息完成SDK初始化
 操作，主帐号可以从开发者控制台获取，应用ID和子帐号可以使用Demo默认配置的也可以自己
 创建应用及子帐号（Demo帐号对电话号码有限制，只能对开发者控制台号码管理页面配置的号
 码发起业务请求）。
 */

/**
 * 初始化SDK
 * @param	serverIP        必选参数 : Rest服务器IP
 * @param	serverPort      必选参数 : Rest服务器端口
 * @return  返回Rest SDK对象
 */
-(id)initWithServerIP:(NSString*) serverIP andserverPort:(NSInteger) serverPort;

/**
 * 设置主帐号
 * @param   accountSid      必选参数 : 主帐号
 * @param   accountToken    必选参数 : 主帐号令牌
 */
-(void)setAccountWithAccountSid:(NSString*) accountSid andAccountToken:(NSString*)accountToken;

/**
 * 设置应用ID
 * @param   appId           必选参数 : 应用ID
 */
-(void)setAppId:(NSString*) appId;

/**
 * 设置子帐号
 * @param   subAccountSid   必选参数 : 子帐号
 * @param   subAccountToken 必选参数 : 子帐号令牌
 * @param   voIPAccount     必选参数 : VoIP帐号
 * @param   voIPPassword    必选参数 : VoIP密码
 */
-(void)setSubAccountWithSubAccountSid:(NSString*) subAccountSid andSubAccountToken:(NSString*) subAccountToken andVoipAccount:(NSString*) voIPAccount andVoIPPassword:(NSString*)voIPPassword;

#pragma mark - 帐号信息查询请求
/**
 * 帐号信息查询请求
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)queryAccountInfo;

#pragma mark - 创建子帐号
/**
 * 创建子帐号
 * @param   friendlyName      必选参数 : 子帐号名称。可由英文字母和阿拉伯数字组成子帐号唯一名称，推荐使用电子邮箱地址
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)createSubAccountWithFriendlyName:(NSString*)friendlyName;

#pragma mark - 获取子帐号
/**
 * 获取子帐号
 * @param   startNo      可选参数 : 开始的序号，默认从0开始
 * @param   offset       可选参数 : 一次查询的最大条数，最小是1条，最大是100条
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)getSubAccountsWithStartNo:(NSInteger) startNo andOffset:(NSInteger)offset;

#pragma mark - 子帐号信息查询
/**
 * 子帐号信息查询
 * @param   friendlyName      必选参数 : 子帐号名称
 * @return  NSMutableDictionary对象
 */

- (NSMutableDictionary*)querySubAccountWithFriendlyName:(NSString*) friendlyName;

#pragma mark - 发送短信
/**
 * 发送短信
 * @param   to      必选参数 : 短信接收端手机号码集合，用英文逗号分开，每批发送的手机号数量不得超过100个
 * @param   body    必选参数 : 短信正文
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)sendSMSWithTo:(NSString*)to andBody:(NSString*)body;

#pragma mark - 发送模板短信
/**
 * 发送模板短信
 * @param   to              必选参数 : 短信接收端手机号码集合，用英文逗号分开，每批发送的手机号数量不得超过100个
 * @param   templateId      必选参数 : 模板Id
 * @param   datas           可选参数 : 数组类型，内部数组元素内含消息内容数据，用于替换模板中{序号}
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)sendTemplateSMSWithTo:(NSString*)to andTemplateId:(NSString*)templateId andDatas:(NSArray*)datas;

#pragma mark - 双向回拨
/**
 * 双向回拨 (显号设置需要云平台开放相关权限)
 * @param   from                必选参数 : 主叫电话号码
 * @param   to                  必选参数 : 被叫电话号码
 * @param   customerSerNum      可选参数 : 被叫侧显示的客服号码，根据平台侧显号规则控制。
 * @param   fromSerNum          可选参数 : 主叫侧显示的号码，根据平台侧显号规则控制
 * @param   promptTone          可选参数 : 第三方自定义回拨提示音
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)callBackWithFrom:(NSString*)from andTo:(NSString*)to andCustomerSerNum:(NSString*)customerSerNum andFromSerNum:(NSString*)fromSerNum andPromptTone:(NSString*)promptTone;

#pragma mark - 发起外呼通知
/**
 * 发起外呼通知
 * @param     to            必选参数 : 被叫号码
 * @param	  mediaName     可选参数 : 语音文件名称，格式 wav。与mediaTxt不能同时为空，不为空时mediaTxt属性失效。
 * @param     mediaTxt      可选参数 : 文本内容，默认值为空。
 * @param     displayNum	可选参数 : 显示的主叫号码，显示权限由服务侧控制。
 * @param     playTimes	 	可选参数 : 循环播放次数，1－3次，默认播放1次。
 * @param     type          可选参数 : 如果传入type等于1，则播放默认语音文件
 * @param     respUrl	 	可选参数 : 外呼通知状态通知回调地址，云通讯平台将向该Url地址发送呼叫结果通知。
 * @return    NSMutableDictionary对象
 */
- (NSMutableDictionary*)landingCallWithTo:(NSString*)to andMediaName:(NSString*)mediaName andMediaTxt:(NSString*)mediaTxt andDisplayNum:(NSString*)displayNum andPlayTimes:(NSInteger)playTimes andType:(NSInteger) type andRespUrl:(NSString*)respUrl;

#pragma mark - 发起语音验证码请求
/**
 * 发起语音验证码请求
 * @param   verifyCode      必选参数 : 验证码内容，为数字和英文字母，不区分大小写，长度4-20位
 * @param   to              必选参数 : 接收验证码的手机、座机号码
 * @param   displayNum      可选参数 : 显示主叫号码，显示权限由服务侧控制
 * @param   playTimes       必选参数 : 播放次数，1－3次
 * @param   respUrl         可选参数 : 用户发起语音验证码请求后，云通讯平台将向该url地址发送呼叫结果通知
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)voiceVerifyWithVerifyCode:(NSString*)verifyCode andTo:(NSString*)to andDisplayNum:(NSString*)displayNum andPlayTimes:(int) playTimes andRespUrl:(NSString*)respUrl;

#pragma mark - IVR外呼
/**
 * IVR外呼
 * @param   number          必选参数 : 待呼叫号码，为Dial节点的属性
 * @param   userdata        可选参数 : 用户数据，在<startservice>通知中返回，只允许填写数字字符，为Dial节点的属性
 * @param   record          必选参数 : 是否录音，可填项为YES和NO，默认值为NO不录音，为Dial节点的属性
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)ivrDialWithNumber:(NSString*)number andUserdata:(NSString*)userdata andRecord:(BOOL)record;

#pragma mark - 话单下载
/**
 * 话单下载 （话单下载是云通讯平台为开发者提供的话单获取通道，通过此接口开发者可以获取前一天、前一周、前一个月的话单数据）
 * @param   date        必选参数 : 用户数据，在<startservice>通知中返回，只允许填写数字字符，为Dial节点的属性
 * @param   keywords    可选参数 : 客户的查询条件，由客户自行定义并提供给云通讯平台。默认不填忽略此参数
 * @return  NSMutableDictionary对象
 */
- (NSMutableDictionary*)billRecordsWithDate:(NSString*)date andKeywords:(NSString*)keywords;

#pragma mark - 日志开关
/**
 * 日志开关
 * @param   enableLog        必选参数 : 是否输出日志，YES输出
 */
-(void) enableLog:(BOOL)enable;
@end
