//
//  XZTabBarCtrl.h
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface XZTabBarCtrl : WDViewControllerBase

@property (nonatomic, copy) NSArray *toolBarTitles;

@property (nonatomic, weak) UIView *customToolBar;

@property (nonatomic, copy) NSMutableArray<__kindof UIViewController *> *childVCs;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIViewController *rootViewCtrl;

@end
