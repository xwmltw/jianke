//
//  SettingController.h
//  jianke
//
//  Created by fire on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  设置

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"
#import "MKBaseTableViewController.h"


typedef NS_ENUM(NSInteger, SettingCellType) {
    SettingCellType_account         = 1,
    
    SettingCellType_opinion,
    SettingCellType_shareJK,
    SettingCellType_notice,
    SettingCellType_reputably,
    SettingCellType_aboutAPP,
    SettingCellType_clearCache,

    SettingCellType_logout,
};


@interface SettingController : WDViewControllerBase

@end
