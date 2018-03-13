//
//  WDTableViewBase.m
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WDTableViewBase.h"
#import "WDConst.h"
#import "ParamModel.h"
#import "JobModel.h"
#import "DataBaseTool.h"


@interface WDTableViewBase(){
    BOOL _init;
    BOOL _isGetLast;
    BOOL _isFirst;
}

@end

@implementation WDTableViewBase

- (void)viewDidAppear{
    if (!_init) {
        _init = YES;
        if ((_refreshType & WdTableViewRefreshTypeHeader) == WdTableViewRefreshTypeHeader) {
            [self.tableView.header beginRefreshing];
            
        }
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _isGetLast = NO;
        self.requestParam = [[RequestParamWrapper alloc]init];
        self.requestParam.queryParam = [[QueryParamModel alloc] init];
        self.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
        
        _refreshType = WdTableViewRefreshTypeNone;
        self.arrayData = [[NSMutableArray alloc] init];
        
        _isFirst = YES;
        ELog("===========WDTableViewBase init ok")
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;

    // 无数据
    NSString* str;
    if (self.isInvitingForJob) {
        str = @"您还没有发布任何岗位，请点击右上角的{+}按钮进行发布";
        
    }else{
        str = @"没有数据，请下拉刷新";
    }
    
    self.noDataView = [UIHelper noDataViewWithTitle:str image:@"v3_public_nodata"];
    [self.tableView addSubview:self.noDataView];
    self.noDataView.frame = CGRectMake(0, 80, self.noDataView.size.width, self.noDataView.size.height);
    self.noDataView.hidden = YES;
    
    //无信号
    self.noSignalView = [UIHelper noDataViewWithTitle:@"啊噢,网络不见了" image:@"v3_public_nowifi"];
    [self.tableView addSubview:self.noSignalView];
    self.noSignalView.frame = CGRectMake(0, 80, self.noDataView.size.width, self.noDataView.size.height);
    self.noSignalView.hidden = YES;
}

- (void)setRefreshType:(WDTableViewRefreshType)refreshType{
    _refreshType = refreshType;
    NSAssert(self.tableView, @"tableView 未指定");
    if (self.isInvitingForJob) {
        if (![[UserData sharedInstance] isLogin]) {
            return;
        }
    }
    
    if ((refreshType & WdTableViewRefreshTypeHeader) == WdTableViewRefreshTypeHeader) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(showLatest)];
        if (self.isJKHomeVC) {
            self.tableView.header.ignoredScrollViewContentInsetTop = 64;
        }
    }
    
    if ((refreshType & WdTableViewRefreshTypeFooter) == WdTableViewRefreshTypeFooter) {
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(showMore)];
//        self.tableView.footer.ignoredScrollViewContentInsetBottom = 80;
    }
}

- (void)reloadTableView{
    [self.tableView reloadData];
}

- (void)showLatest{
    _isGetLast = YES;
    self.requestParam.queryParam = nil;
    self.requestParam.queryParam = [[QueryParamModel alloc]init];
    self.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
    [self sendRequest];
}

- (void)showMore{
    _isGetLast = NO;
    [self sendRequest];
}

- (void)headerBeginRefreshing{
//    [self.tableView.header beginRefreshing];
    [self showLatest];
}

- (void)sendRequest{
    if (self.requestParam == nil) {
        NSAssert(NO, @"requestParam请求参数不存在");
        return;
    }
    
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    
    RequestInfo* info = [[RequestInfo alloc] initWithService:self.requestParam.serviceName andContent:self.requestParam.content];
    info.isShowLoading = NO;
    WEAKSELF
    [info sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.tableView.footer endRefreshing];
        [weakSelf.tableView.header endRefreshing];
        if (weakSelf.isJKHomeVC) {
            if ([weakSelf.delegate respondsToSelector:@selector(showNoDataViewWithActionType:)]) {
                [weakSelf.delegate showNoDataViewWithActionType:callBackType_removeNoMoreData];
            }
        }        
        if (response && [response success]) {
            weakSelf.noDataView.hidden = YES;
            weakSelf.noSignalView.hidden = YES;
            
            NSInteger pageNum = 0;
            
            NSDictionary* query_param = [response.content objectForKey:@"query_param"];
            if (query_param) {
                pageNum = weakSelf.requestParam.queryParam.page_num.integerValue;
                weakSelf.requestParam.queryParam = [QueryParamModel objectWithKeyValues:query_param];
                weakSelf.requestParam.queryParam.page_num = @(weakSelf.requestParam.queryParam.page_num.intValue + 1);
            }
            
            NSArray* dataList = [response.content objectForKey:weakSelf.requestParam.arrayName];
            if (dataList == nil) {
                NSAssert(dataList,@"======self.requestParam.arrayName=%@,response.content=%@",self.requestParam.arrayName, response.content);
            }
            
            if (_isGetLast) {
                [weakSelf.arrayData removeAllObjects];
            }
            
            if (dataList.count < 1) {
                weakSelf.tableView.footer.state = MJRefreshStateNoMoreData;

                if (weakSelf.arrayData.count > 0) {
                    if (weakSelf.showNoDataView) {
                        weakSelf.noDataView.hidden = YES;
                    }
                }else{
                    if (weakSelf.showNoDataView) {
                        weakSelf.noDataView.hidden = NO;
                    }
                }
                
                if (weakSelf.isJKHomeVC ) {  //兼客首页 无数据状态
                    if (pageNum == 1) {
                        if ([self isGetDataWithQueryThroughConditionParam]) { //查询直通车岗位 - 无数据时
                            if (![self isGetDataWithQueryConditionParam]) {  //非筛选条件下
                                weakSelf.requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@}",[UserData sharedInstance].city.id];
                                [weakSelf headerBeginRefreshing];
                            }else{
                                if ([weakSelf.delegate respondsToSelector:@selector(showNoDataViewWithActionType:)]) {
                                    [weakSelf.delegate showNoDataViewWithActionType:callBackType_throughNoMoreData];
                                }
                            }
                        }else{
                            if ([weakSelf.delegate respondsToSelector:@selector(showNoDataViewWithActionType:)]) {
                                [weakSelf.delegate showNoDataViewWithActionType:callBackType_defaultNoMoreData];
                            }
                        }
                    }else{
                        if ([self isGetDataWithQueryThroughConditionParam]) {
                            if ([self.delegate respondsToSelector:@selector(showNoDataViewWithActionType:)]) {
                                [weakSelf.delegate showNoDataViewWithActionType:callBackType_queryConditionNoMoreData];
                            }
                        }
                    }
                }
                
                [weakSelf.tableView reloadData];
            
                [weakSelf scrollToTop];
                // 请求结束回调方法
                if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinish:)]) {
                    [weakSelf.delegate requestDidFinish:(weakSelf.arrayData)];
                }
//                [weakSelf.tableView.header endRefreshing];
                return;
            }else{
//                [self isGetDataWithQueryThroughConditionParam]//取消直通车要求判断
                if (weakSelf.isJKHomeVC && [self isGetDataWithQueryThroughConditionParam] ) {  //兼客首页 查看全部岗位按钮
                    if (dataList.count < weakSelf.requestParam.queryParam.page_size.integerValue) {
                        weakSelf.tableView.footer.state = MJRefreshStateNoMoreData;
                        if ([weakSelf.delegate respondsToSelector:@selector(showNoDataViewWithActionType:)]) {
                            [weakSelf.delegate showNoDataViewWithActionType:callBackType_queryConditionNoMoreData];
                        }
                    }
                }
            }
            
            NSArray *readedJobIdArray = [DataBaseTool readedJobIdArray];
            for (NSDictionary* data in dataList) {
                id obj = [weakSelf.requestParam.typeClass objectWithKeyValues:data];                
                // 设置岗位已读/未读状态
                if ([obj isKindOfClass:[JobModel class]]) {
                    [obj checkReadStateWithReadedJobIdArray:readedJobIdArray];
                }
                
                [weakSelf.arrayData addObject:obj];
            }
            
//            if(globaModel.is_need_hide_limit_job.integerValue == 1 ){
//
//                    //隐藏部分兼职
//                    NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
//                    for (int i = 0; i < weakSelf.arrayData.count; i++) {
//                       id model = weakSelf.arrayData[i];
//                        if ([model isKindOfClass:[JobModel class]]) {
//                            JobModel *jModel = model;
//                            if (jModel.job_type.integerValue == 5) {
//                                [indexs addIndex:i];
//                            }
//                        }
//
//                    }
//                    [weakSelf.arrayData removeObjectsAtIndexes:indexs];
//
//            }
            
            
            //插入广告
            if(globaModel.job_list_ad_1 && weakSelf.arrayData.count > 3){
                [weakSelf.arrayData insertObject:globaModel.job_list_ad_1 atIndex:3];
            }
            if(globaModel.job_list_ad_2 && weakSelf.arrayData.count > 8){
                [weakSelf.arrayData insertObject:globaModel.job_list_ad_2 atIndex:8];
            }
            if(globaModel.job_list_ad_3 && weakSelf.arrayData.count > 15){
                [weakSelf.arrayData insertObject:globaModel.job_list_ad_3 atIndex:15];
            }
            
            //保存数据到本地 做无网络显示
            if (weakSelf.arrayData.count > 0 && _isGetLast) {
                [[UserData sharedInstance] saveHomeJobListWithArray:weakSelf.arrayData];
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf scrollToTop];

        }else{
            //失败也要回调
            if (!weakSelf.arrayData || weakSelf.arrayData.count <= 0) {
                NSArray* jobAry = [[UserData sharedInstance] getHomeJobList];
                if (jobAry && jobAry.count > 0) {
                    weakSelf.arrayData = [[NSMutableArray alloc] initWithArray:jobAry];
                }
                
                JobModel *adModel = [[JobModel alloc] init];
                adModel.isSSPAd = YES;
            }
            
//            if(globaModel.is_need_hide_limit_job.integerValue == 1 ){
//                
//                //隐藏部分兼职
//                NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
//                for (int i = 0; i < weakSelf.arrayData.count; i++) {
//                    id model = weakSelf.arrayData[i];
//                    if ([model isKindOfClass:[JobModel class]]) {
//                        JobModel *jModel = model;
//                        if (jModel.job_type.integerValue == 5) {
//                            [indexs addIndex:i];
//                        }
//                    }
//                    
//                }
//                [weakSelf.arrayData removeObjectsAtIndexes:indexs];
//                
//            }
            
            //插入广告
            if(globaModel.job_list_ad_1 && weakSelf.arrayData.count > 3){
                [weakSelf.arrayData insertObject:globaModel.job_list_ad_1 atIndex:3];
            }
            if(globaModel.job_list_ad_2 && weakSelf.arrayData.count > 8){
                [weakSelf.arrayData insertObject:globaModel.job_list_ad_1 atIndex:8];
            }
            if(globaModel.job_list_ad_3 && weakSelf.arrayData.count > 15){
                [weakSelf.arrayData insertObject:globaModel.job_list_ad_1 atIndex:15];
            }

            
            [weakSelf.tableView reloadData];
            [weakSelf scrollToTop];
            
            weakSelf.noDataView.hidden = YES;
            if (weakSelf.arrayData.count > 0) {
                weakSelf.noSignalView.hidden = YES;
            }else{
                weakSelf.noSignalView.hidden = NO;
            }
        }
        // 请求结束回调方法
        if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [weakSelf.delegate requestDidFinish:(weakSelf.arrayData)];
        }
    }];
}


- (void)scrollToTop{
    if (_isGetLast && _isFirst && self.isJKHomeVC) {
        _isFirst = NO;
        [self.tableView setContentOffset:CGPointMake(0,-64) animated:YES];
    }
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(NO, @"这个方法必须要实现...");
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    DLog(@"=====> %@", NSStringFromCGRect(self.tableView.frame));
//    DLog(@"=====> %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    return self.arrayData ? self.arrayData.count : 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//处理下面多余的线
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

/** 是否是直通车请求 */
- (BOOL)isGetDataWithQueryThroughConditionParam{
    if ([self.requestParam.content rangeOfString:@"through"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

/** 是否是筛选条件请求 */
- (BOOL)isGetDataWithQueryConditionParam{
    if ([self.requestParam.content rangeOfString:@"job_type_id"].location != NSNotFound) {
        return YES;
    }
    if ([self.requestParam.content rangeOfString:@"address_area_id"].location != NSNotFound) {
        return YES;
    }
    if ([self.requestParam.content rangeOfString:@"salary_unit"].location != NSNotFound) {
        return YES;
    }
    if ([self.requestParam.content rangeOfString:@"coord_latitude"].location != NSNotFound) {
        return YES;
    }
    if ([self.requestParam.content rangeOfString:@"coord_longitude"].location != NSNotFound) {
        return YES;
    }
    if ([self.requestParam.content rangeOfString:@"left_time_type"].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

@end
