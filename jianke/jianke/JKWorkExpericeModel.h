//
//  JKWorkExpericeModel.h
//  jianke
//
//  Created by fire on 15/10/5.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  兼客工作经历模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface JKWorkExpericeModel : NSObject

@property (nonatomic, copy) NSNumber *ent_evalu_level;      /*!< 雇主对兼客的评价等级<整形数字>,从1到5的数字 */
@property (nonatomic, copy) NSNumber *resume_id;            /*!< 简历ID */
@property (nonatomic, copy) NSNumber *stu_work_time_type;   /*!< 1：兼客选择    2：默认 */
@property (nonatomic, copy) NSNumber *work_start_time;      /*!< 工作开始时间,<整形数字>,从1970年1月1日开始的毫秒数 */
@property (nonatomic, copy) NSNumber *work_end_time;        /*!< 工作结束时间<整形数字>,从1970年1月1日开始的毫秒数 */
@property (nonatomic, copy) NSString *ent_evalu_content;    /*!< 履历的评价内容 */
@property (nonatomic, copy) NSNumber *ent_evalu_time;       /*!< 履历的评价时间 */
@property (nonatomic, copy) NSString *job_title;            /*!< 岗位名称,<字符串> */
@property (nonatomic, copy) NSNumber *stu_work_history_type; /*!< 兼客工作经历类型   1：正常完工   2：放鸽子 */
@property (nonatomic, copy) NSString *ent_name;             /*!< 雇主名称<字符串> */
@property (nonatomic, copy) NSArray *stu_work_time;         /*!< 兼客选择时间 */
@property (nonatomic, copy) NSString *work_time;            /*!< 工作时间（已拼接好，页面直接使用） */
@property (nonatomic, copy) NSArray *stu_work_time_arr;     /*!< 工作时间数组 */
@property (nonatomic, copy) NSString *working_place;        /*!< 工作地址 */
@property (nonatomic, copy) NSNumber *job_type;             /*!< 岗位类型   1：普通岗位   2：抢单 */
@property (nonatomic, copy) NSString *create_time;          /*!< 创建时间 */

@end


/**
 *  请求Service	shijianke_stuQueryWorkExperice_v2
 请求content	“content”: {
 “query_param”:{
 // 查询参数，请参考全局数据结构
 }
 }
 应答content	“content”:{
 “work_history_list”:[ // 工作履历数组,数据内容如下:
 { // 工作履历数据:
 “work_start_time”: 工作开始时间,<整形数字>,从1970年1月1日开始的毫秒数,
 “job_title”:岗位名称,<字符串>,
 “ent_name”:雇主名称<字符串>,
 “ent_evalu_level”:雇主对兼客的评价等级<整形数字>,从1到5的数字
 “ent_evalu_content”:履历的评价内容
 “ent_evalu_time”:履历的评价时间
 “stu_work_history_type”：兼客工作经历类型   1：正常完工   2：放鸽子
 “work_end_time”:工作结束时间<整形数字>,从1970年1月1日开始的毫秒数
 “stu_work_time”：// 兼客选择时间
 “working_place”:// 工作地址
 “job_type”:// 岗位类型   1：普通岗位   2：抢单
 “work_time”:// 工作时间（已拼接好，页面直接使用）
 
 }
 ]
 “query_param”: {
 // 分页参数，请参考全局数据结构
 },
 }
 */