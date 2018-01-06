//
//  ServiceMange_VC.h
//  JKHire
//
//  Created by xuzhi on 16/10/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface ServiceMange_VC : WDViewControllerBase

@property (nonatomic, copy) NSArray *toolBarTitles;

@property (nonatomic, weak) UIView *customToolBar;

@property (nonatomic, copy) NSArray<__kindof UIViewController *> *childVCs;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
