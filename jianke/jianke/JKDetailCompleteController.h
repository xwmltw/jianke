//
//  JKDetailCompleteController.h
//  jianke
//
//  Created by fire on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMutiTabsNavController.h"
#import "WDViewControllerBase.h"

@interface JKDetailCompleteController : WDViewControllerBase <SYMutiTabsNavSubControllerDelegate>

@property (nonatomic, strong) NSString *jobId;

@end
