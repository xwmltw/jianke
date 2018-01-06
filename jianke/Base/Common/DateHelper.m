//
//  DateHelper.m
//  jianke
//
//  Created by xiaomk on 15/9/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "DateHelper.h"
#import "DateTools.h"

@implementation DateHelper


//NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//formatter.dateFormat = @"yyyyMMddHHmmssSSS";
//NSString* str = [formatter stringFromDate:[NSDate date]];


/** 获取时间戳 毫秒 13位 */
+ (long long)getTimeStamp{
    NSDate* date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    long long totalMilliseconds = interval*1000;
    return totalMilliseconds;
}

/** 获取时间出 秒 10位*/
+ (UInt32)getTimeStamp4Second{
    NSDate* date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    UInt32 totalSeconds = interval;
    return totalSeconds;
}


+ (NSString*)getDateDesc:(NSDate*)date{
    return [DateHelper getDateDesc:date withFormat:@"yyyy年MM月dd日"];
}

+ (NSString*)getDateDesc:(NSDate*)date withFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+ (NSString*)getDateFromTimeString:(NSString*)number{
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[number longLongValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *regStr = [df stringFromDate:dt];
    return regStr;
}

+ (NSString*)getDateFromTimeNumber:(NSNumber*)number withFormat:(NSString*)format {
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[number longLongValue]/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSString *regStr = [df stringFromDate:dt];
    return regStr;
}

+ (NSString*)getDateTimeFromTimeNumber:(NSNumber*)number{
    return [self getDateFromTimeNumber:number withFormat:@"yyyy-M-d HH:mm:ss"];
}

+ (NSString*)getDateFromTimeNumber:(NSNumber*)number {
    return [self getDateFromTimeNumber:number withFormat:@"yyyy-MM-dd"];
}

+ (NSString*)getShortDateFromTimeNumber:(NSNumber*)number {
    return [self getDateFromTimeNumber:number withFormat:@"M/d"];
}

/** 时间转日期 */
+ (NSString *)dayOfNumberTime:(NSNumber *)number{
    return [self getDateFromTimeNumber:number withFormat:@"dd"];
}

/** 时间转月份 */
+ (NSString *)monthOfNumberTime:(NSNumber *)number{
    return [self getDateFromTimeNumber:number withFormat:@"MM"];
}

+ (NSString*)getDayFromTimeNumber:(NSNumber*)number
{
    int time=[number floatValue]/1000;
    int d=time/86400;
    int tmp=time%86400;
    int h=tmp/3600;
    NSString *str=@"";
    if (d>0) {
        str=[NSString stringWithFormat:@"%i天%i小时",d,h];
    }else{
        str=[NSString stringWithFormat:@"%i小时",h];
    }
    return str;
}

+ (NSString*)getTimeChaFromTimeNumber:(NSNumber*)number
{
    return [self getTimeChaWithNumber:@(number.longLongValue/1000)];
}


+ (NSString*)getTimeChaWithNumber:(NSNumber*)number
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now - [number longLongValue];
    NSString *timeString=@"";
    if ((cha/3600)<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        if (timeString==nil||timeString.intValue<=0) {
            timeString=@"1";
        }
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if (cha/3600>1 && cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1 && cha/86400<3)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    if (cha/86400>3) {
        timeString = [self getDateFromTimeNumber:number];
    }
    return timeString;
}



+ (NSString *)getDateWithNumber:(NSNumber *)number{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.longLongValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d";
    return [formatter stringFromDate:date];
}




+ (NSString *)getDateWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d";
    return [formatter stringFromDate:date];
}

/** 根据format格式返回时间 */
+ (NSString *)getDayWithNumber:(NSNumber *)number format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.longLongValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSString *)getTimeWithNumber:(NSNumber *)number
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.longLongValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"H:mm";
    return [formatter stringFromDate:date];
}


+ (NSString *)getDateAndWeekWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d EEE";
    return [formatter stringFromDate:date];
}

+ (NSString *)getTimeAndAMPMWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"H";
    
    NSString *ampm = nil;
    NSString *tmpDateStr = [formatter stringFromDate:date];
    if (tmpDateStr.integerValue > 12) {
        ampm = @"下午";
    } else {
        ampm = @"上午";
    }
    
    formatter.dateFormat = @"H:mm";
    
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:date], ampm];
    return dateStr;

}


/** 刚刚(5分钟内)/x分钟前/x小时前/昨天H:mm/前天H:mm */
+ (NSString *)getTimeRangeWithSecond:(NSNumber *)second{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second.longLongValue];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:unit fromDate:date];
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    
    if (dateComponents.year == nowComponents.year
        && dateComponents.month == nowComponents.month
        && dateComponents.day == nowComponents.day
        && dateComponents.hour == nowComponents.hour
        && (nowComponents.minute - dateComponents.minute < 6)) { // 刚刚5分钟内
        
        return @"刚刚";
        
    } else if ( dateComponents.year == nowComponents.year
               && dateComponents.month == nowComponents.month
               && dateComponents.day == nowComponents.day
               && dateComponents.hour == nowComponents.hour) { // x分钟前
        
        return [NSString stringWithFormat:@"%ld 分钟前", (long)nowComponents.minute - (long)dateComponents.minute];
        
    } else if (dateComponents.year == nowComponents.year
               && dateComponents.month == nowComponents.month
               && dateComponents.day == nowComponents.day) { // x小时前
        
        return [NSString stringWithFormat:@"%ld 小时前", (long)nowComponents.hour - (long)dateComponents.hour];
    
    } else if (dateComponents.year == nowComponents.year
               && dateComponents.month == nowComponents.month
               && nowComponents.day - dateComponents.day == 1) { // 昨天
        
        return [NSString stringWithFormat:@"昨天 %ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
        
    } else if (dateComponents.year == nowComponents.year
               && dateComponents.month == nowComponents.month
               && nowComponents.day - dateComponents.day == 2) { // 前天
        
        return [NSString stringWithFormat:@"前天 %ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
        
    } else if (dateComponents.year == nowComponents.year) { // M:d
        
        return [NSString stringWithFormat:@"%ld/%02ld", (long)dateComponents.month, (long)dateComponents.day];
        
    } else {
        
        return [NSString stringWithFormat:@"%ld %ld/%02ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    }
}


+ (NSString *)getDateStrFromString:(NSString *)string format:(NSString *)dateFormat
{
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = dateFormat;
    NSDate *date = [dateF dateFromString:string];
    
    dateF.dateFormat = @"M月d日";
    NSString *dateStr = [dateF stringFromDate:date];
    return dateStr;
}

/** 取小时,分钟,并转换时间为1970-1-1 : H:mm */
+ (NSDate *)convertTimeTo1970WithNumber:(NSNumber *)num
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longLongValue * 0.001];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"H:mm";
    
    NSString *dateStr = [NSString stringWithFormat:@"1970-1-1 %@", [format stringFromDate:date]];
    
    format.dateFormat = @"yyyy-M-d H:mm";
    return [format dateFromString:dateStr];
}


/** 通过NSDate计算时间差 */
+ (CGFloat)hoursBetweenBeginDate:(NSDate *)beginDate andEndDate:(NSDate *)endDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unit = NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *components = [calendar components:unit fromDate:beginDate toDate:endDate options:NSCalendarWrapComponents];
    
    CGFloat hours = components.hour + components.minute / 60.0;
    return hours;
}


/** 通过NSNumber(毫秒)计算时间差 */
+ (CGFloat)hoursBetweenBeginNumber:(NSNumber *)beginNum andEndNumber:(NSNumber *)endNum;
{
    NSDate *beginDate = [self convertTimeTo1970WithNumber:beginNum];
    NSDate *endDate = [self convertTimeTo1970WithNumber:endNum];
    
    return [self hoursBetweenBeginDate:beginDate andEndDate:endDate];
}

/** 8/25 12:39:56 */
+ (NSString *)walletTimeStrWithNum:(NSNumber *)num
{
    return [self getDateFromTimeNumber:num withFormat:@"M/dd H:mm:ss"];
}
/** 8月25日 12:39:56 */
+ (NSString *)otherOneWalletTimeStrWithNum:(NSNumber *)num
{
    return [self getDateFromTimeNumber:num withFormat:@"M月dd日 H:mm:ss"];
}
/** 8月25日 */
+ (NSString *)jobBillTimeStrWithNum:(NSNumber *)num
{
    return [self getDateFromTimeNumber:num withFormat:@"M月dd日"];
}
+ (NSString *)timeStringWithSecond:(NSInteger)second
{
    NSString *timeStr;
    
    if (second < 60) {

        timeStr = [NSString stringWithFormat:@"%ld 秒", (long)second];
        
    } else if (second < 3600) {
        
        timeStr = [NSString stringWithFormat:@"%ld 分", (long)second/60];
        
    } else if (second < 3600 * 24) {
        
        NSInteger minute = second/60;
        timeStr = [NSString stringWithFormat:@"%ld 小时 %ld 分", (long)minute/60, (long)minute%60];
    
    } else {
        
        timeStr = @"24 小时以上";
    }
    
    return timeStr;    
}

//秒转周
+(NSString*)weekdayStringFromDate:(NSNumber*)dateStr
{
    NSNumber* dateNum;
    if (dateStr.longLongValue > 100000000000) {
        dateNum = [NSNumber numberWithLongLong: dateStr.longLongValue/1000];
    }else{
        dateNum = dateStr;
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDate *inputDate = [NSDate dateWithTimeIntervalSince1970:[dateNum doubleValue]];
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//图文消息(hh:mm || 昨天 hh:mm || 星期 hh:mm)
+(NSString *)getimgTextStringFromDate:(NSNumber*)dateStr{
    NSString *prefix = [DateHelper getDateFromTimeNumber:dateStr withFormat:@"H:mm"];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.longLongValue/1000];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [calendar components:unit fromDate:date];
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    
    if ( nowComponents.day != dateComponents.day || dateComponents.month != nowComponents.month || dateComponents.year != nowComponents.year ) {
        if (nowComponents.day - dateComponents.day == 1) {
            prefix = [NSString stringWithFormat:@" 昨天 %@  ", prefix];
        }else{
            prefix = [NSString stringWithFormat:@" %@ %@  ", [weekdays objectAtIndex:dateComponents.weekday], prefix];
        }
    }
    return prefix;
}

/** 获取指定日期00:00:00的时间 */
+ (NSDate *)zeroTimeOfDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateStr = [NSString stringWithFormat:@"%@ 00:00:00", dateStr];
    return [formatter dateFromString:dateStr];
}


/** 获取今天00:00:00的时间 */
+ (NSDate *)zeroTimeOfToday
{
    return [self zeroTimeOfDate:[NSDate date]];
}



/** 将11/26 11/27 11/28 12/5 转成 11/26 至 11/28, 12/5 的格式 */
+ (NSString *)dateRangeStrWithSecondNumArray:(NSArray *)numArray{
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSNumber *num in numArray) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longValue];
        [dateArray addObject:date];
    }
    return [self dateRangeStrWithDateArray:dateArray];
}


/** 将11/26 11/27 11/28 12/5 转成 11/26 至 11/28, 12/5 的格式 */
+ (NSString *)dateRangeStrWithMicroSecondNumArray:(NSArray *)numArray{
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSNumber *num in numArray) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longValue];
        [dateArray addObject:date];
    }
    return [self dateRangeStrWithDateArray:dateArray];
}

/** 将11/26 11/27 11/28 12/5 转成 11/26 至 11/28, 12/5 的格式 */
+ (NSString *)dateRangeStrWithDateArray:(NSArray *)dateArray{
    // 空数组
    if (!dateArray || dateArray.count < 1) {
        return @"";
    }
    // 只有一天
    if (dateArray.count == 1) {
        return [self getDateWithDate:dateArray.firstObject];
    }
    
    // 只有两天
    if (dateArray.count == 2) {
        return [NSString stringWithFormat:@"%@, %@", [self getDateWithDate:dateArray.firstObject], [self getDateWithDate:dateArray.lastObject]];
    }
    
    // 对日期数组进行排序
    NSArray *sortDateArray = [dateArray sortedArrayUsingComparator:^NSComparisonResult(NSDate *date1, NSDate *date2) {
        if (date1.timeIntervalSince1970 > date2.timeIntervalSince1970) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    // 转换成时间字符串,相邻日期以逗号分隔,不同时间段以|号分隔
    NSMutableString *sortDateArrayStr = [NSMutableString string];
    NSDate *lastDate = nil;
    for (NSDate *date in sortDateArray) {
        if (!lastDate) {
            lastDate = date;
            [sortDateArrayStr appendString:[NSString stringWithFormat:@"%@", [self getDateWithDate:date]]];
            continue;
        }
        
        if ([[NSDate dateWithTimeInterval:24 * 3600 sinceDate:lastDate] isSameDay:date]) {
            [sortDateArrayStr appendString:[NSString stringWithFormat:@",%@", [self getDateWithDate:date]]];
        } else {
            [sortDateArrayStr appendString:[NSString stringWithFormat:@"|%@", [self getDateWithDate:date]]];
        }
        lastDate = date;
    }
    
    // 转换成一维字符串数组
    NSArray *rangeDateStrArray = [sortDateArrayStr componentsSeparatedByString:@"|"];
    
    // 转成二维字符串数组
    NSMutableString *resultStr = [NSMutableString string];
    for (NSString *rangeStr in rangeDateStrArray) {
        NSArray *tmpArray = [rangeStr componentsSeparatedByString:@","];
        if (tmpArray.count == 1) {
            [resultStr appendFormat:@"%@, ", tmpArray.firstObject];
        } else if (tmpArray.count ==2) {
            [resultStr appendFormat:@"%@, %@, ", tmpArray.firstObject, tmpArray.lastObject];
        } else {
            [resultStr appendFormat:@"%@ 至 %@, ", tmpArray.firstObject, tmpArray.lastObject];
        }
    }
    return [resultStr substringToIndex:resultStr.length - 2];
}


/** 获取开始日期0点到结束日期0点间的所有日期0点的日期 */
+ (NSArray *)dateRangeArrayBetweenBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    NSDate *firstDate = [self zeroTimeOfDate:beginDate];
    NSDate *lastDate = [self zeroTimeOfDate:endDate];
    
    if (firstDate.timeIntervalSince1970 > lastDate.timeIntervalSince1970) {
        return nil;
    }
    
    if (firstDate.timeIntervalSince1970 == lastDate.timeIntervalSince1970) {
        return @[firstDate];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    while (firstDate.timeIntervalSince1970 <= endDate.timeIntervalSince1970) {
        
        [array addObject:firstDate];
        firstDate = [NSDate dateWithTimeInterval:24 * 3600 sinceDate:firstDate];
    }
    
    return array;
}



/** 将allDateArray中包含excludeDateArray的日期剔除 */
+ (NSArray *)excludeDateArray:(NSArray *)excludeDateArray fromDateArray:(NSArray *)allDateArray
{
    if (!excludeDateArray.count) {
        return allDateArray;
    }
    
    if (!allDateArray.count) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDate *date in allDateArray) {
        
        for (NSDate *exDate in excludeDateArray) {
            
            if ([self zeroTimeOfDate:date].timeIntervalSince1970 != [self zeroTimeOfDate:exDate].timeIntervalSince1970) {
                [array addObject:date];
            }
        }
    }
    
    return array;
}

/**
 *  比较两个时间相差几年(dang)
 */
+ (NSInteger)compareYearsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return components.year;
}

/**
 *  比较两个时间相差几年（相同年份算0）
 */

+ (int)compareAbsYearsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger intFromDate = [calendar component:NSCalendarUnitYear fromDate:fromDate];
    NSInteger intToDate = [calendar component:NSCalendarUnitYear fromDate:toDate];
    NSInteger result = intFromDate - intToDate;
    return abs(result);
}

/**
 *  dateStr 转 nsdate
 */
+ (NSDate *)getDateFromStr:(NSString *)dateStr formatter:(NSString *)formatter{
    NSDateFormatter *fromat = [[NSDateFormatter alloc] init];
    fromat.dateFormat = formatter;
    return [fromat dateFromString:dateStr];
}

@end
