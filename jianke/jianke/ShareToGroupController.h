//
//  ShareToGroupController.h
//  jianke
//
//  Created by fire on 15/12/31.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@class JobModel;

@interface ShareToGroupController : WDViewControllerBase

@property (nonatomic, strong) JobModel *jobModel; /*!< 岗位模型 */
@property (nonatomic, assign) BOOL isBackToRootView;

@end








