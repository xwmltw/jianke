//
//  JobModel.h
//  jianke
//
//  Created by xiaomk on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SalaryModel.h"
#import "ContactModel.h"
#import "EPModel.h"
#import "ShareInfoModel.h"
#import "WorkTimePeriodModel.h"
#import "WelfareModel.h"

@interface JobModel : NSObject

//==============自定义部分  勿删==============
@property (nonatomic, assign) NSInteger tadayNum;            /*!< 显示是第几个view */
@property (nonatomic, assign) int todayCount;            /*!< 当前天数是第几个view */
@property (nonatomic, assign) BOOL isSSPAd;                 /*!< 兼客首页 SSPAd 使用 */
//==============自定义部分  勿删==============

@property (nonatomic, copy) NSNumber* job_id;               /*!< 岗位id */
@property (nonatomic, copy) NSString* job_title;            /*!< 岗位名称 */
@property (nonatomic, copy) NSNumber* job_type_id;          /*!< 岗位分类id */
@property (nonatomic, copy) NSString* job_classfie_name;    /*!< 岗位分类名称 */

@property (nonatomic, copy) NSNumber* job_type;             /*!< 岗位类型，1表示普通岗位，2表示抢单岗位，3代发岗位，4.快速发布岗位 如果没传这个字段，默认是1 */
@property (nonatomic, copy) NSArray* job_label;                /*!< 岗位标签，只有抢单抢单岗位有这个字段 */
@property (nonatomic, copy) NSString* working_place;        /*!< 工作地点 */
@property (nonatomic, copy) NSNumber* work_time_start;      /*!< <long> 工作开始时间，1970年1月1日至今的秒数， */
@property (nonatomic, copy) NSNumber* work_time_end;        /*!< <long> 工作结束开始时间，1970年1月1日至今的秒数， */
@property (nonatomic, copy) NSNumber* recruitment_num;      /*!< 招聘人数 */
@property (nonatomic, copy) NSString* job_desc;             /*!< 岗位描述 */
@property (nonatomic, copy) NSNumber* city_id;              /*!< 城市ID, 整形数字  */
@property (nonatomic, copy) NSNumber* address_area_id;      /*!< 区域ID , 整形数字 */
@property (nonatomic, copy) NSString *area_code;            /*!< 城市区号 */
@property (nonatomic, copy) NSString *admin_code;           /*!< 区域行政区号 */
@property (nonatomic, copy) NSString* address_area_name;    /*!< 区域名称 */
@property (nonatomic, copy) NSNumber* update_time;          /*!< 最后更新时间 , Int类型 , 从1970年1月1日0时到更新时的毫秒数 */
@property (nonatomic, copy) NSNumber* view_count;           /*!< 查看次数 */
@property (nonatomic, copy) NSNumber* student_applay_status;        /*!<整形数字类型,学生申请状态,0为未申请, 1或2为已申请 */
@property (nonatomic, copy) NSNumber* enterprise_info_id;           /*!<整形数字类型,企业ID */
@property (nonatomic, copy) NSString* job_comment;                  /*!< 岗位备注 , 字符串类型 */
@property (nonatomic, copy) NSNumber* student_collect_status;       /*!< 登录学生收藏状态 , 整形数字, 1 已收藏, 0 未收藏 */
@property (nonatomic, copy) NSNumber* topic_id;                     /*!< 专题ID */
@property (nonatomic, copy) NSString* share_info;                   /*!< 短信分享的信息，包含URL */

@property (nonatomic, copy) NSString* city_name;                     /*!< 城市名称 */
@property (nonatomic, copy) NSNumber* hot;                          /*!<是否热门 1：热门 0：非热门 */
@property (nonatomic, copy) NSNumber* stick;                        /*!<是否置顶 1：是 0:否 */
@property (nonatomic, copy) NSString* weight;                       /*!<权重 */
@property (nonatomic, copy) NSString* icon_url;                     /*!<专题图标 */
@property (nonatomic, copy) NSNumber* icon_status;                  /*!<专题图标状态：0隐藏 1正常, */
@property (nonatomic, copy) NSString* map_coordinates;              /*!<"岗位地图坐标,横坐标和纵坐标以逗号隔开,如 10.123456,20.123456", */
@property (nonatomic, copy) NSString* refresh_time_desc;            /*!<"刷新时间描述" */
@property (nonatomic, copy) NSNumber* source;                       /*!<来源, 1采集2团队发布3企业发布4管理端添加, */
@property (nonatomic, copy) NSNumber* status;                       /*!< 岗位状态   1待审核, 2已发布 , 3已结束 */
@property (nonatomic, copy) NSNumber* job_close_reason;             /*!<岗位关闭原因的枚举，Integer，1："已关闭",2："已过期",3： "已下架",4,："审核未通过"; */
@property (nonatomic, copy) NSString* job_close_reason_str;         /*!< 岗位关闭原因的说明,String,，"已关闭","已过期","已下架","审核未通过"  4个中其中一个 */
@property (nonatomic, copy) NSNumber* ent_big_red_point;            /*!<岗位列表中企业显示的大红点,  Integer */
@property (nonatomic, copy) NSNumber* has_been_filled;              /*!< 岗位已招满    Integer */
@property (nonatomic, copy) NSNumber* distance;                     /*!< <int> 岗位查询时使用，表示当前岗位距离兼客GPS坐标的距离 */
@property (nonatomic, copy) NSNumber* job_publish_time;             /*!< 客服审核岗位时间 */
@property (nonatomic, copy) NSNumber* enterprise_verified;          /*!< 企业认证状态 */



@property (nonatomic, copy) NSString* dead_time_start_end_str;      //开始结束时间

@property (nonatomic, copy) NSString* job_classfie_img_url;         /*!<岗位分类图片 */
@property (nonatomic, strong) SalaryModel* salary;                  /*!< 薪水 */
@property (nonatomic, strong) EPModel* enterprise_info;            /*!< 企业详情,参照企业详情数据结构 */
@property (nonatomic, strong) ShareInfoModel* share_info_not_sms;   /*!<分享信息 */
@property (nonatomic, strong) ContactModel* contact;                /*!<联系人 */
//@property (nonatomic, copy) NSString* job_desc_br;                /*!< 岗位描述带<br/>  */
@property (nonatomic, copy) NSMutableArray* apply_job_resumes;             //报名人数列表
@property (nonatomic, copy) NSNumber *create_time; /*!< 雇主创建岗位的时间 */
@property (nonatomic, copy) NSString *revoke_reason; /*!< 岗位拒绝/下架原因 */
@property (nonatomic, copy) NSNumber *job_employ_big_red_point; /*!< 雇主-已完成页面卡片小红点 */
@property (nonatomic, copy) NSNumber *all_hired_resume_count;    /*!< 录用人数 */

// v2.2.0
@property (nonatomic, copy) NSNumber *working_time_start_date; /*!< <long>工作时间的开始日期，1970年1月1日至今的毫秒数 */
@property (nonatomic, copy) NSNumber *working_time_end_date; /*!< <long>工作结束的日期，1970年1月1日至今的毫秒数 */
@property (nonatomic, strong) WorkTimePeriodModel *working_time_period; /*!< 工作时间段 */
@property (nonatomic, copy) NSString *work_start_end_hours_str;/*!< 兼职时段信息*/

// v2.3.0
// 以下是岗位投递限制
@property (nonatomic, copy) NSNumber *sex; /*!< 性别限制 空：不限制 1：限制男 0：限制女 */
@property (nonatomic, copy) NSNumber *age; /*!< 年龄限制 空：不限制 1：18周岁以上 2：18-25周岁 3：25周岁以上 */
@property (nonatomic, copy) NSNumber *height; /*!< 身高限制 空：不限 1：160cm以上 2：165cm以上 3：168cm以上 4：170cm以上 5：175cm以上 6：180cm以上 */
@property (nonatomic, copy) NSNumber *rel_name_verify; /*!< 身份证限制 空：不限 1：限制 */
@property (nonatomic, copy) NSNumber *life_photo; /*!< 生活照限制 空：不限 1：限制 */
@property (nonatomic, copy) NSNumber *apply_job_date; /*!< 上岗时间限制 空：不限 2：2天以上 3：3天以上 5：5天以上 0：全部到岗 */
@property (nonatomic, copy) NSNumber *health_cer; /*!< 健康证限制 空：不限 1：限制 */
@property (nonatomic, copy) NSNumber *stu_id_card; /*!< 学生证限制 空：不限 1：限制 */

//检测字段枚举值 0:不通过 1:通过 2:信息不全
@property (nonatomic, strong) NSNumber *check_sex; /*!< 检测性别限制 */
@property (nonatomic, strong) NSNumber *check_age; /*!< 检测年龄限制 */
@property (nonatomic, strong) NSNumber *check_height; /*!< 检测身高限制 */
@property (nonatomic, strong) NSNumber *check_rel_name_verify; /*!< 检测身份证限制 */
@property (nonatomic, strong) NSNumber *check_life_photo; /*!< 检测生活照限制 */
@property (nonatomic, strong) NSNumber *check_health_cer; /*!< 检测健康证限制 */
@property (nonatomic, strong) NSNumber *check_stu_id_card; /*!< 检测学生证限制 */
@property (nonatomic, strong) NSNumber *is_accurate_job; /*!< 是否为精确岗位  1：是 0:否(即松散岗位) */

// 以下是雇主首页需要显示的内容
@property (nonatomic, copy) NSNumber* job_recruitment_process_num;  //<int>招聘进度百分比，用整数表示百分比，例如95表示95%
@property (nonatomic, copy) NSArray* expect_on_board_stu_counts;    // 数组，一共有五个，按照时间当天，前天、今天、明天，后天进行排序                   ]

@property (nonatomic, strong) NSNumber *enable_recruitment_service; /*!< <int>是否委托招聘(包招) 0否 1是，默认0 */
@property (nonatomic, strong) NSArray *job_tags;                    /*!< 岗位福利 */
@property (nonatomic, strong) NSArray *apply_limit_arr;             /*!< 岗位限制 */

// v2.6
@property (nonatomic, strong) NSNumber *apply_dead_time;            /*!< 报名截止时间, 1970.1.1至今毫秒数 */
//2.8
@property (nonatomic, strong) NSNumber *ent_publish_price;          /*!< 雇主发布价  以分为单位 */
@property (nonatomic, strong) NSNumber *click_confirm_work_status;  /*!< 点击上岗确认状态 1：已点击 0：未点击 */
@property (nonatomic, copy) NSString *soft_content;                 /*!< 软文广告内容 */
@property (nonatomic, strong) NSArray *job_type_label;              /*!< 包招岗位， 限制 标签数组 */

@property (nonatomic, copy) NSNumber *undeal_apply_num;             /*!< 未处理简历数量 */

@property (nonatomic, copy) NSNumber *is_social_activist_job;       /*!< 是否为人脉王岗位 1：是  0：否 */
@property (nonatomic, copy) NSNumber *social_activist_reward;       /*!< 佣金金额 */
@property (nonatomic, copy) NSString *social_activist_reward_unit;  /*!< 佣金单位 1：元/人 2：元/人/天 */

@property (nonatomic, copy) NSNumber *trade_loop_status;            /*!< 交易闭环状态  1已报名  2录用成功 3投递结束 */
@property (nonatomic, copy) NSNumber *trade_loop_finish_type;       /*!< 交易闭环关闭原因  1取消报名 2雇主拒绝 3雇主确认完成 4兼客未到岗 5雇主24小时未处理 6岗位关闭*/

// v3.0.7 采集岗位相关
@property (nonatomic, copy) NSNumber *contact_apply_num;    /*!< 采集岗位联系投递数(电话咨询数) */
@property (nonatomic, copy) NSNumber *student_contact_status;   /*!< 兼客联系岗位的情况 1已联系 0未联系 */
@property (nonatomic, copy) NSArray *apply_job_contact_resumes; /*!< 已电话联系的兼客列表 */
@property (nonatomic, copy) NSNumber *contact_apply_job_resumes_count;  /*!< 已电话联系的兼客列表数量 */
@property (nonatomic, copy) NSNumber *deliver_count;    /*!< 报名人数 */

// v3.1.7
@property (nonatomic, copy) NSNumber *is_vip_job;   /*!< 是否是vip岗位 1：是 0:否 */
@property (nonatomic, copy) NSNumber *through; /*!< 是否是直通车岗位 1：是 0:否 */
@property (nonatomic, copy) NSNumber *guarantee_amount_status;  /*!< 保证金状态：0 未缴纳 1已缴纳 2 被冻结 3 退回中 4 已退回 */

//  v3.2.0
@property (nonatomic, copy) NSNumber *apply_job_id; /*!< 兼客岗位投递ID */
@property (nonatomic, copy) NSString *job_uuid; /*!< job_uuid */

//  v3.2.1
@property (nonatomic, copy) NSNumber *is_fit_job_limit; /*!< 是否符合岗位限制 */
@property (nonatomic, copy) NSString *fit_job_limit_desc;   /*!< 是否符合岗位限制描述 */

// V3.2.3
@property (nonatomic, copy) NSString *wechat_public;    /*!< 微信公众号 */
@property (nonatomic, copy) NSString *wechat_number;    /*!< 微信号 */
//v3.2.5.2
@property (nonatomic, assign) BOOL is_show_red_packets; /*!<是否显示红包 1：是 0：否*/
//v330.2
@property (nonatomic, copy) NSNumber *today_is_can_apply; /*!<岗位今日是否可以申请 1：是 0：否*/
// v2.4
@property (nonatomic, assign, getter=isReaded) BOOL readed; /*!< 是否已读, 本地字段 */
- (void)checkReadStateWithReadedJobIdArray:(NSArray *)jobIdArray; /*!< 判断是否已读,并设置相应字段readed */
@end


@interface ExpectOnBoardStuCountModel : NSObject
@property (nonatomic, copy) NSNumber* on_board_date;  //<long>对应日期的毫秒数
@property (nonatomic, copy) NSNumber* expect_on_board_num;  //<int>预计的上岗人数
@end


//job_type_spelling = zhongdiangong,
//working_time = 2097151,
//refresh_time_str = 2015-09-27,
//hired_resume_count = 0,
//job_uuid = 4a027242-e590-4833-8aa4-05514b97df0e,
//deliver_count = 0,
//job_city_domain = fuzhou.jiankedevelop.com





