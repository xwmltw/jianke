//
//  ZhaiTaskModel.h
//  jianke
//
//  Created by yanqb on 2016/12/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"

@interface ZhaiTaskModel : MKBaseModel

@property (nonatomic, copy) NSNumber *task_id;  /*!< 宅任务id */
@property (nonatomic, copy) NSString *task_title; /*!< 宅任务名称 */
@property (nonatomic, copy) NSNumber *task_classify_id; /*!< 宅任务分类id */
@property (nonatomic, copy) NSString *task_step;    /*!< 宅任务步骤，json字符串 格式：[{task_step: xxxx,  // 步骤内容，按步骤顺序}] */
@property (nonatomic, copy) NSString *task_url; /*!< 任务链接 */
@property (nonatomic, copy) NSString *task_pic_url; /*!< 任务说明图片地址，json字符串 格式：[{task_pic_url: xxxx,  // 任务说明图片地址}] */
@property (nonatomic, copy) NSNumber *task_num; /*!< 任务数量 */
@property (nonatomic, copy) NSNumber *task_fee; /*!< 任务总单价，单位为分（包括薪资和服务费） */
@property (nonatomic, copy) NSNumber *task_submit_dead_hours;   /*!< 任务提交时长，单位小时 */
@property (nonatomic, copy) NSNumber *task_audit_hours; /*!< 任务审核时长，单位小时 */
@property (nonatomic, copy) NSNumber *task_dead_time;   /*!< 任务截止时间 */
@property (nonatomic, copy) NSString *city_ids; /*!< 任务所在城市id,多个城市用,隔开 */
@property (nonatomic, copy) NSNumber *time_limit;   /*!< 次数限制，1每人一次 0不限次数 */
@property (nonatomic, copy) NSNumber *task_submit_type; /*!< 提交方式，1截图 2文本3截图+文本 */
@property (nonatomic, copy) NSString *task_submit_desc; /*!< 任务提交说明 */
@property (nonatomic, copy) NSString *task_submit_pic_url;  /*!< 任务提交范例图片地址 json 格式：[{task_submit_pic_url: xxxx,  // 任务说明图片地址}] */
@property (nonatomic, copy) NSString *task_classify_img_url;    /*!< 任务分类图标 */
@property (nonatomic, copy) NSNumber *task_salary;  /*!< 任务薪资金额 ，单位为分 */
@property (nonatomic, copy) NSNumber *task_has_apply_valid_num; /*!< 任务有效的领取次数 */
@property (nonatomic, copy) NSNumber *task_left_can_apply_count;    /*!< 任务剩余可申请数 */
@property (nonatomic, copy) NSNumber *task_pay_salary;  /*!< 任务已支付薪资总额，单位为分 */
@property (nonatomic, copy) NSNumber *task_submit_count;    /*!< 任务提交数 */
@property (nonatomic, copy) NSString *task_uuid;    /*!< 任务uuid */
@property (nonatomic, copy) NSString *attention;    /*!< 注意事项 */
@property (nonatomic, copy) NSString *task_submit_check_success_rate;   /*!< 任务审核通过率 */

@property (nonatomic, copy) NSNumber *show_hot_icon;    /*!< 显示热门图标  0不显示  1显示 */
@property (nonatomic, copy) NSNumber *show_fresh_icon;  /*!< 显示新图标  0不显示  1显示 */

//自定义字段
@property (nonatomic, assign) BOOL isRead;

@end
