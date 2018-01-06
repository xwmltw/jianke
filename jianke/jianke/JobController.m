//
//  JobController.m
//  jianke
//
//  Created by fire on 15/10/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobController.h"
#import "JobModel.h"
#import "JobDetail_VC.h"
#import "JobExpress_VC.h"
#import "SeizeJob_VC.h"

@interface JobController ()
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) JobExpress_VC *jobExpressVC;
@property (nonatomic, strong) SeizeJob_VC *seizeJobVC;


@end

@implementation JobController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.titleName) {
        self.title = self.titleName;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (self.isSeizeJob) {
        [self initSeizeJob];
    } else {
        [self initNormalJob];
    }
}


- (void)initSeizeJob{
    self.tableView.backgroundColor = MKCOLOR_RGB(240, 240, 240);
    self.seizeJobVC = [[SeizeJob_VC alloc] init];
    self.seizeJobVC.tableView = self.tableView;
    self.seizeJobVC.owner = self;
    self.seizeJobVC.refreshType = WdTableViewRefreshTypeHeader | WdTableViewRefreshTypeFooter;
    self.seizeJobVC.requestParam = self.requestParam;
    self.seizeJobVC.showNoDataView = YES;
    [self.seizeJobVC headerBeginRefreshing];
}


- (void)initNormalJob{
    self.jobExpressVC = [[JobExpress_VC alloc]init];
    self.jobExpressVC.tableView = self.tableView;
    self.jobExpressVC.owner = self;
    self.jobExpressVC.refreshType = WdTableViewRefreshTypeHeader | WdTableViewRefreshTypeFooter;
    self.jobExpressVC.showNoDataView = YES;
    
    if (self.requestParam) {
        self.jobExpressVC.requestParam = self.requestParam;
    } else {
        self.jobExpressVC.requestParam.serviceName = @"shijianke_queryJobListFromApp";
        self.jobExpressVC.requestParam.typeClass = NSClassFromString(@"JobModel");
        self.jobExpressVC.requestParam.arrayName = @"self_job_list";
        self.jobExpressVC.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
        self.jobExpressVC.requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
        self.jobExpressVC.requestParam.content = self.content;
    }
    [self.jobExpressVC headerBeginRefreshing];
}


@end
