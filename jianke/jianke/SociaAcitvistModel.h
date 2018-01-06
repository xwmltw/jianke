//
//  SociaAcitvistModel.h
//  jianke
//
//  Created by 时现 on 16/1/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareInfoModel;
@class SalaryModel;
@interface SociaAcitvistModel : NSObject

@property (nonatomic, copy) NSNumber *task_id;              //任务id
@property (nonatomic, copy) NSString *job_title;            //岗位标题
@property (nonatomic, copy) NSNumber *social_activist_reward;//人脉王赏金
@property (nonatomic, copy) NSNumber *social_activist_reward_unit;  //赏金单位
@property (nonatomic, copy) NSNumber *view_num;             //查看人数
@property (nonatomic, copy) NSNumber *apply_num;            //报名人数
@property (nonatomic, copy) NSNumber *hire_num;             //录用人数
@property (nonatomic, copy) NSNumber *finish_work_num;      //完工人数
@property (nonatomic, copy) NSNumber *task_status;          //任务状态
@property (nonatomic, strong) ShareInfoModel *share_info_not_sms;//非短信分享
@property (nonatomic, copy) NSNumber *share_info;           //短信分析
@property (nonatomic, copy) NSNumber *expect_reward;        //预计赏金
@property (nonatomic, copy) NSString *job_id;               /*!< 岗位ID */
@property (nonatomic, strong) SalaryModel *salary;               //薪水
@property (nonatomic, copy) NSNumber *receive_reward;       //已获得赏金
@property (nonatomic, copy) NSNumber *all_receive_reward;   //所获得总赏金
@property (nonatomic, assign) CGFloat cellHeight;           

@end


@interface ShareInfoNSModel: NSObject

@property (nonatomic, copy) NSString *share_title;
@property (nonatomic, copy) NSString *share_content;    //分享内容
@property (nonatomic, copy) NSString *share_img_url;    //分享图片URL
@property (nonatomic, copy) NSString *share_url;        //分享链接URL

@end

//“content”:{
//    “task_list”[
//                {
//                    “task_id”：// 任务id
//                    “job_title”:***,
//                    “social_activist_reward”:***(单位为分),
//                    “apply_num”:*** // 报名人数
//                    “hire_num”:*** // 录用人数
//                    “finish_work_num”:*** // 完工人数
//                    “task_status”: // 任务状态  1：未接单  2：已接单 3：已拒绝
//                    “share_info_not_sms”:{
//                        “share_title”://分享标题
//                        “share_content”://分享内容
//                        “share_img_url”://分享图片url
//                        “share_url”://分享链接url
//                    }
//                    “share_info”: // 短信分享
//                    “expect_reward”:// 预计赏金
//                }
//                ]
//    “social_activist_status”:// 人脉王状态  0未申请，1申请中，2申请通过，3被驳回，4被撤销',
//}