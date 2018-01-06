//
//  EPModel.h
//  jianke
//
//  Created by fire on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "ContactModel.h"


@interface EPModel : NSObject
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSNumber *enterprise_id;            /*!< 企业ID *///character_id（机构性质ID）类型： 1：民企  2：团队  3：合资4：国企
@property (nonatomic, copy) NSString *enterprise_name;          /*!< 企业名 */
@property (nonatomic, copy) NSString *ent_short_name;          /*!< 企业简称 */
@property (nonatomic, copy) NSNumber *account_id;               /*!< 账号ID */
@property (nonatomic, copy) NSString *contact_tel_img_url;      /*!< 联系电话图片地址 */
@property (nonatomic, copy) NSNumber *verifiy_status;           /*!< 认证状态, 1未认证, 2正在认证、3认证通过 */
@property (nonatomic, copy) NSNumber *job_ing_count;            /*!< 招聘中的岗位数 */
@property (nonatomic, copy) NSNumber *evalu_byent_count;        /*!< 雇主评价岗位申请的总数 */
@property (nonatomic, copy) NSNumber *complaint_bystu_count;    /*!< 雇主被兼客的投诉次数 */
@property (nonatomic, copy) NSNumber *complaint_for_entread_count;  /*!< 被投诉 未读数的统计 */
@property (nonatomic, copy) NSNumber *bind_wechat_status;           /*!< 是否绑定了微信 0：未绑定 1：已绑定 */
@property (nonatomic, copy) NSNumber* bind_wechat_public_num_status;        /*!< new 2.7 是否绑定了微信 0：未绑定 1：已绑定  */

@property (nonatomic, copy) NSNumber *stu_complaint_ent_small_red_point;    /*!< 兼客对我的投诉小红点 */
@property (nonatomic, copy) NSString *id_card_verify_status;                /*!< 实名认证状态: 1：未认证，2：认证中，3：已认证  4：认证失败 */
@property (nonatomic, copy) NSString *id_card_no;                           /*!< 身份证号 */
@property (nonatomic, copy) NSString *profile_url;          //头像
@property (nonatomic, copy) NSString* true_name;            //认证姓名
@property (nonatomic, copy) NSString* register_no;          //营业执照号
@property (nonatomic, copy) NSString* telphone;             //联系电话
@property (nonatomic, copy) NSString* desc;     //公司详情
@property (nonatomic,copy) NSNumber *sex;   //性别 1男 0女
//@property (nonatomic, copy) NSNumber *student_collect_status;   //兼客 收藏状态
//
//@property (nonatomic, copy) NSNumber *character_id;       /*!< 机构性质id号 */
//@property (nonatomic, copy) NSString *character_name;     /*!< 机构性质 */
@property (nonatomic, copy) NSNumber *industry_id;        /*!< 所属行业id */
@property (nonatomic, copy) NSString *industry_name;      /*!< 所属行业名称 */
@property (nonatomic, copy) NSString *industry_desc;        /*!< 所属行业描述 */
///*!< 联系地址地图坐标 */
@property (nonatomic, copy) NSString *contact;              /*!< 联系人 */
//@property (nonatomic, copy) NSString *contact_tel;        /*!< 电话号码 */
//@property (nonatomic, copy) NSString *address;            /*!< 地址详情 */
//@property (nonatomic, copy) NSString *desc;               /*!< 企业介绍 */
@property (nonatomic, copy) NSString *img_url;              /*!< 企业图标 */
@property (nonatomic, copy) NSNumber *city_id;            /*!< 城市ID */
@property (nonatomic, copy) NSString *city_name;          /*!< 城市名称 */
//@property (nonatomic, copy) NSString *address_area_name;  /*!< 区域名称 */
//@property (nonatomic, copy) NSNumber *address_area_id;    /*!< 区域ID */

//220
@property (nonatomic, copy) NSString *deal_resume_used_time_avg_desc; /*!< 处理简历平均用时 的字段描述 */
@property (nonatomic, copy) NSString *last_read_resume_time_desc; /*!< 上次查看时间描述 */
// v230
@property (nonatomic, strong) NSNumber *apply_job_limit_enable; /*!< 岗位条件限制开关，0表示关闭，1表示开启 */
// v231
@property (nonatomic, strong) NSNumber *is_bd_bind_account; /*!< 1：表示是bd绑定的前台账号  0：表示不是 */
//v240
@property (nonatomic, copy) NSNumber *regist_num;           /*!< 营业执照号 */
@property (nonatomic, copy) NSString *business_licence_url; /*!< 上传营业执照 */


@property (nonatomic, copy) NSNumber *acct_amount;          /*!< 账户余额 */
@property (nonatomic, copy) NSNumber *advance_amount;       /*!< 预付款余额 */
@property (nonatomic, copy) NSNumber *job_bill_small_red_point; /*!< 包招账单小红点 */
//V303
@property (nonatomic, copy) NSNumber *identity_mark;   /*!< 身份标示 1普通 2兼客合伙人 */
@property (nonatomic, copy) NSNumber *partner_service_fee_type; /*!< 合伙人佣金计算方式 1：比例 2：绝对值 */
@property (nonatomic, copy) NSNumber *partner_service_fee;  /*!< 合伙人佣金 */

@property (nonatomic, copy) NSNumber *is_apply_service_team;    /*!< 是否申请过团队服务 */
@property (nonatomic, copy) NSNumber *service_team_apply_count;   /*!< 发布服务数 */
@property (nonatomic, copy) NSNumber *service_team_apply_ordered_count; /*!< 收到的订单数 */
@property (nonatomic, copy) NSNumber *student_focus_status; /*!< 当前兼客关注状态 1已关注 0未关注 */
@property (nonatomic, copy) NSNumber *stu_fans_count;   /*!< 粉丝数(被关注) */
@property (nonatomic, copy) NSString *service_name; /*!< 服务商名称 */
@property (nonatomic, copy) NSString *service_contact_name; /*!< 服务商服务负责人 */
@property (nonatomic, copy) NSString *service_contact_tel;  /*!< 服务商服务电话 */
@property (nonatomic, copy) NSString *service_desc; /*!< 服务商介绍 */
@property (nonatomic, copy) NSNumber *service_team_experience_count;    /*!< 成功案例数 */
@property (nonatomic, copy) NSNumber *history_publish_success_job_count;    /*!< 历史发布成功过的岗位数量 */
@property (nonatomic, copy) NSNumber *arranged_agent_vas_enable;    /*!< 是否正在使用包代招  1：是 0：否 */

@property (nonatomic, assign) CGFloat cellHeight;
@end



/**
 企业/团队基本信息
 “enterprise_basic_info”:{
 “enterprise_id”:xxxx, // 企业ID
 “enterprise_name”: “xxxxxx”, // 企业名
 “character_id”: “xxxx”, // 机构性质id号
 “character_name”: “xxxx”, // 机构性质
 “industry_id” : xxxx //所属行业id
 “industry_name” : xxxx //所属行业名称
 “map_coordinates” : xxxx //联系地址地图坐标
 “contact”: “xxxx”, // 联系人
 “contact_tel”: “xxxx”, // 电话号码
 
 // 新增联系电话图片地址contact_tel_img_url字段 by chenw @ 2015.6.10
 "contact_tel_img_url" : "联系电话图片地址",
 “address”: “xxxxxx”, // 地址详情
 “desc”: “xxxxxxxx”   // 企业介绍
 “img_url”: “xxxxxx”  //企业图标
 “city_id”: 城市ID
 “city_name”: 城市名称
 “address_area_name”: 区域名称
 “address_area_id” : 区域ID
 “verifiy_status” : 认证状态, 1未认证, 2正在认证、3认证通过
 “job_ing_count” : 招聘中的岗位数
 `evalu_byent_count`; // '雇主评价岗位申请的总数',
 “complaint_bystu_count”: // 雇主被兼客的投诉次数
 “complaint_for_entread_count”: 被投诉 未读数的统计<整形数字>,
 bind_wechat_status : //是否绑定了微信 0：未绑定 1：已绑定
 “stu_complaint_ent_small_red_point”:// 兼客对我的投诉小红点
 
 }
 character_id（机构性质ID）类型：
 NONE(-1,"未知"),ENTERPRIS(1, "企业"), PERSON(2, "个人");
 */
