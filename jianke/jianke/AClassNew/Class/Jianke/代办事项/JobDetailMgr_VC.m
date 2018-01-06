//
//  JobDetailMgr_VC.m
//  jianke
//
//  Created by fire on 15/12/28.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobDetailMgr_VC.h"
#import "JobDetail_VC.h"
#import "MJRefresh.h"
#import "XSJUIHelper.h"
#import "TalkToBoss_VC.h"
//#import "JobDetailFooterView.h"


@interface JobDetailMgr_VC ()
@property (nonatomic, weak) JobDetail_VC *currentJobDetailVc;
@property (nonatomic, weak) JobDetail_VC *lastJobDetailVc;
//@property (nonatomic, weak) JobDetailFooterView *botView;

@property (nonatomic, assign) BOOL isFirstShowJob;

//@property (nonatomic, strong) JobDetailModel *jobDetailModel;

@end


typedef NS_ENUM(NSInteger, PositionType){
    PositionTypeTop,
    PositionTypeMiddle,
    PositionTypeBottom
};

@implementation JobDetailMgr_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"岗位详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirstShowJob = YES;
    
    [self addJobVcWith:self.jobId positionType:PositionTypeMiddle withFinishBlock:nil];
    
    [[XSJUIHelper sharedInstance] showAppCommentAlertWithViewController:self];
    
}

/** 增加岗位详情View */
- (void)addJobVcWith:(NSString *)jobId positionType:(PositionType)apositionType withFinishBlock:(MKBlock)block{
    JobDetail_VC* currentVc = [[JobDetail_VC alloc] init];
    currentVc.isFromJobViewController = YES;
    currentVc.jobId = jobId;
    if (self.isFirstShowJob) {
        currentVc.isFirstShowJob = YES;
        self.isFirstShowJob = NO;
    }
    [self addChildViewController:currentVc];
    self.currentJobDetailVc = currentVc;
    [self.currentJobDetailVc view];
    
    WEAKSELF
    currentVc.loadFinishBlock = ^(id obj){
        if (!obj) { // 请求失败
            return;
        }
        
        [weakSelf.view addSubview:weakSelf.currentJobDetailVc.view];
//        weakSelf.jobDetailModel = weakSelf.currentJobDetailVc.jobDetailModel;
        weakSelf.currentJobDetailVc.view.frame = weakSelf.view.bounds;
//        weakSelf.botView.hidden = NO;
//        weakSelf.botView.jobDetailModel = weakSelf.currentJobDetailVc.jobDetailModel;
        switch (apositionType) {
            case PositionTypeTop:
            {
                weakSelf.currentJobDetailVc.view.x = 0;
                weakSelf.currentJobDetailVc.view.y = -weakSelf.view.frame.size.height;
            }
                break;
            case PositionTypeMiddle:
            {
                weakSelf.currentJobDetailVc.view.x = 0;
                weakSelf.currentJobDetailVc.view.y = 0;
            }
                break;
            case PositionTypeBottom:
            {
                weakSelf.currentJobDetailVc.view.x = 0;
                weakSelf.currentJobDetailVc.view.y = weakSelf.view.frame.size.height;
            }
                break;
            default:
                break;
        }
        weakSelf.currentJobDetailVc.headerReflushBlock = ^(id obj) {
            [weakSelf AddLastJob];
        };
        
        weakSelf.currentJobDetailVc.footerReflushBlock = ^(id obj) {
            [weakSelf AddNextJob];
        };
        
        if (block) {
            block(nil);
        }
        [weakSelf setupNavBtn];
        
    };

}


/** 设置导航栏按钮 */
- (void)setupNavBtn{
    // 社交分享
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v3_job_share"] style:UIBarButtonItemStylePlain target:self.currentJobDetailVc action:@selector(share)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"v3_job_share"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.width = 30;
    collectBtn.height = 44;
    [collectBtn setImage:[UIImage imageNamed:@"v3_job_collect_0"] forState:UIControlStateNormal];
    [collectBtn addTarget:self.currentJobDetailVc action:@selector(addCollectionAction) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn setImage:[UIImage imageNamed:@"v3_job_collect_1"] forState:UIControlStateSelected];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
//    // 雇主信息
//    UIBarButtonItem *lookupEPResumeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"job_xq_rt_0"] style:UIBarButtonItemStylePlain target:self.currentJobDetailVc action:@selector(lookupEPResumeClick:)];
//    [lookupEPResumeBtn setBackgroundImage:[UIImage imageNamed:@"job_xq_rt_0"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
//    // IM 对聊
//    UIBarButtonItem *imBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"job_xq_msg_0"] style:UIBarButtonItemStylePlain target:self.currentJobDetailVc action:@selector(chatWithEPClick:)];
//    [imBtn setBackgroundImage:[UIImage imageNamed:@"job_xq_msg_1"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    NSInteger status = self.currentJobDetailVc.jobDetailModel.parttime_job.student_collect_status.integerValue;
    collectBtn.selected = (status == 0) ? NO : YES ;
    self.navigationItem.rightBarButtonItems = @[shareBtn, collectItem];
}


/** 添加上一个岗位 */
- (void)AddLastJob{
    if (self.index <= 0) { // 没有上一个了
        [self.currentJobDetailVc.tableView.header endRefreshing];
        [UIHelper toast:@"已是最新岗位"];
    } else { // 切换到上一个岗位
        self.lastJobDetailVc = self.currentJobDetailVc;
        self.index -= 1;
        NSString *jobId = self.jobIdArray[self.index];
        WEAKSELF
        [self addJobVcWith:jobId positionType:PositionTypeTop withFinishBlock:^(id obj) {
           [weakSelf showLastJob];
        }];
    }
}


/** 添加下一个岗位 */
- (void)AddNextJob{
    if (self.index >= self.jobIdArray.count - 1) { // 没有下一个了
        [self.currentJobDetailVc.tableView.footer endRefreshing];
        [UIHelper toast:@"暂无更多岗位"];
    } else { // 切换到下一个岗位
        self.lastJobDetailVc = self.currentJobDetailVc;
        self.index += 1;
        NSString *jobId = self.jobIdArray[self.index];
        WEAKSELF
        [self addJobVcWith:jobId positionType:PositionTypeBottom withFinishBlock:^(id obj) {
            [weakSelf showNextJob];
        }];
    }
}


/** 显示上一个岗位 */
- (void)showLastJob{
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.currentJobDetailVc.view.y = 0;
        weakSelf.lastJobDetailVc.view.y = weakSelf.view.height;
    } completion:^(BOOL finished) {
        [weakSelf.lastJobDetailVc.tableView.header endRefreshing];
        [weakSelf.lastJobDetailVc.view removeFromSuperview];
        [weakSelf.lastJobDetailVc removeFromParentViewController];
        weakSelf.lastJobDetailVc = nil;
    }];
}


/** 显示下一个岗位 */
- (void)showNextJob{
    WEAKSELF
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.currentJobDetailVc.view.y = 0;
        weakSelf.lastJobDetailVc.view.y = -weakSelf.view.height;
    } completion:^(BOOL finished) {
        [weakSelf.lastJobDetailVc.tableView.header endRefreshing];
        [weakSelf.lastJobDetailVc.view removeFromSuperview];
        [weakSelf.lastJobDetailVc removeFromParentViewController];
        weakSelf.lastJobDetailVc = nil;
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    DLog(@"self.view.frame====%@", NSStringFromCGRect(self.view.frame));
//    DLog(@"self.scrollView.frame====%@", NSStringFromCGRect(self.scrollView.frame));
//    DLog(@"currentJobDetailVc.scrollViewHeightConstraint.constant=======%f", self.currentJobDetailVc.scrollViewHeightConstraint.constant);
//    DLog(@"self.currentJobDetailVc.view====%@", NSStringFromCGRect(self.currentJobDetailVc.view.frame));
}

//- (JobDetailFooterView *)botView{
//    if (!_botView) {
//        JobDetailFooterView *view = [[JobDetailFooterView alloc] init];
//        view.backgroundColor = [UIColor XSJColor_base];
//        _botView = view;
//        _botView.delegate = self;
//        [self.view addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.height.equalTo(@60);
//        }];
//    }
//    return _botView;
//}

//- (void)jobDetailFooterView:(JobDetailFooterView *)footerView jobDetalModel:(JobDetailModel *)jobDetailModel actionType:(JobDetailFooterViewBtnType)actionType{
//    JobModel *jobModel = self.jobDetailModel.parttime_job;
//    switch (actionType) {
//        case JobDetailFooterViewBtnType_sendMsg:{
//            
//        }
//            break;
//        case JobDetailFooterViewBtnType_makeCall:{
//            if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
//                [self phoneClick];
//            } else {
//                [MKAlertView alertWithTitle:@"报名后，才可以拨打雇主电话" message:nil cancelButtonTitle:@"我知道了" confirmButtonTitle:nil completion:nil];
//            }
//        }
//            break;
//        case JobDetailFooterViewBtnType_makeApply:{
//            WEAKSELF
//            [[UserData sharedInstance] userIsLogin:^(id result) {
//                if (result) {
//                    [weakSelf applyEvent:jobDetailModel];
//                }
//            }];
//        }
//            break;
//        case JobDetailFooterViewBtnType_makeApplyCall:{
//            WEAKSELF
//            [[UserData sharedInstance] userIsLogin:^(id result) {
//                if (result) {
//                    [weakSelf phoneClick];
//                }
//            }];
//        }
//            break;
//        default:
//            break;
//    }
//}

//- (void)phoneClick{
//    WEAKSELF
//    [[UserData sharedInstance] userIsLogin:^(id obj) {
//        if (obj) {
//            [[MKOpenUrlHelper sharedInstance] makeAlertCallWithPhone:weakSelf.jobDetailModel.parttime_job.contact.phone_num block:^(id result) {
//                [WDNotificationCenter addObserver:weakSelf.currentJobDetailVc selector:@selector(showSheet) name:UIApplicationWillResignActiveNotification object:nil];
//            }];
//        }
//    }];
//}

//- (void)applyEvent:(JobDetailModel *)jobDetailModel{
//    JobModel *jobModel = jobDetailModel.parttime_job;
//    
//    if (jobModel.job_type.integerValue == 2) { // 抢单
//        // 判断抢单资格
//        JKModel *jkModel = [[UserData sharedInstance] getJkModelFromHave];
//        // 认证中 && 不是第一次抢单
//        if (jkModel.id_card_verify_status.integerValue == 2 && !jkModel.is_first_grab_single) {
//            [XSJUIHelper showAlertWithTitle:@"认证中" message:@"您的认证正在进行中...请耐心等待客服审核完成再来抢单!" okBtnTitle:@"确定"];
//            return;
//        }
//        // 不是已认证 && 不是第一次抢单
//        if (jkModel.id_card_verify_status.integerValue != 3 && !jkModel.is_first_grab_single) {
//            // 提示去认证
//            [MKAlertView alertWithTitle:@"认证提示" message:@"抢单资格不足，您要花几分钟时间认证身份证。" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                if (buttonIndex == 1) {
//                    IdentityCardAuth_VC *verifyVc = [[IdentityCardAuth_VC alloc] init];
//                    [self.navigationController pushViewController:verifyVc animated:YES];
//                }
//            }];
//        }
//        // 不是已认证 && 是第一次抢单 && 未完善名字
//        if (jkModel.id_card_verify_status.integerValue != 3 && jkModel.is_first_grab_single && (!jkModel.true_name || (jkModel.true_name && jkModel.true_name.length < 1))) {
//            // 弹出完善提示
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善姓名" message:@"请填写真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//            alertView.tag = 121;
//            UITextField *nameTextField = [alertView textFieldAtIndex:0];
//            nameTextField.placeholder = @"真实姓名";
//            [alertView show];
//            return;
//        }
//        
//        // 具备抢单资格了..
//        NSString *startDateStr = [DateHelper getDateFromTimeNumber:@(jobModel.work_time_start.longValue * 1000)];
//        NSString *endDateStr = [DateHelper getDateFromTimeNumber:@(jobModel.work_time_end.longValue * 1000)];
//        if ([startDateStr isEqualToString:endDateStr]) { // 只有一天
//            // 弹框确定报名
//            [self checkApplyJob];
//        } else {
//            // 弹出选择日期控件
//            [self selectWorkDate];
//        }
//    }else { // 普通        if (jobModel.job_type.integerValue == 1 || jobModel.job_type.integerValue == 4)
//        // 检测是否完善了姓名
//        NSString *trueName = [[UserData sharedInstance] getUserTureName];
//        
//        if (!trueName || trueName.length < 1) {
//            WEAKSELF
//            [[UserData sharedInstance] getJKModelWithBlock:^(JKModel *jkModel) {
//                if (!jkModel || jkModel.true_name.length < 1) {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善姓名" message:@"请填写真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//                    alertView.tag = 121;
//                    UITextField *nameTextField = [alertView textFieldAtIndex:0];
//                    nameTextField.placeholder = @"真实姓名";
//                    [alertView show];
//                }else{
//                    [weakSelf judgeAboutAccurateJob];
//                }
//            }];
//        }else{
//            [self judgeAboutAccurateJob];
//        }
//    }
//}

- (void)dealloc{
    ELog(@"====JobDetailMgr_VC dealloc");
}
@end
