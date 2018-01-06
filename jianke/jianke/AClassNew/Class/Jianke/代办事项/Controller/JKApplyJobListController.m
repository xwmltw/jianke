//
//  JKApplyJobListController.m
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "JKApplyJobListController.h"
#import "WDConst.h"
#import "JKApplyJobFrame.h"
#import "JKApplyJobCell.h"
#import "ParamModel.h"
#import "JobDetail_VC.h"
#import "WDChatView_VC.h"
#import "ImDataManager.h"
#import "DataBaseTool.h"
#import "ImDataManager.h"
#import "WorkHistoryController.h"
#import "QRcodeScan_VC.h"
#import "MyInfoCollect_VC.h"
#import "ApplySuccess_VC.h"
#import "MyNewInfo_VC.h"
#import "xwmAlertViewController.h"

@interface JKApplyJobListController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;               /*!< tableView */
@property (nonatomic, strong) NSArray *applyJobList;
@property (nonatomic, strong) NSMutableArray *applyJobFList;        /*!< 数组,存放JKApplyJobFrame模型 */
@property (nonatomic, strong) NSMutableArray *historyApplyJobFList; /*!< 历史记录数组,存放JKApplyJobFrame模型 */
@property (nonatomic, strong) NSNumber *historyNum;
@property (nonatomic, strong) QueryParamModel *queryParam;          /*!< 查询参数 */
@property (nonatomic, strong) JKApplyJob *tmpApplyJob;

@end

@implementation JKApplyJobListController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if ([XSJUserInfoData sharedInstance].isShowMyApplyRedPoint) {
        [XSJUserInfoData sharedInstance].isShowMyApplyRedPoint = NO;
        [WDNotificationCenter postNotificationName:clearMyApplyRedPointNotification object:nil];
    }
    if (![[XSJUserInfoData sharedInstance] getIsShowMyInfoTabBarSmallRedPoint]) {
        [self.tabBarController.tabBar hideSmallBadgeOnItemIndex:3];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"兼客个人中心_待办事项页面"];
    
    self.navigationItem.title = @"我的报名";
    
    // 注册通知
    /** 取消报名通知 */
    [WDNotificationCenter addObserver:self selector:@selector(cancelApply:) name:JKApplyJobCancellApplyNotification object:nil];
    /** 有问题通知 */
    [WDNotificationCenter addObserver:self selector:@selector(hasQuestion:) name:JKApplyJobHasQuestionNotification object:nil];
    /** 与雇主聊天通知 */
    [WDNotificationCenter addObserver:self selector:@selector(chatWithEp:) name:JKApplyJobChatWithEPNotification object:nil];
    /** 与雇主微信联系 */
    [WDNotificationCenter addObserver:self selector:@selector(wxWithEp:) name:JKApplyJobWXWithNotification object:nil];
    
    /** 查看简历/录用/完工/ */
    [WDNotificationCenter addObserver:self selector:@selector(updateData) name:IMPushJKWaitTodoNotification object:nil];
    
    [self initNavigationButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = MKCOLOR_RGB(236, 236, 236);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    [self initWithNoDataViewWithStr:@"您当前还没有待办事项" labColor:nil imgName:@"v3_public_notodo" onView:self.tableView];
    self.applyJobFList = [[NSMutableArray alloc] init];
    self.historyApplyJobFList = [[NSMutableArray alloc] init];
    self.historyNum = @(0);
    
    
    // 集成上拉,下拉
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getHistoryData)];
    
    // 开始刷新
    [self.tableView.header beginRefreshing];
}

- (void)initNavigationButton{
    
    UIButton *btnQrCode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQrCode.frame = CGRectMake(0, 0, 66, 44);
    btnQrCode.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnQrCode setTitle:@"扫码录用" forState:UIControlStateNormal];
    [btnQrCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQrCode addTarget:self action:@selector(btnQrCodeOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnQrCode];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)btnRecordOnclick:(UIButton *)sender{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            WorkHistoryController *vc = [[WorkHistoryController alloc] init];
            vc.isFromInfoCenter = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)btnQrCodeOnClick:(UIButton *)sender{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            [UIDeviceHardware getCameraAuthorization:^(id obj) {
                QRcodeScan_VC* vc = [[QRcodeScan_VC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
    }];
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
            weakSelf.viewWithNoData.hidden = YES;
            weakSelf.applyJobList = [JKApplyJob objectArrayWithKeyValuesArray:response.content[@"apply_job_list"]];
            weakSelf.applyJobFList = [JKApplyJobFrame applyJobFListWithApplyJobArray:weakSelf.applyJobList withSection:0];
            
            // 设置非历史记录条数
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"我的报名(%lu)", (unsigned long)weakSelf.applyJobList.count];
            // 设置历史记录条数
            weakSelf.historyNum = response.content[@"apply_job_count_in_history"];
            
            // 清空历史记录数据
            [weakSelf.historyApplyJobFList removeAllObjects];
            weakSelf.queryParam = nil;
            
            if (weakSelf.applyJobFList.count > 0) {
                [weakSelf.tableView reloadData];
            }else{      //没数据
                if (weakSelf.historyNum.integerValue > 0) { //有历史数据
                    weakSelf.viewWithNoData.hidden = YES;
                    [weakSelf getHistoryData];

                }else{
                    weakSelf.viewWithNoData.hidden = NO;
                }
            }
        } else { // 没有数据返回
            weakSelf.viewWithNoNetwork.hidden = NO;
        }
    }];
}

/** 获取历史数据 */
- (void)getHistoryData{
    NSString *content = @"";
    if (self.queryParam) {
        NSString *queryStr = [self.queryParam simpleJsonString];
        content = [NSString stringWithFormat:@"\"query_param\":%@, \"in_history\":1", queryStr];
    }else{
        content = @"\"in_history\":\"1\"";
    }
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuQueryApplyJobList" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据加载中...";
    
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        [weakSelf.tableView.header endRefreshing];
        if (response) { // 有数据
            NSArray *applyJobList = [JKApplyJob objectArrayWithKeyValuesArray:response.content[@"apply_job_list"]];
            if (applyJobList.count) { // 有更多数据
                // 添加新数据到原数据后面

                NSMutableArray *moreApplyJobF = [JKApplyJobFrame applyJobFListWithApplyJobArray:applyJobList withSection:1];
                [weakSelf.historyApplyJobFList addObjectsFromArray:moreApplyJobF];
                
                // 刷新表格
                [weakSelf.tableView reloadData];
                // 保存查询分页参数
                weakSelf.queryParam = [QueryParamModel objectWithKeyValues:response.content[@"query_param"]];
                weakSelf.queryParam.page_num = @(weakSelf.queryParam.page_num.integerValue+1);
            } else { // 没有更多数据
                [UIHelper toast:@"没有更多数据了"];
            }
        }
        [weakSelf.tableView.footer endRefreshing];
    }];
}


#pragma mark - ***** TableView delegate ******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKApplyJobCell *cell = [JKApplyJobCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.applyJobF = self.applyJobFList[indexPath.row];
    } else {
        cell.applyJobF = self.historyApplyJobFList[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JKApplyJob *applyJob = nil;
    if (indexPath.section == 0) {
        applyJob = [self.applyJobFList[indexPath.row] applyJob];
    } else {
        applyJob = [self.historyApplyJobFList[indexPath.row] applyJob];
    }
    [self gotoPostDetailWithApplyJob:applyJob];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.applyJobFList && self.applyJobList.count > indexPath.row) {
            JKApplyJobFrame *applyJobF = self.applyJobFList[indexPath.row];
            return applyJobF.cellHeight;
        }
    } else {
        if (self.historyApplyJobFList && self.historyApplyJobFList.count > indexPath.row) {
            JKApplyJobFrame *applyJobF = self.historyApplyJobFList[indexPath.row];
            return applyJobF.cellHeight;
        }
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.applyJobFList.count ? self.applyJobFList.count : 0;
    }else if (section == 1) {
        return self.historyApplyJobFList.count ? self.historyApplyJobFList.count : 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 ) {
        return 40;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 && (self.applyJobFList.count || self.historyApplyJobFList.count)) {
        UIView *sectionHeadView = [[UIView alloc] init];
        sectionHeadView.width = SCREEN_WIDTH;
        sectionHeadView.height = 40;
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 130) * 0.5, 4, 130, 32)];
        headBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [headBtn addTarget:self action:@selector(historyClick) forControlEvents:UIControlEventTouchUpInside];
        [headBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        NSString *historyBtnTitle = [NSString stringWithFormat:@"历史记录 (%lu)", (unsigned long)self.historyNum.unsignedIntegerValue];
        [headBtn setTitle:historyBtnTitle forState:UIControlStateNormal];
        if (self.historyApplyJobFList.count > 0) {
            [headBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [headBtn setImage:[UIImage imageNamed:@"v3_public_history"] forState:UIControlStateNormal];
            headBtn.userInteractionEnabled = NO;
        }else{
            [headBtn setBackgroundImage:[UIImage imageNamed:@"info_rectbg"] forState:UIControlStateNormal];
            [headBtn setImage:[UIImage imageNamed:@"v3_public_history_white"] forState:UIControlStateNormal];
            [headBtn setImage:[UIImage imageNamed:@"v3_public_history_white"] forState:UIControlStateHighlighted];
            headBtn.userInteractionEnabled = YES;
        }
    
        [sectionHeadView addSubview:headBtn];
        return sectionHeadView;
    }
    return nil;
}


#pragma mark - 其他方法
/** 加载历史数据 */
- (void)historyClick{
    // 加载更多
    [self.tableView.footer beginRefreshing];
}

/** 取消报名点击事件 */
- (void)cancelApply:(NSNotification *)notification{
    JKApplyJob *applyJob = notification.userInfo[JKApplyJobCancellApplyInfo];
    self.tmpApplyJob = applyJob;
  
    WEAKSELF
    [UIHelper showConfirmMsg:@"每个岗位只能报名一次，取消报名后无法再次报名，确定取消？" okButton:@"确定" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf cancelApplyWithReason:@"取消报名"];
        }
    }];
}

/** 举报点击事件 */
- (void)hasQuestion:(NSNotification *)notification{
    JKApplyJob *applyJob = notification.userInfo[JKApplyJobHasQuestionInfo];
    self.tmpApplyJob = applyJob;
    
    UIAlertView *informAlertView = [[UIAlertView alloc] initWithTitle:@"举报原因" message:@"请选择您的举报原因。经查证如不属实将影响您的信用度!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"岗位已过期", @"收费/虚假信息", @"到岗不予录用", @"联系客服", nil];
    [informAlertView show];
}

/** 跳转到岗位详情 */
- (void)gotoPostDetailWithApplyJob:(JKApplyJob *)applyJob{
    DLog(@"跳转到岗位详情");
    JobDetail_VC* vc = [[JobDetail_VC alloc] init];
    vc.jobId = [applyJob.job_id description];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/** 与雇主聊天 */
- (void)chatWithEp:(NSNotification *)notification{
    JKApplyJob *applyJob = notification.userInfo[JKApplyJobChatWithEPInfo];
    NSString *jobTitle = applyJob.job_title;
    NSString *jobId = applyJob.job_id.stringValue;
    [TalkingData trackEvent:@"待办事项_IM"];
    if (applyJob.ent_open_im_status && applyJob.ent_open_im_status.integerValue == 1) { // 有开通IM
        NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", applyJob.ent_account_id];
        RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
        request.isShowLoading = NO;
        [request sendRequestToImServer:^(ResponseInfo* response) {
            if (response && [response success]) {
                [WDChatView_VC openPrivateChatOn:self accountId:applyJob.ent_account_id.description withType:WDImUserType_Employer jobTitle:jobTitle jobId:jobId hideTabBar:YES];
            }
        }];
    } else {
        [UIHelper toast:@"对不起,该用户未开通IM功能"];
    }
}
- (void)wxWithEp:(NSNotification *)nofitication{
    
    JKApplyJob *applyjob = nofitication.userInfo[JKApplyJobWXWithInfo];
    
    [[UserData sharedInstance]getJobDetailWithJobId:applyjob.job_id.description andIsFromSAB:NO isShowLoding:NO Block:^(JobDetailModel *model) {
        NSString *str = applyjob.wechat_public.length ? applyjob.wechat_public : applyjob.wechat_number;
        if (str) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"微信号:%@",str] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [UIHelper copyToPasteboard:applyjob.wechat_public];
                [UIHelper copyToPasteboard:applyjob.wechat_number];
                if ([WXApi isWXAppInstalled]) {
                    [WXApi openWXApp];
                }else{
                    [UIHelper toast:@"已复制到剪贴板"];
                }

            
            }];
            [alert addAction:cel];
            [alert addAction:ok];
            [self presentViewController:alert animated:NO completion:nil];
            
        }else{
          
            
            [[MKOpenUrlHelper sharedInstance] makeAlertCallWithPhone:model.parttime_job.contact.phone_num block:nil];
            
//            [[MKOpenUrlHelper sharedInstance]callWithPhone:model.parttime_job.contact.phone_num];
//            [UIHelper toast:@"该雇主没有微信"];
        }
    }];
}

- (void)updateData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getData];
    });
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    DLog(@"%ld", (long)buttonIndex);
    
    NSString *reason;
    if ([alertView.title isEqualToString:@"举报原因"]) {
        switch (buttonIndex) {
            case 1: // 岗位已过期
            {
                reason = @"岗位已过期";
                [self informEpWithReason:reason];
            }
                break;
                
            case 2: // 收费/虚假信息
            {
                reason = @"收费/虚假信息";
                [self informEpWithReason:reason];
            }
                break;
                
            case 3: // 到岗不予录用
            {
                reason = @"到岗不予录用";
                [self informEpWithReason:reason];
            }
                break;
                
            case 4: // 联系客服
            {
//                reason = @"联系客服";
                [[UserData sharedInstance] userIsLogin:^(id obj) {
                    if (obj) {
                        UIViewController *chatViewController = [ImDataManager getKeFuChatVC];
                        chatViewController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:chatViewController animated:YES];
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
    }
}

/** 举报雇主 */
- (void)informEpWithReason:(NSString *)reason{
    CityModel* cityModel = [[UserData sharedInstance] city];

    SubmitFeedbackV2* contModel = [[SubmitFeedbackV2 alloc] init];
    contModel.city_id = cityModel.parent_id;
    contModel.address_area_id = cityModel.id;
    contModel.feedback_type = @(3);
    contModel.phone_num = [[XSJUserInfoData sharedInstance] getUserInfo].userPhone;
    contModel.desc = reason;
    contModel.job_id = self.tmpApplyJob.job_id;
    
    
//        NSNumber *feedback_type = @(3);
//        NSString *desc = reason;
//        NSNumber *job_id = self.tmpApplyJob.job_id;
//        NSString *content = [NSString stringWithFormat:@"feedback_type:\"%lu\", desc:\"%@\", job_id:\"%lu\"", (unsigned long)feedback_type.unsignedIntegerValue, desc, (unsigned long)job_id.unsignedIntegerValue];
    
    NSString* content = [contModel getContent];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_submitFeedback_v2" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据发送中...";
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            [UIHelper toast:@"举报成功"];
        }
        // 刷新数据
        [weakSelf.tableView.header beginRefreshing];
    }];
}

/** 取消报名 */
- (void)cancelApplyWithReason:(NSString *)reason{
    NSUInteger apply_job_id = self.tmpApplyJob.apply_job_id.unsignedIntegerValue;
    NSString *content = [NSString stringWithFormat:@"apply_job_id:%lu, stu_reciv_apply_reason:%@", (unsigned long)apply_job_id, [[reason dataUsingEncoding:NSUTF8StringEncoding] simpleJsonString]];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_cancelApplyJob" andContent:content];
    request.isShowLoading = NO;
    request.isShowErrorMsg = NO;
    request.loadingMessage = @"数据发送中...";
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            // 显示发送成功提示
            [UserData delayTask:0.3 onTimeEnd:^{
                [UIHelper toast:@"取消报名成功"];
            }];
            
            [weakSelf quitJobGroupIM];
            
        } else {
            [UserData delayTask:0.3 onTimeEnd:^{
                [UIHelper toast:response.errMsg];
            }];
        }
        
        // 刷新数据
        [weakSelf.tableView.header beginRefreshing];
    }];
}

- (void)quitJobGroupIM{
    [[UserData sharedInstance] imQuitGroupWithGroupId:self.tmpApplyJob.job_id.stringValue block:^(ResponseInfo* response) {
        if (response) {
            NSString* jobConversationId = [[ImDataManager sharedInstance] makeGroupLocalConversationIdSignWithUuid:self.tmpApplyJob.job_uuid];
            [DataBaseTool hideConversationWithGroupConversationId:jobConversationId];
        }
    }];
}

- (void)backToLastView{
    NSArray *vcArr = self.navigationController.childViewControllers;
    [vcArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MyNewInfo_VC class]] || [obj isKindOfClass:[ApplySuccess_VC class]] || [obj isKindOfClass:[WDChatView_VC class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
            return;
        }
        if (idx == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    // 移除通知
    [WDNotificationCenter removeObserver:self];
}

@end

