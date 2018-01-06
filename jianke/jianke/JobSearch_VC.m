//
//  JobSearch_VC.m
//  jianke
//
//  Created by 时现 on 15/11/7.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobSearch_VC.h"
#import "UserData.h"
#import "BtnView.h"
#import "DataBtn.h"
#import "JobClassifierModel.h"
#import "JobTopicModel.h"
#import "JobController.h"
#import "JobController.h"
#import "JobExpress_VC.h"
#import "RequestParamWrapper.h"
#import "JobModel.h"
#import "JobExpressCell.h"
#import "JobDetail_VC.h"
#import "CitySearchBar.h"

@interface JobSearch_VC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,BtnViewDelegate,WDTableDelegate>
{
    BOOL _isGetLast;
    JobModel *_jobModel;
}
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UISearchDisplayController *searchController; /*!< searchDisplayController */
@property (nonatomic, strong) NSArray *searchResuleArray; /*!< 搜索结果数组 */
@property (nonatomic, strong) UIView *allView;
@property (nonatomic, weak) BtnView *jobClassBtnView;
@property (nonatomic, weak) BtnView *topicBtnView;
@property (nonatomic, assign) float viewHeight;
@property (nonatomic, strong) UIView *tpView;/*!< 专题View */
@property (nonatomic, strong) UIView *jobClassView; /*!< 分类View */

@property (nonatomic, strong) JobExpress_VC *jobExpressVC;
@property (nonatomic, strong) NSMutableArray* arrayData;
@property (nonatomic, copy) NSString *IDContent;
@property (nonatomic, strong) QueryParamModel* queryParam;

@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation JobSearch_VC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"岗位搜索";
    self.viewHeight = 0;
    _isGetLast = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CitySelectCell" bundle:nil] forCellReuseIdentifier:@"CitySelectCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 44)];

    searchBar.delegate = self;
    searchBar.placeholder = @"输入岗位关键词";
//    searchBar.tintColor = [UIColor XSJColor_base];
//    searchBar.barTintColor = [UIColor XSJColor_base];

    self.tableView.tableHeaderView = searchBar;
    self.searchBar = searchBar;
    
    // 设置UISearchDisplayController
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.searchResultsDelegate = self;
    searchController.searchResultsDataSource = self;
    self.searchController = searchController;
    
    self.searchController.searchResultsTableView.tableFooterView = [[UIView alloc]init];
    
    [self initTopicView];
    [self.searchController.searchResultsTableView registerNib:[UINib nibWithNibName:@"JobExpressCell" bundle:nil] forCellReuseIdentifier:@"JobExpressCell"];
    [self getData];
}
//专题和分类view
-(void)initTopicView
{
    self.allView = [[ UIView alloc]initWithFrame:CGRectMake(0, 44, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    self.allView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.allView];
    
}
//服务器交互
- (void)getData
{
    // 获取岗位列表
    WEAKSELF
    [[UserData sharedInstance] getJobTopicListWithBlock:^(NSArray *jobTopicArray) {
        
        if (jobTopicArray && jobTopicArray.count) {
            
            BtnView *topicBtnView = [[BtnView alloc] initWithWidth:SCREEN_WIDTH - 40 dataType:DataTypeTopic dataArray:jobTopicArray];
            
            topicBtnView.delegate = self;
            weakSelf.topicBtnView = topicBtnView;
            
            UILabel *labelTopic = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
            labelTopic.text = @"专题";
            labelTopic.tintColor = MKCOLOR_RGB(144, 144, 144);
            UIView *fenge = [[UIView alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-10, 1)];
            fenge.backgroundColor = MKCOLOR_RGB(144, 144, 144);
            [self.allView addSubview:labelTopic];
            [self.allView addSubview:fenge];
            self.viewHeight = topicBtnView.height;
            
            self.tpView = [[UIView alloc]initWithFrame:CGRectMake(10,50 , topicBtnView.width, topicBtnView.height)];
            [self.allView addSubview:self.tpView];
            [weakSelf.tpView addSubview:topicBtnView];
        }
        
        
        [[UserData sharedInstance] getJobClassifierListWithBlock:^(NSArray *jobClassArray) {
            
            if (jobClassArray && jobClassArray.count) {
                
                BtnView *jobClassBtnView = [[BtnView alloc] initWithWidth:SCREEN_WIDTH - 40 dataType:DataTypeJobClass dataArray:jobClassArray];
                
                jobClassBtnView.delegate = self;
                weakSelf.jobClassBtnView = jobClassBtnView;
                UILabel *labelTopic = [[UILabel alloc]initWithFrame:CGRectMake(20,self.viewHeight + 50, 40, 40)];
                labelTopic.text = @"分类";
                labelTopic.tintColor = MKCOLOR_RGB(144, 144, 144);
                UIView *fenge = [[UIView alloc]initWithFrame:CGRectMake(10,self.viewHeight + 80, SCREEN_WIDTH-10, 1)];
                fenge.backgroundColor = MKCOLOR_RGB(144, 144, 144);
                [self.allView addSubview:labelTopic];
                [self.allView addSubview:fenge];
                
                self.jobClassView = [[UIView alloc]initWithFrame:CGRectMake(10, self.viewHeight + 100, jobClassBtnView.width, jobClassBtnView.height)];
                [self.allView addSubview:self.jobClassView];
                [weakSelf.jobClassView addSubview:jobClassBtnView];
                
            }
        }];
    }];
    
}
-(void)backToLastView{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.arrayData) {
            return self.arrayData.count;
        }
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobExpressCell *cell = [JobExpressCell cellWithTableView:tableView];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _jobModel = self.arrayData[indexPath.row];
        [cell refreshWithData:_jobModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JobDetail_VC* vc = [[JobDetail_VC alloc] init];
    JobModel *model;
    model = self.arrayData[indexPath.row];
    vc.jobId = [NSString stringWithFormat:@"%@", model.job_id];
    vc.userType = WDLoginType_JianKe;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchController.searchResultsTableView) {
        return 72;
    }
    return 0;
}

#pragma mark - UISearchBarDelegete
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    ELog(@"=====searchText:%@",searchText);
    if (searchText && searchText.length) {
        
        NSString *cityId = [[UserData sharedInstance] city].id.description;
        self.IDContent = [NSString stringWithFormat:@"query_condition:{city_id:%@, job_title:\"%@\", is_include_grab_single:\"%@\", \"coord_use_type\":\"1\"}", cityId, searchText, @"1"];
        [self sendRequest];
        
    }
}

- (void)sendRequest{
    if (self.IDContent == nil) {
        NSAssert(NO, @"requestParam请求参数不存在");
        return;
    }
    self.queryParam = [[QueryParamModel alloc]init];
    self.queryParam.page_num = @(1);
    self.queryParam.page_size = @(30);
    self.queryParam.timestamp = @((long)([[NSDate date] timeIntervalSince1970] * 1000));
    
    NSString *content = [NSString stringWithFormat:@"%@,%@",self.IDContent,[self.queryParam getContent]];
    
    RequestInfo* info = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListFromApp" andContent:content];
    
    [info sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        
//        [WDNotificationCenter postNotificationName:WDNotification_updateRedPoint object:nil];
        
        if (response && [response success]) {
            NSDictionary* query_param = [response.content objectForKey:@"query_param"];
            if (query_param) {
                self.queryParam = [QueryParamModel objectWithKeyValues:query_param];
            }
            self.arrayData = [NSMutableArray arrayWithArray:[JobModel objectArrayWithKeyValuesArray:response.content[@"self_job_list"]]];

            [self.searchController.searchResultsTableView reloadData];
        }else{
            [self.searchController.searchResultsTableView reloadData];



        }
        
    }];
}
#pragma mark - BtnViewDelegate
- (void)btnView:(BtnView *)btnView didClickBtn:(DataBtn *)btn
{
    NSString *cityId = [[UserData sharedInstance] city].id.description;
    
    // 岗位分类
    if (btnView == self.jobClassBtnView) {
        
        DLog(@"岗位分类点击");
        JobClassifierModel *jobClass = btn.dataModel;
        NSString *jobClassId = jobClass.job_classfier_id.description;
        JobController *vc = [[JobController alloc] init];
        vc.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, job_type_id:[%@]}", cityId, jobClassId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // 岗位专题
    if (btnView == self.topicBtnView) {
        
        DLog(@"岗位专题点击");
        JobTopicModel *jobTopic = btn.dataModel;
        NSString *topicId = jobTopic.topic_id.description;
        JobController *vc = [[JobController alloc] init];
        vc.content = [NSString stringWithFormat:@"query_condition:{city_id:%@, topic_id:%@}", cityId, topicId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
