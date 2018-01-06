//
//  MainTabBarCtlMgr.h
//  jianke
//
//  Created by xiaomk on 16/6/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TabBarSwitchVC) {
    TabBarSwitchVC_None             = -1,
    TabBarSwitchVC_JKApplyJobListVC = 1,
    TabBarSwitchVC_JKIM,
    TabBarSwitchVC_EPIM,
};

@interface MainTabBarCtlMgr : NSObject

+ (instancetype)sharedInstance;

- (void)creatJKTabbar;
- (void)creatJKTabbar:(MKBlock)block;

- (void)creatEPTabbar;
- (void)creatEPTabbar:(MKBlock)block;

- (void)setSelectWithIndex:(NSInteger)index;

- (void)setSelectMsgTab;

- (void)showMyApplyCtrlOnCtrl:(UIViewController *)vc;

@end
