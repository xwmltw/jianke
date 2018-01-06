//
//  JKDetailCompleteController.m
//  jianke
//
//  Created by fire on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKDetailCompleteController.h"
#import "JKDetailCompleteCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "UserData.h"
#import "ParamModel.h"
#import "JKDetailCompleteTableHeaderView.h"
#import "Masonry.h"

@interface JKDetailCompleteController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<JKModel *> *jkArray;

@property (nonatomic, strong) QueryParamModel *param;

@property (nonatomic, strong) SocialActivistCompleteModel *completeModel;

@end

@implementation JKDetailCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self initWithNoDataViewWithStr:@"没有数据~" onView:self.tableView];
}

static NSString * const ID = @"JKDetailCompleteCell";

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKDetailCompleteCell class]) bundle:nil] forCellReuseIdentifier:ID];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    WEAKSELF
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}


- (void)setupTableViewHeaderView
{
    
    JKDetailCompleteTableHeaderView *headerView = [JKDetailCompleteTableHeaderView headerView];
    headerView.model = self.completeModel;
    
    self.tableView.tableHeaderView = headerView;
}



- (void)getData
{
    self.param = nil;
    
    self.viewWithNoData.hidden = YES;
    
    WEAKSELF
    [[UserData sharedInstance] getSocialActivistApplyJobResumeListWithJobId:self.jobId listType:@(3) queryParam:self.param block:^(ResponseInfo *response) {
        
        if (response && response.success) {
            
            weakSelf.jkArray = [NSMutableArray arrayWithArray:[JKModel objectArrayWithKeyValuesArray:response.content[@"apply_job_resume_list"]]];
            
            weakSelf.param = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
            
            self.completeModel = [[SocialActivistCompleteModel alloc] init];            
            self.completeModel.allCompleteNum = response.content[@"all_complete_num"]; // 完工人数
            self.completeModel.allCompleteDayNum = response.content[@"all_complete_day_num"]; // 完工天数
            self.completeModel.socialActivistReward_unit = response.content[@"social_activist_reward_unit"]; // 人脉王赏金单位 1元/人 2元/人/天
            self.completeModel.socialActivistReward = response.content[@"social_activist_reward"]; // 人脉王赏金单位值，单位为分
            self.completeModel.allSocialActivistReward = response.content[@"all_social_activist_reward"]; // 人脉王可得到总赏金，单位为分
            
            if (weakSelf.jkArray.count) {
                [weakSelf setupTableViewHeaderView];
                [weakSelf.tableView reloadData];
                weakSelf.tableView.footer.hidden = NO;
                [weakSelf.tableView.footer endRefreshing];
                self.viewWithNoData.hidden = YES;
            } else {
                [weakSelf.tableView.footer noticeNoMoreData];
                self.viewWithNoData.hidden = NO;
            }
        }
        
        [self.tableView.header endRefreshing];
        
    }];
}


- (void)getMoreData
{
    self.viewWithNoData.hidden = YES;
    
    self.param.page_num = @(self.param.page_num.integerValue + 1);
    
    WEAKSELF
    [[UserData sharedInstance] getSocialActivistApplyJobResumeListWithJobId:self.jobId listType:@(3) queryParam:self.param block:^(ResponseInfo *response) {
        
        if (response && response.success) {
            
            NSArray *newJkArray = [JKModel objectArrayWithKeyValuesArray:response.content[@"apply_job_resume_list"]];
            
            if (newJkArray.count) {
                [weakSelf.jkArray addObjectsFromArray:newJkArray];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.footer endRefreshing];
            } else {
                [weakSelf.tableView.footer noticeNoMoreData];
            }
            
        } else {
            
            [self.tableView.footer endRefreshing];
        }
    }];
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jkArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKDetailCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.completeModel = self.completeModel;
    cell.model = self.jkArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView fd_heightForCellWithIdentifier:ID configuration:^(JKDetailCompleteCell *cell) {
//        
       JKModel *model = self.jkArray[indexPath.row];
//    }];
    return model.cellHeight;
}


AddTableViewLineAdjust

#pragma mark - SYMutiTabsNavSubControllerDelegate
- (void)loadData
{
    [self.tableView.header beginRefreshing];
}



@end
