//
//  SYDatePicker.m
//  jianke
//
//  Created by fire on 15/11/5.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "SYDatePicker.h"
#import "Masonry.h"
#import "DLAVAlertView.h"
#import "UIView+MKExtension.h"
#import "DateTools.h"
#import "DateHelper.h"

@interface SYDatePicker()

@property (nonatomic, weak) UIDatePicker *startTimeDatePicker;
@property (nonatomic, weak) UIDatePicker *endTimeDatePicker;
@property (nonatomic, strong) DLAVAlertView *timeAlertView;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@end


@implementation SYDatePicker

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setup];
    }
    
    return self;
}



- (void)setup
{
    // contentView
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
    
    // startTimeTitleLabel
    UILabel *startTimeTitleLabel = [[UILabel alloc] init];
    startTimeTitleLabel.font = [UIFont systemFontOfSize:16];
    startTimeTitleLabel.textColor = MKCOLOR_RGBA(0, 0, 0, 54);
    startTimeTitleLabel.text = @"开始时间";
    [contentView addSubview:startTimeTitleLabel];
    startTimeTitleLabel.x = 16;
    startTimeTitleLabel.y = 0;
    startTimeTitleLabel.height = 24;
    startTimeTitleLabel.width = contentView.width - 32;
    
    // startTimeDatePicker
    UIDatePicker *startTimeDatePicker = [[UIDatePicker alloc] init];
    startTimeDatePicker.datePickerMode = UIDatePickerModeTime;
    startTimeDatePicker.minuteInterval = 30;
    
    NSTimeInterval zeroSecondOfToday = [DateHelper zeroTimeOfToday].timeIntervalSince1970;
    startTimeDatePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:zeroSecondOfToday + 6 * 60 * 60];
    startTimeDatePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:zeroSecondOfToday + 21.5 * 60 * 60];
    [startTimeDatePicker addTarget:self action:@selector(startTimeChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:startTimeDatePicker];
    self.startTimeDatePicker = startTimeDatePicker;
    startTimeDatePicker.x = startTimeTitleLabel.x;
    startTimeDatePicker.width = startTimeTitleLabel.width;
    startTimeDatePicker.height = 120;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        startTimeDatePicker.y = CGRectGetMaxY(startTimeTitleLabel.frame) - 20;
    } else {
        startTimeDatePicker.y = CGRectGetMaxY(startTimeTitleLabel.frame) + 6;
    }
    
    
    
    // endTimeTitleLabel
    UILabel *endTimeTitleLabel = [[UILabel alloc] init];
    endTimeTitleLabel.font = [UIFont systemFontOfSize:16];
    endTimeTitleLabel.textColor = MKCOLOR_RGBA(0, 0, 0, 54);
    endTimeTitleLabel.text = @"结束时间";
    [contentView addSubview:endTimeTitleLabel];
    endTimeTitleLabel.x = startTimeTitleLabel.x;
    endTimeTitleLabel.width = startTimeTitleLabel.width;
    endTimeTitleLabel.height = startTimeTitleLabel.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        endTimeTitleLabel.y = CGRectGetMaxY(startTimeDatePicker.frame) - 20;
    } else {
        endTimeTitleLabel.y = CGRectGetMaxY(startTimeDatePicker.frame) + 6;
    }
    
    // endTimeDatePicker
    UIDatePicker *endTimeDatePicker = [[UIDatePicker alloc] init];
    endTimeDatePicker.datePickerMode = UIDatePickerModeTime;
    endTimeDatePicker.minuteInterval = 30;
    endTimeDatePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:zeroSecondOfToday + 6 * 60 * 60];
    endTimeDatePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:zeroSecondOfToday + 22 * 60 * 60];
    [endTimeDatePicker addTarget:self action:@selector(endTimeChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:endTimeDatePicker];
    self.endTimeDatePicker = endTimeDatePicker;
    endTimeDatePicker.x = startTimeTitleLabel.x;
    endTimeDatePicker.width = startTimeTitleLabel.width;
    endTimeDatePicker.height = startTimeDatePicker.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        endTimeDatePicker.y = CGRectGetMaxY(endTimeTitleLabel.frame) - 20;
    } else {
        endTimeDatePicker.y = CGRectGetMaxY(endTimeTitleLabel.frame) + 6;
    }

    DLAVAlertView *timeAlertView = [[DLAVAlertView alloc] initWithTitle:@"设置时间段" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    timeAlertView.contentView = contentView;
    self.timeAlertView = timeAlertView;
}



- (void)showDatePickerWithStartTime:(NSDate *)aStartTime endTime:(NSDate *)aEndTime selectedBlock:(SelectdBlock)aBlock{
    self.startTimeDatePicker.date = aStartTime;
    self.endTimeDatePicker.date = aEndTime;
    self.endTimeDatePicker.minimumDate = [NSDate dateWithTimeInterval:1800 sinceDate:self.startTimeDatePicker.date];;
    
    self.startTime = aStartTime;
    self.endTime = aEndTime;
    
    [self.timeAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return;
        }
        aBlock(self.startTime, self.endTime);
    }];
}

- (void)showDatePickerWithSelectedBlock:(SelectdBlock)aBlock{
    NSTimeInterval zeroSecondOfToday = [DateHelper zeroTimeOfToday].timeIntervalSince1970;
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:zeroSecondOfToday + 8 * 60 * 60];
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:zeroSecondOfToday + 18 * 60 *60];
    
    [self showDatePickerWithStartTime:startTime endTime:endTime selectedBlock:aBlock];
}


#pragma mark - 点击事件
- (void)startTimeChanged:(UIDatePicker *)aDatePicker
{
    self.startTime = aDatePicker.date;
    NSTimeInterval zeroSecondOfToday = [DateHelper zeroTimeOfToday].timeIntervalSince1970;
    
    if ([aDatePicker.date isEarlierThan:[NSDate dateWithTimeIntervalSince1970:zeroSecondOfToday + 22 * 60 * 60]]) {
        self.endTimeDatePicker.minimumDate = [NSDate dateWithTimeInterval:1800 sinceDate:aDatePicker.date];
        self.endTimeDatePicker.date = [NSDate dateWithTimeInterval:3600 sinceDate:aDatePicker.date];
        self.endTime = self.endTimeDatePicker.date;
    }
}


- (void)endTimeChanged:(UIDatePicker *)aDatePicker
{
    self.endTime = aDatePicker.date;
}


@end
