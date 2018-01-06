//
//  JobCollection_VC.m
//  jianke
//
//  Created by fire on 16/8/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobCollection_VC.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "JobDetail_VC.h"

@interface JobCollection_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation JobCollection_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"岗位收藏";
    self.queryParam = [[QueryParamModel alloc] init];
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self initWithNoDataViewWithStr:@"收藏感兴趣的兼职岗位" onView:self.view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.header beginRefreshing];
}

#pragma mark - 下拉最新

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getCollectedJobList:self.queryParam block:^(NSArray *result) {
        if (result && result.count) {
            weakSelf.viewWithNoData.hidden = YES;
            weakSelf.dataSource = [result mutableCopy];
            weakSelf.queryParam.page_num = @2;
        }else if(result.count == 0){
            [weakSelf.dataSource removeAllObjects];
            weakSelf.viewWithNoData.hidden = NO;
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.header endRefreshing];
    }];
}

#pragma mark - 上拉更多

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getCollectedJobList:self.queryParam block:^(NSArray *result) {
        if (result && result.count) {
            [weakSelf.dataSource addObjectsFromArray:result];
            weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource ? self.dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobExpressCell *cell = [JobExpressCell cellWithTableView:tableView];
    JobModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell refreshWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JobModel *model = [self.dataSource objectAtIndex:indexPath.row];
    JobDetail_VC *viewCtrl = [[JobDetail_VC alloc] init];
    viewCtrl.jobId = model.job_id.stringValue;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog(@"左滑取消收藏");
    JobModel *model = [self.dataSource objectAtIndex:indexPath.row];
    WEAKSELF
    [[XSJRequestHelper sharedInstance] cancelCollectedJob:model.job_id.stringValue isShowLoding:YES block:^(id result) {
        if (result) {
            [UIHelper toast:@"成功取消收藏"];
            [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (!weakSelf.dataSource.count) {
                weakSelf.viewWithNoData.hidden = NO;
            }
        }else{
//            [UIHelper toast:@"取消收藏失败"];
        }
    }];
}

//- (void)table

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
