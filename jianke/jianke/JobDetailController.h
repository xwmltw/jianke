//
//  JobDetailController.h
//  jianke
//
//  Created by fire on 15/9/19.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDConst.h"
#import "WDViewControllerBase.h"

@class JobDetailModel;
@interface JobDetailController : WDViewControllerBase

@property (nonatomic, assign) WDLogin_type userType; /** 查看岗位详情的用户类型 */
@property (nonatomic, copy) NSString *jobId; /*!< 岗位Id */
@property (nonatomic, copy) NSString *jobUuid; /*!< 岗位Uuid */
@property (nonatomic, copy) NSNumber *isAccurateJob;
@property (nonatomic, assign) BOOL isFromQrScan; /*!< 扫码过来的 */
@property (nonatomic, assign) BOOL isFromSocialActivistBroadcast; /*!< 人脉王广播过来的 */
@property (nonatomic, assign) BOOL shouldUpdateApplyBtnState; /*!< 是否更新报名按钮状态 */
@property (nonatomic, strong) JobDetailModel *jobDetailModel; /*!< 岗位详情模型 */


// JobViewController调用
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isFromJobViewController; /*!< 需要实现上拉/下拉功能 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint; /*!< scrollView高度约束 */
@property (nonatomic, copy) Block loadFinishBlock; /*!< 页面加载完成后回调 */
@property (nonatomic, copy) Block headerReflushBlock; /*!< 下拉回调 */
@property (nonatomic, copy) Block footerReflushBlock; /*!< 上拉回调 */
- (void)share; /*!< 分享 */
- (void)lookupEPResumeClick:(UIButton *)sender; /*!< 兼客查看雇主简历 */
- (void)chatWithEPClick:(UIButton *)sender; /*!< 兼客与雇主聊天 */


@end
