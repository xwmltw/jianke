//
//  ApplyJobResumeModel.h
//  jianke
//
//  Created by fire on 15/9/21.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  报名兼客简历模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ApplyJobResumeModel : NSObject
@property (nonatomic, strong) NSNumber* apply_job_id; /*!< 申请岗位id */
@property (nonatomic, strong) NSString* user_profile_url; /*!< 用户头像 */
@property (nonatomic, strong) NSNumber* verify_tatus; // 兼客认证状态
@property (nonatomic, strong) NSNumber* resume_id; /*!< 简历id */
@property (nonatomic, strong) NSNumber* account_id; /*!< 账号id */
@property (nonatomic, copy) NSString* true_name; /*!< 用户名称 */

//v220
@property (nonatomic, assign) BOOL hiring_page_stu_small_red_point; /*!< 正在招人页面兼客头像小红点  0:不显示  1：显示 */

@end
