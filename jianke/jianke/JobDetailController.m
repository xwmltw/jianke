//
//  JobDetailController.m
//  jianke
//
//  Created by fire on 15/9/19.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "JobDetailController.h"
#import "UIView+Extension.h"
#import "JobDetailModel.h"
#import "UIImageView+WebCache.h"
#import "jobQAModel.h"
#import "JobQACellModel.h"
#import "JobQACell.h"
#import "LookupApplyJKListController.h"
#import "LookupEPInfo_VC.h"
#import "DateSelectView.h"
#import "DLAVAlertView.h"
#import "ShareHelper.h"
#import "XHPopMenu.h"
#import "RefreshLeftCountModel.h"
#import "PostJobController.h"
#import "CityTool.h"
#import "WDChatView_VC.h"
#import "ViewController.h"
#import "MoneyBag_VC.h"
#import "IDCardAuth_VC.h"
#import "ImDataManager.h"
#import "TalentModel.h"
#import "BusMap_VC.h"
#import "conditionBtnView.h"
#import "JobApplyConditionController.h"
#import "DateTools.h"
#import "JKApplyJobListController.h"
#import "JobRefreshHeader.h"
#import "JobRefreshBackFooter.h"
#import "ShareToGroupController.h"
#import "NSObject+SYAddForProperty.h"

const CGFloat paddingX = 10;
const CGFloat paddingY = 10;
const CGFloat margingX = 10;
const CGFloat margingY = 15;


@interface JobDetailController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>



// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyViewHeightConstraint; /*!< 抢单&已报名兼客View高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobTitleLabelLeftConstraint; /*!< 岗位标题左边约束 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint; /*!< 头部高度约束 */


// 基本信息
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *seizeImageView; /*!< 抢单图标 */
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel; /*!< 岗位标题 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel; /*!< 薪资 */
@property (weak, nonatomic) IBOutlet UILabel *unitLabel; /*!< 薪资单位 */
@property (weak, nonatomic) IBOutlet UIImageView *jobStateImageView; /*!< 企业认证状态图标 */
@property (weak, nonatomic) IBOutlet UILabel *jobDateLabel; /*!< 兼职日期 */
@property (weak, nonatomic) IBOutlet UILabel *jobTimeRangLabel; /*!< 兼职时间段 */
@property (weak, nonatomic) IBOutlet UILabel *jobPeopleNumLabel; /*!< 招聘的兼职人数 */
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel; /*!< 位置 */
@property (weak, nonatomic) IBOutlet UIImageView *conditionIcon; /*!< 条件限制图标 */
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel; /*!< 条件限制 */
@property (weak, nonatomic) IBOutlet UILabel *applyEndDateLabel; /*!< 报名截止日期 */


// 岗位描述
@property (weak, nonatomic) IBOutlet UIImageView *jobDescBgImageView; /*!< 岗位描述背景图片 */

// 报名
@property (weak, nonatomic) IBOutlet UIView *applyView; /*!< 抢单&已报名兼客View */
@property (weak, nonatomic) IBOutlet UIButton *applyBtn; /*!< 报名按钮 */
@property (weak, nonatomic) IBOutlet UILabel *applyJkCountLabel; /*!< 已报名兼客人数 */
@property (weak, nonatomic) IBOutlet UIView *applyListView; /*!< 已报名兼客列表View */
@property (weak, nonatomic) IBOutlet UIView *applyIconListView; /*!< 已报名兼客头像列表View */

// 雇主答疑
@property (weak, nonatomic) IBOutlet UIButton *askQuestionBtn; /*!< 提问按钮 */
@property (weak, nonatomic) IBOutlet UITableView *questionTableView; /*!< 问答tableView */

@property (nonatomic, strong) NSArray *qaCellArray; /*!< 雇主答疑Cell数组, 存放JobQACellModel模型 */
@property (nonatomic, strong) jobQAModel *qaAnswerModel; /*!< 雇主回复兼客的提问 */

@property (nonatomic, strong) UIAlertView *trueNameAlertView;
@property (nonatomic, strong) UIAlertView *answerAlertView;
@property (nonatomic, strong) UIAlertView *askAlertView;

@property (nonatomic, strong) NSMutableArray *workTime; /*!< 工作时间 */

@property (nonatomic, strong) UIWebView *phoneWebView;

@property (nonatomic, strong) XHPopMenu *epPopMenu; /*!< 雇主视角,右上角pop菜单 */

@property (weak, nonatomic) IBOutlet UILabel *jobDscLabel; /*!< 岗位描述 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *complainBtn;//举报button

@property (weak, nonatomic) IBOutlet UIButton *complainFinishBtn;//举报成功

@property (weak, nonatomic) IBOutlet UIButton *invitBtn; /*!< 邀请人才 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QAToImgConstraint;


// v220



@property (nonatomic, weak) UILabel *dealTimeTitleLabel; /*!< 处理简历用时标题 */
@property (weak, nonatomic) UILabel *lastLookupTimeTitleLabel; /*!< 上次查看简历标题 */
@property (weak, nonatomic) UILabel *payWayTitleLabel; /*!< 付款方式标题 */
@property (weak, nonatomic) UILabel *payTimeTitleLabel; /*!< 结算方式标题 */

@property (weak, nonatomic) UILabel *dealTimeLabel; /*!< 处理简历用时 */
@property (weak, nonatomic) UILabel *lastLookupTimeLabel; /*!< 上次查看简历 */
@property (weak, nonatomic) UILabel *payWayLabel; /*!< 付款方式 */
@property (weak, nonatomic) UILabel *payTimeLabel; /*!< 结算方式 */
@property (weak, nonatomic) IBOutlet UIView *payWayView; /*!< 支付方式等的View */

@property (nonatomic, weak) UIView *line1; /*!< 分割线 */
@property (nonatomic, weak) UIView *line2; /*!< 分割线 */
@property (nonatomic, weak) UIView *line3; /*!< 分割线 */


//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionViewHeightConstraint; /*!< 条件限制View */
//
//@property (weak, nonatomic) IBOutlet UIView *conditionView; /*!< 条件限制View */
//
//@property (nonatomic, strong) NSMutableArray *conditionBtnArray; /*!< 条件限制按钮数组 */





@property (nonatomic, strong) UIButton *guideForSocialActivistBtn; /*!< 人脉王遮罩引导 */


@property (weak, nonatomic) IBOutlet UIView *contactView; /*!< 联系方式View */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactViewHeight; /*!< 联系方式View高度 */
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel; /*!< 联系人 */
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel; /*!< 联系电话 */
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn; /*!< 电话按钮 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conatctViewTopToDescLabel; /*!< 岗位描述距离联系方式View的距离 70/90 */

@property (weak, nonatomic) IBOutlet UIView *bottomView; /*!< 底部的View */

@property (nonatomic, assign) CGFloat iconHeight;

@property (nonatomic, assign) BOOL noCallJobVcFinishBlock; /*!< 不再调用JobViewController的回调 */

@property (nonatomic, assign) CGFloat tableViewHeight;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyEndDateIconTop; /*!< 报名截止日期top约束 44/10 */



@end

@implementation JobDetailController

#pragma mark - lazy
- (XHPopMenu *)epPopMenu{
    
    if (!_epPopMenu) {
        XHPopMenuItem *popMenuPlublishItem = [[XHPopMenuItem alloc] initWithImage:nil title:@"快捷发布"];
        XHPopMenuItem *popMenuCloseItem = [[XHPopMenuItem alloc] initWithImage:nil title:@"结束招聘"];
        XHPopMenu *epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuPlublishItem, popMenuCloseItem]];
        
        if (self.jobDetailModel.parttime_job.status.integerValue == 1 || self.jobDetailModel.parttime_job.status.integerValue == 3) { // 待审核 || 已结束
            epPopMenu = [[XHPopMenu alloc] initWithMenus:@[popMenuPlublishItem]];
        }
        
        epPopMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem){
            if (index == 0) { // 快捷发布
                DLog(@"快捷发布");
                [TalkingData trackEvent:@"已报名_岗位详情_快捷发布"];
                [self jobDetail];
            }
            
            if (index == 1) { // 结束招聘
                [self closeJob];
            }
        };
        _epPopMenu = epPopMenu;
    }
    return _epPopMenu;
}


- (UILabel *)dealTimeTitleLabel{
    if (!_dealTimeTitleLabel) {
        UILabel *dealTimeTitleLabel = [[UILabel alloc] init];
        dealTimeTitleLabel.font = [UIFont systemFontOfSize:10];
        dealTimeTitleLabel.textColor = COLOR_RGB(163, 163, 163);
        dealTimeTitleLabel.textAlignment = NSTextAlignmentCenter;
        dealTimeTitleLabel.text = @"处理简历用时";
        dealTimeTitleLabel.height = 10;
        dealTimeTitleLabel.y = 4;
        [self.payWayView addSubview:dealTimeTitleLabel];
        _dealTimeTitleLabel = dealTimeTitleLabel;
    }
    return _dealTimeTitleLabel;
}


- (UILabel *)lastLookupTimeTitleLabel{
    if (!_lastLookupTimeTitleLabel) {
        UILabel *lastLookupTimeTitleLabel = [[UILabel alloc] init];
        lastLookupTimeTitleLabel.font = [UIFont systemFontOfSize:10];
        lastLookupTimeTitleLabel.textColor = COLOR_RGB(163, 163, 163);
        lastLookupTimeTitleLabel.textAlignment = NSTextAlignmentCenter;
        lastLookupTimeTitleLabel.text = @"上次查看简历";
        lastLookupTimeTitleLabel.height = 10;
        lastLookupTimeTitleLabel.y = 4;
        [self.payWayView addSubview:lastLookupTimeTitleLabel];
        _lastLookupTimeTitleLabel = lastLookupTimeTitleLabel;
    }
    return _lastLookupTimeTitleLabel;
}


- (UILabel *)payWayTitleLabel{
    if (!_payWayTitleLabel) {
        UILabel *payWayTitleLabel = [[UILabel alloc] init];
        payWayTitleLabel.font = [UIFont systemFontOfSize:10];
        payWayTitleLabel.textColor = COLOR_RGB(163, 163, 163);
        payWayTitleLabel.textAlignment = NSTextAlignmentCenter;
        payWayTitleLabel.text = @"付款方式";
        payWayTitleLabel.height = 10;
        payWayTitleLabel.y = 4;
        [self.payWayView addSubview:payWayTitleLabel];
        _payWayTitleLabel = payWayTitleLabel;
    }
    return _payWayTitleLabel;
}


- (UILabel *)payTimeTitleLabel{
    if (!_payTimeTitleLabel) {
        UILabel *payTimeTitleLabel = [[UILabel alloc] init];
        payTimeTitleLabel.font = [UIFont systemFontOfSize:10];
        payTimeTitleLabel.textColor = COLOR_RGB(163, 163, 163);
        payTimeTitleLabel.textAlignment = NSTextAlignmentCenter;
        payTimeTitleLabel.text = @"发薪时间";
        payTimeTitleLabel.height = 10;
        payTimeTitleLabel.y = 4;
        [self.payWayView addSubview:payTimeTitleLabel];
        _payTimeTitleLabel = payTimeTitleLabel;
    }
    return _payTimeTitleLabel;
}


- (UILabel *)dealTimeLabel{
    if (!_dealTimeLabel) {
        UILabel *dealTimeLabel = [[UILabel alloc] init];
        dealTimeLabel.font = [UIFont fontWithName:@"Roboto Slab" size:17];
        dealTimeLabel.textColor = COLOR_RGB(89, 89, 89);
        dealTimeLabel.textAlignment = NSTextAlignmentCenter;
        dealTimeLabel.height = 17;
        dealTimeLabel.y = 25;
        [self.payWayView addSubview:dealTimeLabel];
        _dealTimeLabel = dealTimeLabel;
    }
    return _dealTimeLabel;
}


- (UILabel *)lastLookupTimeLabel{
    if (!_lastLookupTimeLabel) {
        UILabel *lastLookupTimeLabel = [[UILabel alloc] init];
        lastLookupTimeLabel.font = [UIFont fontWithName:@"Roboto Slab" size:17];
        lastLookupTimeLabel.textColor = COLOR_RGB(89, 89, 89);
        lastLookupTimeLabel.textAlignment = NSTextAlignmentCenter;
        lastLookupTimeLabel.height = 17;
        lastLookupTimeLabel.y = 25;
        [self.payWayView addSubview:lastLookupTimeLabel];
        _lastLookupTimeLabel = lastLookupTimeLabel;
    }
    return _lastLookupTimeLabel;
}


- (UILabel *)payTimeLabel{
    if (!_payTimeLabel) {
        UILabel *payTimeLabel = [[UILabel alloc] init];
        payTimeLabel.font = [UIFont fontWithName:@"Roboto Slab" size:17];
        payTimeLabel.textColor = COLOR_RGB(89, 89, 89);
        payTimeLabel.textAlignment = NSTextAlignmentCenter;
        payTimeLabel.height = 17;
        payTimeLabel.y = 25;
        [self.payWayView addSubview:payTimeLabel];
        _payTimeLabel = payTimeLabel;
    }
    return _payTimeLabel;
}


- (UILabel *)payWayLabel{
    if (!_payWayLabel) {
        UILabel *payWayLabel = [[UILabel alloc] init];
        payWayLabel.font = [UIFont fontWithName:@"Roboto Slab" size:17];
        payWayLabel.textColor = COLOR_RGB(89, 89, 89);
        payWayLabel.textAlignment = NSTextAlignmentCenter;
        payWayLabel.height = 17;
        payWayLabel.y = 25;
        [self.payWayView addSubview:payWayLabel];
        _payWayLabel = payWayLabel;
    }
    return _payWayLabel;
}

- (UIView *)line1{
    if (!_line1) {
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = COLOR_RGB(163, 163, 163);
        line1.width = 1;
        line1.height = 10;
        line1.y = 4;
        [self.payWayView addSubview:line1];
        _line1 = line1;
    }
    return _line1;
}


- (UIView *)line2{
    if (!_line2) {
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = COLOR_RGB(163, 163, 163);
        line2.width = 1;
        line2.height = 10;
        line2.y = 4;
        [self.payWayView addSubview:line2];
        _line2 = line2;
    }
    return _line2;
}


- (UIView *)line3{
    if (!_line3) {
        UIView *line3 = [[UIView alloc] init];
        line3.backgroundColor = COLOR_RGB(163, 163, 163);
        line3.width = 1;
        line3.height = 10;
        line3.y = 4;
        [self.payWayView addSubview:line3];
        _line3 = line3;
    }
    return _line3;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionTableView.scrollEnabled = NO;
    self.questionTableView.allowsSelection = NO;
//    self.scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.questionTableView.backgroundColor = [UIColor WDColor_grayTVBg];
    self.questionTableView.separatorColor = [UIColor WDColor_grayTVBg];
    
    //    self.userType = WDLoginType_Employer;
    if (!self.userType) {
        self.userType = [[UserData sharedInstance] getLoginType].intValue;
    }
    
    // 注册cell
    [self.questionTableView registerNib:[UINib nibWithNibName:@"JobQACell" bundle:nil] forCellReuseIdentifier:@"JobQACell"];
    
    // 注册通知
    [WDNotificationCenter addObserver:self selector:@selector(epAnswerJKQuestion:) name:EPAnswerJKQuestionNotification object:nil];
    
    // 加载完成前隐藏初始化页面
    self.scrollView.hidden = YES;
    
    // 添加上拉下拉刷新
    [self setupReflush];
    
    // 获取数据
    [self getData];
}

- (void)sendLog{
    CityModel* cityModel = [[UserData sharedInstance] city];
    
    NSString *content = [NSString stringWithFormat:@"\"job_id\":\"%@\",\"city_id\":\"%@\",\"access_client_type\":\"%@\"", self.jobId, cityModel? cityModel.id : @"211",[UserData getClientType]];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_jobAccessLogRecord" andContent:content];
    request.isShowLoading = NO;
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && response.success) {
            ELog(@"====log 发送成功");
        }
    }];
    
}


- (void)setupReflush{
    if (self.isFromJobViewController) {
     
        self.scrollView.header = [JobRefreshHeader headerWithRefreshingBlock:^{
            if (self.headerReflushBlock) {
                self.headerReflushBlock(nil);
            }
        }];        
        
        self.scrollView.footer = [JobRefreshBackFooter footerWithRefreshingBlock:^{
            if (self.footerReflushBlock) {
                self.footerReflushBlock(nil);
            }
        }];
    }
}


- (void)backToLastView{
    if (self.isFromQrScan) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//快捷举报
- (IBAction)complain:(UIButton *)sender {
    UIAlertView *informAlertView = [[UIAlertView alloc] initWithTitle:@"举报雇主" message:@"请选择您的举报原因。经查证如不属实将影响您的信用度!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"岗位已过期", @"收费/虚假信息", @"到岗不予录用", @"联系客服", nil];
    [informAlertView show];
}

- (void)dealloc{
    [WDNotificationCenter removeObserver:self];
}

/** 设置数据 */
- (void)setupData{
    JobModel *jobModel = self.jobDetailModel.parttime_job;

    // 抢单图标
    if (!jobModel.job_type || jobModel.job_type.integerValue == 1) { // 普通兼职
        self.seizeImageView.hidden = YES;
        self.jobTitleLabelLeftConstraint.constant = 16;
    }
    
    // 企业认证状态
    if (jobModel.enterprise_verified && jobModel.enterprise_verified.integerValue == 3) {
        self.jobStateImageView.hidden = NO;
    }
    // 设置基本信息
    self.jobTitleLabel.text = jobModel.job_title;
    NSString *moneyStr = [NSString stringWithFormat:@"￥%@", [NSString stringWithFormat:@"%.1f", jobModel.salary.value.floatValue]];
    self.moneyLabel.text = [moneyStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    NSString *unitStr = [jobModel.salary.unit_value stringByReplacingOccurrencesOfString:@"小时" withString:@"时"];
    unitStr = [unitStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    self.unitLabel.text = unitStr;
    
    // 日期
    NSString *startDate = [DateHelper getDateWithNumber:@(jobModel.working_time_start_date.longLongValue * 0.001)];
    NSString *endDate = [DateHelper getDateWithNumber:@(jobModel.working_time_end_date.longLongValue * 0.001)];
    
    self.jobDateLabel.text = [NSString stringWithFormat:@"%@ 至 %@", startDate, endDate];
    
    // 时间段
    WorkTimePeriodModel *workTimeRange = jobModel.working_time_period;
    NSString *timeRangeStr = nil;
    
    if (workTimeRange.f_start && workTimeRange.f_end) {
        
        NSString *startTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.f_start.longLongValue * 0.001)];
        NSString *endTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.f_end.longLongValue * 0.001)];
     
        timeRangeStr = [NSString stringWithFormat:@"%@~%@", startTimeStr, endTimeStr];
    }
    
    if (workTimeRange.s_start && workTimeRange.s_end) {
        
        NSString *startTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.s_start.longLongValue * 0.001)];
        NSString *endTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.s_end.longLongValue * 0.001)];
        
        timeRangeStr = [NSString stringWithFormat:@"%@, %@~%@", timeRangeStr, startTimeStr, endTimeStr];
    }
    
    if (workTimeRange.t_start && workTimeRange.t_end) {
        
        NSString *startTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.t_start.longLongValue * 0.001)];
        NSString *endTimeStr = [DateHelper getTimeWithNumber:@(workTimeRange.t_end.longLongValue * 0.001)];
        
        timeRangeStr = [NSString stringWithFormat:@"%@, %@~%@", timeRangeStr, startTimeStr, endTimeStr];
    }
    
    self.jobTimeRangLabel.text = timeRangeStr;
    
    
    NSString *areaStr = jobModel.address_area_name;
    NSString *placeStr = jobModel.working_place;
    
    NSMutableString *addressStr = [NSMutableString stringWithFormat:@""];
    if (areaStr && areaStr.length > 0) {
        [addressStr appendString:areaStr];
        
        if (placeStr && placeStr.length > 0) {
            [addressStr appendString:[NSString stringWithFormat:@"·%@", placeStr]];
        }
    } else if (placeStr && placeStr.length > 0) {
        [addressStr appendString:placeStr];
    }
    
    self.jobAddressLabel.text = addressStr;
    self.jobPeopleNumLabel.text = [NSString stringWithFormat:@"共%@人", jobModel.recruitment_num];
    
    // 岗位描述
    NSString *jobDsc = nil;
    if (jobModel.job_type && jobModel.job_type.integerValue == 2) { // 抢单兼职
        jobDsc = [jobModel.job_label componentsJoinedByString:@","];
    } else { // 普通兼职
        jobDsc = jobModel.job_desc;
    }
    
    // 浏览次数&&发布时间
    NSString *jobdscTime = [DateHelper getDateWithNumber:@(jobModel.create_time.doubleValue * 0.001)];
    NSString *jobDscTimeStr = [NSString stringWithFormat:@"%@ 次浏览 · 发布于 %@", jobModel.view_count, jobdscTime];
    
    
    self.jobDscLabel.text = jobDsc;
    self.timeLabel.text = jobDscTimeStr;
    
    // 处理简历用时 & 上次查看简历 & 付款方式 & 发薪时间
    self.dealTimeLabel.text = jobModel.enterprise_info.deal_resume_used_time_avg_desc;
    
    self.lastLookupTimeLabel.text = jobModel.enterprise_info.last_read_resume_time_desc;
    
    SalaryModel *salary = jobModel.salary;
    
    self.payTimeLabel.text = salary.settlement_value;
    
    CGFloat width;
    if (!salary.pay_type) { // 没有付款方式
        
        width = (SCREEN_WIDTH - 32) / 3;
        
        self.dealTimeTitleLabel.x = 16;
        self.lastLookupTimeTitleLabel.x = 16 + width;
        self.payTimeTitleLabel.x = 16 + width * 2;
        
        self.line1.x = self.lastLookupTimeTitleLabel.x;
        self.line2.x = self.payTimeTitleLabel.x;
        
        self.payWayTitleLabel.hidden = YES;
        self.line3.hidden = YES;
        
    } else { // 有付款方式
        
        width = (SCREEN_WIDTH - 32) / 4;
        
        self.dealTimeTitleLabel.x = 16;
        self.lastLookupTimeTitleLabel.x = 16 + width;
        self.payWayTitleLabel.x = 16 + width * 2;
        self.payTimeTitleLabel.x = 16 + width * 3;
        
        self.line1.x = self.lastLookupTimeTitleLabel.x;
        self.line2.x = self.payWayTitleLabel.x;
        self.line3.x =  self.payTimeTitleLabel.x;
        
        self.payWayTitleLabel.hidden = NO;
        self.line3.hidden = NO;
        self.payWayLabel.text = salary.pay_type.integerValue == 1 ? @"在线支付" : @"现金支付";
    }
    
    self.dealTimeTitleLabel.width = width;
    self.lastLookupTimeTitleLabel.width = width;
    self.payTimeTitleLabel.width = width;
    self.payWayTitleLabel.width = width;
    
    self.dealTimeLabel.width = width;
    self.lastLookupTimeLabel.width = width;
    self.payTimeLabel.width = width;
    self.payWayLabel.width = width;
    
    self.dealTimeLabel.x = self.dealTimeTitleLabel.x;
    self.lastLookupTimeLabel.x = self.lastLookupTimeTitleLabel.x;
    self.payWayLabel.x = self.payWayTitleLabel.x;
    self.payTimeLabel.x = self.payTimeTitleLabel.x;
    
    // 条件限制
    if (jobModel.apply_limit_arr.count) {
        NSString *limitStr = [jobModel.apply_limit_arr componentsJoinedByString:@"，"];
        self.conditionIcon.hidden = NO;
        self.conditionLabel.hidden = NO;
        self.conditionLabel.text = limitStr;
    } else {
        self.conditionIcon.hidden = YES;
        self.conditionLabel.hidden = YES;
        self.conditionLabel.text = nil;
    }
    
    // 报名截止日期
    NSString *applyEndDateStr = [DateHelper getDateWithNumber:@(jobModel.apply_dead_time.longLongValue * 0.001)];
    self.applyEndDateLabel.text = [NSString stringWithFormat:@"%@ 截止报名", applyEndDateStr];
    
    // 报名按钮 && 已报名兼客名单
    if (self.userType == WDLoginType_Employer) { // 雇主视图
        
        // 隐藏抢单按钮及报名兼客列表
        self.applyViewHeightConstraint.constant = 0;
        self.applyView.hidden = YES;
        
        if (jobModel.status.intValue == 2 && jobModel.has_been_filled.intValue != 1) {// 已发布 && 未报满
            self.invitBtn.hidden = NO;
            
        }else{
            self.invitBtn.hidden = YES;
            self.QAToImgConstraint.constant = -10;
        }
        // 隐藏提问题按钮
        self.askQuestionBtn.hidden = YES;
        
    } else {
        
        // 隐藏邀请人才按钮
        self.invitBtn.hidden = YES;
        
        // 报名按钮
        if (jobModel.status.intValue == 1) { // 待审核
            self.applyBtn.enabled = NO;
            [self.applyBtn setTitle:@" 待审核" forState:UIControlStateNormal];
        }else if(jobModel.status.intValue == 3){ // 已结束
            self.applyBtn.enabled = NO;
            
            if (jobModel.job_close_reason.intValue == 1  ){
                [self.applyBtn setTitle:@" 已关闭" forState:UIControlStateNormal];
                
            }else if(jobModel.job_close_reason.intValue == 2){
                [self.applyBtn setTitle:@" 已过期" forState:UIControlStateNormal];
                
            }else if(jobModel.job_close_reason.intValue == 3){
                [self.applyBtn setTitle:@" 已下架" forState:UIControlStateNormal];
                
            }else if(jobModel.job_close_reason.intValue == 4){
                [self.applyBtn setTitle:@" 审核未通过" forState:UIControlStateNormal];
            }
            
        }else if(jobModel.status.intValue == 2){ // 已发布
            if (jobModel.student_applay_status.intValue == 0) { // 未报名
                //隐藏快捷举报按钮
                self.complainBtn.hidden = YES;
                self.complainFinishBtn.hidden = YES;
                
                if (jobModel.has_been_filled.intValue == 0) {
                    if (jobModel.job_type &&jobModel.job_type.integerValue == 2) { // 抢单兼职
                        [self.applyBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
                    } else { // 普通兼职
                        [self.applyBtn setTitle:@"报名" forState:UIControlStateNormal];
                    }
                    self.applyBtn.enabled = YES;
                    
                }else if (jobModel.has_been_filled.intValue == 1){ // 已报满
                    
                    [self.applyBtn setTitle:@"已报满" forState:UIControlStateNormal];
                    self.applyBtn.enabled = NO;
                    
                }
            }
        }
        
        
        if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
            
            [self.applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            self.applyBtn.enabled = NO;
            
            if (self.jobDetailModel.is_complainted.intValue == 1) {//举报过
                self.complainBtn.hidden = YES;
                self.complainFinishBtn.hidden = NO;
            }else{
                self.complainBtn.hidden = NO;
                self.complainFinishBtn.hidden = YES;
            }
        }
        
        if (jobModel.has_been_filled.intValue == 1){ // 已报满
            [self.applyBtn setTitle:@"已报满" forState:UIControlStateNormal];
        }
        
        // 扫码补录过来的..
        if (self.isFromQrScan) {
            
            if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
                
                [self.applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
                self.applyBtn.enabled = NO;
                if (self.jobDetailModel.is_complainted.intValue == 1) {//举报过
                    self.complainBtn.hidden = YES;
                    self.complainFinishBtn.hidden = NO;
                }else{
                    self.complainBtn.hidden = NO;
                    self.complainFinishBtn.hidden = YES;
                }
                
            } else {
                
                if (jobModel.job_type &&jobModel.job_type.integerValue == 2) { // 抢单兼职
                    [self.applyBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
                } else { // 普通兼职
                    [self.applyBtn setTitle:@"报名" forState:UIControlStateNormal];
                }
                self.applyBtn.enabled = YES;
            }
        }
        
        
        // 已报名兼客名单
        if (self.jobDetailModel.apply_job_resumes_count.integerValue != 0 && self.userType != WDLoginType_Employer) {
            
            self.applyJkCountLabel.text = [NSString stringWithFormat:@"%@人已报名", self.jobDetailModel.apply_job_resumes_count];
            
            // 已报名兼客头像列表
            NSInteger count = self.jobDetailModel.apply_job_resumes.count;
            
            if (count > 10) {
                count = 10;
            }
            
            CGFloat iconMargin = 5;
            for (NSInteger i = 0; i < count; i++) {
                UIImageView *iconImagView = [[UIImageView alloc] init];
                ApplyJobResumeModel *applyJobResume = self.jobDetailModel.apply_job_resumes[i];
                iconImagView.width = 20;
                iconImagView.height = iconImagView.width;
                iconImagView.y = 0;
                iconImagView.x = (iconImagView.width + iconMargin) * i;
                [self.applyIconListView addSubview:iconImagView];
                [iconImagView sd_setImageWithURL:[NSURL URLWithString:applyJobResume.user_profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];
                //                iconImagView.backgroundColor = [UIColor redColor]; // delete
            }
            
            self.applyListView.hidden = NO;
            self.applyViewHeightConstraint.constant = 170;
            
        } else {
            self.applyListView.hidden = YES;
            self.applyViewHeightConstraint.constant = 50;
        }
        
        // 显示提问题按钮
        self.askQuestionBtn.hidden = NO;
    }
    
    
    // 导航栏按钮
    if (self.userType == WDLoginType_Employer) { // 雇主视图
        
        //        下拉列表
        //        快捷发布：对该岗位稍作编辑后重新发布。
        //        结束招聘：未招满未到期时，主动结束招聘（沿用旧版本「关闭岗位」的功能设定）
        //        刷新岗位：沿用旧版本功能设定。
        //        社交分享：沿用旧版本功能设定。
        
        // 下拉列表, 下拉子菜单:  快捷发布：对该岗位稍作编辑后重新发布。 结束招聘：未招满未到期时，主动结束招聘（沿用旧版本「关闭岗位」的功能设定）
        
        UIBarButtonItem *epDropDownMenuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"job_xq_more_0"] style:UIBarButtonItemStylePlain target:self action:@selector(epDropDownMenuClick:)];
        [epDropDownMenuBtn setBackgroundImage:[UIImage imageNamed:@"job_xq_more_1"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        // 刷新岗位
        UIBarButtonItem *reflushBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"job_xq_refresh_0"] style:UIBarButtonItemStylePlain target:self action:@selector(reflushClick:)];
        [reflushBtn setBackgroundImage:[UIImage imageNamed:@"job_xq_refresh_1"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        // 社交分享
        UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v231_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick:)];

        [shareBtn setBackgroundImage:[UIImage imageNamed:@"v231_share_p"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        if (self.jobDetailModel.parttime_job.status.integerValue == 1 || self.jobDetailModel.parttime_job.status.integerValue == 3) { // 待审核 || 已结束
            
            self.navigationItem.rightBarButtonItems = @[epDropDownMenuBtn];
            
        } else {
            
            self.navigationItem.rightBarButtonItems = @[epDropDownMenuBtn, shareBtn, reflushBtn];
        }
        
        
    } else { // 兼客 游客视图
        
        // 社交分享
        UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v231_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"v231_share_p"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        // 雇主信息
        UIBarButtonItem *lookupEPResumeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"job_xq_rt_0"] style:UIBarButtonItemStylePlain target:self action:@selector(lookupEPResumeClick:)];
        [lookupEPResumeBtn setBackgroundImage:[UIImage imageNamed:@"job_xq_rt_0"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        // IM 对聊
        UIBarButtonItem *imBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"job_xq_msg_0"] style:UIBarButtonItemStylePlain target:self action:@selector(chatWithEPClick:)];
        [imBtn setBackgroundImage:[UIImage imageNamed:@"job_xq_msg_1"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        self.navigationItem.rightBarButtonItems = @[shareBtn, lookupEPResumeBtn, imBtn];
        if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
        } else { // 未报名
            self.QAToImgConstraint.constant = 24;
        }
    }
    
    
    // 弹窗
    if (self.userType == WDLoginType_Employer) { // 雇主视图
     
        // 审核未通过 || 已下架
        
        if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 3 || self.jobDetailModel.parttime_job.job_close_reason.integerValue == 4) {
            
            NSString *title = nil;
            NSString *message = @"🐷是怎么死的?";
            
            if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 3) {
                title = @"岗位下架原因";
            }
            
            if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 4) {
                title = @"岗位审核未通过原因";
            }
            
            if (self.jobDetailModel.parttime_job.revoke_reason) {
                message = self.jobDetailModel.parttime_job.revoke_reason;
            }
            
            UIAlertView *closeAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [closeAlertView show];
        }
    } else {
        
        
        // 审核未通过 || 已下架
        
        if (self.jobDetailModel.parttime_job.job_close_reason.integerValue == 3 || self.jobDetailModel.parttime_job.job_close_reason.integerValue == 4) {
            
            NSString *title = @"岗位已下架";
            NSString *message = @"对不起，该岗位已下架，看看其他合适的岗位吧";
            
            UIAlertView *closeAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            closeAlertView.tag = 230;
            [closeAlertView show];
        }
    }
    
    
    // 联系方式
    self.contactView.layer.borderColor = COLOR_RGB(227, 227, 227).CGColor;
    self.contactView.layer.borderWidth = 0.5;
    
    if (jobModel.enterprise_info.enterprise_name && jobModel.enterprise_info.enterprise_name.length) {
        self.contactNameLabel.text = jobModel.enterprise_info.enterprise_name;
    } else if (jobModel.contact.name && jobModel.contact.name.length) {
        self.contactNameLabel.text = jobModel.contact.name;
    }
        
    if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
    
        [self.phoneBtn setImage:[UIImage imageNamed:@"info_dbsx_phone"] forState:UIControlStateNormal];
        
        if (jobModel.contact.phone_num && jobModel.contact.phone_num.length == 11) {
            self.contactPhoneLabel.text = jobModel.contact.phone_num;
        }
        
    } else {
        
        [self.phoneBtn setImage:[UIImage imageNamed:@"v240_phone"] forState:UIControlStateNormal];
        
        if (jobModel.contact.phone_num && jobModel.contact.phone_num.length == 11) {
            self.contactPhoneLabel.text = [NSString stringWithFormat:@"%@%@%@", [jobModel.contact.phone_num substringToIndex:3], @"****", [jobModel.contact.phone_num substringFromIndex:7]];
        }
    }
    
    // 绩效, 底薪, 包餐, 培训
    [self.jobTitleLabel sizeToFit];
    [self.jobAddressLabel sizeToFit];
    [self.conditionLabel sizeToFit];
    [self.jobDscLabel sizeToFit];
    
    BOOL showWelfareView = NO;
    
    for (WelfareModel *jobTag in self.jobDetailModel.parttime_job.job_tags) {
        
        if (jobTag.check_status.integerValue) {
            showWelfareView = YES;
            break;
        }
    }
    
    if (showWelfareView) {
        
        self.conatctViewTopToDescLabel.constant = 90;
        self.iconHeight = 20;

        // 添加图标View
        UIView *iconView = [[UIView alloc] init];
        [self.bottomView addSubview:iconView];
        
        WEAKSELF
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(SCREEN_WIDTH - 48);
            make.height.mas_equalTo(20);
            make.top.equalTo(weakSelf.jobDscLabel.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.jobDscLabel);
        }];
        
        // 添加图标
        CGFloat x  = 0;
        CGFloat y = 0;
        
        for (WelfareModel *jobTag in self.jobDetailModel.parttime_job.job_tags) {
            
            if (jobTag.check_status.integerValue) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:jobTag.tag_img_url] placeholderImage:[UIImage imageNamed:@"v230_grid"]];
                imageView.layer.cornerRadius = 2;
                imageView.layer.masksToBounds = YES;
                [iconView addSubview:imageView];
                x += 30;
            }
        }

    } else {
        
        self.conatctViewTopToDescLabel.constant = 70;
        self.iconHeight = 0;
    }
  
    // 初始化页面完成
    self.scrollView.hidden = NO;
    
    [self updateViewHeight];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self updateViewHeight];
    
    DLog(@"xx===%f===%@", self.questionTableView.height, @"self.questionTableView.height");
    DLog(@"xx===%f===%@", self.scrollViewHeightConstraint.constant, @"self.scrollViewHeightConstraint.constant");
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateViewHeight];
    
    DLog(@"xx===%f===%@", self.questionTableView.height, @"self.questionTableView.height");
    DLog(@"xx===%f===%@", self.scrollViewHeightConstraint.constant, @"self.scrollViewHeightConstraint.constant");
    
}

- (void)updateViewHeight
{
    JobModel *jobModel = self.jobDetailModel.parttime_job;
    if (jobModel.apply_limit_arr.count) {
        self.headViewHeightConstraint.constant = self.jobTitleLabel.height + self.jobAddressLabel.height + 185 + self.conditionLabel.height;
        self.applyEndDateIconTop.constant = self.conditionLabel.height + 20;
    } else {
        self.headViewHeightConstraint.constant = self.jobTitleLabel.height + self.jobAddressLabel.height + 179;
        self.applyEndDateIconTop.constant = self.jobAddressLabel.height - 10;
    }
    
    self.scrollViewHeightConstraint.constant = self.jobDscLabel.height + self.applyViewHeightConstraint.constant + self.headViewHeightConstraint.constant + 450 + self.contactViewHeight.constant + self.iconHeight + self.tableViewHeight;
    
    if (self.scrollViewHeightConstraint.constant < SCREEN_HEIGHT) {
        self.scrollViewHeightConstraint.constant = SCREEN_HEIGHT;
    }

}


//- (UILabel *)setupLabelWithTitle:(NSString *)aTitle color:(UIColor *)aColor position:(CGPoint)aPosiiton
//{
//    UILabel *label = [[UILabel alloc] init];
//    label.text = aTitle;
//    label.textColor = aColor;
//    label.font = [UIFont systemFontOfSize:15];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.layer.borderWidth = 1;
//    label.layer.borderColor = aColor.CGColor;
//    label.layer.cornerRadius = 2;
//    label.layer.masksToBounds = YES;
//    label.x = aPosiiton.x;
//    label.y = aPosiiton.y;
//    label.height = 20;
//    label.width = 50;
//    
//    return label;
//}

    
/** 是否进行条件筛选 */
- (BOOL)isSetCondition
{
    JobModel *jobModel = self.jobDetailModel.parttime_job;
    
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


/** 设置条件限制View */
//- (void)updateCondition
//{
//    if (!self.conditionBtnArray) {
//        self.conditionBtnArray = [[NSMutableArray alloc] init];
//    } else {
//        return;
//    }
//    
//    JobModel *jobModel = self.jobDetailModel.parttime_job;
//
//    if (jobModel.sex) {
//        
//        NSString *title = jobModel.sex.integerValue == 1 ? @"仅限男生" : @"仅限女生";
//        
//        UIButton *sexBtn = [[UIButton alloc] init];
//        [sexBtn setTitle:title forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:sexBtn];
//    }
//    
//    if (jobModel.age && jobModel.age.intValue != 0) {
//        
//        NSString *title;
//        
//        switch (jobModel.age.integerValue) {
//            case 1:
//            {
//                title = @"18周岁以上";
//            }
//                break;
//                
//            case 2:
//            {
//                title = @"18-25周岁";
//            }
//                break;
//                
//            case 3:
//            {
//                title = @"25周岁以上";
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        UIButton *ageBtn = [[UIButton alloc] init];
//        [ageBtn setTitle:title forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:ageBtn];
//        
//    }
//    
//    if (jobModel.height && jobModel.height.intValue != 0) {
//
//        NSString *title;
//        
//        switch (jobModel.height.integerValue) {
//            case 1:
//            {
//                title = @"160cm以上";
//            }
//                break;
//                
//            case 2:
//            {
//                title = @"165cm以上";
//            }
//                break;
//                
//            case 3:
//            {
//                title = @"168cm以上";
//            }
//                break;
//                
//            case 4:
//            {
//                title = @"170cm以上";
//            }
//                break;
//                
//            case 5:
//            {
//                title = @"175cm以上";
//            }
//                break;
//                
//            case 6:
//            {
//                title = @"180cm以上";
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        UIButton *heightBtn = [[UIButton alloc] init];
//        [heightBtn setTitle:title forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:heightBtn];
//    }
//    
//    if (jobModel.rel_name_verify && jobModel.rel_name_verify.intValue != 0) {
//
//        UIButton *relNameVerifytBtn = [[UIButton alloc] init];
//        [relNameVerifytBtn setTitle:@"实名认证" forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:relNameVerifytBtn];
//    }
//    
//    if (jobModel.life_photo && jobModel.life_photo.intValue != 0) {
//
//        UIButton *lifePhotoBtn = [[UIButton alloc] init];
//        [lifePhotoBtn setTitle:@"有生活照" forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:lifePhotoBtn];
//    }
//    
//    if (jobModel.apply_job_date) {
//        
//        NSString *title;
//        
//        switch (jobModel.apply_job_date.integerValue) {
//            case 2:
//            {
//                title = @"到岗2天以上";
//            }
//                break;
//                
//            case 3:
//            {
//                title = @"到岗3天以上";
//            }
//                break;
//                
//            case 5:
//            {
//                title = @"到岗5天以上";
//            }
//                break;
//                
//            case 0:
//            {
//                title = @"全部到岗";
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        UIButton *applyJobDateBtn = [[UIButton alloc] init];
//        [applyJobDateBtn setTitle:title forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:applyJobDateBtn];
//    }
//    
//    if (jobModel.health_cer && jobModel.health_cer.intValue != 0) {
//
//        UIButton *healthCerBtn = [[UIButton alloc] init];
//        [healthCerBtn setTitle:@"有健康证" forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:healthCerBtn];
//        
//    }
//    
//    if (jobModel.stu_id_card && jobModel.stu_id_card.intValue != 0) {
//        
//        UIButton *stuIdBtn = [[UIButton alloc] init];
//        [stuIdBtn setTitle:@"有学生证" forState:UIControlStateNormal];
//        
//        [self.conditionBtnArray addObject:stuIdBtn];
//    }
//
//    if (self.conditionBtnArray.count) {
//        
//        [self.conditionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        
//        conditionBtnView *btnView = [[conditionBtnView alloc] initWithBtnArray:self.conditionBtnArray width:SCREEN_WIDTH - 32];
//        
//        [self.conditionView addSubview:btnView];
//        
//        self.conditionViewHeightConstraint.constant = btnView.height;
//        
//    } else {
//        
//        self.conditionViewHeightConstraint.constant = 0;
//    }
//}


#pragma mark - 数据交互
/** 获取数据 */
- (void)getData
{
    NSInteger isFromSAB;
    if (self.isFromSocialActivistBroadcast) {
        isFromSAB = 1;
    }else{
        isFromSAB = 0;
    }
    
    WEAKSELF
    if (self.jobUuid) {
        [[UserData sharedInstance] getJobDetailWithJobUuid:self.jobUuid block:^(JobDetailModel *model) {
            [weakSelf dealJobDetailModelBlockWithJobDetailModel:model];
        }];
        
    } else if (self.jobId) {
        [[UserData sharedInstance] getJobDetailWithJobId:self.jobId andIsFromSAB:isFromSAB Block:^(JobDetailModel *model) {
            [weakSelf dealJobDetailModelBlockWithJobDetailModel:model];
        }];
    }
}


- (void)dealJobDetailModelBlockWithJobDetailModel:(JobDetailModel *)model
{
    if (!model) {
        [UIHelper toast:@"获取岗位详情失败"];
        
        // 加载完成回调(用于上下拉查看上一个,下一个)
        if (self.loadFinishBlock && !self.noCallJobVcFinishBlock) {
            self.noCallJobVcFinishBlock = YES;
            self.loadFinishBlock(nil);
        }
        
        return;
    }
    
    if (self.jobUuid) {
        self.jobId = model.parttime_job.job_id.stringValue;
    }
    
    // 发送访问日志
    [self sendLog];
    
    self.jobDetailModel = model;
    [self setupData];
    
    // 雇主答疑
    [[UserData sharedInstance] queryJobQAWithJobId:self.jobId block:^(NSArray *qaArray) {
        
        self.qaCellArray = [JobQACellModel JobQACellArrayWithJobQAArray:qaArray];
        
        __block CGFloat tmp = 0;
        [self.qaCellArray enumerateObjectsUsingBlock:^(JobQACellModel *model, NSUInteger idx, BOOL *stop) {
            
            tmp += model.cellHeight;
        }];
        
        if (self.scrollViewHeightConstraint.constant < SCREEN_HEIGHT) {
            self.scrollViewHeightConstraint.constant = SCREEN_HEIGHT;
        }
        
        self.tableViewHeight = tmp;
        self.scrollViewHeightConstraint.constant = self.jobDscLabel.height + self.applyViewHeightConstraint.constant + self.headViewHeightConstraint.constant + 450 + self.contactViewHeight.constant + self.iconHeight + self.tableViewHeight;
        
        [self.questionTableView reloadData];
        
        // 加载完成回调(用于上下拉查看上一个,下一个)
        if (self.loadFinishBlock && !self.noCallJobVcFinishBlock) {
            self.noCallJobVcFinishBlock = YES;
            self.loadFinishBlock(@(1));
        }
    }];
}



#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.qaCellArray.count > 0) {
        return self.qaCellArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobQACellModel *qaCellModel = self.qaCellArray[indexPath.row];
    JobQACell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobQACell"];
    cell.jobQACellModel = qaCellModel;
    
    // 雇主答疑,回复按钮
    if (self.userType == WDLoginType_Employer) {
        cell.epAnswerBtn.hidden = NO;
    } else {
        cell.epAnswerBtn.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.qaCellArray.count > 0) {
        JobQACellModel *qaCellModel = _qaCellArray[indexPath.row];
        return qaCellModel.cellHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}



#pragma mark - 按钮点击
/** 报名按钮点击 */
- (IBAction)applyClick:(UIButton *)sender{
    [TalkingData trackEvent:@"岗位详情_报名申请"];
    // 判读是否登录
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        [self applyEvent];
    }];
}


- (void)applyEvent
{
    JobModel *jobModel = self.jobDetailModel.parttime_job;
    
    if (jobModel.job_type.integerValue == 1) { // 普通
        
        // 检测是否完善了姓名
        NSString *trueName = [[UserData sharedInstance] getUserTureName];
        if (!trueName || trueName.length < 1) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善姓名" message:@"请填写真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            nameTextField.placeholder = @"真实姓名";
            self.trueNameAlertView = alertView;
            [alertView show];
            
        } else {
            
            if (self.jobDetailModel.parttime_job.salary.unit.integerValue == 3 || self.jobDetailModel.parttime_job.salary.unit.integerValue == 4) { // 包月 || 元/次
                
                // 弹框确定报名
                [self checkApplyJob];
                
            } else {
                
                NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_start.longValue * 1000)];
                NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_end.longValue * 1000)];
                
                if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
                    
                    NSDate *workDate = [NSDate dateWithTimeIntervalSince1970:self.jobDetailModel.parttime_job.working_time_start_date.longLongValue * 0.001];
                    workDate = [DateHelper zeroTimeOfDate:workDate];
                    
                    self.workTime = [NSMutableArray arrayWithObject:@(workDate.timeIntervalSince1970)];
                    
                    // 弹框确定报名
                    [self checkApplyJob];
                    
                } else {
                    
                    // 弹出选择日期控件
                    [self selectWorkDate];
                }
            }
        }
        
        
    } else { // 抢单
        
        [TalkingData trackEvent:@"抢单岗位详情_立即抢单"];
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
        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(jobModel.work_time_start.longValue * 1000)];
        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(jobModel.work_time_end.longValue * 1000)];
        
        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
            // 弹框确定报名
            [self checkApplyJob];
            
        } else {
            
            // 弹出选择日期控件
            [self selectWorkDate];
        }
    }
}


/** 弹框确定报名 */
- (void)checkApplyJob
{
    // 有报名限制就进入报名限制页面
    if ([self isSetCondition] && !self.isFromQrScan) {
        
        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_start.longValue * 1000)];
        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_end.longValue * 1000)];
        
        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
            [self goToConditionVcWithCalendar:YES];
        } else {
            
            [self goToConditionVcWithCalendar:NO];
        }
        
        return;
    }
    
    // 弹框确定报名
    UIAlertView *applyAlertView = [[UIAlertView alloc] initWithTitle:@"报名确认" message:@"确定报名吗? 上岗后要努力工作唷~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [applyAlertView show];
}

/** 进入条件限制页面 */
- (void)goToConditionVcWithCalendar:(BOOL)isShowCalendar
{
    JobApplyConditionController *vc = [[JobApplyConditionController alloc] init];
    vc.showCalendar = isShowCalendar;
    vc.jobModel = self.jobDetailModel.parttime_job;
    vc.jobDetailVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 查看已报名兼客列表 */
- (IBAction)lookupApplyList:(UIButton *)sender
{
    [TalkingData trackEvent:@"岗位详情_已报名兼客更多"];
    LookupApplyJKListController *vc = [[LookupApplyJKListController alloc] init];
    vc.jobId = self.jobId;
    [self.navigationController pushViewController:vc animated:YES];
}


/** 提问按钮点击 */
- (IBAction)askQuestionClick:(UIButton *)sender
{
    [TalkingData trackEvent:@"抢单岗位详情_提问题"];
    // 判读是否登录
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提问" message:@"有什么问题要问雇主呢?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        self.askAlertView = alertView;
        [alertView show];
    }];
}


/** 分享 */
- (void)share
{
    [TalkingData trackEvent:@"岗位详情_分享"];
    
//    if (self.userType == WDLoginType_Employer) { // 雇主视图
//    
//        [ShareHelper customShareWithVc:self info:self.jobDetailModel.parttime_job.share_info_not_sms block:^(id obj) {
//            
//            [[UserData sharedInstance] entShareJobToTalentPoolWithJobId:self.jobId];
//        }];
//        
//    } else {
//     
//        [ShareHelper shareWithVc:self info:self.jobDetailModel.parttime_job.share_info_not_sms];
//    }
    
    
    WEAKSELF
    [ShareHelper jobShareWithVc:self info:self.jobDetailModel.parttime_job.share_info_not_sms block:^(NSNumber *obj) {
      
        switch (obj.integerValue) {
            case ShareTypeInvitePerson: // 分享到人才库
            {                
                [[UserData sharedInstance] entShareJobToTalentPoolWithJobId:self.jobId];
            }
                break;
            case ShareTypeIMGroup: // 分享到IM群组
            {
                ShareToGroupController *vc = [[ShareToGroupController alloc] init];
                vc.jobModel = weakSelf.jobDetailModel.parttime_job;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
//                MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:vc];
//                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }];
}


/** 兼客查看雇主简历 */
- (void)lookupEPResumeClick:(UIButton *)sender{
    [TalkingData trackEvent:@"岗位详情_雇主信息"];
    // 判读是否登录
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        LookupEPInfo_VC* vc = [UIHelper getVCFromStoryboard:@"EP" identify:@"sid_lookupEPInfo"];
        vc.lookOther = YES;
        vc.enterpriseId = [NSString stringWithFormat:@"%@",self.jobDetailModel.parttime_job.enterprise_info.enterprise_id];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
  
    
}

/** 兼客与雇主聊天 */
- (void)chatWithEPClick:(UIButton *)sender{
    [TalkingData trackEvent:@"岗位详情_IM"];

    // 判读是否登录
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        if (self.jobDetailModel.im_open_status && weakSelf.jobDetailModel.im_open_status.integerValue == 1) { // 有开通IM
            [TalkingData trackEvent:@"岗位详情_咨询" label:@"给雇主发消息"];
            NSString *jobTitle = weakSelf.jobDetailModel.parttime_job.job_title;
            
            NSString* content = [NSString stringWithFormat:@"\"accountId\":\"%@\"", weakSelf.jobDetailModel.account_id];
            RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_im_getUserPublicInfo" andContent:content];
            request.isShowLoading = NO;
            [request sendRequestToImServer:^(ResponseInfo* response) {
                if (response && [response success]) {
                    [WDChatView_VC openPrivateChatOn:weakSelf accountId:weakSelf.jobDetailModel.account_id withType:WDImUserType_Employer jobTitle:jobTitle jobId:weakSelf.jobId];
                }
            }];
        } else {
            [UIHelper toast:@"对不起,该用户未开通IM功能"];
        }
    }];

}

/** 兼客拨打雇主电话 */
- (void)phoneClick:(UIButton *)sender{
    WEAKSELF
    [[UserData sharedInstance] userIsLogin:^(id obj) {
        DLog(@"电话按钮点击事件");
        if (!weakSelf.phoneWebView) {
            weakSelf.phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [TalkingData trackEvent:@"岗位详情_拨打电话"];
        [weakSelf.phoneWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", weakSelf.jobDetailModel.parttime_job.contact.phone_num]]]];
    }];
}


/** 雇主点击导航栏右侧下拉菜单 */
- (void)epDropDownMenuClick:(UIButton *)sender{
    [self.epPopMenu showMenuAtPoint:CGPointMake(self.view.width - 130, 55)];
}

/** 雇主刷新岗位 */
- (void)reflushClick:(UIButton *)sender{
    [TalkingData trackEvent:@"已报名_岗位详情刷新"];
    JobModel *model = self.jobDetailModel.parttime_job;
    
    WEAKSELF
    [self getJobRefreshLeftCount:^(RefreshLeftCountModel* select) {
        if (select.busi_power_gift_limit.intValue + select.busi_power_limit.intValue > 0) {
            NSInteger leftCount = select.busi_power_gift_limit.intValue + select.busi_power_limit.intValue;
            NSString* leftCountStr = [NSString stringWithFormat:@"今天还剩%ld次刷新岗位机会，是否确定刷新", (long)leftCount];
            
            [UIHelper showConfirmMsg:leftCountStr completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return;
                }else{
                    [weakSelf updateParttimeJobRanking:model.job_id];
                    [TalkingData trackEvent:@"已报名_确定岗位详情刷新"];
                }
            }];
//            DLAVAlertView* alert = [[DLAVAlertView alloc] initWithTitle:@"提示" message:leftCountStr delegate:select cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
//                if (buttonIndex == 0) {
//                    return;
//                }else{
//                    [weakSelf updateParttimeJobRanking:model.job_id];
//                    [TalkingData trackEvent:@"已报名_确定岗位详情刷新"];
//                }
//            }];
        }else{
            [UIHelper showConfirmMsg:@"您今天已用完该权限...明天再来试试吧" title:@"提示" cancelButton:@"取消" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                
            }];
//            DLAVAlertView* alert = [[DLAVAlertView alloc] initWithTitle:@"提示" message:@"您今天已用完该权限...明天再来试试吧" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//            [alert show];
        }
    }];
}

/** 雇主分享岗位 */
- (void)shareClick:(UIButton *)sender{
    [TalkingData trackEvent:@"已报名_岗位详情_分享"];
    [self share];
}

/** 雇主关闭岗位 */
- (void)closeJob{
    [TalkingData trackEvent:@"已报名_岗位详情_结束招聘"];
    JobModel *model = self.jobDetailModel.parttime_job;
    if (model.status.intValue == 2) {
        WEAKSELF
        [UIHelper showConfirmMsg:@"确定结束?" completion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return;
            } else {
                [weakSelf closeJob:model.job_id];
            }
        }];
    }
}


/** 获取刷新次数 */
- (void)getJobRefreshLeftCount:(WdBlock_Id)block{
    NSString* content =@"";
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_getJobRefreshLeftCount" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据加载中...";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            if (block) {
                RefreshLeftCountModel *model=[RefreshLeftCountModel objectWithKeyValues:response.content];
                block(model);
            }
        }
    }];
}

/** 刷新岗位 */
- (void)updateParttimeJobRanking:(NSNumber *)jobId{
    NSString* content = [NSString stringWithFormat:@"job_id:%@", jobId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_updateParttimeJobRanking" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据加载中...";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            ELog(@"刷新成功");
            [UserData delayTask:0.3 onTimeEnd:^{
                [UIHelper toast:@"刷新成功"];
            }];
        } else {
            [UIHelper toast:@"刷新失败,请稍后再试~"];
        }
    }];
}


/** 举报 */
- (void)informEpWithReason:(NSString *)reason{
    NSNumber *feedback_type = @(3);
    NSString *desc = reason;
    NSNumber *job_id = self.jobDetailModel.parttime_job.job_id;
    
    NSString *content = [NSString stringWithFormat:@"feedback_type:\"%lu\", desc:\"%@\", job_id:\"%lu\"", (unsigned long)feedback_type.unsignedIntegerValue, desc, (unsigned long)job_id.unsignedIntegerValue];
    
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_submitFeedback_v2" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据发送中...";
    
    WEAKSELF
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        
        if (response && response.success) {
            [UIHelper toast:@"举报成功"];
            weakSelf.complainBtn.hidden = YES;
            weakSelf.complainFinishBtn.hidden = NO;
        } else if (!response) {
            [UIHelper toast:@"当前网络不稳定,请稍后再试"];
        }
    }];
}


/** 关闭岗位 **/
- (void)closeJob:(NSNumber *)jobId{
    NSString* content = [NSString stringWithFormat:@"job_id:%@", jobId];
    RequestInfo* request = [[RequestInfo alloc] initWithService:@"shijianke_closeJob" andContent:content];
    request.isShowLoading = NO;
    request.loadingMessage = @"数据加载中...";
    [request sendRequestWithResponseBlock:^(ResponseInfo *response) {
        if (response && [response success]) {
            if (response.errCode.intValue==0) {
                DLog(@"关闭成功");
                [UIHelper toast:@"关闭成功"];
            }
        } else if (!response) {
            [UIHelper toast:@"当前网络不稳定,请稍后再试"];
        }
    }];
}


/** 邀请人才按钮点击 */
- (IBAction)inviteBtnClick:(UIButton *)sender{
    DLog(@"邀请人才");
    [[UserData sharedInstance] entShareJobToTalentPoolWithJobId:self.jobId];
}


/** 雇主回答提问通知 */
- (void)epAnswerJKQuestion:(NSNotification *)notification{
    JobQACellModel *cellModel = notification.userInfo[EPAnswerJKQuestionInfo];
    jobQAModel *model = cellModel.jobQAModel;
    self.qaAnswerModel = model;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"回复" message:@"回复兼客提问" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.answerAlertView = alertView;
    [alertView show];
}


/** 判断余额是否够支付保证金 */
- (void)checkMoney{
    JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
    if (jkModel.bond.doubleValue > jkModel.acct_amount.doubleValue) { // 余额不足
        
        // 弹框提示充值
        NSString *message = [NSString stringWithFormat:@"当前岗位需要支付%.2f元保证金,但您目前的余额不足以支付保证金，立即充值?", jkModel.bond.doubleValue * 0.01];
        UIAlertView *moneyAlertView = [[UIAlertView alloc] initWithTitle:@"余额不足" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [moneyAlertView show];
        
    } else { // 余额充足
        
        if (jkModel.bond && jkModel.bond.doubleValue > 0) { // 保证金大于0
            
            // 弹框提醒扣款
            NSString *message = [NSString stringWithFormat:@"高薪职位抢单要先扣%.2f诚信金，只要您不放鸽子，平台立即返还全额。如果临时有事，您也别担心，可以和雇主协商后退回诚信金", (double)jkModel.bond.doubleValue * 0.01];
            [TalkingData trackEvent:@"立即抢单_立即支付"];
            UIAlertView *tackMoneyAlertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [tackMoneyAlertView show];
            
        } else {
            
            // 发送报名请求
            [self applyJobWithJobId:self.jobDetailModel.parttime_job.job_id.description workTime:self.workTime];
        }
    }
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 退出键盘
    [self.view endEditing:YES];
    
    if ([alertView.title isEqualToString:@"提问"] && buttonIndex == 1) { // 确定
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        [TalkingData trackEvent:@"抢单岗位详情_提问题_确定"];
        
        if (textField.text.length < 1) {
            [UIHelper toast:@"提问内容不能为空"];
            [alertView show];
            return;
        }
        
        [[UserData sharedInstance] stuJobQuestionWithJobId:self.jobId quesiton:textField.text block:^(id obj) {
            
            [UIHelper toast:@"发送成功"];
            [self getData];
        }];
    }
    
    if ([alertView.title isEqualToString:@"回复"] && buttonIndex == 1) { // 确定
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        if (textField.text.length < 1) {
            [UIHelper toast:@"回复内容不能为空"];
            [alertView show];
            return;
        }
        
        [[UserData sharedInstance] entJobAnswerWithJobId:self.jobId quesitonId:[self.qaAnswerModel.qa_id description] answer:textField.text block:^(id obj) {
            
            [UIHelper toast:@"发送成功"];
            [self getData];
        }];
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
                [TalkingData trackEvent:@"岗位详情_报名申请_确定输入姓名"];
                
                if (self.jobDetailModel.parttime_job.job_type.integerValue == 1) {
                    
                    // 弹出选择日期控件
                    [self selectWorkDate];
                    
                } else {
                    
                    // 具备抢单资格了..
                    NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_start.longValue * 1000)];
                    NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(self.jobDetailModel.parttime_job.work_time_end.longValue * 1000)];
                    
                    if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
                        // 弹框确定报名
                        [self checkApplyJob];
                        
                    } else {
                        
                        // 弹出选择日期控件
                        [self selectWorkDate];
                    }
                    
                }
                
            } else if (!response){
                [UIHelper toast:@"当前网络不稳定,请稍后再试"];
            }
        }];
    }
    
    
    if ([alertView.title isEqualToString:@"报名确认"] && buttonIndex == 1) {
        
        if (self.jobDetailModel.parttime_job.job_type.integerValue == 1) { // 普通
            
            // 发送报名请求
            [self applyJobWithJobId:self.jobId workTime:self.workTime];
            
        } else { // 抢单
            
            // 判断余额是否够支付保证金
            [self checkMoney];
        }
    }
    
    if ([alertView.title isEqualToString:@"认证提示"] && buttonIndex == 1) {
        
        // 跳转到认证页面
        IDCardAuth_VC *verifyVc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_jiankeIdCardAuth"];
        [self.navigationController pushViewController:verifyVc animated:YES];
    }
    
    
    if ([alertView.title isEqualToString:@"余额不足"] && buttonIndex == 1) {
        
        // 跳转到钱袋子
        MoneyBag_VC *moneyVc = [UIHelper getVCFromStoryboard:@"JK" identify:@"sid_moneybag"];
        [self.navigationController pushViewController:moneyVc animated:YES];
    }
    
    
    if ([alertView.title isEqualToString:@"提醒"] && buttonIndex == 1) {
        
        // 发送报名请求
        [self applyJobWithJobId:self.jobDetailModel.parttime_job.job_id.description workTime:self.workTime];
    }
    
    NSString *reason = nil;
    if ([alertView.title isEqualToString:@"举报雇主"]) {
        
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
                reason = @"联系客服";
                
                [[UserData sharedInstance] userIsLogin:^(id obj) {
                    UIViewController *chatViewController = [ImDataManager getKeFuChatVC];
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }];
            }
                break;
                
            default:
                break;
        }
    }
    
    // 兼客视角-岗位下架弹窗
    if (alertView.tag == 230) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 报名 */
- (void)applyJobWithJobId:(NSString *)jobId workTime:(NSArray *)workTime
{
    NSNumber *isFromQrCodeScan = @(0);
    
    if (self.isFromQrScan) {
        isFromQrCodeScan = @(1);
    }
    
    [[UserData sharedInstance] candidateApplyJobWithJobId:jobId workTime:workTime isFromQrCodeScan:isFromQrCodeScan block:^(ResponseInfo *response) {
        
        if (response && response.success) {
            
            [UIHelper toast:@"报名成功"];
            JKApplyJobListController *vc = [[JKApplyJobListController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            [self getData];
            
        }
    }];
}


// 进行快捷发布
- (void)jobDetail
{
    WEAKSELF
    [CityTool getCityModelWithCityId:self.jobDetailModel.parttime_job.city_id block:^(CityModel *city) {
            if (!city) {
            [UIHelper toast:@"获取城市信息失败,请稍后再试"];
            return;
        }
        PostJobController *vc = [UIHelper getVCFromStoryboard:@"EP" identify:@"sid_postJob"];
        vc.jobModel = self.jobDetailModel.parttime_job;
        vc.city = city;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];

}


- (void)selectWorkDate
{
    // 有报名限制就进入报名限制页面
    if ([self isSetCondition] && !self.isFromQrScan) {
        [self goToConditionVcWithCalendar:YES];
        return;
    }
    
    // 精确岗位,请求可报名日期
    if (self.jobDetailModel.parttime_job.is_accurate_job && self.jobDetailModel.parttime_job.is_accurate_job.integerValue == 1 && !self.isFromQrScan) {

        WEAKSELF
        [[UserData sharedInstance] queryJobCanApplyDateWithJobId:self.jobDetailModel.parttime_job.job_id resumeId:nil block:^(ResponseInfo *response) {
            
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
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.jobDetailModel.parttime_job.work_time_start.longValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.jobDetailModel.parttime_job.work_time_end.longValue];
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
    selectBtn.layer.borderColor = COLOR_RGB(200, 199, 204).CGColor;
    selectBtn.layer.borderWidth = 0.5;
    selectBtn.layer.masksToBounds = YES;
    selectBtn.tagObj = dateView;
    [contentView addSubview:selectBtn];
    
    dateSelectAlertView.contentView = contentView;
    dateSelectAlertView.contentMode = UIViewContentModeCenter;
    
    [dateSelectAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [TalkingData trackEvent:@"报名申请_确定时间"];
            
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.shouldUpdateApplyBtnState) {
        [self updateApplyBtnState];
    }
    
    // 显示引导图
    if (self.isFromSocialActivistBroadcast) {
        
        JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
        NSString *key = [NSString stringWithFormat:@"WDUserDefault_SocialActivist_Guide_%@", jkModel.account_id.stringValue];
        BOOL isRead = [WDUserDefaults boolForKey:key];
        
        if (!isRead) {
            [self showGuideForSocialActivist];
            [WDUserDefaults setBool:YES forKey:key];
        }
    }
    
}


// 显示人脉王引导遮罩
- (void)showGuideForSocialActivist
{
    if (!self.guideForSocialActivistBtn) {
        
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgBtn.backgroundColor = COLOR_RGBA(0, 0, 0, 0.5);
        [bgBtn addTarget:self action:@selector(hideGuideForSocialActivist) forControlEvents:UIControlEventTouchUpInside];
        self.guideForSocialActivistBtn = bgBtn;
        
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 40, 10, 10)];
        dotView.backgroundColor = [UIColor whiteColor];
        dotView.layer.cornerRadius = 5;
        dotView.layer.masksToBounds = YES;
        [bgBtn addSubview:dotView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, 50, 3, 100)];
        lineView.backgroundColor = [UIColor whiteColor];
        [bgBtn addSubview:lineView];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(16, 150, SCREEN_WIDTH - 32, 140)];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = 3;
        containerView.layer.masksToBounds = YES;
        [bgBtn addSubview:containerView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, containerView.width - 40, 20)];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = @"分享得赏金";
        [containerView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, containerView.width - 40, 70)];
        contentLabel.font = [UIFont systemFontOfSize:17];
        contentLabel.textColor = COLOR_RGB(54, 54, 54);
        contentLabel.text = @"点击分享生成伯乐链接, 通过你的伯乐链接招录每一名完工兼客记作你的一份伯乐赏金哦~";
        contentLabel.numberOfLines = 0;
        [containerView addSubview:contentLabel];
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.guideForSocialActivistBtn];
}


// 隐藏人脉王引导遮罩
- (void)hideGuideForSocialActivist
{
    [self.guideForSocialActivistBtn removeFromSuperview];
}


- (void)updateApplyBtnState
{
    if (self.jobDetailModel.parttime_job.student_applay_status.integerValue != 0) {
        
        [self.applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
        self.applyBtn.enabled = NO;
        if (self.jobDetailModel.is_complainted.intValue == 1) { // 举报过
            self.complainBtn.hidden = YES;
            self.complainFinishBtn.hidden = NO;
        }else{
            self.complainBtn.hidden = NO;
            self.complainFinishBtn.hidden = YES;
        }
    }
}


#pragma mark - V220 按钮点击
/** 公交线路按钮点击 */
- (IBAction)busWayBtnClick:(UIButton *)sender
{
    BusMap_VC* vc = [UIHelper getVCFromStoryboard:@"Public" identify:@"sid_busMap"];
    vc.workPlace = self.jobDetailModel.parttime_job.working_place;
    vc.city = self.jobDetailModel.parttime_job.city_name;
    [self.navigationController pushViewController:vc animated:YES];
}



- (IBAction)phoneBtnClick:(UIButton *)sender
{
    JobModel *jobModel = self.jobDetailModel.parttime_job;
    if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
        
        [self phoneClick:sender];
    
    } else {
        
        [UIHelper toast:@"报名后可联系雇主"];
    }
}



@end
