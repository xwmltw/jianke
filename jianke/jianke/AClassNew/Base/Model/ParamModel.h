//
//  ParamModel.h
//  jianke
//
//  Created by xiaomk on 15/9/20.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBaseModel.h"

@interface ParamModel : NSObject
//@property (nonatomic, assign) BOOL isNeedBracket;
- ( NSString * )getContent;
@end

@interface BaseInfoPM : ParamModel
@property (nonatomic, copy) NSString* client_type;
@property (nonatomic, copy) NSString* client_version;
@property (nonatomic, copy) NSNumber* city_id;          //选择城市ID
@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* lng;
@property (nonatomic, copy) NSNumber* pos_city_id;      //定位城市ID
@end

@interface QueryParamModel : ParamModel
@property (nonatomic, copy) NSNumber* timestamp;        // 毫秒数
@property (nonatomic, copy) NSNumber* page_size;        // 页大小
@property (nonatomic, copy) NSNumber* page_num;         // 页号
- (instancetype)initWithPageSize:(NSNumber *)pageSize pageNum:(NSNumber *)pageNum;
- (NSString*)getContent;
@end

@interface UserLoginPM : BaseInfoPM
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSNumber* user_type;
@property (nonatomic, copy) NSString* dynamic_sms_code; /*!< 动态验证码 */
@property (nonatomic, copy) NSString* dynamic_password; /*!< 动态密码(动态验证码登录后返回的动态密码) */
@end

@interface PostPerfectUserInfoPM : BaseInfoPM
@property (nonatomic, copy) NSString* oauth_id;
@property (nonatomic, copy) NSString* phone_num;
@property (nonatomic, copy) NSString* sms_authentication_code;
@end

@interface PostOathUserInfoPM : BaseInfoPM
@property (nonatomic, copy) NSNumber* thrid_plat_type;
@property (nonatomic, copy) NSString* open_id;
@property (nonatomic, copy) NSString* access_token;
@property (nonatomic, copy) NSNumber* user_type;
@end

@interface RegistUserByPhoneNumPM : BaseInfoPM
@property (nonatomic, copy) NSString* phone_num;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* sms_authentication_code;
@property (nonatomic, copy) NSNumber* user_type;
@property (nonatomic, copy) NSString *true_name;
@end

@interface ResetPasswordByPhoneNumPM : ParamModel
@property (nonatomic, copy) NSString* phone_num;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* sms_authentication_code;
@property (nonatomic, copy) NSNumber* user_type;
@end

@interface GetSmsAuthenticationCodePM : ParamModel
@property (nonatomic, copy) NSString* phone_num;
@property (nonatomic, assign) NSInteger opt_type;
@property (nonatomic, copy) NSNumber* user_type;
@property (nonatomic, copy) NSString* sms_authentication_code;
@end

@class FeedbackParam;
@interface SubmitFeedbackV2 : ParamModel
@property (nonatomic, copy) NSNumber* city_id;
@property (nonatomic, copy) NSNumber* address_area_id;
@property (nonatomic, copy) NSNumber* feedback_type;
@property (nonatomic, copy) NSString* phone_num;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, copy) NSNumber* job_id;
@property (nonatomic, strong) NSNumber *feedback_classify;
@end

@interface WechatParmentRequest : ParamModel
@property (nonatomic, copy) NSString* acct_encpt_password;
@property (nonatomic, copy) NSString* client_time_millseconds;
@property (nonatomic, copy) NSString* client_sign;
@property (nonatomic, copy) NSString* payment_amount;
@property (nonatomic, copy) NSString* open_id;
@end

@interface AlipayPM : ParamModel
@property (nonatomic, copy) NSString* acct_encpt_password;
@property (nonatomic, copy) NSString* client_time_millseconds;
@property (nonatomic, copy) NSString* client_sign;
@property (nonatomic, copy) NSString* payment_amount;
@property (nonatomic, copy) NSString* alipay_user_name;
@property (nonatomic, copy) NSString* alipay_user_true_name;
@end
//“acct_encpt_password”: // 兼客/雇主密码，使用challenge加密，加密方式与登录时一致，加密的challenge就是create_session阶段的challenge
//“client_time_millseconds”: // 客户端当前系统时间毫秒数
//“client_sign”: // 客户端为本次交互生成的签名(字母为大写)
//“payment_amount”: // 提现金额
//“alipay_user_name”: // 支付宝账号名
//“alipay_user_true_name”://支付宝账号所属人姓名

@interface PostResumeInfoPM : ParamModel
@property (nonatomic, copy) NSString* true_name;
@property (nonatomic, copy) NSString* profile_url;
@property (nonatomic, copy) NSString* obode;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* lng;
@property (nonatomic, copy) NSNumber* address_area_id;
@property (nonatomic, copy) NSNumber* city_id;
@property (nonatomic, copy) NSNumber* school_id;
@property (nonatomic, copy) NSNumber* sex;
@property (nonatomic, copy) NSNumber* weight;
@property (nonatomic, copy) NSNumber* height;
@property (nonatomic, copy) NSString* birthday;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSNumber *id_card_verify_status;
@property (nonatomic, copy) NSNumber *education;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *specialty;
@property (nonatomic, copy) NSNumber *user_type;
@property (nonatomic, copy) NSString *contact_tel;

//自定义字段

@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, strong) NSDate *date;

@end

@interface PostIdcardAuthInfoPM : ParamModel
@property (nonatomic, copy) NSString *id_card_url_front;    /*!< 身份证正面图片URL */
@property (nonatomic, copy) NSString *id_card_url_back; /*!< 身份证反面图片URL */
@property (nonatomic, copy) NSString *id_card_url_third; /*!< 手持身份证的照片 */
@property (nonatomic, copy) NSString *id_card_no;
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSNumber *id_card_verify_status;
@property (nonatomic, assign) BOOL isUpdateIdCardUrlfront;    /*!< 是否上传新的正面照 */
@property (nonatomic, assign) BOOL isUpdateIdCardUrlBack;    /*!< 是否上传新的发面照 */
@property (nonatomic, assign) BOOL isUpdateIdCardUrlthird;    /*!< 是否上传新的手持身份证照 */

//@property (nonatomic, copy) NSString *id_card_status;   /*!< 身份证认证状态 */
//@property (nonatomic, copy) NSString *business_licence_status;  /*!< 营业执照认证状态 */
//@property (nonatomic, copy) NSString *enterprise_name;  /*!< 雇主名称 */
//@property (nonatomic, copy) NSString *regist_num;   /*!< 营业执照号 */
//@property (nonatomic, copy) NSString *business_licence_url; /*!< 营业执照图片 */
@end

@interface EmployApplyJobPM : ParamModel
@property (nonatomic, copy) NSArray *apply_job_id_list;
@property (nonatomic, copy) NSString *job_id;
@property (nonatomic, strong) NSNumber *employ_status;
@property (nonatomic, copy) NSString *employ_memo;
@end

@interface EntPayForStuPM : ParamModel
@property (nonatomic, copy) NSString* acct_encpt_password;
@property (nonatomic, copy) NSString* client_time_millseconds;
@property (nonatomic, copy) NSString* client_sign;
@property (nonatomic, copy) NSArray* payment_list;
- (NSDictionary *)objectClassInArray;
@end

@interface PaymentPM : ParamModel
@property (nonatomic, copy) NSNumber* apply_job_id;
@property (nonatomic, copy) NSNumber* salary_num;
@property (nonatomic, strong) NSArray *on_board_date;
@end


@interface SchoolPM : ParamModel
@property (nonatomic, copy) NSString *address_area_id;
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *school_name;
@end

@interface ActivateDeviceModel : ParamModel
@property (nonatomic, copy) NSString* dev_name;
@property (nonatomic, copy) NSString* system;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* lng;
@property (nonatomic, copy) NSString* city_name;
@property (nonatomic, copy) NSString* city_code;
@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* platform_type;
@property (nonatomic, copy) NSString* is_login;
@property (nonatomic, copy) NSString* idfa;
@end

@interface SendGroupMsgPM : ParamModel
@property (nonatomic, copy) NSString *account_idlist;
@property (nonatomic, strong) NSNumber *notice_channel;
@property (nonatomic, copy) NSString *notice_content;
@property (nonatomic, copy) NSString *notice_parttime_id;
@end


@interface GetADModel : ParamModel
@property (nonatomic, copy) NSString* ad_site_id;
@property (nonatomic, copy) NSString* city_id;
@end

@interface StuUploadPhotoPM : ParamModel
@property (nonatomic, copy) NSString *photo_url;
@property (nonatomic, strong) NSNumber *photo_type;
@property (nonatomic, copy) NSString *card_no;
@end

@interface UpdateJobBillModel : ParamModel
@property (nonatomic, copy) NSString *job_bill_id;
@property (nonatomic, copy) NSString *service_fee;
@property (nonatomic, copy) NSString *stu_pay_list;
@property (nonatomic, copy) NSString *leader_pay_list;
@end
@interface UpdateStuJobBillPM : ParamModel
@property (nonatomic, copy) NSString *stu_account_id;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *ent_publish_price;
@end

@interface GetQuickReplyMsgModel : ParamModel
@property (nonatomic, copy) NSString* custom_info_type;
@property (nonatomic, copy) NSString* data_md5;
@end

@interface GetImGroupInfoModel : ParamModel
@property (nonatomic, copy) NSString* md5_hash;
@property (nonatomic, copy) NSString* groupId;
@end


@interface QueryJobListConditionModel : ParamModel
@property (nonatomic, copy) NSString* city_id;
@property (nonatomic, copy) NSString* job_title;
@property (nonatomic, copy) NSString* is_include_grab_single;

@property (nonatomic, copy) NSString* job_type_id;
@property (nonatomic, copy) NSString* address_area_id;
@property (nonatomic, copy) NSString* salary_unit;
@property (nonatomic, copy) NSString* coord_latitude;
@property (nonatomic, copy) NSString* coord_longitude;
@property (nonatomic, copy) NSString* left_time_type;
@property (nonatomic, copy) NSNumber *through;  /*!< 是否查询直通车岗位 1：是 0:否 */
@end

@interface QueryJobListModel : ParamModel
@property (nonatomic, strong) QueryParamModel* query_param;
@property (nonatomic, strong) QueryJobListConditionModel* query_condition;
@property (nonatomic, assign) int is_need_count;
@property (nonatomic, assign) int is_show_stick_job;
@end

@interface RemoveGroupModel : ParamModel
@property (nonatomic, copy) NSString* groupId;
@property (nonatomic, copy) NSString* accountId;
@end

@interface PostEPInfo : ParamModel
@property (nonatomic, copy) NSString* enterprise_name;
@property (nonatomic, copy) NSString* true_name;
@property (nonatomic, copy) NSString* profile_url;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* desc;
@end

@interface GetTopicDetailPM : ParamModel
@property (nonatomic, copy) NSString* topic_id;
@end

@interface GetClientGlobalPM : ParamModel
@property (nonatomic, copy) NSNumber* city_id;
@property (nonatomic, copy) NSString* client_type;
@property (nonatomic, copy) NSNumber* app_version_code;
@property (nonatomic, copy) NSString *product_type;
//“client_type”: xxx //客户端类型 1Android  2 ios
//“app_version_code”: xxxx // 客户端版本号
@end

@interface GetEnterpriscJobModel : ParamModel
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, copy) NSNumber *query_type;   /*!<  1表示正在招人的岗位列表，2表示已完成的岗位列表, 3表示被投诉的岗位，4：发布中的岗位 5表示2.3版雇主首页的列表
                                                     6表示查询历史岗位列表 */
@property (nonatomic, copy) NSNumber *in_history;   /*!<  1：是  0：否  (不在历史记录的数据是一次性下发，不分页) */

@property (nonatomic, copy) NSNumber *ent_id;       /*!< 雇主id */
@property (nonatomic, copy) NSNumber *job_type;     /*!< 岗位类型，1普通岗位 2抢单岗位 3：代发岗位 4:快招岗位 */
@end

@interface GetQueryApplyJobModel : ParamModel
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, copy) NSString *job_id;
@property (nonatomic, copy) NSNumber *on_board_date;        /*!< 上岗日期，0点，时间戳毫秒  精确岗位查询每一天上岗的已录用兼客列表 */
@property (nonatomic, copy) NSNumber *is_need_pagination;   /*!< :// 是否需要分页  不传或者传1表示需要分页  传0表示不需要分页 */
@property (nonatomic, copy) NSNumber *list_type;    /*!< 列表类型:
                                                     1表示需要处理报名的列表，
                                                     2表示录用成功的，
                                                     3表示不合适的,
                                                     4表示已处理结束的兼客列表,
                                                     5表示需要支付工资的兼客列表 
                                                     6:【已报名】页兼客投递列表 (未处理，已拒绝，录用成功) 
                                                     7获取【已报名】页兼客投递列表（即除兼客撤销投递外的所有申请记录）
                                                     8：V2.3已报名列表 */
@end

#pragma mark - 链接收录信息
@interface MakeupInfo : ParamModel
@property (nonatomic, copy) NSString *qr_code;      /*!< 二维码补录链接 */
@property (nonatomic, copy) NSString *expire_time;  /*!< 过期时间 */
@property (nonatomic, copy) NSString *makeup_info;  /*!< 补录链接文本信息 */
@property (nonatomic, assign) CGFloat cellHeight;   /*!< 对应cell的高度 */
@property (nonatomic, strong) UIImage *qr_image;    /** 二维码图 */

@end

#pragma mark - 雇主收录请求

@interface EntMakeupRequest : ParamModel
@property (nonatomic, copy) NSString *job_id;       /** 岗位ID */
@property (nonatomic, copy) NSArray *resume_list;   /** 兼客数组 */

@end

#pragma markk - 请求列表

@interface EntQueryPunch : ParamModel
@property (nonatomic, copy) NSString *job_id; /** 岗位ID */
@property (nonatomic, copy) NSNumber *list_type;  /** 1进行中 2 历史记录 */
@property (nonatomic, strong) QueryParamModel *query_param;
- (instancetype)initWithJob:(NSString *)job andListType:(NSNumber *)listType andParam:(QueryParamModel *)param;
@end

#pragma mark - 打卡对应列表请求

@interface EntQueryStuPunch : ParamModel
@property(nonatomic,strong)QueryParamModel *query_param;    /** 分页模型 */
@property(nonatomic,copy)NSString *punch_the_clock_request_id;  /** 打卡请求ID */
- (instancetype)initWithQueryParam:(QueryParamModel *)queryParam withRequestId:(NSString *)requestId;
@end

@interface EntChangeOnBoardDateStuPM : ParamModel
@property (nonatomic, copy) NSString *job_id;           /** 岗位ID */
@property (nonatomic, copy) NSNumber *on_board_date;
@property (nonatomic, copy) NSArray *apply_job_id_list;

@end

@class LocalModel;
@interface GetJobLikeParam : ParamModel

@property (nonatomic, copy) NSString *job_id;
@property (nonatomic, copy) NSNumber *city_id;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
- (instancetype)initWithjobId:(NSString *)jobId andCityId:(NSNumber *)cityId andCityModel:(LocalModel *)localModel;
@end

@interface QueryJobQAParam : ParamModel
@property (nonatomic,strong)QueryParamModel *query_param;    /** 分页模型 */
@property (nonatomic, copy) NSString *job_id;
@end


@interface RechargeAmountParam : ParamModel
@property (nonatomic, copy) NSString *pay_channel;  /** 1, "钱袋子";2, "支付宝";3, "微信";4, “微信公众号” ;5, “平安付” */
@property (nonatomic, copy) NSString *acct_encpt_password;  /** 支付密码 // 支付渠道为钱袋子余额支付的时候必填 */
@property (nonatomic, copy) NSString *client_time_millseconds;  /** 必填, 客户端请求时间戳 */
@end


@interface DetailItmeParam : ParamModel
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, copy) NSString *detail_list_id;   /** 总流水ID */
@end


@interface FeedbackParam : ParamModel
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@end

@interface FreeCallPM : MKBaseModel
@property (nonatomic, copy, nonnull) NSNumber *plat_type;/*!< 平台类型 1：轻码云平台 */
@property (nonatomic, copy, nonnull) NSString *caller;   /*!< 主叫号码 */
@property (nonatomic, copy, nonnull) NSString *called;   /*!< 被叫号码 */
@property (nonatomic, copy, nonnull) NSNumber *opt_type; /*!< 操作类型 0查询剩余可拨打秒数 1拨打电话 */
@end
