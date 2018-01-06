//
//  JKApplyJobCellFootView.m
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "JKApplyJobCellFootView.h"
#import "WDConst.h"
#import "XSJRequestHelper.h"
#import "JobDetailModel.h"
#import "SYAlertView.h"
#import "xwmAlertViewController.h"

@interface JKApplyJobCellFootView()

@property (nonatomic, weak) UIButton *messageBtn; /*!< 发消息按钮 */
@property (nonatomic, weak) UIButton *phoneBtn; /*!< 电话按钮 */
@property (nonatomic, weak) UIButton *questionBtn; /*!< 有问题按钮 */
@property (nonatomic, weak) UIButton *cancelBtn; /*!< 取消报名按钮 */
@property (nonatomic, weak) UIView *lineView; /*!< 分割线 */

@property (nonatomic, strong) UIWebView *phoneWebView; /*!< 用于打电话的WebView */


@end

@implementation JKApplyJobCellFootView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 顶部分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = MKCOLOR_RGB(236, 236, 236);
        [self addSubview:lineView];
        self.lineView = lineView;
        
        // 发消息
        UIButton *messageBtn = [[UIButton alloc] init];
        [messageBtn setImage:[UIImage imageNamed:@"v3_mgr_chat"] forState:UIControlStateNormal];
        
        // 电话按钮
        UIButton *phoneBtn = [[UIButton alloc] init];
        
        
        // 取消报名按钮
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消报名" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:MKCOLOR_RGB(0, 188, 212) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:MKCOLOR_RGB(214, 214, 214) forState:UIControlStateDisabled];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        // 有问题按钮
        UIButton *questionBtn = [[UIButton alloc] init];
        [questionBtn setTitle:@"举报" forState:UIControlStateNormal];
        [questionBtn setTitleColor:MKCOLOR_RGB(0, 188, 212) forState:UIControlStateNormal];
        [questionBtn setTitle:@"举报成功" forState:UIControlStateDisabled];
        [questionBtn setTitleColor:MKCOLOR_RGB(214, 214, 214) forState:UIControlStateDisabled];
        questionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:messageBtn];
        [self addSubview:phoneBtn];
        [self addSubview:questionBtn];
        [self addSubview:cancelBtn];
        
        self.messageBtn = messageBtn;
        self.phoneBtn = phoneBtn;
        self.questionBtn = questionBtn;
        self.cancelBtn = cancelBtn;
        
        // 消息按钮
        [self.messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 电话按钮
        [self.phoneBtn addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 有问题按钮
        [self.questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 取消报名按钮
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
//        [[UserData sharedInstance]getjob
    }
    return self;
}


- (void)setApplyJobF:(JKApplyJobFrame *)applyJobF{
    
    _applyJobF = applyJobF;
    
    NSString *str = applyJobF.applyJob.wechat_public.length ? applyJobF.applyJob.wechat_public : applyJobF.applyJob.wechat_number;
    if (str) {
        [self.phoneBtn setImage:[UIImage imageNamed:@"MyApplication_wechat"] forState:UIControlStateNormal];
    }else{
        [self.phoneBtn setImage:[UIImage imageNamed:@"v3_job_call_0"] forState:UIControlStateNormal];
    }

    
    if (applyJobF.applyJob.trade_loop_status.integerValue == 1) { // 已报名
        self.cancelBtn.enabled = YES;
    } else {
        self.cancelBtn.enabled = NO;
        if (applyJobF.applyJob.trade_loop_finish_type.integerValue == 1) {
            [self.cancelBtn setTitle:@"已取消" forState:UIControlStateDisabled];
        } else {
            [self.cancelBtn setTitle:@"取消报名" forState:UIControlStateDisabled];
        }
    }
    
    if (applyJobF.applyJob.is_complainted.integerValue == 1) { // 已投诉过
        self.questionBtn.enabled = NO;
    } else {  //未投诉过
        self.questionBtn.enabled = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 分割线
    self.lineView.width = self.width;
    self.lineView.height = 1;
    self.lineView.x = 0;
    self.lineView.y = 0;
    
    // 消息按钮
    self.messageBtn.width = 30;
    self.messageBtn.height = self.height - 2 * JKApplyJobCellFooterPendding;
    self.messageBtn.x = JKApplyJobCellPendding;
    self.messageBtn.y = JKApplyJobCellFooterPendding;
    
    // 电话按钮
    self.phoneBtn.width = 30;
    self.phoneBtn.height = self.height - 2 * JKApplyJobCellFooterPendding;
//    DLog(@"+++++++++%f",self.height);
    self.phoneBtn.x = self.messageBtn.width + 2 * JKApplyJobCellPendding;
    self.phoneBtn.y = JKApplyJobCellFooterPendding;
    
    // 取消报名按钮
    self.cancelBtn.width = 64;
    self.cancelBtn.height = 30;
    self.cancelBtn.x = self.width - 168;
//    self.cancelBtn.y = JKApplyJobCellFooterPendding;
    self.cancelBtn.y = 10;
    // 有问题按钮
    self.questionBtn.width = 108;
    self.questionBtn.height = self.cancelBtn.height;
    self.questionBtn.x = CGRectGetMaxX(self.cancelBtn.frame);
    self.questionBtn.y = self.cancelBtn.y;
}


#pragma mark - 按钮点击方法
/** 消息按钮点击 */
- (void)messageBtnClick{
    DLog(@"消息按钮点击事件");
    
    // 发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JKApplyJobChatWithEPInfo] = self.applyJobF.applyJob;    
    [[NSNotificationCenter defaultCenter] postNotificationName:JKApplyJobChatWithEPNotification object:self userInfo:userInfo];
}

/** 电话按钮点击事件 */
- (void)phoneBtnClick{
    
    DLog(@"微信按钮点击事件");
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JKApplyJobWXWithInfo] = self.applyJobF.applyJob;
    [[NSNotificationCenter defaultCenter] postNotificationName:JKApplyJobWXWithNotification object:self userInfo:userInfo];
    
    
//
//    [TalkingData  trackEvent:@"待办事项_微信联系"];
//    JKApplyJob *applyJob = self.applyJobF.applyJob;
//    [[MKOpenUrlHelper sharedInstance] callWithPhone:applyJob.contact_phone_num];
}

/** 有问题按钮点击事件 */
- (void)questionBtnClick{
    // 发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JKApplyJobHasQuestionInfo] = self.applyJobF.applyJob;
    [[NSNotificationCenter defaultCenter] postNotificationName:JKApplyJobHasQuestionNotification object:self userInfo:userInfo];
}

/** 取消报名按钮点击事件 */
- (void)cancelBtnClick{
    [TalkingData trackEvent:@"待办事项_取消报名"];

    // 发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JKApplyJobCancellApplyInfo] = self.applyJobF.applyJob;
    [[NSNotificationCenter defaultCenter] postNotificationName:JKApplyJobCancellApplyNotification object:self userInfo:userInfo];
}

@end
