//
//  ResponseInfo.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ParamModel.h"
#import "JobClassifyInfoModel.h"

@interface ResponseInfo : NSObject

@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, copy) NSNumber *errCode;
@property (nonatomic, copy) NSDictionary *content;
@property (nonatomic, copy) NSDictionary *originData;

- (BOOL)success;

@end


@interface GetPublicKeyModel : NSObject
@property (nonatomic, copy) NSString *pub_key_exp;
@property (nonatomic, copy) NSString *expire_time;
@property (nonatomic, copy) NSString *modulus;
@property (nonatomic, copy) NSString *pub_key_base64;
@end

@interface ShockHand2Model : NSObject
@property (nonatomic, copy) NSNumber *seq;
@property (nonatomic, copy) NSNumber *expire_time;
@property (nonatomic, copy) NSString *server_random;
@property (nonatomic, copy) NSString *token;

@end

@interface CreatSessionModel : NSObject
@property (nonatomic, copy) NSString *challenge;
@property (nonatomic, copy) NSString *pub_key_base64;
@property (nonatomic, copy) NSString *pub_key_modulus;
@property (nonatomic, copy) NSString *pub_key_exp;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userToken;

@end

@interface PunchResponseModel : NSObject
@property (nonatomic, copy) NSString *punch_the_clock_request_id;
@property (nonatomic, copy) NSNumber *create_time;
@property (nonatomic, strong) NSNumber *need_punch_count;
@property (nonatomic, strong) NSNumber *has_punch_count;
@property (nonatomic, strong) NSNumber *request_status;
@end


//“apply_job_id”:// 申请岗位id
//“stu_account_id”:// 兼客账号id
//“true_name”:// 兼客姓名
//“user_profile_url” : // 兼客头像
//“sex”:// 性别
//“telphone”:// 手机号，即登录账号

@interface PunchClockModel : NSObject
@property (nonatomic, copy) NSArray *punch_request_list;    /** 模型数组 */
@property (nonatomic, strong) QueryParamModel *query_param; /** 分页模型 */
@property (nonatomic, copy) NSNumber *punch_request_list_history_count;   /** 历史记录数 */
@end



@interface AcctVirtualModel : NSObject

@property (nonatomic, copy) NSString *detail_list_id;   /** 流水记录id */
@property (nonatomic, copy) NSString *account_money_id; /** 帐户id */
@property (nonatomic, copy) NSNumber *actual_amount;    /**  <int>明细产生的金额，单位为分，不包含小数 */
@property (nonatomic, copy) NSNumber *small_red_point;  /**  <int>是否呈现小红点，1表示是，0表示否 */
@property (nonatomic, copy) NSString *virtual_money_detail_type;    /** 流水类型 */
@property (nonatomic, copy) NSString *virtual_money_detail_title;   /** 流水标题 */
@property (nonatomic, copy) NSNumber *aggregation_number;   /** <int>流水的聚合次数（仅对于企业为兼客支付工资有效，数字表示支付次数） */
@property (nonatomic, copy) NSNumber *create_time;  /** <long> 从1970年1月1日至今的秒数 */
@property (nonatomic, copy) NSNumber *update_time;  /**  <long> 从1970年1月1日至今的秒数 */
@property (nonatomic, copy) NSString *job_id;   /** <long>如果此明细与岗位有关，本字段不为空 */
@property (nonatomic, copy) NSString *task_id;  /** <long>如果此明细与宅任务有关，本字段不为空 */

@end

@interface AcctVirtualResponseModel : NSObject

@property (nonatomic, strong) QueryParamModel *query_param; /** 分页模型 */
@property (nonatomic, copy) NSNumber *recruitment_amount; /** <int>账户招聘余额 */
@property (nonatomic, copy) NSNumber *recruitment_frozen_amount; /** <int>账户招聘冻结款余额 */
@property (nonatomic, copy) NSNumber *has_set_bag_pwd;  /**  <int>是否设置过钱袋子密码 */
@property (nonatomic, copy) NSArray *detail_list;    /** 招聘余额明细模型数组 */

@end

@interface DetailItemResponseMolde : NSObject

@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, copy) NSString *detail_item_count;
@property (nonatomic, copy) NSArray *stu_list;

@end

@interface ToadyPublishedJobNumRM : NSObject
@property (nonatomic, copy) NSNumber *max_published_today;                  /*!< 认证雇主每日岗位限制发布数 */
@property (nonatomic, copy) NSNumber *authenticated_publish_job_num;        /*!< 认证雇主今日已发布岗位数 */
@property (nonatomic, copy) NSNumber *authenticated_status;                 /*!< 认证转态 */
@property (nonatomic, copy) NSNumber *not_authenticated_can_publish_num;    /*!< 未认证剩余可发布数量 */
@end

@class CityModel;
@interface StuSubscribeModel : MKBaseModel

@property (nonatomic, strong) NSArray *job_classify_id_list;    /*!< 岗位分类id */
@property (nonatomic, strong) NSArray *address_area_id_list;    /*!< 工作区域id */
@property (nonatomic, strong) NSArray *job_classifier_list; /*!< 岗位类型   JobClassifyInfoModel  */
@property (nonatomic, strong) NSArray *child_area;  /*!< 城市子区域列表 CityModel */
@property (nonatomic, assign) long work_time;  /*!< 工作时间 */
@property (nonatomic, strong) CityModel *city_info; /*!< 城市模型 */
@property (nonatomic, copy) NSNumber *city_id;  /*!< 订阅城市id */

@end

@interface UpdateStuSubscribeModel : MKBaseModel

@property (nonatomic, copy) NSArray* job_classify_id_list;
@property (nonatomic, copy) NSArray* address_area_id_list;
@property (nonatomic, assign) NSUInteger work_time;
@property (nonatomic, strong) NSNumber* is_reset_subscribe;
@property (nonatomic, copy) NSNumber *city_id;

@end

@interface SocialActivistTaskListModel : MKBaseModel
@property (nonatomic, copy) NSArray *task_list; /*!< 人脉王岗位列表 */
@property (nonatomic, copy) NSNumber *all_receive_reward; /*!< 所获得总赏金 */
@property (nonatomic, copy) NSNumber *is_receive_social_activist_push; /*!< 是否接收人脉王推送  1：是 0：否 */
@property (nonatomic, copy) NSNumber *in_history_task_list_count; /*!< 历史记录条数 */
@property (nonatomic, copy) NSNumber *job_topic_id; /*!< 人脉王专题id */

@end

@interface JobVasModel : MKBaseModel
@property (nonatomic, copy) NSNumber *id;    /*!< 服务ID */
@property (nonatomic, copy) NSNumber *price;    /*!< 服务价格,单位为分 */
@property (nonatomic, copy) NSNumber *promotion_price;  /*!< 服务促销价格,单位为分 */
@property (nonatomic, copy) NSNumber *top_days; /*!< 置顶天数 */
@property (nonatomic, copy) NSNumber *push_num; /*!< 推送人数 */

//自定义字段
@property (nonatomic, copy) NSNumber *serviceType; /*!< 增值服务类型 */
@property (nonatomic, assign) BOOL selected;    /*!< 是否被选中 */
@property (nonatomic, copy) NSNumber *rechargePrice;    /*!< 支付价格 */
@end

@interface JobVasResponse : MKBaseModel

@property (nonatomic, copy) NSNumber *top_dead_time;    /*!< 置顶截止时间 */
@property (nonatomic, copy) NSNumber *last_refresh_time;    /*!< 上次岗位刷新时间 */
@property (nonatomic, copy) NSNumber *last_push_time;   /*!< 上次岗位推送时间 */
@property (nonatomic, copy) NSString *last_push_desc;   /*!< 上次岗位推送描述 */

@end

@interface ServiceTeamApplyModel : MKBaseModel

//雇主信息案例
@property (nonatomic,copy) NSNumber *account_id;   /*!< 账号Id */
@property (nonatomic,copy) NSNumber *id;    /*!< 申请Id */
@property (nonatomic,copy) NSNumber *create_time;   /*!< 创建时间 */
@property (nonatomic,copy) NSNumber *service_classify_id;   /*!< 服务类型id */
@property (nonatomic,copy) NSString *service_classify_img_url;  /*!< 服务分类图片url */
@property (nonatomic,copy) NSString *service_classify_name; /*!< 服务分类名称 */
@property (nonatomic,copy) NSNumber *experience_count;  /*!< 成功案例个数 */
@property (nonatomic,copy) NSNumber *status;    /*!< 状态 1申请中 2已通过 3未通过 */
@end

@interface ServicePersonalStuModel : MKBaseModel
@property (nonatomic, copy) NSNumber *stu_account_id;  // 账号id
@property (nonatomic, copy) NSString *true_name;    // 姓名
@property (nonatomic, copy) NSString *sex; // 性别
@property (nonatomic, copy) NSNumber *id_card_verify_status;    // 身份认证状态
@property (nonatomic, copy) NSString *desc_after_true_name; // 姓名后面显示的描述信息
@property (nonatomic, copy) NSArray *service_personal_info_list;    //key-value键值
@property (nonatomic, copy) NSArray *work_photos_list; //经历图片数组

@property (nonatomic, copy) NSNumber *id;   /*!< 投递id */
@property (nonatomic, copy) NSNumber *apply_status; /*!< 状态  1：待回复 2：已报名 3：已拒绝 4：已支付 */
@property (nonatomic, copy) NSNumber *contact_telephone;    /*!< 联系手机号（注：只有已支付状态才有联系手机号字段） */
@property (nonatomic, copy) NSString *profile_url;  /*!< 兼客头像 */
@property (nonatomic, copy) NSNumber *service_personal_job_apply_id;    /*!< 个人服务需求申请Id */
@property (nonatomic, copy) NSNumber *is_be_invited;    /*!< 是否已经邀约  1：是  0:否 */
@property (nonatomic,copy) NSNumber *read_num;  /*!< 查看人数 */
@property (nonatomic,copy) NSNumber *invite_num;    /*!< 邀约人数 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface ResumeExperienceModel : MKBaseModel

@property (nonatomic, copy) NSNumber *resume_experience_id; /*!< 工作经历id */
@property (nonatomic, copy) NSNumber *job_classify_id;  /*!< 岗位分类id */
@property (nonatomic, copy) NSString *job_classify_name;    /*!< 岗位分类名称 */
@property (nonatomic, copy) NSString *job_title;    /*!< 岗位名称 */
@property (nonatomic, copy) NSNumber *job_begin_time;   /*!< 岗位开始时间，时间戳 */
@property (nonatomic, copy) NSNumber *job_end_time; /*!< 岗位结束时间，时间戳 */
@property (nonatomic, copy) NSString *job_content;  /*!< 工作内容 */

@property (nonatomic, assign) CGFloat cellHeight;

@end
