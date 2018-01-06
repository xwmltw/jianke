//
//  JKApplyJobList_VC.m
//  jianke
//
//  Created by xiaomk on 16/6/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKApplyJobList_VC.h"
#import "JKApplyJob.h"
#import "XSJConst.h"
#import "JKApplyJobsCell.h"

@interface JKApplyJobList_VC ()<UITableViewDelegate, UITableViewDataSource>{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QueryParamModel *queryParam;      /*!< 查询参数 */
@property (nonatomic, strong) NSArray *applyJobArray;
@property (nonatomic, strong) NSMutableArray *historyApplyJobArray;
@property (nonatomic, copy) NSNumber *historyNum;
@end

@implementation JKApplyJobList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor XSJColor_grayTinge];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    self.historyApplyJobArray = [[NSMutableArray alloc] init];
    [self initWithNoDataViewWithStr:@"您当前还没有待办事项" onView:self.tableView];

    // 集成上拉,下拉
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getHistoryData)];
    
    // 开始刷新
    [self.tableView.header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    /** 取消报名通知 */
//    [WDNotificationCenter addObserver:self selector:@selector(cancelApply:) name:JKApplyJobCancellApplyNotification object:nil];
//    /** 有问题通知 */
//    [WDNotificationCenter addObserver:self selector:@selector(hasQuestion:) name:JKApplyJobHasQuestionNotification object:nil];
//    /** 与雇主聊天通知 */
//    [WDNotificationCenter addObserver:self selector:@selector(chatWithEp:) name:JKApplyJobChatWithEPNotification object:nil];
}

#pragma mark - *****  数据交互 ******
/** 获取我的工作列表数据 */
- (void)getData{
    NSString *content = @"\"in_history\":\"0\"";
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuQueryApplyJobList" andContent:content];
    request.isShowLoading = NO;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response && response.success) { // 有数据
            weakSelf.viewWithNoNetwork.hidden = YES;
            weakSelf.applyJobArray = [JKApplyJob objectArrayWithKeyValuesArray:response.content[@"apply_job_list"]];
            
            // 设置非历史记录条数
            weakSelf.title = [NSString stringWithFormat:@"待办事项 (%lu)", (unsigned long)weakSelf.applyJobArray.count];
            
            // 设置历史记录条数
            weakSelf.historyNum = response.content[@"apply_job_count_in_history"];
            [weakSelf.historyApplyJobArray removeAllObjects];
            
            //有数据
            if (weakSelf.applyJobArray.count > 0) {
                [weakSelf.tableView reloadData];
                // 保存查询分页参数
                weakSelf.queryParam = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                weakSelf.queryParam.page_num = @(0);
            }else{ //没数据
                if (weakSelf.historyNum.integerValue > 0) {    //有历史数据
                    weakSelf.viewWithNoData.hidden = YES;
                    [weakSelf historyClick];
                }else{  //没有历史数据
                    weakSelf.viewWithNoData.hidden = NO;
                }
            }
        } else { // 没有数据返回
            weakSelf.viewWithNoNetwork.hidden = NO;
        }
    }];
}

- (void)historyClick{
    // 加载更多
    [self getHistoryData];
}


/** 获取历史数据 */
- (void)getHistoryData{
    NSString *content = @"";
    if (self.queryParam) {
        // 页码+1
        NSUInteger pageNum = self.queryParam.page_num.integerValue;
        pageNum++;
        self.queryParam.page_num = @(pageNum);
        NSString *queryStr = [self.queryParam simpleJsonString];
        content = [NSString stringWithFormat:@"\"query_param\":%@, \"in_history\":1", queryStr];
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuQueryApplyJobList" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据加载中...";
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response) { // 有数据
            NSArray *applyJobList = [JKApplyJob objectArrayWithKeyValuesArray:response.content[@"apply_job_list"]];
            if (applyJobList.count) { // 有更多数据
                [weakSelf.historyApplyJobArray addObjectsFromArray:applyJobList];
                [weakSelf.tableView reloadData];
                weakSelf.queryParam = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
            } else { // 没有更多数据
                [UIHelper toast:@"没有更多数据了"];
            }
        }
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JKApplyJobsCell *cell = [JKApplyJobsCell cellWithTableView:tableView];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 226;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.applyJobArray.count > 0 ? self.applyJobArray.count : 0;
    }else if (section == 1){
        return self.historyApplyJobArray.count > 0 ? self.historyApplyJobArray.count : 0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.historyApplyJobArray && self.historyApplyJobArray.count > 0) {
        return 2;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *sectionHeadView = [[UIView alloc] init];
        sectionHeadView.width = SCREEN_WIDTH;
        sectionHeadView.height = 40;
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120) * 0.5, 10, 120, 20)];
        NSString *historyBtnTitle = [NSString stringWithFormat:@"历史记录 (%@)",self.historyNum];
        [headBtn setTitle:historyBtnTitle forState:UIControlStateNormal];
        headBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [headBtn setImage:[UIImage imageNamed:@"v3_public_history"] forState:UIControlStateNormal];
        [headBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [headBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
//        headBtn.userInteractionEnabled = NO;
        [sectionHeadView addSubview:headBtn];
        return sectionHeadView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
