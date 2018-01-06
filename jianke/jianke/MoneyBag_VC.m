//
//  MoneyBag_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/22.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MoneyBag_VC.h"
#import "WDConst.h"
#import "MoneyDetailModel.h"
#import "MoneyBagCell.h"

#import "TencentOpenAPI/TencentOAuth.h"
#import "WXApi.h"
#import "ThirdPartAccountModel.h"
#import "QueryAccountMoneyModel.h"
#import "PayDetail_VC.h"
#import "ImDataManager.h"
#import "WebView_VC.h"
#import "GetMoney_VC.h"
#import "MoneyDetail_VC.h"
#import "JobBillDetail_VC.h"
#import "MoneyBagPasswordManager.h"

@interface MoneyBag_VC ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>{
    
    NSMutableArray* _dataArray;
    NSNumber* _moneyAmount;
    NSNumber* _advanceAmount;
    WechatParmentRequest* _wxGetMoneyRequestModel;
}

@property (nonatomic, strong) QueryParamModel *queryParam;
@property (weak, nonatomic) IBOutlet UILabel *labMoneyNum;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnGetoutMoney;
//@property (weak, nonatomic) IBOutlet UIButton *btnPayMoney;
@property (weak, nonatomic) IBOutlet UILabel *labAdvance;
@property (nonatomic, strong) UIBarButtonItem* rightItem;
@property (nonatomic, strong) NSNumber *alipay_sigle_withdraw_min_limit;//支付宝取出最低限额
@end

@implementation MoneyBag_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除小红点
    if ([XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint) {
        [XSJUserInfoData sharedInstance].isShowMoneyBadRedPoint = NO;
        [WDNotificationCenter postNotificationName:clearMyMoneyBagNotification object:nil];
    }
    
    if (![[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]) {
        [self.tabBarController.tabBar hideSmallBadgeOnItemIndex:3];
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"钱袋子页面"];
    self.title = @"钱袋子";
    
    [UIHelper setCorner:self.labAdvance withValue:2];
    self.labAdvance.hidden = YES;
    [self.btnGetoutMoney setCornerValue:2.0f];
    self.labMoneyNum.font = [UIFont fontWithName:kFont_RSR size:38];
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(btnKufuOnclick:)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.rightItem.enabled = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = YES;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getLastData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    WEAKSELF
    [[MoneyBagPasswordManager sharedInstance] setPasswordSuccess:^(MoneyBagInfoModel* model) {
        if (model) {
            weakSelf.alipay_sigle_withdraw_min_limit = model.alipay_sigle_withdraw_min_limit;
            weakSelf.rightItem.enabled = YES;
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - ***** 获取钱袋子流水 ******
- (void)getLastData{
    QueryParamModel* qpModel = [[QueryParamModel alloc] init];
    qpModel.page_num = [[NSNumber alloc] initWithInt:1];
    qpModel.page_size = [[NSNumber alloc] initWithInt:30];
    NSString* content = qpModel.getContent;
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctDetail_v2" andContent:content];
    request.isShowLoading = NO;
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        [weakSelf.tableView.header endRefreshing];
        if (response && [response success]) {
            _moneyAmount = response.content[@"acct_amount"];
            _advanceAmount = response.content[@"advance_amount"];
            NSArray* dataArray = response.content[@"detail_list"];
            if (dataArray.count > 0) {
                _dataArray = [NSMutableArray arrayWithArray:[MoneyDetailModel objectArrayWithKeyValuesArray:dataArray]];
                weakSelf.queryParam = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue+1);
            }
            [weakSelf updateData];
        }
    }];
}

- (void)getMoreData{
    if (self.queryParam) {
//        NSInteger pageNum = self.queryParam.page_num.integerValue;
//        pageNum++;
//        self.queryParam.page_num = @(pageNum);
//        QueryParamModel* qpModel = [[QueryParamModel alloc] init];
//        qpModel.page_num = self.queryParam.page_num;
//        qpModel.page_size = self.queryParam.page_size;
//        qpModel.timestamp = self.queryParam.timestamp;
        
        NSString* content = [self.queryParam getContent];
        
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryAcctDetail_v2" andContent:content];
        request.isShowLoading = NO;
        WEAKSELF
        [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
            _moneyAmount = response.content[@"acct_amount"];

            if (response && [response success]) {
                NSArray* dataArray = response.content[@"detail_list"];
                if (dataArray.count > 0) {
                    [_dataArray addObjectsFromArray:[MoneyDetailModel objectArrayWithKeyValuesArray:dataArray]];
                    QueryParamModel* qpModel = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                    weakSelf.queryParam.page_num = @(qpModel.page_num.integerValue+1);
                }else{
//                    NSInteger pageNum = weakSelf.queryParam.page_num.integerValue;
//                    pageNum--;
//                    weakSelf.queryParam.page_num = @(pageNum);
                    [UIHelper toast:@"没有更多信息"];
                }
            }
            [weakSelf updateData];
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.tableView.header endRefreshing];
        }];
    }
}

/** 跟新数据 */
- (void)updateData{
    NSString* moneyStr = [NSString stringWithFormat:@"%0.2f", _moneyAmount.floatValue*0.01];
    self.labMoneyNum.text = [[NSString alloc] initWithFormat:@"%@",moneyStr];
    if (_advanceAmount && _advanceAmount.integerValue > 0) {
        self.labAdvance.hidden = NO;
        self.labAdvance.text = [NSString stringWithFormat:@" 预付款: %0.2f ",_advanceAmount.floatValue*0.01];
    }else{
        self.labAdvance.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - ***** UITableView delegate ******
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoneyBagCell* cell = [MoneyBagCell cellWithTableView:tableView];

    if (_dataArray.count <= indexPath.row) {
        return cell;
    }
    MoneyDetailModel* model = _dataArray[indexPath.row];
    [cell refreshWithData:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog("====didSelectRowAtIndexPath:%ld",(long)indexPath.row);
 
    MoneyDetailModel* model = _dataArray[indexPath.row];
    if (model.money_detail_type.intValue == 4) {
        PayDetail_VC* vc = [[PayDetail_VC alloc] init];
        vc.detail_list_id = model.account_money_detail_list_id;
        vc.money_detail_title = model.money_detail_title;
//        vc.job_id = model.job_id;
//        vc.query_create_time = model.create_time;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (model.money_detail_type.intValue == 6) {
        MoneyDetail_VC *vc = [[MoneyDetail_VC alloc]init];
        vc.jobId = [NSString stringWithFormat:@"%@",model.job_id];
        vc.moneyDetailID = model.account_money_detail_list_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.money_detail_type.intValue == 7) {
        //账单的进口
        JobBillDetail_VC *vc = [[JobBillDetail_VC alloc]init];
        vc.job_id = model.job_id;
        vc.isAccurateJob = @(1);
        [self.navigationController pushViewController:vc animated:YES];

    }

}

#pragma mark - ***** 按钮事件 ******

/** 取现 */
- (IBAction)btnGetMoneyOnClick:(UIButton *)sender {
    GetMoney_VC* vc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_getMoney"];
    vc.alipay_sigle_withdraw_min_limit = self.alipay_sigle_withdraw_min_limit;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 客服 */
- (void)btnKufuOnclick:(UIButton*)sender{
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            UIViewController *chatViewController = [ImDataManager getKeFuChatVC];
            [self.navigationController pushViewController:chatViewController animated:YES];
        }
    }];
}

/** 小贴士 */
- (IBAction)btnAlert:(UIButton *)sender {
    WebView_VC* vc = [[WebView_VC alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@", URL_HttpServer, kUrl_moneyBagTip];
    vc.title = @"使用贴士";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backToLastView{
    if (self.isFromPay) {
//        [self.navigationController popViewControllerAnimated:YES];
        [WDNotificationCenter postNotificationName:WDNotification_backFromMoneyBag object:nil];
    }else if (self.isFromWebView) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
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
