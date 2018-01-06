//
//  JobExpress_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTableViewBase.h"

@interface JobExpress_VC : WDTableViewBase

@property (nonatomic, weak) UIView* defaultView;

@property (nonatomic, assign) BOOL isHome;
@property (nonatomic, strong) UIView *tableSectionView;
@property (nonatomic, copy) MKBlock block;
- (void)getHistoryData;

@end
