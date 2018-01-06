//
//  JKDetailApplyController.h
//  jianke
//
//  Created by fire on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMutiTabsNavController.h"
#import "WDViewControllerBase.h"

typedef NS_ENUM(NSInteger, JKDetailApplyControllerType) {
    
    JKDetailApplyControllerTypeApply = 1,
    JKDetailApplyControllerTypeEmploy,
};

@interface JKDetailApplyController : WDViewControllerBase <SYMutiTabsNavSubControllerDelegate>

@property (nonatomic, assign) JKDetailApplyControllerType controllerType;

@property (nonatomic, strong) NSString *jobId;

@end
