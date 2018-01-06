//
//  JobController.h
//  jianke
//
//  Created by fire on 15/10/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@class RequestParamWrapper;
@interface JobController : WDViewControllerBase

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) RequestParamWrapper *requestParam;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) BOOL isSeizeJob; /*!< 是否是抢单界面 */

@end
