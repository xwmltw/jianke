//
//  WorkHistoryTableViewCell.m
//  jianke
//
//  Created by fire on 16/2/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WorkHistoryTableViewCell.h"
#import "JKWorkExpericeModel.h"
#import "SortWorkExpModel.h"
#import "DateHelper.h"
#import "XSJConst.h"

@interface WorkHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *title; /*!< 标题 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel; /*!< 日期 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel; /*!< 地址 */

@property (weak, nonatomic) IBOutlet UIView *lineTop;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftConstraint; /*!< 标题距离左边约束 */

@property (weak, nonatomic) IBOutlet UIView *ballView; /*!< 圆球 */

@property (weak, nonatomic) IBOutlet UILabel *monthLabel; /*!< 月份 */

@property (weak, nonatomic) IBOutlet UIView *smallBall;

@property (weak, nonatomic) IBOutlet UIView *line;
@end



@implementation WorkHistoryTableViewCell

- (void)setSortModel:(SortWorkExpModel *)sortModel{
    _sortModel = sortModel;
    
    if (sortModel.isLast) {
        self.line.hidden = YES;
    }else{
        self.line.hidden = NO;
    }
    
    if (sortModel.isFirstBegin) {
        self.lineTop.hidden = YES;
    }else{
        self.lineTop.hidden = NO;
    }
    
    JKWorkExpericeModel *model = sortModel.model;
    
    // 标题
    self.title.text = model.job_title;
    
    // 日期
    NSArray *tmpWorkTime = [self sortForWorkDate];
    self.dateLabel.text = [DateHelper dateRangeStrWithMicroSecondNumArray:tmpWorkTime];
    
    // 地址
    self.addressLabel.text = model.working_place ? model.working_place : @"无";
        
    // 月份
    if (sortModel.isFirst) { // 月份第一个
        NSMutableAttributedString *monthStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@月", sortModel.monthStr]];
        [monthStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(monthStr.length - 1, 1)];
        self.monthLabel.attributedText = monthStr;
        self.ballView.hidden = NO;
    } else {
        self.ballView.hidden = YES;
    }
    
    [self.smallBall setToCircle];
    [self.ballView setToCircle];
}

/** 报名日期排序 */
- (NSArray *)sortForWorkDate{
    NSArray *tmpWorkTime = [_sortModel.model.stu_work_time_arr sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if (obj1.longLongValue < obj2.longLongValue) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    return tmpWorkTime;
}

@end
