     //
//  JobDetailFooterView.m
//  jianke
//
//  Created by yanqb on 2017/3/20.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobDetailFooterView.h"
#import "Masonry.h"
#import "JobDetailModel.h"
#import "WDConst.h"

@interface JobDetailFooterView ()

@property (nonatomic, weak) UIButton *btnMsg;
@property (nonatomic, weak) UIButton *btnCall;
@property (nonatomic, weak) UIButton *btnApply;

@end

@implementation JobDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = [UIColor XSJColor_newWhite];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = JobDetailFooterViewBtnType_putQuestion;
    [btn1 setTitle:@"咨询雇主" forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn1 setTitleColor:MKCOLOR_RGB(0, 188, 212) forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];

    _btnMsg = btn1;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = JobDetailFooterViewBtnType_makeCall;
    [btn2 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnCall = btn2;
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = JobDetailFooterViewBtnType_makeApply;
    [btn3 setTitle:@"报名" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"] forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"v3_public_btn_bg_2"] forState:UIControlStateDisabled];
    _btnApply = btn3;
    
    [self addSubview:btn1];
    [self addSubview:btn2];
    [self addSubview:btn3];
    
    [self makeConstraints:NO];
}

- (void)makeConstraints:(BOOL)isUpdate{
    
    if (!isUpdate) {
        [_btnMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH / 5));
        }];
        
        [_btnCall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_btnMsg.mas_right);
            make.width.equalTo(@(SCREEN_WIDTH / 5));
        }];
        
        [_btnApply mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(@((SCREEN_WIDTH / 5) * 3));
        }];
    }else{
        [_btnMsg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH / 5));
        }];
        
        [_btnCall mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_btnMsg.mas_right);
            make.width.equalTo(@(SCREEN_WIDTH / 5));
        }];
        
        [_btnApply mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(@((SCREEN_WIDTH / 5) * 3));
        }];
    }
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(jobDetailFooterView:jobDetalModel:actionType:)]) {
        [self.delegate jobDetailFooterView:self jobDetalModel:_jobDetailModel actionType:sender.tag];
    }
}

- (void)setJobDetailModel:(JobDetailModel *)jobDetailModel{
    _jobDetailModel = jobDetailModel;
    JobModel *jobModel = jobDetailModel.parttime_job;
    self.btnApply.tag = JobDetailFooterViewBtnType_makeApply;
    
    NSString *str = jobModel.wechat_public.length ? jobModel.wechat_public : jobModel.wechat_number;
    if (str) {
        [_btnCall setImage:[UIImage imageNamed:@"MyApplication_wechat"] forState:UIControlStateNormal];
        [_btnCall setImage:[UIImage imageNamed:@"MyApplication_wechat"] forState:UIControlStateDisabled];
    }else{
        [_btnCall setImage:[UIImage imageNamed:@"v3_job_call_0"] forState:UIControlStateNormal];
        [_btnCall setImage:[UIImage imageNamed:@"v3_job_call_0"] forState:UIControlStateDisabled];
    }

    
    if (jobModel.source.integerValue == 1) {   //采集岗位
        self.btnMsg.hidden = YES;
        self.btnCall.hidden = YES;
        [self.btnApply mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        if (jobModel.status.integerValue == 1) {
            self.btnApply.enabled = NO;
            [self.btnApply setTitle:@" 待审核" forState:UIControlStateNormal];
        }else if (jobModel.status.integerValue == 2){
            if (jobModel.student_contact_status.integerValue == 1) {
                [self.btnApply setTitle:@"已联系" forState:UIControlStateNormal];
                self.btnApply.enabled = NO;
            }else{
                [self.btnApply setTitle:@"电话联系报名" forState:UIControlStateNormal];
                self.btnApply.tag = JobDetailFooterViewBtnType_makeApplyCall;
                self.btnApply.enabled = YES;
            }
        }else if (jobModel.status.integerValue == 3){
            self.btnApply.enabled = NO;
            if (jobModel.job_close_reason.intValue == 1 || jobModel.job_close_reason.intValue == 2 ){
                [self.btnApply setTitle:@" 已过期" forState:UIControlStateNormal];
            }else if(jobModel.job_close_reason.intValue == 3){
                [self.btnApply setTitle:@" 已下架" forState:UIControlStateNormal];
            }else if(jobModel.job_close_reason.intValue == 4){
                [self.btnApply setTitle:@" 审核未通过" forState:UIControlStateNormal];
            }
        }
    }else{  //非采集岗位
        [self makeConstraints:YES];
        self.btnMsg.hidden = NO;
        

        self.btnCall.hidden = NO;
        if (self.isFromQrScan) {
            if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
                
                [self.btnMsg setImage:[UIImage imageNamed:@"v3_job_msg_0"] forState:UIControlStateNormal];
                self.btnMsg.tag = JobDetailFooterViewBtnType_sendMsg;
                [self.btnMsg setTitle:@"" forState:UIControlStateNormal];
                
                [self.btnApply setTitle:@"已报名" forState:UIControlStateNormal];
                self.btnApply.enabled = NO;
                if (jobModel.trade_loop_status.integerValue == 1) {    //仅仅已报名，雇主未处理
                    [self.btnApply setTitle:@"取消报名" forState:UIControlStateNormal];
                    self.btnApply.tag = JobDetailFooterViewBtnType_cancelApply;
                    self.btnApply.enabled = YES;
                    
                }else if (jobModel.trade_loop_status.integerValue == 2){
                    [self.btnApply setTitle:@"已录用" forState:UIControlStateNormal];
                }else if (jobModel.trade_loop_finish_type.integerValue == 2){
                    [self.btnApply setTitle:@"已拒绝" forState:UIControlStateNormal];
                }else if (jobModel.trade_loop_finish_type.integerValue == 1){
                    [self.btnApply setTitle:@"已取消报名" forState:UIControlStateNormal];
                }
            } else {
                if (jobModel.job_type && jobModel.job_type.integerValue == 2) { // 抢单兼职
                    [self.btnApply setTitle:@"立即抢单" forState:UIControlStateNormal];
                } else { // 普通兼职
                    [self.btnApply setTitle:@"报名" forState:UIControlStateNormal];
                }
                self.btnApply.enabled = YES;
            }
        }else{
            if (jobModel.status.intValue == 1) { // 待审核
                
                [self.btnMsg setImage:[UIImage imageNamed:@"v3_job_msg_0"] forState:UIControlStateNormal];
                self.btnMsg.tag = JobDetailFooterViewBtnType_sendMsg;
                [self.btnMsg setTitle:@"" forState:UIControlStateNormal];
                
                self.btnApply.enabled = NO;
                [self.btnApply setTitle:@" 待审核" forState:UIControlStateNormal];
            }else if(jobModel.status.intValue == 2){ // 已发布
                if (jobModel.student_applay_status.intValue == 0) { // 未报名
                    self.btnCall.hidden = YES;
                    [self.btnApply mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.right.equalTo(self);
                        make.left.equalTo(self).offset((SCREEN_WIDTH / 5)*2 );
                    }];
                    [self.btnMsg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.left.equalTo(self);
                        make.right.equalTo(self.btnApply.mas_left);
                        
                    }];
                    if (jobModel.has_been_filled.intValue == 0) {
                        if (jobModel.is_fit_job_limit.integerValue == 0 && jobModel.fit_job_limit_desc.length) {
                            [self.btnApply setTitle:jobModel.fit_job_limit_desc forState:UIControlStateNormal];
                            self.btnApply.enabled = NO;
                        }else{
                            [self.btnApply setTitle:@"报名" forState:UIControlStateNormal];
                            self.btnApply.enabled = YES;
                        }
                    }else if (jobModel.has_been_filled.intValue == 1){ // 已报满
                        [self.btnApply setTitle:@"已报满" forState:UIControlStateNormal];
                        self.btnApply.enabled = NO;
                    }
                }else if (jobModel.student_applay_status.intValue == 1 || jobModel.student_applay_status.intValue == 2){ // 已报名过
                    [self.btnApply setTitle:@"已报名" forState:UIControlStateNormal];
                    self.btnApply.enabled = NO;
                    
                    [self.btnMsg setImage:[UIImage imageNamed:@"v3_job_msg_0"] forState:UIControlStateNormal];
                    self.btnMsg.tag = JobDetailFooterViewBtnType_sendMsg;
                    [self.btnMsg setTitle:@"" forState:UIControlStateNormal];
                    
                    if (jobModel.trade_loop_status.integerValue == 1) {
                        [self.btnApply setTitle:@"取消报名" forState:UIControlStateNormal];
                        self.btnApply.tag = JobDetailFooterViewBtnType_cancelApply;
                        self.btnApply.enabled = YES;
                    }else if (jobModel.trade_loop_status.integerValue == 2){
                        [self.btnApply setTitle:@"已录用" forState:UIControlStateNormal];
                    }else if (jobModel.trade_loop_finish_type.integerValue == 2){
                        [self.btnApply setTitle:@"已拒绝" forState:UIControlStateNormal];
                    }else if (jobModel.trade_loop_finish_type.integerValue == 1){
                        [self.btnApply setTitle:@"已取消报名" forState:UIControlStateNormal];
                    }
                }
            }else if(jobModel.status.intValue == 3){ // 已结束
                self.btnApply.enabled = NO;
                
                [self.btnMsg setImage:[UIImage imageNamed:@"v3_job_msg_0"] forState:UIControlStateNormal];
                self.btnMsg.tag = JobDetailFooterViewBtnType_sendMsg;
                [self.btnMsg setTitle:@"" forState:UIControlStateNormal];
                
                
                if (jobModel.job_close_reason.intValue == 1 || jobModel.job_close_reason.intValue == 2 ){
                    [self.btnApply setTitle:@" 已过期" forState:UIControlStateNormal];
                }else if(jobModel.job_close_reason.intValue == 3){
                    [self.btnApply setTitle:@" 已下架" forState:UIControlStateNormal];
                }else if(jobModel.job_close_reason.intValue == 4){
                    [self.btnApply setTitle:@" 审核未通过" forState:UIControlStateNormal];
                }
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
