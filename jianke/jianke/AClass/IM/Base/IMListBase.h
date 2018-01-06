//
//  IMListBase.h
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMHome_VC.h"

@interface IMListBase : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IMHome_VC* home;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* view;
@property (nonatomic, assign) NSArray* arrayData;
@property (nonatomic, assign) WDLogin_type loginType;

- (instancetype)initWithHome:(IMHome_VC*)home;
- (void)setupListView;
- (void)viewDidLayoutSubviews;
- (void)viewWillAppear;
- (void)viewWillDisappear;
@end

