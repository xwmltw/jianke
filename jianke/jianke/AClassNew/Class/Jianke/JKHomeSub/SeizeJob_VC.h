//
//  SeizeJob_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTableViewBase.h"

@interface SeizeJob_VC : WDTableViewBase

@property (nonatomic, weak) UIView* defaultView;
@property (nonatomic, strong) NSArray* arrayData2;

+ (void)needRefreshOnNextViewApper;

- (void)registerLocateEvent;

- (void)getSecion2Data:(NSString*)content;
@end
