//
//  PayDetailModel.h
//  
//
//  Created by xiaomk on 15/10/10.
//
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface PayDetailModel : NSObject

@property (nonatomic, copy) NSString *item_id;              /*!< 流水id */
@property (nonatomic, copy) NSNumber *account_id;           /*!< 账户id */
@property (nonatomic, copy) NSString *user_profile_url;     /*!< 头像 */
@property (nonatomic, copy) NSNumber *sex;                  /*!< 性别 */
@property (nonatomic, copy) NSString *true_name;            /*!< 用户名 */
@property (nonatomic, copy) NSNumber *actual_amount;        /*!< 雇主给兼客的工资精确到分 */

@property (nonatomic, copy) NSNumber *create_time;          /*!< 流水创建的毫秒数 */
@property (nonatomic, copy) NSString *telphone;             /*!< 电话 */
@property (nonatomic, copy) NSNumber *payroll_check_status; /*!< 工资校验状态 1：未校验 2：已校验 */
@property (nonatomic, copy) NSString *payroll_check_name;   /*!< 工资校验姓名 */
@property (nonatomic, copy) NSString *payroll_check_sms;    /*!< 工资校验重发短信内容 */

@property (nonatomic, copy) NSNumber *time_detail_user_count;   /*!< 当前毫秒数下的人数 */
@property (nonatomic, copy) NSNumber *time_sum_actual_amount;   /*!< 当前毫秒数下的总金额 */
@property (nonatomic, copy) NSNumber *trade_loop_finish_type;   /*!< 交易闭环结束原因 */
@property (nonatomic, copy) NSNumber *stu_absent_type;          /*!< 兼客未到岗原因 */
@property (nonatomic, copy) NSString *item_title;               /*!< 流水标题 */
@property (nonatomic, copy) NSNumber *apply_job_source;         /*!< 报名来源 */


@end





/*
 请求Service    shijianke_queryAcctDetailItem_v2
 
 请求content
 “content”:{
    “query_param”: {
 // 查询条件，请参考全局数据结构
 }
    “job_id” : //岗位id
    “query_create_time”: <long>流水创建的毫秒数
 }
 应答content
    “content”:{
    “query_param”: {
        // 查询条件，请参考全局数据结构
    }
 “stu_list”: [
        “item_id”:// 流水id
        “sex”:// 性别
        “account_id”: <long>账户id
        “user_profile_url”: <string>简历头像
        “true_name”: <string>用户名
        “actual_amount”: <int>雇主给兼客发的工资，精确到分
        “create_time”: <long>流水创建的毫秒数
        “telphone”:// 账号手机号
        “payroll_check_status”: xxx //工资校验状态 1：未校验 2：已校验
 ],
 “dynmac_query_condition”:[
 {
 “create_time”: <long>流水创建的毫秒数,
 “time_detail_user_count”: <int>当前毫秒数下的人数
 “time_sum_actual_amount”： <int>当前毫秒数下的总金额
 
 }
 ]
 }

 */
