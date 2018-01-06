//
//  JKDetailApplyController.m
//  jianke
//
//  Created by fire on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//  兼客详情->已报名控制器

#import "JKDetailApplyController.h"
#import "JKDetailApplyCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "UserData.h"
#import "ParamModel.h"
#import "Masonry.h"

@interface JKDetailApplyController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<JKModel *> *jkArray;

@property (nonatomic, strong) QueryParamModel *param;

@end

@implementation JKDetailApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self initWithNoDataViewWithStr:@"没有数据~" onView:self.tableView];
}

static NSString * const ID = @"JKDetailApplyCell";

- (void)setupTableView
{    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JKDetailApplyCell class]) bundle:nil] forCellReuseIdentifier:ID];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    WEAKSELF
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

- (void)getData
{
    self.viewWithNoData.hidden = YES;
    self.param = nil;
    
    NSNumber *listType = (self.controllerType == JKDetailApplyControllerTypeApply) ? @(1) : @(2);
    
    WEAKSELF
    [[UserData sharedInstance] getSocialActivistApplyJobResumeListWithJobId:self.jobId listType:listType queryParam:self.param block:^(ResponseInfo *response) {
       
        if (response && response.success) {
            
            weakSelf.jkArray = [NSMutableArray arrayWithArray:[JKModel objectArrayWithKeyValuesArray:response.content[@"apply_job_resume_list"]]];
            
            weakSelf.param = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.jkArray.count) {
                weakSelf.tableView.footer.hidden = NO;
                [weakSelf.tableView.footer endRefreshing];
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
    
    NSNumber *listType = self.controllerType == JKDetailApplyControllerTypeApply ? @(1) : @(2);
    
    WEAKSELF
    [[UserData sharedInstance] getSocialActivistApplyJobResumeListWithJobId:self.jobId listType:listType queryParam:self.param block:^(ResponseInfo *response) {
        
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
    JKDetailApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.model = self.jkArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView fd_heightForCellWithIdentifier:ID configuration:^(JKDetailApplyCell *cell) {
    
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
