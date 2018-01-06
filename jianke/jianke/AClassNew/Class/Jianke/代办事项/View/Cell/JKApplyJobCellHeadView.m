//
//  JKApplyJobCellHeadView.m
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "JKApplyJobCellHeadView.h"
#import "WDConst.h"

@interface JKApplyJobCellHeadView()

@property (nonatomic, weak) UILabel *jobTitleLabel; /*!< 岗位名称 */
@property (nonatomic, weak) UIImageView *typeImgView; /*!< 抢单标志 */
@property (nonatomic, weak) UIButton *jobLastTimeBtn; /*!< 岗位持续时间 */
@property (nonatomic, weak) UIButton *jobAreaNameBtn; /*!< 岗位所在区域名称 */

@end

@implementation JKApplyJobCellHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 岗位名称
        UILabel *jobTitleLabel = [[UILabel alloc] init];
        jobTitleLabel.font = [UIFont systemFontOfSize:17];
        jobTitleLabel.textColor = [UIColor XSJColor_tBlackTinge];
        
        // 抢单标志
        UIImageView *typeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_icon_qiang"]];
        
        // 岗位持续时间
        UIButton *jobLastTimeBtn = [[UIButton alloc] init];
//        [jobLastTimeBtn setImage:[UIImage imageNamed:@"main_icon_data"] forState:UIControlStateNormal];
        [jobLastTimeBtn setTitleColor:MKCOLOR_RGB(169, 169, 169) forState:UIControlStateNormal];
        jobLastTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        jobLastTimeBtn.userInteractionEnabled = NO;
        
        // 岗位所在区域名称
        UIButton *jobAreaNameBtn = [[UIButton alloc] init];
//        [jobAreaNameBtn setImage:[UIImage imageNamed:@"main_icon_local"] forState:UIControlStateNormal];
        [jobAreaNameBtn setTitleColor:MKCOLOR_RGB(169, 169, 169) forState:UIControlStateNormal];
        jobAreaNameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        jobLastTimeBtn.userInteractionEnabled = NO;
        
        [self addSubview:typeImgView];
        [self addSubview:jobTitleLabel];
        [self addSubview:jobLastTimeBtn];
        [self addSubview:jobAreaNameBtn];
        
        self.typeImgView = typeImgView;
        self.jobTitleLabel = jobTitleLabel;
        self.jobLastTimeBtn = jobLastTimeBtn;
        self.jobAreaNameBtn = jobAreaNameBtn;
    }
    
    return self;
}


- (void)setApplyJobF:(JKApplyJobFrame *)applyJobF
{
    _applyJobF = applyJobF;
    JKApplyJob *applyJob = applyJobF.applyJob;
    
    // 岗位名称
    self.jobTitleLabel.text = applyJob.job_title;
    self.jobTitleLabel.backgroundColor = [UIColor whiteColor];
    
    // 抢单标志
    if (applyJob.job_type.integerValue == 1) { // 普通
        self.typeImgView.hidden = YES;
    } else { //抢单
        self.typeImgView.hidden = NO;
    }
    
    // 岗位持续时间
    NSString *startDateStr = [DateHelper getDateWithNumber:@(applyJob.deadline_time_start.longLongValue * 0.001)];
    NSString *endDateStr = [DateHelper getDateWithNumber:@(applyJob.deadline_time.longLongValue * 0.001)];
//    NSString *startTimeStr = [DateHelper getTimeWithNumber:@(applyJob.deadline_time_start.longLongValue * 0.001)];
//    NSString *endTimeStr = [DateHelper getTimeWithNumber:@(applyJob.deadline_time.longLongValue * 0.001)];
//    NSString *jobLastTime = [NSString stringWithFormat:@"%@ 至 %@ | %@~%@", startDateStr, endDateStr, startTimeStr, endTimeStr];
    
    NSString *jobLastTime = [NSString stringWithFormat:@"%@ 至 %@", startDateStr, endDateStr];
    
    [self.jobLastTimeBtn setTitle:jobLastTime forState:UIControlStateNormal];
    
    // 岗位所在区域
    if (applyJob.job_working_place && ![applyJob.job_working_place isEqualToString:@""]) {
        [self.jobAreaNameBtn setTitle:applyJob.job_working_place forState:UIControlStateNormal];
    } else {
        [self.jobAreaNameBtn setTitle:[NSString stringWithFormat:@"%@市", applyJob.city_name] forState:UIControlStateNormal];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 抢单图标
    self.typeImgView.width = 17;
    self.typeImgView.height = 16;
    self.typeImgView.x = JKApplyJobCellPendding;
    self.typeImgView.y = JKApplyJobCellMargin;
    
    // 岗位名称
    if (self.applyJobF.applyJob.job_type.integerValue == 1) { // 普通
        self.jobTitleLabel.x = JKApplyJobCellPendding;
        self.jobTitleLabel.width = self.width - 2 * JKApplyJobCellPendding;
    } else {
        self.jobTitleLabel.x = self.typeImgView.width + JKApplyJobCellPendding + 5;
        self.jobTitleLabel.width = self.width - 2 * JKApplyJobCellPendding - 22;
    }
    self.jobTitleLabel.height = 17;
    self.jobTitleLabel.y = JKApplyJobCellMargin;
    
    self.jobTitleLabel.font = [UIFont systemFontOfSize:17];
    self.jobTitleLabel.textColor = MKCOLOR_RGB(42, 42, 42);
    
    // 岗位持续时间
    self.jobLastTimeBtn.width = 120;
    self.jobLastTimeBtn.height = 20;
    self.jobLastTimeBtn.x = JKApplyJobCellPendding-2;
    self.jobLastTimeBtn.y = CGRectGetMaxY(self.jobTitleLabel.frame) + 5;
    self.jobLastTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.jobLastTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    self.jobLastTimeBtn.titleLabel.font = [UIFont fontWithName:kFont_RSR size:13];
//    self.jobLastTimeBtn.backgroundColor = [UIColor redColor];

    
    // 岗位所在区域
    self.jobAreaNameBtn.width = self.width - self.jobLastTimeBtn.width - JKApplyJobCellPendding - 5;
    self.jobAreaNameBtn.height = self.jobLastTimeBtn.height;
    self.jobAreaNameBtn.x = CGRectGetMaxX(self.jobLastTimeBtn.frame) - 8;
    self.jobAreaNameBtn.y = self.jobLastTimeBtn.y;
    self.jobAreaNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.jobAreaNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
}


- (NSString *)dateStringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d";
    return [formatter stringFromDate:date];
}

- (NSString *)timeStringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"H:mm";
    return [formatter stringFromDate:date];
}

@end
