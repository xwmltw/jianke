//
//  JobApplyConditionController.h
//  jianke
//
//  Created by fire on 15/11/20.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobModel.h"
#import "WDViewControllerBase.h"
#import "JobDetail_VC.h"

@interface JobApplyConditionController : WDViewControllerBase

@property (nonatomic, strong) JobModel *jobModel; /*!< 岗位模型 */
@property (nonatomic, assign) BOOL showCalendar; /*!< 是否显示日历 */
@property (nonatomic, strong) JobDetail_VC *jobDetailVC;

@end
