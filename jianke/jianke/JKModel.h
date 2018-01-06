//
//  JKModel.h
//  jianke
//
//  Created by fire on 15/9/15.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  兼客简历模型

#import <Foundation/Foundation.h>
#import "ContactModel.h"
#import "MJExtension.h"

@class ResumeExperience;
@interface JKModel : NSObject

@property (nonatomic, copy) NSString* name_first_letter;    /*!< 拼音首字母 */
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSNumber* resume_id;            /*!< 简历id */
@property (nonatomic, copy) NSString* true_name;            /*!< 姓名 */
@property (nonatomic, copy) NSString* input_name;            /*!< 输入姓名 */
@property (nonatomic, copy) NSString* telphone;             //用户手机号
@property (nonatomic, copy) NSNumber* weight;               //体重kg
@property (nonatomic, copy) NSString* profile_url;          //头像
@property (nonatomic, copy) NSString* lat;                  //纬度
@property (nonatomic, copy) NSString* lng;                  //经度
@property (nonatomic, copy) NSString* obode;                //常居住地址
@property (nonatomic, copy) NSNumber* id_card_verify_status;    /*!< 实名认证状态: 1：未认证，2：认证中，3：已认证 */
@property (nonatomic, copy) NSNumber* height;               /*!< 身高 */
@property (nonatomic, copy) NSNumber* sex;                  /*!< 0女 1男 */
@property (nonatomic, copy) NSNumber* address_area_id;      /*!< 所在区域的id */
@property (nonatomic, copy) NSString* id_card_no;           //身份证号
@property (nonatomic, copy) NSNumber* account_id;           //账号ID
@property (nonatomic, copy) NSNumber* school_id;            /*!< 学校id */
@property (nonatomic, copy) NSString* school_name;          /*!< 学校名称 */
@property (nonatomic, copy) NSNumber* view_count;           /*!< 浏览次数 */
@property (nonatomic, copy) NSString* address_area_name;    /*!< 区域名称 */
@property (nonatomic, copy) NSNumber* city_id;              /*!< 城市ID */
@property (nonatomic, copy) NSString* city_name;            /*!< 城市名称 */
@property (nonatomic, copy) NSNumber* work_experice_count;  /*!< 工作经验数值 */
@property (nonatomic, copy) NSNumber* working_experience_small_red_point;   /*!< 工作经验小红点, 0不显示, 1显示 */
@property (nonatomic, copy) NSNumber* my_apply_job_big_red_point;       /*!< 我的报名红点数 */
@property (nonatomic, copy) NSNumber* break_promise_count;              /*!< 放鸽子数 */
@property (nonatomic, copy) NSNumber* break_promise_small_red_point;    /*!< 放鸽子的红点, 0不显示, 1显示 */
@property (nonatomic, copy) NSNumber* left_apply_job_quota;             /*!< 是否有剩余投递岗位的次数 */
@property (nonatomic, copy) NSNumber* salary_num;           /*!< <int> // 需要支付的工资，shijianke_entQueryApplyJobList这个接口调用，并且list_type为5时，才下发这个字段 */
@property (nonatomic, assign) NSInteger evalu_byent_count;              /*!< 被雇主评价数统计 */
@property (nonatomic, assign) NSInteger evalu_byent_level_avg;          /*!< 评价星级平均值 */
@property (nonatomic, assign) BOOL ent_evalu_status;                    /*!< 雇主评价状态, 1:已评价   0:未评价 */
@property (nonatomic, copy) NSNumber* bind_wechat_status;               /*!< 是否绑定了微信 0：未绑定 1：已绑定 */
@property (nonatomic, copy) NSNumber* bind_wechat_public_num_status;    /*!< new 2.7 是否绑定了微信 0：未绑定 1：已绑定  */

@property (nonatomic, assign) BOOL account_im_open_status;              /*!< 账户IM开通状态, 0 未开通 , 1 已开通 */

@property (nonatomic, copy) NSNumber* apply_job_id;                     /*!< 申请岗位id */
@property (nonatomic, copy) NSNumber* trade_loop_finish_type;           /*!< 交易闭环结束原因 1取消报名 2雇主拒绝 3雇主确认完成 4兼客未到岗 5雇主24小时未处理 6岗位关闭  */
@property (nonatomic, copy) NSString* ent_default_refused_time;         /*!< 企业默认拒绝时间 */
@property (nonatomic, copy) NSString* ent_default_refused_time_left;    /*!< 企业默认拒绝时间的毫秒数 */
@property (nonatomic, copy) NSNumber* ent_big_red_point_status;         /*!< 雇主是否显示大红点 */
@property (nonatomic, copy) NSNumber* ent_read_resume_time;             /*!< 企业阅读简历时间, 也用于判断企业是否查看了简历 */
@property (nonatomic, copy) NSNumber* trade_loop_status;                /*!< 交易闭环状态 1已报名  2录用成功 3投递结束*/

@property (nonatomic, copy) NSNumber* task_salary_sum;                  /*!<  兼客累计获得的任务薪资总额(财富值)，单位为分 */
@property (nonatomic, copy) NSNumber *task_applying_count;  /*!< 兼客申请中的任务数量
 */
@property (nonatomic, copy) NSString* task_submit_success_rate;         /*!< 兼客提交任务的通过率 */

@property (nonatomic, copy) NSNumber *is_apply_service_personal;

//@property (nonatomic, copy) NSString *nick_name; /*!<  昵称 */
//@property (nonatomic, copy) NSNumber *birthday; /*!< 出生日期 */
@property (nonatomic, copy) NSNumber *user_type; /*!< 用户类型, 1学生 0社会人员 */
@property (nonatomic, copy) NSString *desc; /*!< 简历描述(自我评价) */
//@property (nonatomic, copy) NSNumber* trade_loop_ent_evalu_level; /*!< 交易闭环当前记录的雇主评价星级 */
//@property (nonatomic, copy) NSString* trade_loop_ent_evalu_content; /*!< 交易闭环当前记录的雇主评价内容 */



@property (nonatomic, strong) ContactModel *contact;                /*!< 联系方式 */
@property (nonatomic, copy) NSString *user_profile_url;             /*!< 简历头像地址 */
//@property (nonatomic, copy) NSNumber *verify_status; /*!< 认证结果 1未认证 2正在认证 3认证通过 4被驳回 */
//@property (nonatomic, copy) NSNumber *student_collect_state;//学生收藏状态
//@property (nonatomic, copy) NSString *enterprise_collect_comment;//企业对简历的备注内容
//@property (nonatomic, copy) NSNumber *enterprise_collect_status;// 整形数字 , 登录企业对简历收藏状态, 1已收藏,0未收藏

@property (nonatomic, strong) NSArray *stu_work_time;               /*!< 上岗时间时间戳数组（秒数） */
@property (nonatomic, copy) NSNumber *stu_work_time_type;         /*!< 1：兼客选择    2：默认 */
@property (nonatomic, copy) NSNumber *stu_absent_type;            /*!< 兼客未到岗位原因 1双方沟通一致 2 放鸽子 */


@property (nonatomic, copy) NSNumber* ent_evalu_level;              /*!< 交易闭环当前记录的雇主评价星级 */
@property (nonatomic, copy) NSString* ent_evalu_content;            /*!< 交易闭环当前记录的雇主评价内容 */
@property (nonatomic, assign) BOOL is_can_evaluate;                 /*!< 是否可以修改评级 */
@property (nonatomic, copy) NSNumber *stu_apply_resume_time;      /*!< 兼客报名时间 */
@property (nonatomic, assign) BOOL is_first_grab_single;            /*!< 是否第一次抢单 */
@property (nonatomic, copy) NSNumber *acct_amount;                /*!< 账户余额 */
@property (nonatomic, copy) NSNumber *bond; /*!< 保证金 */

@property (nonatomic, copy) NSString *stu_apply_resume_time_str;    /*!< 报名时间 */
@property (nonatomic, copy) NSNumber *ent_pay_salary_num;         /*!< 企业支付工资次数 */
@property (nonatomic, assign) BOOL is_tick_off;                     /*!< 是否默认勾选(需要发工资的兼客列表使用) */

//Ver.2.31
@property (nonatomic, copy) NSString *birthday;                 //出生日期
@property (nonatomic, copy)NSNumber *social_activist_status;    //人脉王状态，请参考数据字典
@property (nonatomic, copy) NSString *stu_id_card_no;           //学生证号
@property (nonatomic, copy) NSString *stu_id_card_url;          //学生证链接
@property (nonatomic, copy) NSString *health_cer_no;            //健康证号
@property (nonatomic, copy) NSString *health_cer_url;           //健康证链接
@property (nonatomic, copy) NSMutableArray *life_photo;         //生活照列表

 // 兼客管理页面按天查询上岗兼客列表页面，每个兼客当天对应的打卡信息  punck_the_clock_time为打卡时间， punck_the_clock_status为打卡状态  1：表示已打卡 0：表示没打卡 只有有打卡的时候打卡时间才有值
@property (nonatomic, copy) NSArray* stu_punck_clock_info; //

@property (nonatomic, copy) NSNumber* on_board_status;          /*!< 精确岗位日到岗状态 0：未到岗  1：到岗  2：未处理 */
@property (nonatomic, copy) NSNumber* day_stu_absent_type;      /*!< 精确岗位日未到岗原因  1：沟通一致 2：放鸽子 */


// v2.6
@property (nonatomic, copy) NSNumber *social_activist_complete_day_count;     /*!<  通过人脉王报名的完工人数 */

@property (nonatomic, copy) NSNumber *stu_confirm_work_time;                  /*!< 点击确认上岗按钮时间  上岗详情里用 */
//@property (nonatomic, copy) NSString* pinyinFirstLetter;

@property (nonatomic, copy) NSNumber *apply_job_type;   /*!<(1, "兼客申请"),(2, "WEB代发工资"),(3, "雇主手动补录"),(4, "链接补录"); */
@property (nonatomic, copy) NSNumber *apply_job_source;          /*!< 投递来源，1平台报名，2人员补录 3人员推广 */
@property (nonatomic, copy) NSNumber *is_subscribe_job; /*!<  是否订阅意向岗位  1：是  0：否 */

@property (nonatomic, copy) NSString *complete; /*!< 简历完整度 */

// v3.2.4
@property (nonatomic, copy) NSNumber *complete_work_num;    /*!< 完工数 */
@property (nonatomic, copy) NSNumber *is_public;    /*!< 简历是否公开：1是 0否 */
@property (nonatomic, copy) NSNumber *education;    /*!< 学历类型：0高中1大专2本科3硕士4博士5其他 */
@property (nonatomic, copy) NSString *profession;   /*!< 专业 */
@property (nonatomic, copy) NSString *specialty;    /*!< 特长 */
@property (nonatomic, copy) NSString *last_login_time_str;  /*!< 最近登录时间描述 */
@property (nonatomic, copy) NSString *subscribe_job_classify_str;   /*!< 意向岗位分类描述 */
@property (nonatomic, copy) NSString *subscribe_address_area_str;   /*!< 意向区域描述 */
@property (nonatomic, copy) NSNumber *ent_contact_status;   /*!< 企业联系兼客状态 1已联系 0未联系 */
@property (nonatomic, copy) NSArray *resume_experience_list;    /*!< 工作经历列表 */
@property (nonatomic, copy) NSNumber *age;  /*!< 年龄 */
// v3.2.6
@property (nonatomic, copy) NSNumber *resume_view_num;/*!<被预览次数*/
- (NSString *)getEducationStr;
- (NSString *)getAgeStr;
//- (void)getNameFirstPinyin;
#pragma mark - ***** 自定义添加 ******
@property (nonatomic, copy) NSNumber *stu_account_id;   /*!< 兼客账号ID */
@property (nonatomic, assign) BOOL isSelect;            /*!< 是否选中  */
@property (nonatomic, assign) CGFloat cellHeight;       /*!< sell height */
@property (nonatomic, assign) BOOL isFromPayAdd;        /*!< 是否来至 发放工资 的添加 */

#pragma mark - ***** 网络请求返回 *****
@property (nonatomic, copy) NSNumber *contact_time ;        /*!< 联系时间：时间的毫秒数 */
@property (nonatomic, copy) NSNumber *stu_telephone;        /*!< 兼客联系电话 */

@end

@interface StuPunckClockInfoModel : NSObject
@property (nonatomic, copy) NSNumber* punch_the_clock_status;   /*!< 1:表示已打卡 0：表示没打卡 */
@property (nonatomic, copy) NSNumber* punch_the_clock_time;     /*!< 打卡时间 */
@end

@interface ResumeExperience : NSObject
@property (nonatomic, copy) NSNumber *resume_experience_id; /*!< 工作经历id */
@property (nonatomic, copy) NSNumber *job_classify_id;  /*!< 岗位分类id */
@property (nonatomic, copy) NSString *job_classify_name;    /*!< 岗位分类名称 */
@property (nonatomic, copy) NSString *job_title;    /*!< 岗位名称 */
@property (nonatomic, copy) NSNumber *job_begin_time;   /*!< 岗位开始时间，时间戳 */
@property (nonatomic, copy) NSNumber *job_end_time; /*!< 岗位结束时间，时间戳 */
@property (nonatomic, copy) NSString *job_content;  /*!< 工作内容 */

@property (nonatomic, assign) CGFloat cellHeight;

@end

/**
 “resume_info”:{
 “resume_id”: xxxx, // 简历id
 “apply_job_id”:// 申请岗位id
 “nick_name”: “xxxx”,  // 昵称
	“true_name”: “xxxx”, // 姓名
	“birthday”: “yyyy-MM-dd”,  // 出生日期
	“height”: “xxx”, // 身高
	“sex”: xx, // 枚举，具体定义请参考数据字典
	“address_area_id”, xx, // 所在区域的id
	
	“user_type”: xx, // 学生类型，枚举，具体定义请参考数据字典
	“school_id”: xxxx, // 学校id
 “grade”: “xxx”, // 年级
	“desc”: “xxxx”, // 简历描述
	“contact”:{  // 联系方式
 “phone_num”: “xxxx”, // 手机号码
 “is_show_telphone”:  xxxx, // Boolean 类型，true表示公开，false表示不公开
 },
 “user_profile_url”: “xxxxx”, // 简历头像地址
 “verify_status” : xxx , // 认证结果,参考数据字典 , 学生简历认证结果
 “city_id”: xxx , // 城市ID, 整形数字类型.
 “view_count”: xxx , // 浏览次数 , 整形数字类型
 “address_area_name” : 区域名称
 “city_name” :  // 城市名称
 “school_name” : 学校名称
 “student_collect_state” : 学生收藏状态
 “enterprise_collect_comment”:企业对简历的备注内容
 “enterprise_collect_status”: // 整形数字 , 登录企业对简历收藏状态, 1已收藏,0未收藏,
 “work_experice_count” : 履历统计值,<整形数字>即工作过的所有岗位数.
 “working_experience_small_red_point”: // 工作经验红点
 
	“evalu_byent_count “; // 被雇主评价数统计“byent_level_sum” ; // 评价星级总和
	“evalu_byent_level_avg” ; // 评价星级平均值
 “trade_loop_finish_type”: // 交易闭环结束原因
 “my_apply_job_big_red_point”: //我的报名红点数
 “break_promise_count”; // 放鸽子数
 “break_promise_small_red_point”: // 放鸽子的红点
 “ent_default_refused_time”: 企业默认拒绝时间
 “ent_default_refused_time_left”: 企业默认拒绝时间的毫秒数
 “trade_loop_ent_evalu_level”: // 交易闭环当前记录的雇主评价星级
 “trade_loop_ent_evalu_content”: // 交易闭环当前记录的雇主评价内容
 " ent_big_red_point_status ":雇主是否显示大红点
 
 “ent_read_resume_time”:// 企业阅读简历时间
 
 “trade_loop_status”：// 交易闭环状态
 
 
 // 以下 2015-04-10 添加的属性
 
 account_im_open_status : 账户IM开通状态, 0 未开通 , 1 已开通 .
 
 // 2015-05-29 添加属性
 bind_wechat_status : //是否绑定了微信 0：未绑定 1：已绑定
 “left_apply_job_quota”: // 是否有剩余投递岗位的次数
 
 “ent_evalu_status”://企业评价状态   1:已评价   0:未评价,
 “salary_num”: <int> // 需要支付的工资，shijianke_entQueryApplyJobList这个接口调用，并且list_type为5时，才下发这个字段
 
 
 人脉王状态  social_activist_status
        0未申请
        1申请中
        2申请通过
        3被驳回
        4被撤销
 人脉类型  social_activist_type
        1校内
        2校外
        3校内+校外
 
 }
 
 */
