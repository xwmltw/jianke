//
//  JobDetailModel.h
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  岗位详情模型

#import <Foundation/Foundation.h>
#import "JobModel.h"
#import "ApplyJobResumeModel.h"

@interface JobDetailModel : NSObject

@property (nonatomic, strong) JobModel *parttime_job;               /*!< 兼职岗位模型 */
@property (nonatomic, copy) NSString *im_open_status;             /*!< im开通情况，0未开通,1已开通 */
@property (nonatomic, copy) NSString *account_id;                 /*!< 账号Id */
@property (nonatomic, copy) NSArray *apply_job_resumes;           /*!< 存放ApplyJobResumeModel模型 报名的兼客列表（根据最后处理时间排序前10个) */
@property (nonatomic, copy) NSNumber *apply_job_resumes_count;    /*!< 岗位报名兼客人数 */
@property (nonatomic, copy) NSNumber *is_complainted;             /*!< 是否被举报 */
@property (nonatomic, copy) NSArray *job_question_answer;           /*!< 雇主答疑 JobQAInfoModel 列表 最多3个*/

@property (nonatomic, copy) NSNumber *contact_apply_job_resumes_count;  /*!< 已电话联系的兼客列表数量 */
@property (nonatomic, copy) NSArray *contact_apply_job_resumes;    /*!< 已电话联系的兼客列表 */

@end



/**
 请求Service	shijianke_getJobDetail
 请求content	“content”:{
 “job_id”: xxxx, // 岗位id
 “job_uuid”: xxxxx //岗位uuid
 }
 应答content	“content”:{
 “parttime_job”{
 // 兼职岗位信息，请参考全局数据结构中的兼职岗位定义
 }
 “im_open_status” : int, // im开通情况，0未开通,1已开通 add by chenw @ 2015.4.7
 “account_id” : long, // 账户ID add by chenw @ 2015.4.7
 “apply_job_resumes”: [   // 报名的兼客列表（根据最后处理时间排序前10个）
 {
 “apply_job_id”: // 申请岗位id
 “user_profile_url”: // 用户头像,
 “verify_status”: // 兼客认证状态
 ‘resume_id’:// 简历id
 “account_id”://账号id
 “true_name”:// 用户名称
 }
 ]
 “apply_job_resumes_count”：// 岗位报名兼客人数
 }
 处理细节
 */
