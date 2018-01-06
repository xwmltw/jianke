//
//  JobBillModel.h
//  jianke
//
//  Created by 时现 on 15/12/9.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface PayListModel : NSObject

@property (nonatomic, strong) NSNumber *stu_account_id;// 兼客账号id
@property (nonatomic, strong) NSNumber *salary;//薪资 分
@property (nonatomic, copy)   NSString *true_name;//姓名
@property (nonatomic, strong) NSNumber *sex;//性别枚举
@property (nonatomic, copy)   NSString *profile_url;//头像
@property (nonatomic, strong) NSNumber *id_card_verify_status;//实名认证状态: 1：未认证，2：认证中，3：已认证
@property (nonatomic, strong) NSArray  *work_date;//工作日期毫秒数
@property (nonatomic, strong) NSNumber *stu_work_time_type;  //1 兼客选择  2 默认
@property (nonatomic, strong) NSNumber *ent_publish_price; /*!< 雇主支付价 */
@property (nonatomic, strong) NSNumber *real_work_day;  /*!< 实际工作天数 */
@property (nonatomic, strong) NSNumber *apply_job_id;   /*!< 报名申请的岗位 */
@property (nonatomic, strong) NSString *work_date_str;  /*!< 报名的日期 */
@property (nonatomic, assign) BOOL isLeader; /*!< 是否是领队 */

@end

@interface JobBillModel : NSObject

@property (nonatomic, strong) NSNumber *job_id;     /*!< <long> 岗位id */
@property (nonatomic, strong) NSNumber *job_bill_id;/*!< <long>岗位账单id */
@property (nonatomic, strong) NSNumber *bill_status;/*!< <int>岗位账单状态： 1未发送 2已发送 3已支付 */
@property (nonatomic, strong) NSNumber *bill_type;  /*!< <int>岗位账单类型：1精确岗位按天的账单 0松散岗位的完整账单 */
@property (nonatomic, strong) NSNumber *bill_start_date;/*!< <long>账单的开始日期 */
@property (nonatomic, strong) NSNumber *bill_end_date;/*!< <long>账单的结束日期 */
@property (nonatomic, strong) NSNumber *total_amount;/*!< <int>账单总额，单位为分 */
@property (nonatomic, strong) NSNumber *service_fee;/*!< <int>服务费，单位为分 */
@property (nonatomic, strong) NSNumber *salary_amount;/*!< <int>工资总额，单位为分 */
@property (nonatomic, strong) NSNumber *pay_stu_count;/*!< <int>需要发工资的总人数 */

@property (nonatomic, strong) NSNumber *leader_amount;//<int>领队工资总额，单位为分
@property (nonatomic, copy) NSString *job_title;
@property (nonatomic, strong) NSNumber* pay_bill_time;/*!< <long>支付账单时间 */
@property (nonatomic, strong) NSNumber* is_apply_mat;   /*!< '是否申请垫资 0未申请 1已申请' */
@property (nonatomic, copy) NSString* expect_repayment_time; /*!< 预计还款时间 */
@property (nonatomic, strong) NSNumber* mat_apply_status;   /*!< 垫资申请状态:1待雇主确认 2审核中 3已驳回 4已垫资 5已还款' */

@property (nonatomic, strong) NSNumber *ent_publish_price;  /*!< 雇主发布价 */
@property (nonatomic, strong) NSNumber *salary_type;    /*!<  <int> 薪资单位类型. 1:天，2:小时, 3:月, 4:次. */

@property (nonatomic, copy) NSString *job_bill_title;   /*!< 账单日期 */

@property (nonatomic, strong) NSArray *stu_pay_list;/*!< <string>json格式要发工资的列表 */
@property (nonatomic, strong) NSArray *leader_pay_list;//<string>json格式要发工资的列表

@end






/*
“job_id”: <long> 岗位id
“job_bill_id”:<long>岗位账单id
“bill_status”:<int>岗位账单状态： 1未发送 2已发送 3已支付
“bill_type”:<int>岗位账单类型：1精确岗位按天的账单 0松散岗位的完整账单
“bill_start_date”:<long>账单的开始日期
“bill_end_date”:<long>账单的结束日期
“total_amount”:<int>账单总额，单位为分
“service_fee”:<int>服务费，单位为分
“salary_amount”:<int>工资总额，单位为分
“pay_stu_count”:<int>需要发工资的总人数
“ent_publish_price”: <int> 雇主岗位发布价, 单位为分
“salary_type”:
“stu_pay_list”:<string>json格式要发工资的列表

[{ “stu_account_id”: xxx, // 兼客账号id
    “salary”: xxx,//薪资 分
    “ent_publish_price”:xxx, // 雇主支付价
    “true_name”:xxx,//姓名
    “sex”:xxx,//性别枚举
    “profile_url”:xxx,//头像
    “id_card_verify_status”:”xxx”//实名认证状态: 1：未认证，2：认证中，3：已认证},
    “work_date”:[xxx,xxx]//工作日期毫秒数
    “stu_work_time_type”:// 1：兼客选择    2：默认
    ]
    
    
    “leader_amount”:<int>领队工资总额，单位为分
    “leader_pay_list”:<string>json格式要发工资的列表
    [同stu_pay_list]
    “job_title”:xxx , //岗位名称
    “pay_bill_time”:<long>支付账单时间
    “is_apply_mat”: // '是否申请垫资 0未申请 1已申请',
    “expect_repayment_time”, // '预计还款时间
    “mat_apply_status”, // 垫资申请状态:1待雇主确认 2审核中 3已驳回 4已垫资 5已还款'
 

*/