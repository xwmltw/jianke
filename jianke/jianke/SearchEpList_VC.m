//
//  SearchEpList_VC.m
//  jianke
//
//  Created by xiaomk on 16/4/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SearchEpList_VC.h"
#import "WDConst.h"
#import "GetEnterpriseModel.h"
#import "WDConst.h"
#import "EpProfile_VC.h"

@interface SearchEpList_VC ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray* _datasArray;
    NSNumber* _entCount;
    QueryParamModel *_queryParam;
}

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation SearchEpList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多雇主";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getLastData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];

    WEAKSELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    _datasArray = [[NSMutableArray alloc] init];
    [self getLastData];
}

- (void)getLastData{
    [_datasArray removeAllObjects];
    
    _queryParam = [[QueryParamModel alloc] init];
    _queryParam.page_size = @(30);
    _queryParam.page_num = @(1);
    
    EntNameModel* enModel = [[EntNameModel alloc] init];
    enModel.enterprise_name = self.searchStr;
    enModel.city_id = [UserData sharedInstance].city.id;
    
    GetEnterpriseModel* gemModel = [[GetEnterpriseModel alloc] init];
    gemModel.query_condition = enModel;
    gemModel.query_param = _queryParam;
    
    NSString* content = [gemModel getContent];
    WEAKSELF
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryEnterpriseList" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf.tableView.header endRefreshing];
        if (response && [response success]) {
            NSArray* ary = [EntInfoModel objectArrayWithKeyValuesArray:response.content[@"ent_list"]];
            if (ary.count) {
                _entCount = response.content[@"ent_count"];
                _queryParam = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                [_datasArray addObjectsFromArray:ary];
                
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (void)getMoreData{
    if (_queryParam) {
        NSInteger pageNum = _queryParam.page_num.integerValue;
        pageNum++;
     
        QueryParamModel* qpModel = [[QueryParamModel alloc] init];
        qpModel.page_num = @(pageNum);
        qpModel.page_size = _queryParam.page_size;
        qpModel.timestamp = _queryParam.timestamp;
        
        EntNameModel* enModel = [[EntNameModel alloc] init];
        enModel.enterprise_name = self.searchStr;
        enModel.city_id = [UserData sharedInstance].city.id;
        
        GetEnterpriseModel* gemModel = [[GetEnterpriseModel alloc] init];
        gemModel.query_condition = enModel;
        gemModel.query_param = qpModel;
        
        NSString* content = [gemModel getContent];
        
        WEAKSELF
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryEnterpriseList" andContent:content];
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.tableView.header endRefreshing];
            if (response && [response success]) {
                NSArray* ary = [EntInfoModel objectArrayWithKeyValuesArray:response.content[@"ent_list"]];
                if (ary.count) {
                    _entCount = response.content[@"ent_count"];
                    _queryParam = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                    [_datasArray addObjectsFromArray:ary];
                    
                    [weakSelf.tableView reloadData];
                }else{
                    [UIHelper toast:@"没有更多数据"];
                }
            }
        }];
    }
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SearchEpCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (_datasArray.count <= indexPath.row) {
        return cell;
    }
    EntInfoModel* eiModel = [_datasArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:eiModel.enterprise_name];
    NSRange range = [eiModel.enterprise_name rangeOfString:_searchStr];
    if (range.location != NSNotFound) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
        cell.textLabel.attributedText = attributeStr;
    }else{
        cell.textLabel.text = eiModel.enterprise_name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EntInfoModel* eiModel = [_datasArray objectAtIndex:indexPath.row];
    EpProfile_VC *vc = [[EpProfile_VC alloc] init];
    vc.isLookForJK = YES;
    vc.enterpriseId = [NSString stringWithFormat:@"%@",eiModel.enterprise_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasArray.count > 0 ? _datasArray.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
