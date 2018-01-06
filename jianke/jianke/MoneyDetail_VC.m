//
//  MoneyDetail_VC.m
//  jianke
//
//  Created by 时现 on 15/11/18.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MoneyDetail_VC.h"
#import "PayDetailModel.h"
#import "MoneyDetailCell.h"
#import "UserData.h"

@interface MoneyDetail_VC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dynmacArray;

@end

@implementation MoneyDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金明细";
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView = tableView;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:tableView];
    
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.tableView.footer.hidden = YES;
    [self.tableView.header beginRefreshing];

    [self initWithNoDataViewWithStr:@"您还没有人脉王赏金" onView:self.tableView];

}

- (void)getData{
    self.queryParam = [[QueryParamModel alloc] init];
    self.queryParam.page_size = [[NSNumber alloc] initWithInt:30];
    
    WEAKSELF
    [[UserData sharedInstance] queryAcctSocialActivistBonusWithQueryParam:self.queryParam jobId:self.jobId detailID:self.moneyDetailID  block:^(ResponseInfo* respone) {
        if (respone && respone.success) {
            weakSelf.viewWithNoNetwork.hidden = YES;

            NSArray *dataArray = [PayDetailModel objectArrayWithKeyValuesArray:respone.content[@"stu_list"]];
            weakSelf.queryParam = [QueryParamModel objectWithKeyValues:respone.content[@"query_param"]];
            weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
            
            if (weakSelf.dataArray.count) {
                weakSelf.viewWithNoData.hidden = YES;
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
            [weakSelf.tableView reloadData];
        }else{
          //没网络
            weakSelf.viewWithNoNetwork.hidden = NO;
            weakSelf.viewWithNoData.hidden = YES;
        }
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)getMoreData{
    self.queryParam.page_num = @(self.queryParam.page_num.integerValue + 1);

    WEAKSELF
    [[UserData sharedInstance] queryAcctSocialActivistBonusWithQueryParam:self.queryParam jobId:self.jobId detailID:self.moneyDetailID block:^(ResponseInfo* respone) {
        if (respone && respone.success) {
            weakSelf.viewWithNoNetwork.hidden = YES;
            NSArray *newDataArray = [PayDetailModel objectArrayWithKeyValuesArray:respone.content[@"stu_list"]];
            if (newDataArray && newDataArray.count) {
                [weakSelf.dataArray addObjectsFromArray:newDataArray];
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
        }else{
            //没网络
            weakSelf.viewWithNoNetwork.hidden = NO;
            weakSelf.viewWithNoData.hidden = YES;
        }
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyDetailCell"];
    
    if (cell == nil) {
        cell = [MoneyDetailCell new];
    }
    
    if (self.dataArray.count <= indexPath.row) {
        return cell;
    }
    PayDetailModel *model = self.dataArray[indexPath.row];
    [cell refreshWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ? self.dataArray.count : 0;
}
@end
