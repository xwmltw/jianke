//
//  JobDetail_VC.h
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"
#import "JobDetailModel.h"

typedef NS_ENUM(NSInteger, JDCellType) {
    JDCellType_jobName       = 1,
    JDCellType_date,
    JDCellType_time,
    JDCellType_peopleNum,
    JDCellType_address,
    JDCellType_condition,
    JDCellType_endDate,
    
    JDCellType_bus,
    JDCellType_introduce,
    
    JDCellType_contact,
    JDCellType_manage,
    
    JDCellType_apply,
    JDCellType_listApply,
    JDCellType_QA,
    JDCellType_welfare,

    JDCellType_payWay,  //兼职日期
    JDCellType_payTime, 

    JDCellType_contactEp,       /*!< 联系商家 */
    JDCellType_epAuth,          /*!< 企业名称 */
    JDCellType_respondTime,     /*!< 处理用时 */
    JDCellType_lastSeeTime,     /*!< 查看简历 */
    
    JDCellType_jkLike,          /*!< 猜你喜欢 */
};

typedef NS_ENUM(NSInteger, JDGroupType){
    JDGroupType_jobBase    = 100,   /*!< 岗位名称等 */
    JDGroupType_address,            /*!< 公交 */
    JDGroupType_workTime,           /*!< 工作时间 */
    JDGroupType_workDetail,         /*!< 工作详情 */
    JDGroupType_contactInfo,        /*!< 联系信息 */
    JDGroupType_apply,              /*!< 报名 */
    JDGroupType_epQA,               /*!< 雇主答疑 */
    JDGroupType_jkLike              /*!< 猜你喜欢 */
};

@interface JobDetail_VC : WDViewControllerBase

@property (nonatomic, assign) WDLogin_type userType; /** 查看岗位详情的用户类型 */
@property (nonatomic, copy) NSString *jobId; /*!< 岗位Id */
@property (nonatomic, copy) NSString *jobUuid; /*!< 岗位Uuid */
@property (nonatomic, copy) NSNumber *isAccurateJob;
@property (nonatomic, assign) BOOL isFromQrScan; /*!< 扫码过来的 */
@property (nonatomic, assign) BOOL isFromSocialActivistBroadcast; /*!< 人脉王广播过来的 */
@property (nonatomic, assign) BOOL shouldUpdateApplyBtnState; /*!< 是否更新报名按钮状态 */
@property (nonatomic, strong) JobDetailModel *jobDetailModel; /*!< 岗位详情模型 */

@property (nonatomic, assign) BOOL isFirstShowJob;      /*!< 是否第一次显示，控制菊花用 */


// JobDetailMgr_VC调用
@property (nonatomic, strong) UITableView* tableView;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint; /*!< scrollView高度约束 */
@property (nonatomic, assign) BOOL isFromJobViewController; /*!< 需要实现上拉/下拉功能 */
@property (nonatomic, copy) MKBlock loadFinishBlock; /*!< 页面加载完成后回调 */
@property (nonatomic, copy) MKBlock headerReflushBlock; /*!< 下拉回调 */
@property (nonatomic, copy) MKBlock footerReflushBlock; /*!< 上拉回调 */
- (void)share; /*!< 分享 */
- (void)lookupEPResumeClick:(UIButton *)sender; /*!< 兼客查看雇主简历 */
- (void)chatWithEPClick:(UIButton *)sender; /*!< 兼客与雇主聊天 */
- (void)addCollectionAction;

//added by kizy v3.2.0
@property (nonatomic, copy) MKBlock block;  /*!< 上下拉岗位回调专用 */

@end
