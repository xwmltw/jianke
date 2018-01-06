//
//  EpPostedJobList_VC.m
//  JKHire
//
//  Created by yanqb on 16/11/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EpPostedJobList_VC.h"
#import "JobDetail_VC.h"
#import "JobExpressCell.h"
#import "JobModel.h"

@interface EpPostedJobList_VC ()

@property (nonatomic,strong) GetEnterpriscJobModel *reqModel;

@end

@implementation EpPostedJobList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"岗位列表";
    self.reqModel = [[GetEnterpriscJobModel alloc] init];
    self.reqModel.query_type = @(7);
    self.reqModel.query_param = [[QueryParamModel alloc] init];
    self.reqModel.ent_id = self.enterpriseId;
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.reqModel.query_param.page_num = @1;
    WEAKSELF
    NSString* content;
    content = [self.reqModel getContent];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getEnterpriseSelfJobList_v2" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.tableView.header endRefreshing];
        if (response && response.success) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            if (array.count) {
                weakSelf.dataSource = [array mutableCopy];
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.reqModel.query_param.page_num = @2;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    NSString* content;
    content = [self.reqModel getContent];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getEnterpriseSelfJobList_v2" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response && response.success) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            if (array.count) {
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.reqModel.query_param.page_num = @(weakSelf.reqModel.query_param.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
    JobModel* model = self.dataSource[indexPath.row];
    [cell refreshWithData:model];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"跳转到岗位详情");
    JobModel *jobModel = [self.dataSource objectAtIndex:indexPath.row];
    JobDetail_VC* vc = [[JobDetail_VC alloc] init];
    vc.jobId = jobModel.job_id.description;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
