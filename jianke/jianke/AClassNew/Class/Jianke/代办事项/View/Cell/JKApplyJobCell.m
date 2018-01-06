//
//  JKApplyJobCell.m
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//  我的工作单元格cell

#import "JKApplyJobCell.h"
#import "JKApplyJobCellHeadView.h"
#import "JKApplyJobCellMiddleView.h"
#import "JKApplyJobCellFootView.h"
#import "WDConst.h"

@interface JKApplyJobCell(){
    JKApplyJob *_applyJob;
}

@property (nonatomic, weak) UIImageView *contentImageView; /*!< 整体View */
@property (nonatomic, weak) JKApplyJobCellHeadView *headView; /*!< 头部View */
@property (nonatomic, weak) JKApplyJobCellMiddleView *middlleView; /*!< 报名动态View */
@property (nonatomic, weak) JKApplyJobCellFootView *footView; /*!< 底部的View */

@property (nonatomic, strong) UIButton *btnConfirmWork;

@end

@implementation JKApplyJobCell

/** 创建cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"applyJobCell";
    JKApplyJobCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[JKApplyJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MKCOLOR_RGB(236, 236, 236);
        // 整体View
        UIImageView *contentImageView = [[UIImageView alloc] init];
        contentImageView.image = [UIImage imageNamed:@"v231_card_bg"];
        contentImageView.userInteractionEnabled = YES;
        contentImageView.backgroundColor = MKCOLOR_RGB(236, 236, 236);
        //        contentImageView.backgroundColor = [UIColor clearColor];
//        contentImageView.layer.cornerRadius = 3;
//        contentImageView.layer.borderWidth = 1;
//        contentImageView.layer.borderColor = COLOR_RGBA(200,199,204,0.5).CGColor;
        // 头部View
        JKApplyJobCellHeadView *headView = [[JKApplyJobCellHeadView alloc] init];
        [contentImageView addSubview:headView];
        
        // 报名动态
        JKApplyJobCellMiddleView *middlleView = [[JKApplyJobCellMiddleView alloc] init];
        [contentImageView addSubview:middlleView];
        
        // 尾部
        JKApplyJobCellFootView *footView = [[JKApplyJobCellFootView alloc] init];
        [contentImageView addSubview:footView];
        
        [self.contentView addSubview:contentImageView];
        
        self.contentImageView = contentImageView;
        self.headView = headView;
        self.middlleView = middlleView;
        self.footView = footView;
        
        self.btnConfirmWork = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 72, 72, 32)];
        [self.btnConfirmWork setBackgroundImage:[UIImage imageNamed:@"main_btn_gotowork_0"] forState:UIControlStateNormal];
        [self.btnConfirmWork setBackgroundImage:[UIImage imageNamed:@"main_btn_gotowork_1"] forState:UIControlStateDisabled];
        [self.btnConfirmWork setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnConfirmWork addTarget:self action:@selector(btnConfirmWorkOnclick:) forControlEvents:UIControlEventTouchUpInside];
        self.btnConfirmWork.titleLabel.font = HHFontSys(kFontSize_2);
        [self.contentView addSubview:self.btnConfirmWork];
        
        
        // test
//        self.contentImageView.backgroundColor = [UIColor greenColor];
//        self.headView.backgroundColor = [UIColor redColor];
//        self.middlleView.backgroundColor = [UIColor lightGrayColor];
//        self.footView.backgroundColor = [UIColor purpleColor];
    }
    
    return self;
}

- (void)setApplyJobF:(JKApplyJobFrame *)applyJobF{
    _applyJobF = applyJobF;
    _applyJob = applyJobF.applyJob;

    self.headView.applyJobF = applyJobF;
    self.middlleView.applyJobF = applyJobF;
    self.footView.applyJobF = applyJobF;
    
    if (_applyJob.trade_loop_status.integerValue == 1){  //已报名
        if (_applyJob.confirm_on_board.integerValue == 2) {
            [self.btnConfirmWork setTitle:@"确认上岗" forState:UIControlStateNormal];
            self.btnConfirmWork.enabled = YES;
        }else if (_applyJob.confirm_on_board.integerValue == 3) {
            [self.btnConfirmWork setTitle:@"已确认" forState:UIControlStateNormal];
            self.btnConfirmWork.enabled = NO;
        }else{
            self.btnConfirmWork.hidden = YES;
        }
        WEAKSELF
        [UserData delayTask:0.5 onTimeEnd:^{
            [UIView transitionWithView:self.btnConfirmWork duration:0.4 options:0 animations:^{
                weakSelf.btnConfirmWork.frame = CGRectMake(SCREEN_WIDTH-72-10, 72, 72, 32);
            } completion:nil];
        }];
    }
}

- (void)btnConfirmWorkOnclick:(UIButton*)sender{
    [TalkingData trackEvent:@"待办事项_确认上岗"];

    NSString* content = [NSString stringWithFormat:@"\"apply_job_id\":%@",_applyJob.apply_job_id.stringValue];
    RequestInfo *request = [[RequestInfo alloc] initWithService:@"shijianke_stuConfirmToWork" andContent:content];
    [request sendRequestWithResponseBlock:^(ResponseInfo* response) {
        if (response && [response success]) {
            [UIHelper toast:@"确认成功"];
            sender.enabled = NO;
            [sender setTitle:@"已确认" forState:UIControlStateNormal];
        }
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    JKApplyJobFrame *applyJobF = self.applyJobF;
    
    // 设置Frame
    self.contentImageView.frame = applyJobF.contentImageViewF;
    self.headView.frame = applyJobF.headViewF;
    self.middlleView.frame = applyJobF.middleViewF;
    self.footView.frame = applyJobF.footViewF;
    
//    [self.middlleView layoutSubviews];
}


@end
