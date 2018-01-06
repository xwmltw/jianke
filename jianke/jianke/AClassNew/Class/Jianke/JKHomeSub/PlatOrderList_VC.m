//
//  PlatOrderList_VC.m
//  jianke
//
//  Created by yanqb on 2016/11/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PlatOrderList_VC.h"
#import "PersonServiceDetail_VC.h"
#import "PlatOrderCell.h"
#import "PersonServiceModel.h"

@interface PlatOrderList_VC ()

@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, copy) NSNumber *cityId;

@end

@implementation PlatOrderList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queryParam = [[QueryParamModel alloc] init];
    self.cityId = [UserData sharedInstance].city.id;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    [self initWithNoDataViewWithStr:@"暂无相关订单" onView:self.tableView];
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"PlatOrderCell") forCellReuseIdentifier:@"PlatOrderCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 191.0f;
    [self.tableView.header beginRefreshing];
}

- (void)headerRefresh{
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryServicePersonalJobListWithServiceType:self.serviceType cityId:self.cityId queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [PersonServiceModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_list"]];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.queryParam.page_num = @2;
                weakSelf.dataSource = [array mutableCopy];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryServicePersonalJobListWithServiceType:self.serviceType cityId:self.cityId queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [PersonServiceModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_personal_job_list"]];
            if (array.count) {
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlatOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatOrderCell" forIndexPath:indexPath];
    PersonServiceModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.personalServiceModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonServiceModel *model = [self.dataSource objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonServiceModel *model = self.dataSource[indexPath.section];
    PersonServiceDetail_VC *viewCtrl = [[PersonServiceDetail_VC alloc] init];
    viewCtrl.service_personal_job_id = model.service_personal_job_id;
    viewCtrl.isApplyAction = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
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
