//
//  IntristJob_VC.m
//  jianke
//
//  Created by fire on 16/9/26.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "IntristJob_VC.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "JobDetailMgr_VC.h"
#import "DataBaseTool.h"
#import "JobSearchList_VC.h"
#import "JobDetail_VC.h"
#import "InterestJob_VC.h"

@interface IntristJob_VC () <JobExpressCellDelegate>

@property (nonatomic, strong) QueryParamModel *queryParam;

@end

@implementation IntristJob_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"岗位推荐";
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.refreshType = RefreshTypeAll;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self creatNoDataView];
    self.queryParam = [[QueryParamModel alloc] init];
    [self.tableView.header beginRefreshing];
}


- (void)creatNoDataView{
    [self initWithNoDataViewWithStr:@"请先到【我的】-【兼职意向】-设置岗位意向城市或区域，再回来看看吧！" labColor:MKCOLOR_RGB(0, 188, 212) imgName:@"MyNewInfoLookMe_nil" button:@"去设置" onView:self.tableView];
    [self.btnWithNoData mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
    }];

}
- (void)creatNoDataViewWith:(NSString *)msg{
    [self initWithNoDataViewWithStr:msg labColor:MKCOLOR_RGB(0, 188, 212) imgName:@"MyNewInfoLookMe_nil" button:@"去设置" onView:self.tableView];
    [self.btnWithNoData mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
    }];
    
}
- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryStuSubscribeJobList" andContent:[self.queryParam getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.viewWithNoData.hidden = NO;
        if (response && response.success) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"self_job_list"]];
            if (array.count > 0) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.dataSource = [array mutableCopy];
                [weakSelf.tableView reloadData];
                weakSelf.queryParam.page_num = @(2);
            }
        }else if(response && !response.success ){
            [self creatNoDataViewWith:response.errMsg];
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_queryStuSubscribeJobList" andContent:[self.queryParam getContent]];
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response && response.success) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"self_job_list"]];
            if (array.count > 0) {
                weakSelf.viewWithNoData.hidden = YES;
                [weakSelf.dataSource addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
            }
        }else if(response && !response.success ){
            [self creatNoDataViewWith:response.errMsg];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource ? self.dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
    cell.delegate = self;
    JobModel* model = self.dataSource[indexPath.row];
    [cell refreshWithData:model];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog("====didSelectRowAtIndexPath:%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JobModel* model = self.dataSource[indexPath.row];
    // 设置岗位为已读状态
    model.readed = YES;
    [DataBaseTool saveReadedJobId:model.job_id.stringValue];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 跳转到岗位详情
    DLog(@"跳转到有上拉/下拉的岗位详情");
    NSString *jobId = model.job_id.stringValue;
    NSInteger index = indexPath.row;
    
    NSMutableArray *jobIdArray = [NSMutableArray array];
    for (JobModel *model in self.dataSource) {
        if (!model.isSSPAd) {
            NSString *jobIdStr = model.job_id.stringValue;
            [jobIdArray addObject:jobIdStr];
        }
    }
    
    JobDetail_VC *vc = [[JobDetail_VC alloc] init];
    vc.jobId = jobId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noDataButtonAction:(UIButton *)sender{
    InterestJob_VC *vc = [[InterestJob_VC alloc]init];
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
