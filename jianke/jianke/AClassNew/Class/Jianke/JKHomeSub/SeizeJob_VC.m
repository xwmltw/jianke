//
//  SeizeJob_VC.m
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "SeizeJob_VC.h"
#import "SeizeJobCell.h"
#import "JobModel.h"
#import "WDConst.h"
#import "JobDetail_VC.h"
#import "DateSelectView.h"
#import "IdentityCardAuth_VC.h"
#import "MoneyBag_VC.h"
#import "LookupApplyJKListController.h"
#import "JobApplyConditionController.h"
#import "DateTools.h"
#import "NSObject+SYAddForProperty.h"
#import "JobExpressCell.h"
#import "ApplySuccess_VC.h"

@interface SeizeJob_VC ()<SeizeJobDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) JobModel *jobModel;
@property (nonatomic, strong) NSMutableArray *workTime; /*!< 工作时间 */
@property (nonatomic, strong) UIAlertView *trueNameAlertView;

@end

@implementation SeizeJob_VC

static bool s_needRefresh = NO;

+ (void)needRefreshOnNextViewApper{

    s_needRefresh = YES;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        ELog(@"=====SeizeJob_VC init ok");
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 56, 0);        
        s_needRefresh = YES;
    }
    
    return self;
}

- (void)viewDidAppear{
    
    self.arrayData2 = [[NSMutableArray alloc]init];

    if (s_needRefresh) {
        self.defaultView.hidden = YES;
        self.tableView.hidden = YES;
        [self headerBeginRefreshing];
        s_needRefresh = NO;
        ELog(@"=====SeizeJob_VC init viewDidAppear");
        
    }
}


- (void)registerLocateEvent{
    [self showLatest];
    //添加通知
}

- (void)getSecion2Data:(NSString*)content{
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_queryJobListFromApp" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            NSArray* dataList = [response.content objectForKey:@"self_job_list"];
            if (dataList.count > 0) {
                self.arrayData2 = [JobModel objectArrayWithKeyValuesArray:response.content[@"self_job_list"]];
                [self.tableView reloadData];
            }
        }else{
            [self.tableView reloadData];
        }
    }];
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
}



#pragma mark = TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.arrayData ? self.arrayData.count : 0;
    }else if (section == 1){
        return self.arrayData2 ? self.arrayData2.count : 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier1 = @"SeizeJobCell";
    
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            SeizeJobCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
//            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            if (cell == nil) {
                cell = [SeizeJobCell new];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            if (self.arrayData.count <= indexPath.row) {
                return cell;
            }
            
            JobModel* model = self.arrayData[indexPath.row];
            [cell refreshWithData:model];
            return cell;

        }else{
            JobExpressCell* cell = [JobExpressCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (self.arrayData2.count <= indexPath.row) {
                return cell;
            }
            if (self.arrayData2.count > 0) {
                self.noDataView.hidden = YES;
            }else{
                self.noDataView.hidden = NO;
            }
            JobModel* model = self.arrayData2[indexPath.row];
            [cell refreshWithData:model];
            return cell;

        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        return 0;
    }else{
        return cell.frame.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELog("====didSelectRowAtIndexPath:%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        JobModel* model = self.arrayData[indexPath.row];
        JobDetail_VC* vc = [[JobDetail_VC alloc] init];
        vc.jobId = [NSString stringWithFormat:@"%@",model.job_id];
        [self.owner.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        JobModel* model = self.arrayData2[indexPath.row];
        JobDetail_VC* vc = [[JobDetail_VC alloc] init];
        vc.jobId = [NSString stringWithFormat:@"%@",model.job_id];
        [self.owner.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark - ==========

- (void)cell_applyListClick:(JobModel *)model
{
    DLog(@"跳转到已报名兼客列表");
    [TalkingData trackEvent:@"抢单_已报名_录用详情"];
    
    if (model.apply_job_resumes && model.apply_job_resumes.count) {
     
        LookupApplyJKListController *vc = [[LookupApplyJKListController alloc] init];
        vc.jobId = model.job_id.description;
        [self.owner.navigationController pushViewController:vc animated:YES];
    }
}

- (void)cell_didSelectRowAtIndex:(JobModel *)model{    
    // 跳转到岗位详情
    DLog(@"跳转到岗位详情");
    JobDetail_VC* vc = [[JobDetail_VC alloc] init];
    vc.jobId = [model.job_id description];
    [self.owner.navigationController pushViewController:vc animated:YES];
}

- (void)cell_btnApplyOnclick:(JobModel *)model{
    ELog(@"=======点击报名按钮");    
    
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (obj) {
            [self applyEventWithModel:model];
        }
    }];
}

- (void)applyEventWithModel:(JobModel* )model{
  
    
    self.jobModel = model;
    
    // 判断抢单资格
    JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
    
    // 认证中 && 不是第一次抢单
    if (jkModel.id_card_verify_status.integerValue == 2 && !jkModel.is_first_grab_single) {
        
        UIAlertView *unVerifyAlertView = [[UIAlertView alloc] initWithTitle:@"认证中" message:@"您的认证正在进行中...请耐心等待客服审核完成再来抢单!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [unVerifyAlertView show];
        return;
    }
    
    // 不是已认证 && 不是第一次抢单
    if (jkModel.id_card_verify_status.integerValue != 3 && !jkModel.is_first_grab_single) {
        
        // 提示去认证
        UIAlertView *verifyAlertView = [[UIAlertView alloc] initWithTitle:@"认证提示" message:@"抢单资格不足，您要花几分钟时间认证身份证。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [verifyAlertView show];
        return;
    }
    
    // 不是已认证 && 是第一次抢单 && 未完善名字
    if (jkModel.id_card_verify_status.integerValue != 3 && jkModel.is_first_grab_single && (!jkModel.true_name || (jkModel.true_name && jkModel.true_name.length < 1))) {
        
        // 弹出完善提示
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善姓名" message:@"请填写真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        nameTextField.placeholder = @"真实姓名";
        self.trueNameAlertView = alertView;
        [alertView show];
        return;
    }
    
    
    // 具备抢单资格了..
    NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobModel.work_time_start.longValue * 1000)];
    NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobModel.work_time_end.longValue * 1000)];
    
    if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
        // 弹框确定报名
        [self checkApplyJob];
        
    } else {
        
        // 弹出选择日期控件
        [self selectWorkDate];
    }
}

/** 选择报名时间 */
- (void)selectWorkDate
{
    // 有条件限制
    if ([self isSetConditionWithJobModel:self.jobModel]) {
        [self goToConditionVcWithCalendar:YES jobModel:self.jobModel];
        return;
    }
    
    // 精确岗位,请求可报名日期
    if (self.jobModel.is_accurate_job && self.jobModel.is_accurate_job.integerValue == 1) {
        
        WEAKSELF
        [[UserData sharedInstance] queryJobCanApplyDateWithJobId:self.jobModel.job_id resumeId:nil block:^(ResponseInfo *response) {
            
            NSArray *numArray = response.content[@"job_can_apply_date"];
            
            NSMutableArray *dateArray = [NSMutableArray array];
            for (NSString *num in numArray) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longLongValue * 0.001];
                [dateArray addObject:date];
            }
            
            NSMutableArray *canApplyDateArray = [NSMutableArray array];
            NSDate *today = [NSDate date]; // 转化成今天0点0分
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *todayStr = [formatter stringFromDate:today];
            formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
            todayStr = [NSString stringWithFormat:@"%@ 00:00:00", todayStr];
            today = [formatter dateFromString:todayStr];
            
            for (NSDate *date in dateArray) {
                
                if ([date isLaterThanOrEqualTo:today]) {
                    
                    [canApplyDateArray addObject:date];
                }
            }
            
            [weakSelf showDateSelectViewWithDateArray:canApplyDateArray];
        }];
        
    } else {
        
        [self showDateSelectViewWithDateArray:nil];
    }
}


- (void)showDateSelectViewWithDateArray:(NSArray *)dateArray
{
    DLAVAlertView *dateSelectAlertView = [[DLAVAlertView alloc] initWithTitle:@"请选择兼职日期" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
    
    DateSelectView *dateView = [[DateSelectView alloc] initWithFrame:CGRectMake(0, 0, 260, 260)];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.jobModel.work_time_start.longValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.jobModel.work_time_end.longValue];
    
    if (startDate.timeIntervalSince1970 < [NSDate date].timeIntervalSince1970) {
        
        startDate = [NSDate date];
    }
    
    if (!dateArray) {
        dateView.startDate = startDate;
        dateView.endDate = endDate;
    } else {
        dateView.canSelDateArray = dateArray;
    }
    
    [contentView addSubview:dateView];
    
    // 全选按钮
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 260, 90, 32)];
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"pay_btn_select_0"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"pay_btn_select_1"] forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    selectBtn.layer.cornerRadius = 15;
    selectBtn.layer.borderColor = MKCOLOR_RGB(200, 199, 204).CGColor;
    selectBtn.layer.borderWidth = 0.5;
    selectBtn.layer.masksToBounds = YES;
    selectBtn.tagObj = dateView;
    [contentView addSubview:selectBtn];
    
    dateSelectAlertView.contentView = contentView;
    dateSelectAlertView.contentMode = UIViewContentModeCenter;
    
    [dateSelectAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            if (dateView.datesSelected.count < 1) {
                [UIHelper toast:@"必须至少选择一天才能报名"];
                return;
            }
            
            // 保存报名数组
            self.workTime = [NSMutableArray array];
            for (NSDate *date in dateView.datesSelected) {
                [self.workTime addObject:@([date timeIntervalSince1970])];
            }
            
            // 日期排序
            NSArray *tmpWorkTime = [self.workTime sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
                
                if (obj1.longLongValue < obj2.longLongValue) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }];
            
            self.workTime = [NSMutableArray arrayWithArray:tmpWorkTime];
            
            // 弹框确定报名
            [self checkApplyJob];
        }
    }];
}

/** 日历全选点击 */
- (void)selectBtnClick:(UIButton *)btn
{
    DateSelectView *dateView = (DateSelectView *)btn.tagObj;
    
    NSArray *allDateArray;
    if (dateView.canSelDateArray) {
        allDateArray = dateView.canSelDateArray;
    } else {
        allDateArray = [DateHelper dateRangeArrayBetweenBeginDate:dateView.startDate endDate:dateView.endDate];
    }
    
    if (!allDateArray.count) {
        return;
    }
    
    if (!btn.selected) {
        dateView.datesSelected = [NSMutableArray arrayWithArray:allDateArray];
    } else {
        dateView.datesSelected = [NSMutableArray array];
    }
    
    btn.selected = !btn.selected;
    [dateView setNeedsLayout];
}

/** 弹框确定报名 */
- (void)checkApplyJob
{
    // 有条件限制
    if ([self isSetConditionWithJobModel:self.jobModel]) {
        
        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobModel.work_time_start.longValue * 1000)];
        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobModel.work_time_end.longValue * 1000)];
        
        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
            [self goToConditionVcWithCalendar:YES jobModel:self.jobModel];
        } else {
            
            [self goToConditionVcWithCalendar:NO jobModel:self.jobModel];
        }

        return;
    }
    
    // 弹框确定报名
    UIAlertView *applyAlertView = [[UIAlertView alloc] initWithTitle:@"报名确认" message:@"确定报名吗? 上岗后要努力工作唷~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [applyAlertView show];
}


/** 报名 */
- (void)applyJobWithJobId:(NSString *)jobId workTime:(NSArray *)workTime{
    WEAKSELF
    [[UserData sharedInstance] candidateApplyJobWithJobId:jobId workTime:workTime isFromQrCodeScan:@(0) block:^(ResponseInfo *response) {
        if (response && response.success) {
            [UIHelper toast:@"报名成功"];
            
            ApplySuccess_VC *vc = [[ApplySuccess_VC alloc] init];
            vc.jobModel = weakSelf.jobModel;
            [weakSelf.owner.navigationController pushViewController:vc animated:YES];
            
            [weakSelf headerBeginRefreshing];
        }
    }];
}


/** 判断余额是否够支付保证金 */
- (void)checkMoney
{
    [TalkingData trackEvent:@"抢单_保证金"];
    JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
    if (jkModel.bond.doubleValue > jkModel.acct_amount.doubleValue) { // 余额不足
        
        // 弹框提示充值
        NSString *message = [NSString stringWithFormat:@"当前岗位需要支付%.2f元保证金,但您目前的余额不足以支付保证金，立即充值?", jkModel.bond.doubleValue * 0.01];
        UIAlertView *moneyAlertView = [[UIAlertView alloc] initWithTitle:@"余额不足" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [moneyAlertView show];
        
    } else { // 余额充足
        
        if (jkModel.bond && jkModel.bond.doubleValue > 0) { // 保证金大于等于0
            
            // 弹框提醒扣款
            NSString *message = [NSString stringWithFormat:@"高薪职位抢单要先扣%.2f诚信金，只要您不放鸽子，平台立即返还全额。如果临时有事，您也别担心，可以和雇主协商后退回诚信金", jkModel.bond.doubleValue * 0.01];
            
            UIAlertView *tackMoneyAlertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [tackMoneyAlertView show];
            
        } else {
            
            // 发送报名请求
            [self applyJobWithJobId:self.jobModel.job_id.description workTime:self.workTime];
        }
    }
}


/** 进入条件限制页面 */
- (void)goToConditionVcWithCalendar:(BOOL)isShowCalendar jobModel:(JobModel *)jobModel;
{
    JobApplyConditionController *vc = [[JobApplyConditionController alloc] init];
    vc.showCalendar = isShowCalendar;
    vc.jobModel = jobModel;
    [self.owner.navigationController pushViewController:vc animated:YES];
}

/** 是否进行条件筛选 */
- (BOOL)isSetConditionWithJobModel:(JobModel *)jobModel
{
    
    if (jobModel.sex) {
        return YES;
    }
    
    if (jobModel.age && jobModel.age.intValue != 0) {
        return YES;
    }
    
    if (jobModel.height && jobModel.height.intValue != 0) {
        return YES;
    }
    
    if (jobModel.rel_name_verify && jobModel.rel_name_verify.intValue != 0) {
        return YES;
    }
    
    if (jobModel.life_photo && jobModel.life_photo.intValue != 0) {
        return YES;
    }
    
    if (jobModel.apply_job_date) {
        return YES;
    }
    
    if (jobModel.health_cer && jobModel.health_cer.intValue != 0) {
        return YES;
    }
    
    if (jobModel.stu_id_card && jobModel.stu_id_card.intValue != 0) {
        return YES;
    }
    
    return NO;
}


#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 退出键盘
    [self.owner.view endEditing:YES];

    if ([alertView.title isEqualToString:@"报名确认"] && buttonIndex == 1) {
        
        // 判断余额是否够支付保证金
        [self checkMoney];
    }else if ([alertView.title isEqualToString:@"报名确认"] && buttonIndex == 0){
       
    }
    
    if ([alertView.title isEqualToString:@"认证提示"] && buttonIndex == 1) {
        
        [TalkingData trackEvent:@"抢单_身份证资格认证"];
        // 跳转到认证页面
        IdentityCardAuth_VC *verifyVc = [[IdentityCardAuth_VC alloc] init];
        [self.owner.navigationController pushViewController:verifyVc animated:YES];
    }
    
    
    if ([alertView.title isEqualToString:@"完善姓名"] && buttonIndex == 1) {
        
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if (!nameTextField.text || nameTextField.text.length < 2 || nameTextField.text.length > 5) {
            [UIHelper toast:@"请填写真实姓名"];
            [alertView show];
            return;
        }
        
        // 发送完善姓名的请求
        [[UserData sharedInstance] stuUpdateTrueName:nameTextField.text block:^(ResponseInfo *response) {
            if (response && response.success) {
                // 保存姓名
                [[UserData sharedInstance] setUserTureName:nameTextField.text];
                // 具备抢单资格了..
                NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobModel.work_time_start.longValue * 1000)];
                NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobModel.work_time_end.longValue * 1000)];
                
                if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
                    // 弹框确定报名
                    [self checkApplyJob];
                } else {
                    // 弹出选择日期控件
                    [self selectWorkDate];
                }
            }
        }];
    }
    
    
    if ([alertView.title isEqualToString:@"余额不足"] && buttonIndex == 1) {
        [TalkingData trackEvent:@"抢单_保证金_立即支付"];
        // 跳转到钱袋子
        MoneyBag_VC *moneyVc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
        [self.owner.navigationController pushViewController:moneyVc animated:YES];
    }else if ([alertView.title isEqualToString:@"余额不足"] && buttonIndex == 0){
        [TalkingData trackEvent:@"抢单_保证金_取消"];
    }
    
    
    if ([alertView.title isEqualToString:@"提醒"] && buttonIndex == 1) {
        
        // 发送报名请求
        [self applyJobWithJobId:self.jobModel.job_id.description workTime:self.workTime];
    }

}



@end
