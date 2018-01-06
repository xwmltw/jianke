//
//  JobApplyConditionController.m
//  jianke
//
//  Created by fire on 15/11/20.
//  Copyright © 2015年 xianshijian. All rights reserved.
//  

#import "JobApplyConditionController.h"
#import "JobApplyConditionCellModel.h"
#import "JobApplyConditionCell.h"
#import "UserData.h"
#import "Masonry.h"
#import "DateSelectView.h"
#import "LookupResume_VC.h"
#import "DateTools.h"
#import "JobDetailModel.h"
#import "NSObject+SYAddForProperty.h"
#import "ApplySuccess_VC.h"


@interface JobApplyConditionController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, weak) UIButton *applyBtn;
@property (nonatomic, weak) DateSelectView *dateView; /*!< 日期控件 */

@property (nonatomic, assign) NSInteger days; /*!< 可报名天数 */
@property (nonatomic, assign) BOOL reGetData; /*!< 是否重新获取岗位详情模型数据 */
@property (nonatomic, assign) BOOL isApplyed; /*!< 已报名 */

@property (nonatomic, strong) NSMutableArray *cellModelArray; /*!< 存放JobApplyConditionCellModel */
@property (nonatomic, strong) NSMutableArray *canApplyDateArray; /*!< 可报名日期数组 */
@property (nonatomic, strong) NSMutableArray *applyDateArray; /*!< 报名日期数组 */

@end

@implementation JobApplyConditionController

#pragma mark - layzer
- (UIView *)headerView{
    if (!_headerView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 468)];
        headerView.backgroundColor = [UIColor whiteColor];
        _headerView = headerView;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        titleView.backgroundColor = MKCOLOR_RGB(236, 236, 236);
        [_headerView addSubview:titleView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 5, 200, 20)];
        label.textColor = MKCOLOR_RGB(89, 89, 89);
        label.text = @"哪几天有空?";
        label.font = [UIFont systemFontOfSize:14];
        [titleView addSubview:label];
        
        // 日历
        DateSelectView *dateView = [[DateSelectView alloc] initWithFrame:CGRectMake(8, 73, SCREEN_WIDTH - 16, 355)];
        WEAKSELF
        dateView.didClickBlock = ^(id obj){
            if (weakSelf.jobModel.apply_job_date) {
                [weakSelf checkApplyDate];
                [weakSelf updateDateConditionWithConditionState:[weakSelf conditionStateOfApplyJobDate]];
            }
            
            [weakSelf updateApplyBtnState];
            [weakSelf.tableView reloadData];
        };
        
        [_headerView addSubview:dateView];
        self.dateView = dateView;
        
        
        // 全选按钮
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 420, 90, 32)];
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
        [_headerView addSubview:selectBtn];
    }
    
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _footerView = footerView;
        
        UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 20, SCREEN_WIDTH-32, 44)];
        applyBtn.layer.cornerRadius = 2;
        applyBtn.layer.masksToBounds = YES;
        [applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.applyBtn = applyBtn;
        [footerView addSubview:applyBtn];
    }
    
    return _footerView;
}

- (UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _sectionHeaderView = sectionHeaderView;
        UILabel *label = [[UILabel alloc] init];
        label.textColor = MKCOLOR_RGB(89, 89, 89);
        label.text = @"限制条件";
        label.font = [UIFont systemFontOfSize:14];
        [sectionHeaderView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.centerY.equalTo(sectionHeaderView);
            make.left.mas_equalTo(16);
        }];
    }
    
    return _sectionHeaderView;
}


#pragma mark - ***** life circle ******
- (void)viewDidLoad {
//    self.isUIRectEdgeAll = YES;
    [super viewDidLoad];
    self.title = @"报名";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.tableFooterView = self.footerView;
    self.tableView.rowHeight = 50;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = MKCOLOR_RGB(236, 236, 236);
    [self.tableView registerNib:[UINib nibWithNibName:@"JobApplyConditionCell" bundle:nil] forCellReuseIdentifier:@"JobApplyConditionCell"];
    
    if (self.showCalendar) {
        self.tableView.tableHeaderView = self.headerView;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.hidden = YES;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.reGetData) {
        WEAKSELF
        [[UserData sharedInstance] getJobDetailWithJobId:self.jobModel.job_id.stringValue Block:^(JobDetailModel *model) {
            if (!model) {
                [UIHelper toast:@"获取岗位详情失败"];
                return;
            }
            weakSelf.jobModel = model.parttime_job;
            [weakSelf setData];
        }];
    }
    self.reGetData = YES;
}


#pragma mark - init
- (void)getData{
    if (self.jobModel.is_accurate_job.boolValue) {
        [self getAccurateWorkDate];
        
    } else {
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.jobModel.working_time_start_date.longValue * 0.001];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.jobModel.working_time_end_date.longValue * 0.001];
        if (startDate.timeIntervalSince1970 < [NSDate date].timeIntervalSince1970) {
            startDate = [NSDate date];
        }
        
        self.dateView.startDate = startDate;
        self.dateView.endDate = endDate;
        
        self.days = [startDate daysEarlierThan:endDate] + 2;
        [self setData];
        self.tableView.hidden = NO;
    }
}


- (void)getAccurateWorkDate{
    WEAKSELF
    [[UserData sharedInstance] queryJobCanApplyDateWithJobId:self.jobModel.job_id resumeId:nil block:^(ResponseInfo *response) {
        NSArray *numArray = response.content[@"job_can_apply_date"];
        NSMutableArray *dateArray = [NSMutableArray array];
        for (NSString *num in numArray) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longLongValue * 0.001];
            [dateArray addObject:date];
        }
        
        weakSelf.canApplyDateArray = [NSMutableArray array];
        NSDate *today = [NSDate date]; // 转化成今天0点0分
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *todayStr = [formatter stringFromDate:today];
        formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
        todayStr = [NSString stringWithFormat:@"%@ 00:00:00", todayStr];
        today = [formatter dateFromString:todayStr];
        
        for (NSDate *date in dateArray) {
            if ([date isLaterThanOrEqualTo:today]) {
                [weakSelf.canApplyDateArray addObject:date];
            }
        }
        
        weakSelf.dateView.canSelDateArray = weakSelf.canApplyDateArray;
        
        [weakSelf setData];
        weakSelf.tableView.hidden = NO;
    }];
}


- (void)setData{
    self.cellModelArray = [NSMutableArray array];
    if (self.jobModel.sex) {
        NSString *title = nil;
        switch (self.jobModel.sex.integerValue) {
            case 0:{
                title = @"女";
            }
                break;
            case 1:{
                title = @"男";
            }
                break;
            default:
                break;
        }
        
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeSex title:title state:[self conditionStateWithNum:self.jobModel.check_sex]]];
    }
    
    if (self.jobModel.age && self.jobModel.age.integerValue != 0) {
        
        NSString *title = nil;
        switch (self.jobModel.age.integerValue) {
            case 1:{
                title = @"18周岁以上";
            }
                break;
            case 2:{
                title = @"18-25周岁";
            }
                break;
            case 3:{
                title = @"25周岁以上";
            }
                break;
            default:
                break;
        }
        
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeAge title:title state:[self conditionStateWithNum:self.jobModel.check_age]]];
    }
    
    if (self.jobModel.height && self.jobModel.height.integerValue != 0) {

        NSString *title = nil;
        switch (self.jobModel.height.integerValue) {
            case 1:{
                title = @"160cm以上";
            }
                break;
            case 2:{
                title = @"165cm以上";
            }
                break;
            case 3:{
                title = @"168cm以上";
            }
                break;
            case 4:{
                title = @"170cm以上";
            }
                break;
            case 5:{
                title = @"175cm以上";
            }
                break;
            case 6:{
                title = @"180cm以上";
            }
                break;            default:
                break;
        }
        
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeHeight title:title state:[self conditionStateWithNum:self.jobModel.check_height]]];
    }
    
    if (self.jobModel.rel_name_verify && self.jobModel.rel_name_verify.integerValue != 0) {
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeRelNameVerify title:@"实名认证" state:[self conditionStateWithNum:self.jobModel.check_rel_name_verify]]];
    }
    
    if (self.jobModel.life_photo && self.jobModel.life_photo.integerValue != 0) {
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeLifePhoto title:@"有生活照" state:[self conditionStateWithNum:self.jobModel.check_life_photo]]];
    }
    
    if (self.jobModel.apply_job_date) {
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeApplyJobDate title:[self conditionDayStr] state:[self conditionStateOfApplyJobDate]]];
    }
    
    if (self.jobModel.health_cer && self.jobModel.health_cer.integerValue != 0) {
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeHealthCer title:@"有健康证" state:[self conditionStateWithNum:self.jobModel.check_health_cer]]];
    }
    
    if (self.jobModel.stu_id_card && self.jobModel.stu_id_card.integerValue != 0) {
        [self.cellModelArray addObject:[JobApplyConditionCellModel cellModelWithType:ConditionTypeStuIdCard title:@"有学生证" state:[self conditionStateWithNum:self.jobModel.check_stu_id_card]]];
    }
    
    [self.tableView reloadData];
    [self updateApplyBtnState];
}

/** 判断约束条件是否符合 */
- (ConditionState)conditionStateWithNum:(NSNumber *)num{
    ConditionState state = ConditionStateFit;
    switch (num.integerValue) {
        case 0:{
            state = ConditionStateUnFit;
        }
            break;
        case 1:{
            state = ConditionStateFit;
            
        }
            break;
        case 2:{
            state = ConditionStateUnknow;
        }
            break;
    }
    return state;
}


/** 更新cellModel中日期限定的状态 */
- (void)updateDateConditionWithConditionState:(ConditionState)state{
    for (JobApplyConditionCellModel *model in self.cellModelArray) {
        if (model.cellType == ConditionTypeApplyJobDate) {
            model.state = state;
        }
    }
}

/** 判断报名日期是否符合限制 */
- (ConditionState)conditionStateOfApplyJobDate{
    ConditionState state = ConditionStateUnFit;
    
    // 没有选择报名日期
    if (!self.applyDateArray || !self.applyDateArray.count) {
        return ConditionStateUnFit;
    }
    
    // 没有下发日期限制字段
    if (!self.jobModel.apply_job_date && self.applyDateArray.count) {
        return ConditionStateFit;
    }
    
    if (self.canApplyDateArray && self.canApplyDateArray.count) {
        self.days = self.canApplyDateArray.count;
    }
    
    switch (self.jobModel.apply_job_date.integerValue) {
        case 2:{
            if (self.applyDateArray.count >= MIN(self.days, 2)) { // 2天以上
                state = ConditionStateFit;
            }
        }
            break;
        case 3:{
            if (self.applyDateArray.count >= MIN(self.days, 3)) { // 3天以上
                state = ConditionStateFit;
            }
        }
            break;
        case 5:{
            if (self.applyDateArray.count >= MIN(self.days, 5)) { // 5天以上
                state = ConditionStateFit;
            }
        }
            break;
        case 0:{
            if (self.applyDateArray.count == self.days) { // 全部到岗
                state = ConditionStateFit;
            }
        }
            break;
        default:
            break;
    }
    return state;
}


/** 判断约束情况 */
- (ConditionState)checkForApply{
    if (!self.cellModelArray || !self.cellModelArray.count) {
        return ConditionStateUnFit;
    }
    
    ConditionState state = ConditionStateFit;
    
    for (JobApplyConditionCellModel *model in self.cellModelArray) {
        
        if (model.state == ConditionStateUnknow) {
            return ConditionStateUnknow;
        }
        
        if (model.state == ConditionStateUnFit) {
            state = ConditionStateUnFit;
        }
    }
    
    // 需要显示日历,却没有选择时间,则不能报名
    if (self.showCalendar && !self.dateView.datesSelected.count) {
        state = ConditionStateUnFit;
    }
    
    return state;
}


/** 更新确定按钮状态 */
- (void)updateApplyBtnState{
    ConditionState state = [self checkForApply];
    
    switch (state) {
        case ConditionStateUnknow:
        {
            [self.applyBtn setTitle:@"去完善" forState:UIControlStateNormal];
            self.applyBtn.enabled = YES;
            [self.applyBtn setBackgroundImage:[UIImage imageNamed:@"v210_delete_background"] forState:UIControlStateNormal];
        }
            break;
            
        case ConditionStateUnFit:
        {
            [self.applyBtn setTitle:@"确定" forState:UIControlStateNormal];
            self.applyBtn.enabled = NO;
            [self.applyBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        }
            break;
            
        case ConditionStateFit:
        {
            [self.applyBtn setTitle:@"确定" forState:UIControlStateNormal];
            self.applyBtn.enabled = YES;
            [self.applyBtn setBackgroundImage:[UIImage imageNamed:@"v210_delete_background"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    // 已报名
    if (self.isApplyed) {
        self.dateView.userInteractionEnabled = NO;
        [self.applyBtn setTitle:@"已报名" forState:UIControlStateDisabled];
        [self.applyBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateDisabled];
        self.applyBtn.enabled = NO;
    }
}


- (NSString *)conditionDayStr{
    NSString *dayStr = @"最少上岗天数";
    
    switch (self.jobModel.apply_job_date.integerValue) {
        case 0:{
            dayStr = @"全部到岗";
        }
            break;
        case 2:{
            dayStr = @"到岗2天以上";
        }
            break;
        case 3:{
            dayStr = @"到岗3天以上";
        }
            break;
        case 5:
        {
            dayStr = @"到岗5天以上";
        }
            break;
        default:
            break;
    }
    return dayStr;
}


#pragma mark - ***** UITableViewDelegate ******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobApplyConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobApplyConditionCell" forIndexPath:indexPath];
    
    cell.model = self.cellModelArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.cellModelArray) {
        return 0;
    }
    return self.cellModelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


#pragma mark - 点击事件
/** 报名按钮点击 */
- (void)applyBtnClick:(UIButton*)sender{
    ConditionState state = [self checkForApply];
    
    if (state == ConditionStateFit) {
        [self apply];
    }
    
    if (state == ConditionStateUnknow) {
        // 跳转完善简历页面
        LookupResume_VC *vc = [[LookupResume_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)apply{
    [self checkApplyDate];
    
    // 抢单(手续费) | 普通
    if (self.jobModel.job_type.integerValue == 1) { // 普通
        [self checkApplyJob];
    }
    
}


- (void)checkApplyDate{
    self.applyDateArray = [NSMutableArray array];
    
    // 保存报名数组
    for (NSDate *date in self.dateView.datesSelected) {
        [self.applyDateArray addObject:@([date timeIntervalSince1970])];
    }
    
    // 日期排序
    NSArray *tmpWorkTime = [self.applyDateArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        
        if (obj1.longLongValue < obj2.longLongValue) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    self.applyDateArray = [NSMutableArray arrayWithArray:tmpWorkTime];
}


/** 弹框确定报名 */
- (void)checkApplyJob{
    // 弹框确定报名
    UIAlertView *applyAlertView = [[UIAlertView alloc] initWithTitle:@"报名确认" message:@"确定报名吗? 上岗后要努力工作唷~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [applyAlertView show];
}



/** 报名 */
- (void)applyJobWithJobId:(NSString *)jobId workTime:(NSArray *)workTime{
    NSNumber *isFromQrCodeScan = @(0);
    
    WEAKSELF
    [[UserData sharedInstance] candidateApplyJobWithJobId:jobId workTime:workTime isFromQrCodeScan:isFromQrCodeScan block:^(ResponseInfo *response) {
        if (response && response.success) {
            [UIHelper toast:@"报名成功"];
            
            // 岗位详情设置为已报名
            weakSelf.jobDetailVC.jobDetailModel.parttime_job.student_applay_status = @(1);
            weakSelf.jobDetailVC.shouldUpdateApplyBtnState = YES;
            
            // 当前页面设置为已报名
            weakSelf.isApplyed = YES;
            
            ApplySuccess_VC *vc = [[ApplySuccess_VC alloc] init];
            vc.jobModel = weakSelf.jobModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}


/** 日历全选按钮点击 */
- (void)selectBtnClick:(UIButton *)btn{
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
    
    if (self.jobModel.apply_job_date) {
        
        [self checkApplyDate];
        [self updateDateConditionWithConditionState:[self conditionStateOfApplyJobDate]];
    }

    [self updateApplyBtnState];
    [self.tableView reloadData];
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if ([alertView.title isEqualToString:@"报名确认"] && buttonIndex == 1) {
        if (self.jobModel.job_type.integerValue == 1) { // 普通
            // 发送报名请求
            [self applyJobWithJobId:self.jobModel.job_id.stringValue workTime:self.applyDateArray];
        }
    }

    // 扣款提醒
    if ([alertView.title isEqualToString:@"提醒"] && buttonIndex == 1) {
        // 发送报名请求
        [self applyJobWithJobId:self.jobModel.job_id.description workTime:self.applyDateArray];
    }
}

@end
