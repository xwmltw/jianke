//
//  DateSelectView.m
//  jianke
//
//  Created by fire on 15/10/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  日期选择控件

#import "DateSelectView.h"
#import "UIView+MKExtension.h"
#import "JTCalendar.h"
#import "UIColor+Extension.h"
#import "DateHelper.h"
#import "DateTools.h"
#import "UIHelper.h"

@interface DateSelectView () <JTCalendarDelegate>

@property (nonatomic, weak) JTCalendarMenuView *calendarMenuView;
@property (nonatomic, weak) JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, strong) JTCalendarManager *calendarManager;

@end


@implementation DateSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // MenuView
        JTCalendarMenuView *calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 00, self.width, 20)];
        [self addSubview:calendarMenuView];
        self.calendarMenuView = calendarMenuView;
        
        // ContentView
        JTHorizontalCalendarView *calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height - 20)];
        [self addSubview:calendarContentView];
        self.calendarContentView = calendarContentView;
        
        // Manager
        self.calendarManager = [[JTCalendarManager alloc] init];
        self.calendarManager.delegate = self;
        [self.calendarManager setMenuView:self.calendarMenuView];
        [self.calendarManager setContentView:self.calendarContentView];
        [self.calendarManager setDate:[NSDate date]];
        
        // dates
        self.datesSelected = [NSMutableArray array];
        self.datesAdd = [NSMutableArray array];
        self.datesReduce = [NSMutableArray array];
        self.datesApply = [NSMutableArray array];
    }
    return self;
}

#pragma mark - ***** prepareDayView ******
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView{
    // today
    if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        dayView.textLabel.text = @"今";
    }
    
    switch (self.type) {
        case DateViewTypeNormal:{
            [self prepareForNormalTypeDateView:dayView];
        }
            break;
        case DateViewTypePay:{
            [self prepareForPayTypeDateView:dayView];
        }
            break;
        case DateViewTypeAdjust:{
            [self prepareForAdjustTypeDateView:dayView];
        }
            break;
        case DateViewTypeInsurance:{
            [self prepareForPayTypeDateView:dayView];
        }
            break;
        case DateViewType_makeCheck:{
            [self prepareForMakeCheckTypeDateView:dayView];
        }
            break;
        default:
            break;
    }
}


/** DateViewTypeNormal类型DateView设置 */
- (void)prepareForNormalTypeDateView:(JTCalendarDayView *)dayView{
    if([self isInDatesSelected:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor XSJColor_base];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // startDate < date < endDate
    else if(![self isBetweenCanSelDateWithDayView:dayView]){
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
}

/** DateViewTypePay类型DateView设置 */
- (void)prepareForPayTypeDateView:(JTCalendarDayView *)dayView{
    if([self isCompleteDateWithDayView:dayView]){ // 已报名
        dayView.textLabel.hidden = YES;
        if ([self isInDatesSelected:dayView.date]) { // 已报名, 已选择
            dayView.imageView.image = [UIImage imageNamed:@"v230_payCheck"];
            dayView.imageView.hidden = NO;
            dayView.circleView.hidden = YES;
        }
        else if([self isPayDateWithDayView:dayView]){ // 已付款
            dayView.textLabel.hidden = YES;
            dayView.imageView.hidden = NO;
            dayView.circleView.hidden = YES;
            
            if (self.type == DateViewTypeInsurance) {
                dayView.imageView.image = [UIImage imageNamed:@"v231_check"];
            } else if (self.type == DateViewTypePay) {
                dayView.imageView.image = [UIImage imageNamed:@"v230_payed"];
            }
        }
        
        else if ([self isAbsentDateWithDayView:dayView]){ // 未到岗
            dayView.imageView.hidden = YES;
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = MKCOLOR_RGB(244, 201, 197);
            dayView.textLabel.textColor = MKCOLOR_RGB(203, 51, 26);
        }
        
        else { // 已报名,未选择
            dayView.circleView.hidden = NO;
            dayView.imageView.hidden = YES;
            dayView.circleView.backgroundColor = MKCOLOR_RGB(84, 172, 80);
        }
    }
    
    else if ([self isBetweenCanSelDateWithDayView:dayView]){ // 未报名的工作时间
        dayView.imageView.hidden = YES;
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = MKCOLOR_RGB(200, 200, 200);
        dayView.textLabel.textColor = MKCOLOR_RGB(51, 51, 51);
    }
    else { // 其余
        dayView.circleView.hidden = YES;
        dayView.imageView.hidden = YES;
        dayView.textLabel.textColor = MKCOLOR_RGB(180, 180, 185);
    }
}


/** DateViewTypeAdjust类型DateView设置 */
- (void)prepareForAdjustTypeDateView:(JTCalendarDayView *)dayView{
    if ([self isBetweenCanSelDateWithDayView:dayView]) { // 可选择日期
        
        if ([self isReduceDateWithDayView:dayView]) { // 已减少的日期
            dayView.circleView.hidden = NO;
            dayView.underLabel.hidden = NO;
            dayView.underLabel.text = @"减";
            dayView.underLabel.textColor = MKCOLOR_RGB(217, 46, 33);
            dayView.circleView.backgroundColor = MKCOLOR_RGB(200, 200, 200);
            dayView.textLabel.textColor = MKCOLOR_RGB(33, 33, 33);
        }else if ([self isAddDateWithDayView:dayView]) { // 已增加的日期
            dayView.circleView.hidden = NO;
            dayView.underLabel.hidden = NO;
            dayView.underLabel.text = @"加";
            dayView.underLabel.textColor = MKCOLOR_RGB(7, 187, 152);
            dayView.circleView.backgroundColor = MKCOLOR_RGB(0, 188, 212);
            dayView.textLabel.textColor = [UIColor whiteColor];
        }else if ([self isApplyDateWithDayView:dayView]) { // 原本已报名的日期
            dayView.circleView.hidden = NO;
            dayView.underLabel.hidden = YES;
            dayView.circleView.backgroundColor = MKCOLOR_RGB(0, 188, 212);
            dayView.textLabel.textColor = [UIColor whiteColor];
            
        }else {
            dayView.circleView.hidden = YES;
            dayView.underLabel.hidden = YES;
            dayView.textLabel.textColor = MKCOLOR_RGBA(0, 0, 0, 0.87);
        }
    
    } else { // 不可选择的日期
        dayView.textLabel.textColor = MKCOLOR_RGB(180, 180, 185);
    }
}

#pragma mark - ***** didTouchDayView ******
/** 日期点击 */
- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView{
    switch (self.type) {
        case DateViewTypeNormal:{
            [self didTouchNormalTypeDayView:dayView];
        }
            break;
        case DateViewTypePay:{
            [self didTouchPayTypeDayView:dayView];
        }
            break;
        case DateViewTypeAdjust:{
            [self didTouchAdjustTypeDayView:dayView];
        }
            break;
        case DateViewTypeInsurance:{
            [self didTouchPayTypeDayView:dayView];
        }
            break;
        case DateViewType_makeCheck:{
            [self didTouchMakeChectTypeDayView:dayView];
        }
        default:
            break;
    }
    
    // 调用回调block
    if (self.didClickBlock) {
        self.didClickBlock(self.datesSelected);
    }
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}


/** DateViewTypeNormal类型点击处理 */
- (void)didTouchNormalTypeDayView:(JTCalendarDayView *)dayView{
    if([self isInDatesSelected:dayView.date]){
        [_datesSelected removeObject:dayView.date];
        
        [UIView transitionWithView:dayView
                          duration:.3
                           options:0
                        animations:^{
                            [_calendarManager reload];
                            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                        } completion:^(BOOL finished) {
                            dayView.circleView.transform = CGAffineTransformIdentity;
                        }];
    }
    else if (![self isBetweenCanSelDateWithDayView:dayView]) {
        
    }
    else{
        [_datesSelected addObject:dayView.date];
        
        dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        [UIView transitionWithView:dayView
                          duration:.3
                           options:0
                        animations:^{
                            [_calendarManager reload];
                            dayView.circleView.transform = CGAffineTransformIdentity;
                        } completion:nil];
    }
}


/** DateViewTypeAdjust类型点击处理 */
- (void)didTouchAdjustTypeDayView:(JTCalendarDayView *)dayView{
    if ([self isBetweenCanSelDateWithDayView:dayView]) { // 可选择
        if ([self isReduceDateWithDayView:dayView]) { // 减少的
            
            [_datesReduce removeObject:dayView.date];
            [_datesApply addObject:dayView.date];
            
            dayView.circleView.transform = CGAffineTransformIdentity;
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{
                                [_calendarManager reload];
                                dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                            } completion:^(BOOL finished) {
                                
                                dayView.circleView.transform = CGAffineTransformIdentity;
                            }];
        }
        
        else if ([self isAddDateWithDayView:dayView]) { // 增加的
            if (self.datesApply.count + self.datesAdd.count < 2) {
                [UIHelper toast:@"上岗时间仅剩一天，无法取消"];
                return;
            }
            
            [_datesAdd removeObject:dayView.date];

            dayView.circleView.transform = CGAffineTransformIdentity;
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{                                
                                dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                            } completion:^(BOOL finished) {
                                
                                [_calendarManager reload];
                                dayView.circleView.transform = CGAffineTransformIdentity;
                            }];
        }
        
        else if ([self isApplyDateWithDayView:dayView]) { // 已报名
            if (self.datesApply.count + self.datesAdd.count < 2) {
                [UIHelper toast:@"上岗时间仅剩一天，无法取消"];
                return;
            }
            
            [_datesApply removeObject:dayView.date];
            [_datesReduce addObject:dayView.date];
            
            dayView.circleView.transform = CGAffineTransformIdentity;
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{
                                [_calendarManager reload];
                                dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                            } completion:^(BOOL finished) {
                                
                                dayView.circleView.transform = CGAffineTransformIdentity;
                            }];
        }
        
        else { // 未报名的
            
            [_datesAdd addObject:dayView.date];
            
            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{
                                [_calendarManager reload];
                                dayView.circleView.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                                
                                dayView.circleView.transform = CGAffineTransformIdentity;
                            }];
        }
    }
}


/** DateViewTypePay类型点击处理 */
- (void)didTouchPayTypeDayView:(JTCalendarDayView *)dayView{
    if ([self isCompleteDateWithDayView:dayView]) { // 已报名
        
        if ([self isInDatesSelected:dayView.date]) { // 已选中
            
            [_datesSelected removeObject:dayView.date];
            
            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{
                                [_calendarManager reload];
                                dayView.circleView.transform = CGAffineTransformIdentity;
                                dayView.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                            } completion:nil];
        }
        
        else if([self isPayDateWithDayView:dayView]){ // 已付款
            
        }
        
        else if ([self isAbsentDateWithDayView:dayView]){ // 未到岗
            
        }
        
        else { // 未选中
            
            [_datesSelected addObject:dayView.date];
            
            dayView.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{
                                [_calendarManager reload];
                                dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                                dayView.imageView.transform = CGAffineTransformIdentity;
                            } completion:nil];
        }
    }
}
    
/** 是否为可选择日期 */
- (BOOL)isBetweenCanSelDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.startDate && self.endDate) {
        return [_calendarManager.dateHelper date:dayView.date isEqualOrAfter:self.startDate andEqualOrBefore:self.endDate];
    }
    if (self.canSelDateArray) {
        for (NSDate *date in self.canSelDateArray) {
            if ([self.calendarManager.dateHelper date:dayView.date isTheSameDayThan:date]) {
                return YES;
            }
        }
        return NO;
    }
    return NO;
}


/** 判断是否为已支付的日期 */
- (BOOL)isPayDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.datesPay && self.datesPay.count) {
        
        for (NSDate *date in self.datesPay) {
            
            if ([self.calendarManager.dateHelper date:dayView.date isTheSameDayThan:date]) {
                return YES;
            }
        }
    }
    
    return NO;
}

/** 判断是否为已完工的日期 */
- (BOOL)isCompleteDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.datesComplete && self.datesComplete.count) {
        
        for (NSDate *date in self.datesComplete) {
            
            if ([self.calendarManager.dateHelper date:dayView.date isTheSameDayThan:date]) {
                return YES;
            }
        }
    }
    
    return NO;
}

/** 判断是否为未到岗的日期 */
- (BOOL)isAbsentDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.datesAbsent && self.datesAbsent.count) {
        
        for (NSDate *date in self.datesAbsent) {
            
            if ([self.calendarManager.dateHelper date:dayView.date isTheSameDayThan:date]) {
                return YES;
            }
        }
    }
    
    return NO;
}

/** 判断是否为已报名的日期 */
- (BOOL)isApplyDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.datesApply && self.datesApply.count) {
        
        for (NSDate *date in self.datesApply) {
            
            if ([self.calendarManager.dateHelper date:dayView.date isTheSameDayThan:date]) {
                return YES;
            }
        }
    }
    
    return NO;
}


/** 判断是否为增加的日期 */
- (BOOL)isAddDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.datesAdd && self.datesAdd.count) {
        
        for (NSDate *date in self.datesAdd) {
            
            if ([self.calendarManager.dateHelper date:dayView.date isTheSameDayThan:date]) {
                return YES;
            }
        }
    }
    
    return NO;
}


/** 判断是否为减少的日期 */
- (BOOL)isReduceDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.datesReduce && self.datesReduce.count) {
        
        for (NSDate *date in self.datesReduce) {
            
            if ([self.calendarManager.dateHelper date:dayView.date isTheSameDayThan:date]) {
                return YES;
            }
        }
    }
    
    return NO;
}


/** 设置可选择的日期 */
- (void)setCanSelDateArray:(NSArray *)canSelDateArray{
    _canSelDateArray = canSelDateArray;
    
    [self setNeedsLayout];
}

- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    [self setNeedsLayout];
}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    [self setNeedsLayout];
}



#pragma mark - Date selection

- (BOOL)isInDatesSelected:(NSDate *)date{
    for(NSDate *dateSelected in _datesSelected){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    return NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.calendarManager reload];
}

#pragma mark - ***** DateViewType_makeCheck ******
- (void)prepareForMakeCheckTypeDateView:(JTCalendarDayView *)dayView{
    
    if([self isInDatesSelected:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor XSJColor_base];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }else if([self makeCheck_isBetweenOldCheckDateWithDayView:dayView]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = MKCOLOR_RGB(200, 200, 200);
        dayView.textLabel.textColor = [UIColor blackColor];
    }else if ([self makeCheck_isBetweenCanSelDateWithDayView:dayView]) {
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }else{
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - ***** MakeChect 点击处理 ******
- (void)didTouchMakeChectTypeDayView:(JTCalendarDayView *)dayView{
    if([self isBillStartDate:dayView.date]){
        [_datesSelected removeAllObjects];
        [_datesSelected addObject:self.billStartDate];
        [self reloadDayView:dayView];
        return;
    }
    if ([self makeCheck_isBetweenCanSelDateWithDayView:dayView]) {
        [_datesSelected removeAllObjects];
    
        NSDate* sDate = self.billStartDate;
        NSDate* eDate = dayView.date;
        long long timeS =  sDate.timeIntervalSince1970;
        long long timeE =  eDate.timeIntervalSince1970;
        do {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeS];
            [_datesSelected addObject:date];
            timeS = timeS + 60*60*24;
        } while (timeS <= timeE);
    
        [_datesSelected addObject:dayView.date];
        [self reloadDayView:dayView];
    }
}


/** 是否为已发账单日期内 */
- (BOOL)makeCheck_isBetweenOldCheckDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.startDate && self.billStartDate) {
        return [_calendarManager.dateHelper date:dayView.date isEqualOrAfter:self.startDate andEqualOrBefore:self.billStartDate];
    }
    return NO;
}
/** 是否为可选择日期 */
- (BOOL)makeCheck_isBetweenCanSelDateWithDayView:(JTCalendarDayView *)dayView{
    if (self.billStartDate && self.endDate) {
        return [_calendarManager.dateHelper date:dayView.date isEqualOrAfter:self.billStartDate andEqualOrBefore:self.endDate];
    }
    return NO;
}

- (BOOL)isBillStartDate:(NSDate *)date{
    if([_calendarManager.dateHelper date:self.billStartDate isTheSameDayThan:date]){
        return YES;
    }
    return NO;
}

- (void)reloadDayView:(JTCalendarDayView *)dayView{
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        [_calendarManager reload];
                        dayView.circleView.transform = CGAffineTransformIdentity;
                    } completion:nil];

}
@end
