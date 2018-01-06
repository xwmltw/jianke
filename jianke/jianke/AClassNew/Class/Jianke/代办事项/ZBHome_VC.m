//
//  ZBHome_VC.m
//  jianke
//
//  Created by yanqb on 2016/12/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ZBHome_VC.h"
#import "WebView_VC.h"
#import "ZBBannerView.h"
#import "ZBTopView.h"
#import "ZBHomeCell.h"

#import "XSJRequestHelper.h"
#import "JKHomeModel.h"
#import "ZhaiTaskModel.h"
#import "DataBaseTool.h"

@interface ZBHome_VC () <ZBBannerViewDelegate, ZBTopViewDelegate>{
    BOOL _isRefresh;    //在tabbar的众包页无效
}

@property (nonatomic, strong) QueryParamModel *queryParam;
@property (nonatomic, strong) ZBBannerView *zbBannerView;
@property (nonatomic, strong) ZBTopView *zbTopView;
@property (nonatomic, copy) NSArray *taskArr;

@end

@implementation ZBHome_VC

- (void)viewDidLoad {
    self.isRootVC = !self.isnotBelongsTabBar;
    [super viewDidLoad];
    self.navigationItem.title = @"众包任务";
    self.queryParam = [[QueryParamModel alloc] init];
    [WDNotificationCenter addObserver:self selector:@selector(loginSuccess) name:WDNotifi_LoginSuccess object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(reloadData) name:AppWillBecomeBeforeground object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"frequent_icon_wenhao"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToZhaiHelp)];
    [self initUIWithType:DisplayTypeOnlyTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshType = RefreshTypeAll;
    [self.tableView registerNib:nib(@"ZBHomeCell") forCellReuseIdentifier:@"ZBHomeCell"];
    [self initWithNoDataViewWithStr:@"暂无任务数据" onView:self.tableView];
    self.viewWithNoData.y += 180;
    self.dataSource = [[[UserData sharedInstance] getZBHomeList] mutableCopy];
    [self headerRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserData sharedInstance].isRefreshZBHome) {
        [UserData sharedInstance].isRefreshZBHome = NO;
        [self headerRefresh];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)initHeaderView{
    __block CGFloat tableHeaderViewH = 0;
    UIView *tableHeaderView = [[UIView alloc] init];
    
    WEAKSELF
    [[XSJRequestHelper sharedInstance] getClientGlobalInfoWithBlock:^(ClientGlobalInfoRM *globalInfo) {
        if (globalInfo) {
            if ([[UserData sharedInstance] isLogin]) {
                JKModel *jkMolde = [[UserData sharedInstance] getJkModelFromHave];
                [weakSelf.zbTopView setModel:jkMolde];
                tableHeaderViewH += 58;
                [tableHeaderView addSubview:weakSelf.zbTopView];
                
                [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *jkModel) {
                    if (jkModel) {
                        [weakSelf.zbTopView setModel:jkModel];
                    }
                }];
            }else{
                [weakSelf.zbTopView removeFromSuperview];
                weakSelf.zbTopView = nil;
            }
            
            NSArray *array = [MenuBtnModel objectArrayWithKeyValuesArray:globalInfo.zhai_app_special_entry_list];
            weakSelf.taskArr = array;
            if (array.count) {
                [self.zbBannerView setModelArr:array];
                [tableHeaderView addSubview:self.zbBannerView];
                tableHeaderViewH += (162 + 16);
                
                [self.zbBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(tableHeaderView);
                    make.height.equalTo(@162);
                }];
            }else{
                [self.zbBannerView removeFromSuperview];
                self.zbBannerView = nil;
            }
            tableHeaderView.height = tableHeaderViewH;
            weakSelf.tableView.tableHeaderView = tableHeaderView;
        }
    }];
}

- (void)headerRefresh{
    [self initHeaderView];
    self.queryParam.page_num = @1;
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryZhaiTaskListWithCityId:[UserData sharedInstance].city.id queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) {
            NSArray *array = [ZhaiTaskModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"zhai_task_list"]];
            if (array.count) {
                [self checkZhaiReadedStatusWith:array];
                weakSelf.dataSource = [array mutableCopy];
                weakSelf.viewWithNoData.hidden = YES;
                weakSelf.queryParam.page_num = @2;
            }else{
                [weakSelf.dataSource removeAllObjects];
                weakSelf.viewWithNoData.hidden = NO;
            }
            [weakSelf.tableView reloadData];
            [[UserData sharedInstance] saveZBHomeListWithArray:weakSelf.dataSource];
        }
    }];
}

- (void)footerRefresh{
    WEAKSELF
    [[XSJRequestHelper sharedInstance] queryZhaiTaskListWithCityId:[UserData sharedInstance].city.id queryParam:self.queryParam block:^(ResponseInfo *response) {
        [weakSelf.tableView.footer endRefreshing];
        if (response) {
            NSArray *array = [ZhaiTaskModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"zhai_task_list"]];
            if (array.count) {
                [weakSelf checkZhaiReadedStatusWith:array];
                [weakSelf.dataSource addObjectsFromArray:array];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue + 1);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZBHomeCell" forIndexPath:indexPath];
    ZhaiTaskModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[UserData sharedInstance] isLogin]) {
        _isRefresh = YES;
        [self pushToTaskDetailWithIndexPath:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [[UserData sharedInstance] userIsLogin:^(id result) {
            if (result) {
                _isRefresh = YES;
                [self initHeaderView];
                [self pushToTaskDetailWithIndexPath:indexPath];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

- (void)pushToTaskDetailWithIndexPath:(NSIndexPath *)indexPath{
    ZhaiTaskModel *model = [self.dataSource objectAtIndex:indexPath.row];
    model.isRead = YES;
    [DataBaseTool saveReadedTaksId:model.task_id.description withEndTime:model.task_dead_time.description];
    
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    viewCtrl.url = [NSString stringWithFormat:@"%@/m/task/%@", URL_ZhaiTaskHttp, model.task_uuid];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    WEAKSELF
    viewCtrl.block = ^(id result){
        [weakSelf headerRefresh];
    };
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark - ZBBannerViewDelegate
- (void)zbBannerView:(ZBBannerView *)bannerView btnOnClick:(NSInteger)index{
    if (self.taskArr.count < (index + 1)) {
        return;
    }
    MenuBtnModel *model = [self.taskArr objectAtIndex:index];
    
    switch (model.special_entry_type_new.integerValue) {
        case 1:{ // 1：应用内打开链接
            if (!model.special_entry_url || model.special_entry_url.length < 5) {
                return;
            }
            NSString *url = [model.special_entry_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            WebView_VC* vc = [[WebView_VC alloc] init];
            vc.url = url;
            vc.uiType = WebViewUIType_Feature;
            vc.title = model.special_entry_title;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2: {// 2：应用外打开链接
            if (!model.special_entry_url || model.special_entry_url.length < 5) {
                return;
            }
            NSString *url = [model.special_entry_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
            break;
            
        case 3:{ // 3：岗位列表
//            CityModel *city = [[UserData sharedInstance] city];
//            LocalModel *localModel = [[UserData sharedInstance] local];
//            
//            // 跳转普通岗位列表页面
//            RequestParamWrapper *requestParam = [[RequestParamWrapper alloc] init];
//            requestParam.serviceName = @"shijianke_querySpecialEntryJobList";
//            requestParam.typeClass = NSClassFromString(@"JobModel");
//            requestParam.arrayName = @"self_job_list";
//            requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
//            requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
//            requestParam.content = [NSString stringWithFormat:@"\"special_entry_id\":\"%@\", \"city_id\":\"%@\", \"coord_latitude\":\"%@\", \"coord_longitude\":\"%@\"", model.special_entry_id.stringValue, city.id.stringValue, localModel?localModel.latitude:@"0", localModel?localModel.longitude:@"0"];
//            
//            JobController *vc = [[JobController alloc] init];
//            vc.titleName = model.special_entry_title;
//            vc.requestParam = requestParam;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{ // 4: 抢单列表
//            // 跳转抢单岗位列表页面
//            CityModel *city = [[UserData sharedInstance] city];
//            
//            // 跳转普通岗位列表页面
//            RequestParamWrapper *requestParam = [[RequestParamWrapper alloc] init];
//            requestParam.serviceName = @"shijianke_queryGrabSingleJobList";
//            requestParam.typeClass = NSClassFromString(@"JobModel");
//            requestParam.arrayName = @"self_job_list";
//            requestParam.queryParam.page_size = [NSNumber numberWithInt:30];
//            requestParam.queryParam.page_num = [NSNumber numberWithInt:1];
//            requestParam.content = [NSString stringWithFormat:@"query_condition:{city_id:%@}", city.id.stringValue];
//            
//            JobController *vc = [[JobController alloc] init];
//            vc.isSeizeJob = YES;
//            vc.titleName = model.special_entry_title;
//            vc.requestParam = requestParam;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
//            TopicJobList_VC* vc = [[TopicJobList_VC alloc] init];
//            vc.adDetailId = model.job_topic_id;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}

#pragma mark - ZBTopViewDelegate
- (void)zbTopView:(ZBTopView *)view btnAction:(BtnOnClickActionType)actionType{
    ClientGlobalInfoRM *globalInfo = [[XSJRequestHelper sharedInstance] getClientGlobalModel];
    switch (actionType) {
        case BtnOnClickActionType_zhaiTaskApplying:{
            if (globalInfo.wap_url_list && globalInfo.wap_url_list.jianke_task_applying_list_url.length) {
                WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                viewCtrl.url = globalInfo.wap_url_list.jianke_task_applying_list_url;
                viewCtrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
        }
            break;
        case BtnOnClickActionType_zhaiTaskSalary:{
            if (globalInfo.wap_url_list && globalInfo.wap_url_list.jianke_task_salary_list_url.length) {
                WebView_VC *viewCtrl = [[WebView_VC alloc] init];
                viewCtrl.url = globalInfo.wap_url_list.jianke_task_salary_list_url;
                viewCtrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewCtrl animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)loginSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self headerRefresh];
    });
}

- (void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self headerRefresh];
    });
}

- (void)jumpToZhaiHelp{
    WebView_VC *viewCtrl = [[WebView_VC alloc] init];
    viewCtrl.url = [NSString stringWithFormat:@"%@%@", URL_ZhaiTaskHttp, KUrl_toHelpCenterPage];
    viewCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)checkZhaiReadedStatusWith:(NSArray *)modelArr{
    if (!modelArr) {
        return;
    }
    
    NSArray *readedArr = [DataBaseTool queryAllReadedTask];
    ZhaiTaskModel *taskModel = nil;
    
    for (NSInteger index = 0; index < modelArr.count; index++) {
        taskModel = [modelArr objectAtIndex:index];
        
        for (NSString *readedTaskId in readedArr) {
            if ([readedTaskId isEqualToString:taskModel.task_id.description]) {
                taskModel.isRead = YES;
                break;
            }
        }
        
    }
}

#pragma mark -  lazy

- (ZBTopView *)zbTopView{
    if (!_zbTopView) {
        _zbTopView = [[ZBTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        _zbTopView.delegate = self;
    }
    return _zbTopView;
}

- (ZBBannerView *)zbBannerView{
    if (!_zbBannerView) {
        _zbBannerView = [[ZBBannerView alloc] init];
        _zbBannerView.delegate = self;
    }
    return _zbBannerView;
}

- (void)backToLastView{
    if (self.isnotBelongsTabBar && _isRefresh) {
        [[UserData sharedInstance] setIsRefreshZBHome:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
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
