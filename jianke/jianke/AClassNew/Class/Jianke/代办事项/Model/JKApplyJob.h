//
//  JKApplyJob.h
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//  我的报名数据模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/**
 请求Service	shijianke_stuQueryApplyJobList
 请求content	“content”: {
 “query_param”:{
 // 分页查询参数，请参考全局数据结构
 }，
 in_history:    // 是否是历史申请列表    1：是  0：否
 }
 
 应答content
 “content”:{
 “apply_job_list” : [   申请列表 ,
 {
 "apply_job_id":申请ID,
 " trade_loop_status ": 交易闭环状态,
 " trade_loop_status_update_time ":交易闭环状态变更时间,
 " trade_loop_finish_type ": 交易闭环关闭原因
 " stu_absent_type ":兼客未到岗原因
 " job_close_type ":岗位关闭原因,
 " stu_reciv_apply_reason ":取消投递的原因
 " stu_apply_resume_time ":兼客投递简历的时间,
 " ent_read_resume_time ":企业阅读简历的时间
 " trade_loop_finish_time ":交易结束时间,
 " stu_big_red_point_status "：兼客是否显示大红点
 " ent_big_red_point_status ":雇主是否显示大红点
 “ent_evalu_status”:// 交易闭环当前记录雇主评价状态
 “ent_evalu_level”: // 交易闭环当前记录的雇主评价星级
 “ent_evalu_content”: // 交易闭环当前记录的雇主评价内容
 "enterprise_info_id":雇主id,
 “ent_open_im_status”: 雇主是否开通im,
 "job_address_area_id": 岗位所在区域id,
 "job_address_area_name": 岗位所在区域名称,
 "job_id": 岗位id,
 “job_uuid”: 岗位uuid
 "job_refresh_time":岗位更新时间,
 "job_title": "岗位名称",
 “stu_open_im_status” : 兼客开通IM状态,<整形数字> 0未开通,1已开通.
 “city_name”://城市名称
 “contact_phone_num”//雇主联系方式
 “job_classif_id”://岗位分类id
 “job_classify_name”://岗位分类名称
 “is_complainted”:// 学生投诉状态  1：已投诉过  0：未投诉过
 “deadline_time_start”://岗位开始时间
 “deadline_time”://岗位结束时间
 
 }
 ]
 
 apply_job_list_count : 统计值<整形数字> , 当需要统计时,该属性有值
 
 }
 */

@interface JKApplyJob : NSObject
@property (nonatomic, strong) NSNumber *apply_job_id; /*!< 申请ID */
@property (nonatomic, strong) NSNumber *trade_loop_status; /*!< 交易闭环状态 1 等待雇主确认 2 已录用 3 投递结束*/
@property (nonatomic, strong) NSNumber *trade_loop_status_update_time; /*!< 交易闭环状态变更时间 */
@property (nonatomic, strong) NSNumber *trade_loop_finish_type; /*!< 交易闭环关闭原因 1兼客取消投递 2 雇主拒绝 3雇主确认完成 4 兼客未到岗 5 雇主24小时未处理 6 岗位关闭*/
@property (nonatomic, strong) NSNumber *stu_absent_type; /*!< 兼客未到岗原因  1双方沟通一致 2 放鸽子 */
@property (nonatomic, strong) NSNumber *job_close_type; /*!< 岗位关闭原因 */
@property (nonatomic, copy) NSString *stu_reciv_apply_reason; /*!< 取消投递的原因 */
@property (nonatomic, strong) NSNumber *stu_apply_resume_time; /*!< 兼客投递简历的时间 */
@property (nonatomic, strong) NSNumber *ent_read_resume_time; /*!< 企业阅读简历的时间 */
@property (nonatomic, strong) NSNumber *trade_loop_finish_time; /*!< 交易结束时间 */
@property (nonatomic, strong) NSNumber *stu_big_red_point_status; /*!< 兼客是否显示大红点 */
@property (nonatomic, strong) NSNumber *ent_big_red_point_status; /*!< 雇主是否显示大红点 */
@property (nonatomic, strong) NSNumber *ent_evalu_status; /*!< 交易闭环当前记录雇主评价状态, 0未评价, 1已评价 */
@property (nonatomic, strong) NSNumber *ent_evalu_level; /*!< 交易闭环当前记录的雇主评价星级 */
@property (nonatomic, copy) NSString *ent_evalu_content; /*!< 交易闭环当前记录的雇主评价内容 */
@property (nonatomic, strong) NSNumber *enterprise_info_id; /*!< 雇主id */
@property (nonatomic, strong) NSNumber *ent_open_im_status; /*!< 雇主是否开通im */
@property (nonatomic, strong) NSNumber *job_address_area_id; /*!< 岗位所在区域id */
@property (nonatomic, copy) NSString *job_address_area_name; /*!< 岗位所在区域名称 */
@property (nonatomic, strong) NSNumber *job_id; /*!< 岗位id */
@property (nonatomic, copy) NSString *job_uuid; /*!< 岗位uuid */
@property (nonatomic, strong) NSNumber *job_refresh_time; /*!< 岗位更新时间 */
@property (nonatomic, copy) NSString *job_title; /*!< 岗位名称 */
@property (nonatomic, strong) NSNumber *stu_open_im_status; /*!< 兼客开通IM状态,<整形数字> 0未开通,1已开通 */
@property (nonatomic, copy) NSString *city_name; /*!< 城市名称 */
@property (nonatomic, copy) NSString *contact_phone_num; /*!< 雇主联系方式 */
@property (nonatomic, strong) NSNumber *job_classif_id; /*!< 岗位分类id */
@property (nonatomic, copy) NSString *job_classify_name; /*!< 岗位分类名称 */
@property (nonatomic, strong) NSNumber *is_complainted; /*!< 学生投诉状态 */
@property (nonatomic, strong) NSNumber *deadline_time_start; /*!< 岗位开始时间 */
@property (nonatomic, strong) NSNumber *deadline_time; /*!< 岗位结束时间 */

@property (nonatomic, copy) NSString *job_classify_spelling; /*!< 岗位分类拼音 */
@property (nonatomic, copy) NSString *city_domain_prefix;   /*!< 城市域名前缀 */
@property (nonatomic, copy) NSString *job_classify_img_url; /*!< 岗位分类图标url */
@property (nonatomic, copy) NSString *job_working_place;    /*!< 工作地址 */
@property (nonatomic, strong) NSNumber *job_type;           /*!< 岗位类型  1：普通岗位   2：抢单岗位 */
@property (nonatomic, strong) NSString *ent_account_id;     /*!< 企业账号id */
@property (nonatomic, strong) NSNumber *confirm_on_board;   /*!< 1：已报名未发送过im通知 2：未确认上岗  3：已确认上岗 */
@property (nonatomic, strong) NSString *wechat_public;   /*! 微信公众号*/
@property (nonatomic, strong) NSString *wechat_number;  /*! 微信号*/
@end
