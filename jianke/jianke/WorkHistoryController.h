//
//  WorkHistoryController.h
//  jianke
//
//  Created by fire on 15/9/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@interface WorkHistoryController : WDViewControllerBase

@property (nonatomic, assign) BOOL isFromResume;
@property (nonatomic, assign) BOOL isFromInfoCenter;
@property (nonatomic, copy) NSNumber *stu_work_history_type;//1完工2放鸽子
@property (nonatomic, copy) NSNumber *resume_id;//简历id
@end
