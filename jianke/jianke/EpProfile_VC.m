//
//  EpProfile_VC.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EpProfile_VC.h"
#import "EpProfileHeadeView.h"
#import "WDConst.h"
#import "EpProfileCell.h"
#import "EpProfileCell_summary.h"
#import "JobExpressCell.h"
#import "JobModel.h"
#import "EpPostedJobList_VC.h"
#import "JobDetail_VC.h"
#import "EprofileCaseCell.h"
#import "WebView_VC.h"
#import "WDChatView_VC.h"
#import "PictureBrowser.h"

#define TableViewTag 100

@interface EpProfile_VC () <EpProfileHeadeViewDelegate, EpProfileCellDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) EpProfileHeadeView *topView;
@property (nonatomic, strong) UIView *jobTableViewWithNoData;
@property (nonatomic, strong) UIView *caseTableViewWithNoData;
@property (nonatomic, weak) UITableView *indexTableView;
@property (nonatomic, strong) NSMutableArray *firstArr;
@property (nonatomic, weak) UITableView *jobTableView;
@property (nonatomic, strong) NSMutableArray *secondArr;
@property (nonatomic, weak) UITableView *caseTableView;
@property (nonatomic, strong) NSMutableArray *thirdArr;
@property (nonatomic, weak) UIButton *botBtn;
@property (nonatomic, assign) BOOL isFirstRefreshJobTableview;

@end

@implementation EpProfile_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)getData{
    if (self.isLookForJK) {
        ELog(@"=====lookOther");
        if (self.isFromGroupMembers && self.accountId) {
            WEAKSELF
            [[UserData sharedInstance] getEPModelWithEpAccount:self.accountId block:^(EPModel* model) {
                _epModel = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf updateUIWithData];
                });
            }];
        }else if (self.enterpriseId.length > 0){
            WEAKSELF
            [[UserData sharedInstance] getEPModelWithEpid:self.enterpriseId block:^(EPModel* model) {
                _epModel = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf updateUIWithData];
                });
            }];
        }
    }else{
        WEAKSELF
        [[UserData sharedInstance] getEPModelWithBlock:^(EPModel *result) {
            if (result) {
                weakSelf.epModel = result;
                [weakSelf updateUIWithData];
            }
        }];
    }
}

- (void)updateUIWithData{
    [self.indexTableView reloadData];
    [self.topView setEpModel:_epModel];
    [self updateBtnStatus];
}

- (void)updateBtnStatus{
    self.botBtn.userInteractionEnabled = YES;
    if (self.epModel.student_focus_status.integerValue == 1) {
//        [self.botBtn setImage:[UIImage imageNamed:@"my_subscrible_icon"] forState:UIControlStateNormal];
        [self.botBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
//        [self.botBtn setImage:[UIImage imageNamed:@"my_focus_icon"] forState:UIControlStateNormal];
        [self.botBtn setTitle:@"+ 加关注" forState:UIControlStateNormal];
    }
}

- (void)loadDatas{
    self.isFirstRefreshJobTableview = YES;
    self.firstArr = [NSMutableArray array];
    [self.firstArr addObject:@(EpProfileCellType_hireCity)];
    [self.firstArr addObject:@(EpProfileCellType_industry)];
    [self.firstArr addObject:@(EpProfileCellType_commpany)];
    [self.firstArr addObject:@(EpProfileCellType_shortCommpany)];
    [self.firstArr addObject:@(EpProfileCellType_summary)];

    self.secondArr = [NSMutableArray array];
    self.thirdArr = [NSMutableArray array];
}

- (void)setupViews{
    // topview
    EpProfileHeadeView *topView = [[EpProfileHeadeView alloc] init];
    topView.delegate = self;
    _topView = topView;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@188);
    }];
    if (self.isfromIM) {
        UIBarButtonItem *phoneBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"card_icon_phone"] style:UIBarButtonItemStyleDone target:self action:@selector(phoneClick)];
        UIBarButtonItem *chatBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"card_icon_msg"] style:UIBarButtonItemStyleDone target:self action:@selector(chatClick)];
        self.navigationItem.rightBarButtonItems = @[phoneBtn, chatBtn];
    }
    if (self.isLookForJK) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"+ 加关注" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:MKCOLOR_RGB(0, 188, 212)];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button addTarget:self action:@selector(borBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = NO;
        [button setCornerValue:5];
        _botBtn = button;
        [topView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.labName);
            make.right.equalTo(self.view).offset(-16);
            make.height.equalTo(@30);
            make.width.equalTo(@60);
        }];
//        [button addBorderInDirection:BorderDirectionTypeTop borderWidth:0.7 borderColor:[UIColor XSJColor_clipLineGray] isConstraint:YES];
    }else{
        NSAssert(self.epModel, @"雇主视角请为epModel赋值!!");
        [self.topView setEpModel:_epModel];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    }
    self.indexTableView.hidden = NO;
    [self.indexTableView registerNib:nib(@"EpProfileCell") forCellReuseIdentifier:@"EpProfileCell"];
    [self.indexTableView registerNib:nib(@"EpProfileCell_summary") forCellReuseIdentifier:@"EpProfileCell_summary"];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case TableViewTag:{
            return self.firstArr.count;
        }
        case TableViewTag + 1:{
            return self.secondArr.count;
        }
        case TableViewTag + 2:{
            return self.thirdArr.count;
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TableViewTag) {
        EpProfileCellType cellType = [[self.firstArr objectAtIndex:indexPath.row] integerValue];
        switch (cellType) {
            case EpProfileCellType_hireCity:
            case EpProfileCellType_industry:
            case EpProfileCellType_commpany:
            case EpProfileCellType_shortCommpany:{
                EpProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EpProfileCell" forIndexPath:indexPath];
                cell.delegate = self;
                cell.isLookForJK = self.isLookForJK;
                [cell setEpModel:_epModel cellType:cellType];
                return cell;
            }
            case EpProfileCellType_summary:{
                EpProfileCell_summary *cell = [tableView dequeueReusableCellWithIdentifier:@"EpProfileCell_summary" forIndexPath:indexPath];
                [cell setModel:self.epModel];
                return cell;
            }
        }
    }else if (tableView.tag == TableViewTag + 1){
        JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
        JobModel* model = self.secondArr[indexPath.row];
        cell.isFromEpProfile = YES;
        cell.indexPath = indexPath;
        [cell refreshWithData:model];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v210_pressed_background"]];
        return cell;
    }else if (tableView.tag == TableViewTag + 2){
        EprofileCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EprofileCaseCell" forIndexPath:indexPath];
        ServiceTeamApplyModel *model = [self.thirdArr objectAtIndex:indexPath.row];
        [cell setModel:model];
        return cell;
    }
    
    return nil;
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TableViewTag) {
        EpProfileCellType cellType = [[self.firstArr objectAtIndex:indexPath.row] integerValue];
        switch (cellType) {
            case EpProfileCellType_commpany:
            case EpProfileCellType_shortCommpany:
            case EpProfileCellType_industry:
            case EpProfileCellType_hireCity:
                return 49.0f;
            case EpProfileCellType_summary:{
                return self.epModel.cellHeight;
            }
        }
        
    }else if (tableView.tag == TableViewTag + 1){
        return 91.0f;
    }else if (tableView.tag == TableViewTag + 2){
        return 49.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView.tag == TableViewTag +1 && self.secondArr.count >= 5) {
        UIView *view = [[UIView alloc] init];
        
        UIButton *button = [UIButton buttonWithTitle:@"查看更多 >" bgColor:[UIColor XSJColor_grayTinge] image:nil target:self sector:@selector(viewMoreAction:)];
        [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [view addSubview:button];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor XSJColor_clipLineGray];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(view);
            make.height.equalTo(@0.7);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == TableViewTag + 1 && self.secondArr.count >= 5) {
        return 44.0f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (tableView.tag) {
        case TableViewTag + 1:{
            DLog(@"跳转到岗位详情");
            JobModel *jobModel = [self.secondArr objectAtIndex:indexPath.row];
            JobDetail_VC* vc = [[JobDetail_VC alloc] init];
            vc.jobId = jobModel.job_id.description;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TableViewTag + 2:{
            ServiceTeamApplyModel *model = [self.thirdArr objectAtIndex:indexPath.row];
            WebView_VC *viewCtrl = [[WebView_VC alloc] init];
            NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_HttpServer, KUrl_toTeamApplyCaseListPage, model.id];
            viewCtrl.url = url;
            [self.navigationController pushViewController:viewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - epProfileHeadeView delegate

- (void)epProfileHeadeView:(EpProfileHeadeView *)headerView actionType:(BtnOnClickActionType)actionType{
    switch (actionType) {
        case BtnOnClickActionType_epInfoIndex:{
            self.indexTableView.hidden = NO;
            if (_jobTableView) {
                self.jobTableView.hidden = YES;
            }
            if (self.epModel.is_apply_service_team.integerValue == 1 && _caseTableView) {
                self.caseTableView.hidden = YES;
            }
        }
            break;
        case BtnOnClickActionType_epInfoJob:{
            self.indexTableView.hidden = YES;
            self.jobTableView.hidden = NO;
            if (self.epModel.is_apply_service_team.integerValue == 1 && _caseTableView) {
                self.caseTableView.hidden = YES;
            }
        }
            break;
        case BtnOnClickActionType_epInfoCase:{
            self.indexTableView.hidden = YES;
            if (_jobTableView) {
                self.jobTableView.hidden = YES;
            }
            self.caseTableView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)viewHeadImg:(UIImageView *)imageView{
    if (imageView) {
        [PictureBrowser showImage:imageView];
    }
}

#pragma mark - EpProfileCellDelegate

- (void)EpProfileCell:(EpProfileCell *)cell rightBtnActionType:(BtnOnClickActionType)actionType{
}

#pragma mark - 网络请求

- (void)getJobList{
    WEAKSELF
    NSString* content;
    GetEnterpriscJobModel *reqModel = [[GetEnterpriscJobModel alloc] init];
    reqModel.query_type = @(7);
    QueryParamModel *queryParam = [[QueryParamModel alloc] init];
    queryParam.page_size = @5;
    reqModel.query_param = queryParam;
    reqModel.ent_id = (self.epModel.enterprise_id) ? self.epModel.enterprise_id : nil;
    content = [reqModel getContent];
    
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getEnterpriseSelfJobList_v2" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.jobTableView.header endRefreshing];
        if (response && response.success) {
            NSArray *array = [JobModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"job_list"]];
            if (array.count) {
                weakSelf.secondArr = [array mutableCopy];
                weakSelf.jobTableViewWithNoData.hidden = YES;
                [weakSelf.jobTableView reloadData];
            }else{
                weakSelf.jobTableViewWithNoData.hidden = NO;
            }
        }
    }];
}

- (void)getServiceList{
    WEAKSELF
    NSString *entId = (self.enterpriseId) ? self.enterpriseId : self.epModel.enterprise_id.description;
    [[XSJRequestHelper sharedInstance] queryServiceTeamApplyListWithEntID:entId status:@(2) block:^(ResponseInfo *response) {
        [weakSelf.caseTableView.header endRefreshing];
        if (response) {
            NSArray *array = [ServiceTeamApplyModel objectArrayWithKeyValuesArray:[response.content objectForKey:@"service_team_apply_list"]];
            if (array.count) {
                weakSelf.caseTableViewWithNoData.hidden = YES;
                weakSelf.thirdArr = [array mutableCopy];
                [weakSelf.caseTableView reloadData];
            }else{
                weakSelf.caseTableViewWithNoData.hidden = NO;
            }
        }
    }];
}

#pragma mark - 按钮事件

- (void)borBtnOnClick:(UIButton *)sender{
    ELog(@"加关注");
    WEAKSELF
    if (self.epModel.student_focus_status.integerValue == 1) {
        [MKAlertView alertWithTitle:@"提示" message:@"是否取消关注该雇主？" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[XSJRequestHelper sharedInstance] cancelFocusEntWithAccountId:_epModel.account_id block:^(id result) {
                    if (result) {
                        [UIHelper toast:@"取消关注"];
                        weakSelf.epModel.student_focus_status = @0;
                        [weakSelf updateBtnStatus];
                        
                    }
                }];
            }
        }];

    }else{
        [[XSJRequestHelper sharedInstance] stuFocusEntWithAccountId:_epModel.account_id block:^(id result) {
            if (result) {
                [UIHelper toast:@"已关注"];
                weakSelf.epModel.student_focus_status = @1;
                [weakSelf updateBtnStatus];
            }
        }];
    }
}

- (void)viewMoreAction:(UIButton *)sender{
    ELog(@"查看更多岗位");
    EpPostedJobList_VC *viewCtrl = [[EpPostedJobList_VC alloc] init];
    if (self.isLookForJK) {
        viewCtrl.enterpriseId = self.epModel.enterprise_id;
    }
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

- (void)editAction{
}

#pragma mark - 懒加载

- (UITableView *)indexTableView{
    if (!_indexTableView) {
        UITableView *tableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:self.view];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tag = TableViewTag;
        if (self.isLookForJK) {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(10);
                make.left.right.bottom.equalTo(self.view);
            }];
        }else{
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(10);
                make.left.right.bottom.equalTo(self.view);
            }];
        }
        _indexTableView = tableView;
        [self.view addSubview:tableView];
    }
    return _indexTableView;
}

- (UITableView *)jobTableView{
    if (!_jobTableView) {
        UITableView *tableView = [UIHelper createTableViewWithStyle:UITableViewStyleGrouped delegate:self onView:self.view];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tag = TableViewTag + 1;
        if (self.isLookForJK) {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(10);
                make.bottom.left.right.equalTo(self.view);
            }];
        }else{
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(10);
                make.left.right.bottom.equalTo(self.view);
            }];
        }
        self.jobTableViewWithNoData = [UIHelper noDataViewWithTitle:@"暂无已发布的岗位" titleColor:nil image:@"v3_public_nodata" button:nil];
        [tableView addSubview:self.jobTableViewWithNoData];
        self.jobTableViewWithNoData.frame = CGRectMake(0, 80, self.view.size.width, self.view.size.height);
        self.jobTableViewWithNoData.hidden = YES;
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getJobList];
        }];
        [tableView.header beginRefreshing];
        _jobTableView = tableView;
        [self.view addSubview:tableView];
    }
    return _jobTableView;
}

- (UITableView *)caseTableView{
    if (!_caseTableView) {
        UITableView *tableView = [UIHelper createTableViewWithStyle:UITableViewStylePlain delegate:self onView:self.view];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tag = TableViewTag + 2;
        if (self.isLookForJK) {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(10);
                make.bottom.left.right.equalTo(self.view);
            }];
        }else{
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(10);
                make.left.right.bottom.equalTo(self.view);
            }];
        }
        self.caseTableViewWithNoData = [UIHelper noDataViewWithTitle:@"暂无相关案例" titleColor:nil image:@"v3_public_nodata" button:nil];
        [tableView addSubview:self.caseTableViewWithNoData];
        self.caseTableViewWithNoData.frame = CGRectMake(0, 20, self.view.size.width, self.view.size.height);
        self.caseTableViewWithNoData.hidden = YES;
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getServiceList];
        }];
        [tableView registerNib:nib(@"EprofileCaseCell") forCellReuseIdentifier:@"EprofileCaseCell"];
        [tableView.header beginRefreshing];
        _caseTableView = tableView;
        [self.view addSubview:tableView];
    }
    return _caseTableView;
}

#pragma mark - 其他

/** 打电话 */
- (void)phoneClick{
    [[MKOpenUrlHelper sharedInstance] callWithPhone:_epModel.telphone];
}

/** IM聊天 */
- (void)chatClick{
    NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", _epModel.account_id];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
    request.isShowLoading = NO;
    [request sendRequestToImServer:^(ResponseInfo* response) {
        if (response && [response success]) {
            int type = [[UserData sharedInstance] getLoginType].integerValue == WDLoginType_JianKe ? WDLoginType_Employer : WDLoginType_JianKe;
            [WDChatView_VC openPrivateChatOn:self accountId:_epModel.account_id.description withType:type jobTitle:nil jobId:nil];
        }else {
            [UIHelper toast:@"对不起,该用户未开通IM功能"];
        }
    }];
}

- (void)backToLastView{
    if (self.isLookForJK ) {
        MKBlockExec(self.block, self.epModel.student_focus_status.integerValue != 1);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
