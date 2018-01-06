//
//  ParttimeJobList_VC.m
//  jianke
//
//  Created by yanqb on 2017/2/14.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "ParttimeJobList_VC.h"
#import "JSDropDownMenu.h"
#import "MenuDataSource.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "DataBaseTool.h"
#import "JobDetailMgr_VC.h"
#import "JobSearchList_VC.h"
#import "JobDetail_VC.h"

@interface ParttimeJobList_VC () <JSDropDownMenuSelectDelegate, JobExpressCellDelegate>

@property (nonatomic, strong) JSDropDownMenu *tableSectionView; /*!< 撒选控件section */
@property (nonatomic, strong) MenuDataSource *menuDataSource;   /*!< 撒选控件 */
@property (nonatomic, strong) RequestParamWrapper *param;

@end

@implementation ParttimeJobList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@兼职", [UserData sharedInstance].city.name];
    [self setupNavigation];
    
    self.param = [[RequestParamWrapper alloc] init];
    self.param.queryParam = [[QueryParamModel alloc] init];
    
    LocalModel *model = [UserData sharedInstance].local;
    
    if ([[UserData sharedInstance] isEnableThroughService] && [[UserData sharedInstance] isEnableVipService]) {
        if (model) {
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",[UserData sharedInstance].city.id, model.latitude, model.longitude];
        }else{
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",[UserData sharedInstance].city.id];
        }
    }else{
        if (model) {
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1, \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"}",[UserData sharedInstance].city.id, model.latitude, model.longitude];
        }else{
            self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",[UserData sharedInstance].city.id];
        }
    }
    
//    self.param.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, coord_use_type:1}",[UserData sharedInstance].city.id];
    
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.isNotNeedLogin = YES;
    [self initWithNoDataViewWithStr:@"当前没有招聘的岗位" onView:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
    [self.tableView.header beginRefreshing];
}

- (void)setupNavigation{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    [searchBtn setImage:[UIImage imageNamed:@"v3_home_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nevgativeSpaceRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nevgativeSpaceRight.width = -12;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[nevgativeSpaceRight,rightItem];
}

#pragma mark - 数据请求
- (void)headerRefresh{
    WEAKSELF
    ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    self.param.queryParam.page_num = @1;
    [[XSJRequestHelper sharedInstance] queryJobListFromApp:self.param block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"self_job_list"]];
            [weakSelf.dataSource removeAllObjects];
            if (array.count) {
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.param.queryParam.page_num = @2;
                NSArray *readedJobIdArray = [DataBaseTool readedJobIdArray];
                for (JobModel *obj in array) {
                    // 设置岗位已读/未读状态
                    [obj checkReadStateWithReadedJobIdArray:readedJobIdArray];
                    
                    [weakSelf.dataSource addObject:obj];
                }
            }else{
                weakSelf.viewWithNoData.hidden = NO;
            }
            
//            if ([XSJUserInfoData isReviewAccount]) {
//            
//                //隐藏部分兼职
//                NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
//                for (int i = 0; i < weakSelf.dataSource.count; i++) {
//                    JobModel *model = weakSelf.dataSource[i];
//                    if ([model.job_title rangeOfString:@"试玩"].location != NSNotFound || [model.job_title rangeOfString:@"苹果手机"].location != NSNotFound || [model.job_title rangeOfString:@"优惠券"].location != NSNotFound) {
//                        [indexs addIndex:i];
//                    }
//                }
//                [weakSelf.dataSource removeObjectsAtIndexes:indexs];
//            }
            if(globaModel.is_need_hide_limit_job.integerValue == 1 ){
                
                //隐藏部分兼职
                NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
                for (int i = 0; i < weakSelf.dataSource.count; i++) {
                    id model = weakSelf.dataSource[i];
                    if ([model isKindOfClass:[JobModel class]]) {
                        JobModel *jModel = model;
                        if (jModel.job_type.integerValue == 5) {
                            [indexs addIndex:i];
                        }
                    }
                    
                }
                [weakSelf.dataSource removeObjectsAtIndexes:indexs];
                
            }

            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
     ClientGlobalInfoRM* globaModel = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    [[XSJRequestHelper sharedInstance] queryJobListFromApp:self.param block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"self_job_list"]];
            if (array.count) {
                weakSelf.param.queryParam.page_num = @(weakSelf.param.queryParam.page_num.integerValue + 1);
                [weakSelf.dataSource addObjectsFromArray:array];
              
//                if ([XSJUserInfoData isReviewAccount]) {
//                    //隐藏部分兼职
//                    NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
//                    for (int i = 0; i < weakSelf.dataSource.count; i++) {
//                        JobModel *model = weakSelf.dataSource[i];
//                        if ([model.job_title rangeOfString:@"试玩"].location != NSNotFound || [model.job_title rangeOfString:@"苹果手机"].location != NSNotFound || [model.job_title rangeOfString:@"优惠券"].location != NSNotFound) {
//                            [indexs addIndex:i];
//                        }
//                    }
//                    [weakSelf.dataSource removeObjectsAtIndexes:indexs];
//                }
                
                if(globaModel.is_need_hide_limit_job.integerValue == 1 ){
                    
                    //隐藏部分兼职
                    NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
                    for (int i = 0; i < weakSelf.dataSource.count; i++) {
                        id model = weakSelf.dataSource[i];
                        if ([model isKindOfClass:[JobModel class]]) {
                            JobModel *jModel = model;
                            if (jModel.job_type.integerValue == 5) {
                                [indexs addIndex:i];
                            }
                        }
                        
                    }
                    [weakSelf.dataSource removeObjectsAtIndexes:indexs];
                    
                }

                [weakSelf.tableView reloadData];
            }
        }
    }];
}

#pragma mark - uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
    cell.delegate = self;
    
    JobModel* model = self.dataSource[indexPath.row];
    [cell refreshWithData:model];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
    
    return cell;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
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
    
    //    NSArray *tmpJobIdArray = [self.arrayData valueForKeyPath:@"job_id"];
    //    NSMutableArray *jobIdArray = [NSMutableArray array];
    //    for (NSNumber *num in tmpJobIdArray) {
    //        if (num) {
    //            NSString *jobIdStr = num.stringValue;
    //            [jobIdArray addObject:jobIdStr];
    //        }
    //    }
    
    JobDetail_VC *vc = [[JobDetail_VC alloc] init];
    vc.jobId = jobId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ***** JSDropDownMenuSelectDelegate ******
- (void)menu:(JSDropDownMenu *)menu didSelectResult:(NSString *)result{
    ELog(@"JSDropDownMenuSelectDelegate");

    
    self.param.content = result;
    self.param.queryParam.page_num = @1;
//    _jobExpressVC.requestParam.content = result;
//    _jobExpressVC.requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
//    _jobExpressVC.requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
//    
    [self headerRefresh];
//    self.leftTableView.scrollEnabled = !menu.show;
}

//- (void)menuWillShow:(JSDropDownMenu *)menu{
//    CGFloat tableHeaderViewHeight = self.tableHeaderView.height;
//    CGFloat contentOffsetY = self.leftTableView.contentOffset.y;
//    
//    if (contentOffsetY < tableHeaderViewHeight) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.leftTableView.contentOffset = CGPointMake(0, tableHeaderViewHeight - 64);
//        }];
//    }
//}
//
//- (void)menuDidShow:(JSDropDownMenu *)menu{
//    self.leftTableView.scrollEnabled = !menu.show;
//    //    self.leftTableView.footer.hidden = YES;
//}

#pragma mark - 按钮相应
- (void)searchBtnOnClick:(UIButton *)sender{
    JobSearchList_VC *vc = [[JobSearchList_VC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (JSDropDownMenu *)tableSectionView{
    if (!_tableSectionView) {
        _tableSectionView = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
        _tableSectionView.indicatorColor = [UIColor XSJColor_tGrayDeepTinge];
        _tableSectionView.indicatorHightColor = MKCOLOR_RGB(0, 188, 212);
        _tableSectionView.separatorColor = MKCOLOR_RGB(233, 233, 233);
        _tableSectionView.textColor = [UIColor XSJColor_tGrayDeepTinge];
        _tableSectionView.textHightColor = MKCOLOR_RGB(0, 188, 212);
        _tableSectionView.dataSource = self.menuDataSource;
        _tableSectionView.delegate = self.menuDataSource;
        _tableSectionView.isViewAllParttime = YES;
        _tableSectionView.selectDelegate = self;
    }
    return _tableSectionView;
}

- (MenuDataSource *)menuDataSource{
    if (!_menuDataSource) {
        _menuDataSource = [[MenuDataSource alloc] init];
    }
    return _menuDataSource;
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
