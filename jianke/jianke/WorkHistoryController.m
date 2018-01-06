//
//  WorkHistoryController.m
//  jianke
//
//  Created by fire on 15/9/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WorkHistoryController.h"
//#import "WorkHistoryCell.h"
#import "WorkHistoryTableViewCell.h"
#import "UserData.h"
#import "MJRefresh.h"
#import "ParamModel.h"
#import "JKWorkExpericeModel.h"
#import "SortWorkExpModel.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "WorkHistoryTableHeaderView.h"
#import "MKVButton.h"

@interface WorkHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *workExpArray;
@property (nonatomic, strong) NSMutableArray *sortWorkExpArray;
@property (nonatomic, strong) QueryParamModel *param;
@property (nonatomic, strong) NSArray *sectonTitleArray;

@property (nonatomic, strong) MKVButton *btnLeft;
@property (nonatomic, strong) MKVButton *btnRight;
@end

@implementation WorkHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];

    [WDNotificationCenter postNotificationName:JKWorkHistoryRedDotNotification object:self];
    [self setupTableView];
    [self initWithNoDataViewWithStr:@"你还没有工作经历，快去兼职吧！" onView:self.tableView];

    // 获取数据
    [self.tableView.header beginRefreshing];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.isFromInfoCenter) {
        [self.tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)]];
        [self.tableView setFooter:[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)]];
        self.tableView.footer.hidden = YES;
        [self initTableHeadView];
    }
    
    if (self.isFromResume) {
        [self.tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDataComplete)]];
        [self.tableView setFooter:[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataComplete)]];
        self.tableView.footer.hidden = YES;
    }
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WorkHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"WorkHistoryTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WorkHistoryTableHeaderView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(WorkHistoryTableHeaderView.class)];
}

- (void)initTableHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectZero];
    topLine.backgroundColor = [UIColor XSJColor_grayDeep];
    [headView addSubview:topLine];
    
    UIView *botLine = [[UIView alloc] initWithFrame:CGRectZero];
    botLine.backgroundColor = [UIColor XSJColor_grayDeep];
    [headView addSubview:botLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(headView);
        make.height.mas_equalTo(12);
    }];
    
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(headView);
        make.height.mas_equalTo(12);
    }];
    
    MKVButton *btnLeft = [MKVButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setImage:[UIImage imageNamed:@"v3_record_flag"] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLeft setTitle:@"0次完工" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
//    [btnLeft addTarget:self action:@selector(btnHeadOnclick:) forControlEvents:UIControlEventTouchUpInside];
    btnLeft.tag = 100;
    [headView addSubview:btnLeft];
    self.btnLeft = btnLeft;
    
    MKVButton *btnRight = [MKVButton buttonWithType:UIButtonTypeCustom];
    [btnRight setImage:[UIImage imageNamed:@"v3_record_pigeon"] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRight setTitle:@"0次放鸽子" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
//    [btnRight addTarget:self action:@selector(btnHeadOnclick:) forControlEvents:UIControlEventTouchUpInside];
    btnRight.tag = 101;
    [headView addSubview:btnRight];
    self.btnRight = btnRight;
    
    [btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView);
        make.right.equalTo(btnRight.mas_left);
        make.top.equalTo(topLine.mas_bottom);
        make.bottom.equalTo(botLine.mas_top);
    }];
    
    [btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnLeft.mas_right);
        make.right.equalTo(headView);
        make.top.equalTo(topLine.mas_bottom);
        make.bottom.equalTo(botLine.mas_top);
        make.width.mas_equalTo(btnLeft.mas_width);
    }];
    
    UIView *midLine = [[UIView alloc] init];
    midLine.backgroundColor = [UIColor XSJColor_base];
    [headView addSubview:midLine];
    
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(40);
    }];
    self.tableView.tableHeaderView = headView;
}

//- (void)btnHeadOnclick:(UIButton *)sender{
//    NSInteger tag = sender.tag;
//    if (tag == 100) {
//        WorkHistoryController *vc = [[WorkHistoryController alloc] init];
//        vc.title = @"完工经历";
//        vc.isFromResume = YES;
//        vc.stu_work_history_type = @(1);
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (tag == 101){
//        WorkHistoryController *vc = [[WorkHistoryController alloc] init];
//        vc.title = @"放鸽子经历";
//        vc.isFromResume = YES;
//        vc.stu_work_history_type = @(2);
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}


#pragma mark - ***** UITableView delagate ******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkHistoryTableViewCell"];
    
    NSArray* tempAry = self.sortWorkExpArray[indexPath.section];
    SortWorkExpModel *sortModel = tempAry[indexPath.row];
    sortModel.isLast = NO;
    if ([tempAry lastObject] == sortModel) {
        sortModel.isLast = YES;
    }
    if ([tempAry firstObject] == sortModel) {
        sortModel.isFirstBegin = YES;
    }

    cell.sortModel = sortModel;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sortWorkExpArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sortWorkExpArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"WorkHistoryTableViewCell" configuration:^(WorkHistoryTableViewCell *cell) {
        SortWorkExpModel *sortModel = self.sortWorkExpArray[indexPath.section][indexPath.row];
        cell.sortModel = sortModel;
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    
    WorkHistoryTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(WorkHistoryTableHeaderView.class)];
    headerView.year = self.sectonTitleArray[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 20;
}

#pragma mark - 服务器交互

- (void)getData{
    WEAKSELF
    [[UserData sharedInstance] stuQueryWorkExpericeWithQueryParam:nil block:^(ResponseInfo *response) {
        if (response && response.success) {
            weakSelf.viewWithNoNetwork.hidden = YES;
            
            NSNumber *expericeCount = response.content[@"work_experice_count"]; // 完工数
            if (expericeCount) {
                [_btnLeft setTitle:[NSString stringWithFormat:@"%@次完工",expericeCount] forState:UIControlStateNormal];
            }
            NSNumber *promiseCount = response.content[@"break_promise_count"];  // 放鸽子数
            if (promiseCount) {
                [_btnRight setTitle:[NSString stringWithFormat:@"%@次放鸽子",promiseCount] forState:UIControlStateNormal];
            }
            
            NSArray *workExpArray = [JKWorkExpericeModel objectArrayWithKeyValuesArray:response.content[@"work_history_list"]];
            
            weakSelf.workExpArray = [NSMutableArray arrayWithArray:workExpArray];
            weakSelf.param = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
            
            if (weakSelf.workExpArray.count == 0) {
                weakSelf.viewWithNoData.hidden = NO;
                weakSelf.tableView.tableHeaderView.hidden = YES;
            }else{
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.tableView.tableHeaderView.hidden = NO;
            }
            weakSelf.tableView.footer.hidden = NO;
            [weakSelf sortData];
            [weakSelf.tableView reloadData];
        } else {
            if ( weakSelf.workExpArray.count > 0) {
                weakSelf.viewWithNoNetwork.hidden = YES;
                weakSelf.tableView.tableHeaderView.hidden = NO;
            }else{
                weakSelf.viewWithNoNetwork.hidden = NO;
                weakSelf.tableView.tableHeaderView.hidden = YES;
            }
        }
        
        [weakSelf.tableView.header endRefreshing];
    }];
}

-(void)getDataComplete{
    self.param = [[QueryParamModel alloc]init];
    self.param.page_num = @(1);
    self.param.page_size = @(30);
    self.param.timestamp = @(([[NSDate date] timeIntervalSince1970] * 1000));

    NSString  *content = [[NSString alloc]init];
    content = [NSString stringWithFormat:@"%@,\"stu_work_history_type\":\"%@\"",[self.param getContent],self.stu_work_history_type];

    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuQueryWorkExperice_v2" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"正在查询,请稍候";
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
            weakSelf.viewWithNoData.hidden = YES;
            NSArray *workExpArray = [JKWorkExpericeModel objectArrayWithKeyValuesArray:response.content[@"work_history_list"]];
            weakSelf.workExpArray = [NSMutableArray arrayWithArray:workExpArray];
            weakSelf.param = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
            
            if (weakSelf.workExpArray.count == 0) {
                weakSelf.viewWithNoData.hidden = NO;
            }else{
                weakSelf.viewWithNoData.hidden = YES;
            }
            weakSelf.tableView.footer.hidden = NO;
            [weakSelf sortData];
            
            [weakSelf.tableView reloadData];
        } else {
            if ( weakSelf.workExpArray.count > 0) {
                weakSelf.viewWithNoNetwork.hidden = YES;
            }else{
                weakSelf.viewWithNoNetwork.hidden = NO;
            }
        }
        [weakSelf.tableView.header endRefreshing];
        DLog(@">>>>>>>>>>>>");
    }];
    
    
}

- (void)getMoreData{
    self.param.page_num = @(self.param.page_num.integerValue + 1);
    WEAKSELF
    [[UserData sharedInstance] stuQueryWorkExpericeWithQueryParam:self.param block:^(ResponseInfo *response) {
        if (response && response.success) {
            NSArray *workExpArray = [JKWorkExpericeModel objectArrayWithKeyValuesArray:response.content[@"work_history_list"]];
            if (workExpArray && workExpArray.count > 0) {
                [weakSelf.workExpArray addObjectsFromArray:workExpArray];
                weakSelf.param = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                [weakSelf sortData];
                [weakSelf.tableView reloadData];
            } else {
                weakSelf.tableView.footer.hidden = YES;
            }
        }
        [weakSelf.tableView.footer endRefreshing];
    }];
}

- (void)getMoreDataComplete{

    self.param.page_num = @(self.param.page_num.integerValue +1);
    
    NSString  *content = [[NSString alloc]init];
    if ([[UserData sharedInstance]getLoginType].integerValue == WDLoginType_Employer) {
        content = [NSString stringWithFormat:@"%@,\"stu_work_history_type\":\"%@\",\"resume_id\":\"%@\"",[self.param getContent],self.stu_work_history_type,self.resume_id];
    }else if ([[UserData sharedInstance]getLoginType].integerValue == WDLoginType_JianKe){
        content = [NSString stringWithFormat:@"%@,\"stu_work_history_type\":\"%@\"",[self.param getContent],self.stu_work_history_type];
    }
    WEAKSELF
    RequestInfo *request = [[RequestInfo alloc]initWithService:@"shijianke_stuQueryWorkExperice_v2" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && response.success) {
            NSArray *workExpArray = [JKWorkExpericeModel objectArrayWithKeyValuesArray:response.content[@"work_history_list"]];
            if (workExpArray && workExpArray.count > 0) {
                [weakSelf.workExpArray addObjectsFromArray:workExpArray];
                weakSelf.param = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                [weakSelf sortData];
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf.tableView.footer  endRefreshing];
            }

            if (weakSelf.workExpArray.count == 0) {
                weakSelf.viewWithNoData.hidden = NO;
            }else{
                weakSelf.viewWithNoData.hidden = YES;
            }
            [weakSelf.tableView reloadData];
            
        } else {
            if ( weakSelf.workExpArray.count > 0) {
                weakSelf.viewWithNoNetwork.hidden = YES;
            }else{
                weakSelf.viewWithNoNetwork.hidden = NO;
            }
        }
        [weakSelf.tableView.footer endRefreshing];
    }];
    

}

/** 按月份排序数据 */
- (void)sortData{
    // 添加月份等属性
    NSMutableArray *arrayM = [NSMutableArray array];
    [self.workExpArray enumerateObjectsUsingBlock:^(JKWorkExpericeModel *model, NSUInteger idx, BOOL *stop) {
       
        SortWorkExpModel *tmpModel = [[SortWorkExpModel alloc] init];
        tmpModel.model = model;
        tmpModel.monthStr = [self strFromNumber:@(model.create_time.longLongValue) withDateFormat:@"M"];
        tmpModel.yearStr = [self strFromNumber:@(model.create_time.longLongValue) withDateFormat:@"yyyy"];
        tmpModel.yearAndMonthStr = [self strFromNumber:@(model.create_time.longLongValue) withDateFormat:@"yyyyM"];
        [arrayM addObject:tmpModel];
    }];
    
    
    // 获取yyyy字符串数组
    NSArray *yearStrArray = [self getSortStrArrayWithArray:arrayM sortStr:@"yearStr"];
    self.sectonTitleArray = yearStrArray;
    
    // 获取按年份排序好的二维数组
    NSMutableArray *yearDataArray = [NSMutableArray array];
    [yearStrArray enumerateObjectsUsingBlock:^(NSString *yearStr, NSUInteger idx, BOOL *stop) {
        NSArray *array = [arrayM filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"yearStr == %@", yearStr]];
        array = [array sortedArrayUsingComparator:^NSComparisonResult(SortWorkExpModel *model1, SortWorkExpModel *model2) {
            if (@(model1.model.create_time.longLongValue).longValue < @(model2.model.create_time.longLongValue).longValue) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        
        // 添加月份第一个表示
        NSString *monthStr;
        for (SortWorkExpModel *sortModel in array) {
            if (![sortModel.monthStr isEqualToString:monthStr]) {
                sortModel.isFirst = YES;
            }
            monthStr = sortModel.monthStr;
        }
        [yearDataArray addObject:array];
    }];
    self.sortWorkExpArray = yearDataArray;
}


- (NSString *)strFromNumber:(NSNumber *)num withDateFormat:(NSString *)dateFormat{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longLongValue * 0.001];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = dateFormat;
    return [format stringFromDate:date];
}


- (NSArray *)getSortStrArrayWithArray:(NSArray *)array sortStr:(NSString *)sortStr{
    // 获取sortStr属性组成的数组
    NSArray *strArray = [array valueForKeyPath:sortStr];
    
    // 数组转字典key value相等
    NSMutableDictionary *tmpDicM = [NSMutableDictionary dictionary];
    [strArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [tmpDicM setObject:obj forKey:obj];
    }];
    
    // 去重
    NSArray *uniqueStrArray = [tmpDicM allKeys];
    
    // 排序
    uniqueStrArray = [uniqueStrArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if (@(obj1.longLongValue).longValue < @(obj2.longLongValue).longValue) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    return uniqueStrArray;
}


@end
