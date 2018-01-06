//
//  TopicJobList_VC.m
//  jianke
//
//  Created by xiaomk on 16/3/2.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "TopicJobList_VC.h"
#import "WDConst.h"
#import "JobExpress_VC.h"
#import "DetailTopicInfoModel.h"
#import "ShareInfoModel.h"
#import "JobModel.h"
#import "JobExpressCell.h"
#import "JobDetailMgr_VC.h"
#import "JobDetail_VC.h"

@interface TopicJobList_VC () <JobExpressCellDelegate> {
    JobExpress_VC* _jobExpressVC;
    DetailTopicInfoModel *_detailTopicModel;
}

//@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) QueryParamModel *queryParam;
@end

@implementation TopicJobList_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton* btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted];
    [btnShare addTarget:self action:@selector(btnShareOnclick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self initUIWithType:DisplayTypeOnlyTableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor XSJColor_grayDeep];
    self.refreshType = RefreshTypeHeader;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.8)];
    
    [self initWithNoDataViewWithStr:@"暂无数据" onView:self.view];
  
    GetTopicDetailPM* getModel = [[GetTopicDetailPM alloc] init];
    getModel.topic_id = self.adDetailId;
    
    NSString* content = [getModel getContent];
    WEAKSELF
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getTopicDetail" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            _detailTopicModel = [DetailTopicInfoModel objectWithKeyValues:response.content[@"topic_detail"]];
            weakSelf.title = _detailTopicModel.topic_name;
            if (_detailTopicModel.topic_desc_url && _detailTopicModel.topic_desc_url.length > 0) {
                [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:_detailTopicModel.topic_desc_url] placeholderImage:[UIHelper getDefaultImage]];
            }
        }
    }];
    
    [self headerRefresh];
}

- (void)headerRefresh{
    CityModel* nowCity = [[UserData sharedInstance] city];
    
    _jobExpressVC.requestParam.arrayName = @"self_job_list";
    NSString *content = [NSString stringWithFormat:@"query_condition:{\"topic_id\":\"%@\",\"city_id\":\"%@\"}",self.adDetailId, nowCity.id ? nowCity.id : @"211"];
    
    RequestInfo* info = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListFromApp" andContent:content];
    info.isShowLoading = NO;
    WEAKSELF
    [info sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.tableView.header endRefreshing];
        if (response && response.success) {
            weakSelf.viewWithNoNetwork.hidden = YES;
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"self_job_list"]];
            if (array.count > 0) {
                weakSelf.dataSource = [array mutableCopy];
                weakSelf.viewWithNoData.hidden = YES;
            }else{
                [weakSelf.dataSource removeAllObjects];
                weakSelf.viewWithNoData.hidden = NO;
            }
            [weakSelf.tableView reloadData];
        }else{
            weakSelf.viewWithNoData.hidden = YES;
            weakSelf.viewWithNoNetwork.hidden = NO;
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count ? 1 : 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource ? self.dataSource.count : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
    cell.delegate = self;
    if (self.dataSource.count <= indexPath.row) {
        return cell;
    }
    
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
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_WIDTH * 0.8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.imageView;
}

- (void)btnShareOnclick:(UIButton*)sender{
    ShareInfoModel* model = [[ShareInfoModel alloc] init];
    model.share_title = _detailTopicModel.topic_name;
    model.share_content = _detailTopicModel.topic_desc;
    model.share_url = _detailTopicModel.web_detail_url;
    model.share_img_url = _detailTopicModel.topic_desc_url;
    [ShareHelper platFormShareWithVc:self info:model block:^(id obj) {
    }];
}

- (void)jobExpressCell_closeSSPAD{
    if (self.dataSource && self.dataSource.count >= 11) {
        [self.dataSource removeObjectAtIndex:10];
        [self.tableView reloadData];
        [XSJADHelper closeAdWithADType:XSJADType_homeJobList];
    }
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
