//
//  DateHelper.h
//  jianke
//
//  Created by xiaomk on 15/9/8.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTools.h"
#import "NSDate+DateTools.h"

@interface DateHelper : NSObject

//获取时间戳
+ (long long)getTimeStamp;          //毫秒
+ (UInt32)getTimeStamp4Second;      //秒

//NSDate和日期描述转换
+ (NSString*)getDateDesc:(NSDate*)date;
+ (NSString*)getDateDesc:(NSDate*)date withFormat:(NSString*)format;

+ (NSString*)getDateFromTimeString:(NSString*)number;

//传的是毫秒数
+ (NSString*)getDateFromTimeNumber:(NSNumber*)number withFormat:(NSString*)format;
+ (NSString*)getDateFromTimeNumber:(NSNumber*)number; // yyyy-MM-dd
+ (NSString*)getShortDateFromTimeNumber:(NSNumber*)number; // MM-dd
+ (NSString*)getDateTimeFromTimeNumber:(NSNumber*)number;

/** 时间转日期 */
+ (NSString *)dayOfNumberTime:(NSNumber *)number; // dd
/** 时间转月份 */
+ (NSString *)monthOfNumberTime:(NSNumber *)number; // MM

/**
 *  //几天几小时
 */
+ (NSString*)getDayFromTimeNumber:(NSNumber*)number;

/**
 *  //几天前, 参数是毫秒
 */
+ (NSString*)getTimeChaFromTimeNumber:(NSNumber*)number;
/** 几天前, 参数是秒 */
+ (NSString*)getTimeChaWithNumber:(NSNumber*)number;


/**
 *  获取9/2这种类型的日期
 *
 *  @param number 1970至今的秒数
 *
 *  @return M/d形式的日期
 */
+ (NSString *)getDateWithNumber:(NSNumber *)number;


/**
 *  获取9:32这种类型的时间
 *
 *  @param number 1970至今的秒数
 *
 *  @return h:m形式的日期
 */
+ (NSString *)getTimeWithNumber:(NSNumber *)number;

+ (NSString *)getDateAndWeekWithDate:(NSDate *)date;
+ (NSString *)getTimeAndAMPMWithDate:(NSDate *)date;

/** 根据format格式返回时间 */
+ (NSString *)getDayWithNumber:(NSNumber *)number format:(NSString *)format;

/** 刚刚/ */
+ (NSString *)getTimeRangeWithSecond:(NSNumber *)second;


+ (NSString *)getDateStrFromString:(NSString *)string format:(NSString *)dateFormat;

/** 取小时,分钟,并转换时间为1970-1-1 : H:mm */
+ (NSDate *)convertTimeTo1970WithNumber:(NSNumber *)num;

/** 通过NSDate计算时间差 */
+ (CGFloat)hoursBetweenBeginDate:(NSDate *)beginDate andEndDate:(NSDate *)endDate;

/** 通过NSNumber(毫秒)计算时间差 */
+ (CGFloat)hoursBetweenBeginNumber:(NSNumber *)beginNum andEndNumber:(NSNumber *)endNum;

/** 8/25 12:39:56 */
+ (NSString *)walletTimeStrWithNum:(NSNumber *)num;
/** 8月25日 12:39:56 */
+ (NSString *)otherOneWalletTimeStrWithNum:(NSNumber *)num;

/** 8月25日 */
+ (NSString *)jobBillTimeStrWithNum:(NSNumber *)num;

+ (NSString *)timeStringWithSecond:(NSInteger)second;
//秒数传周几
+(NSString*)weekdayStringFromDate:(NSNumber*)dateStr;

/** 获取指定日期00:00:00的时间 */
+ (NSDate *)zeroTimeOfDate:(NSDate *)date;

/** 图文消息(hh:mm 或 昨天 hh:mm 或 星期几 hh:mm) */
+(NSString *)getimgTextStringFromDate:(NSNumber*)dateStr;

/** 获取今天00:00:00的时间 */
+ (NSDate *)zeroTimeOfToday;

/**
 *  将11/26 11/27 11/28 12/5 转成 11/26 至 11/28, 12/5 的格式
 *
 *  @param numArray 1970到现在的秒数的NSNumber组成的数组
 *
 *  @return 11/26 至 11/28, 12/5格式的字符串
 */
+ (NSString *)dateRangeStrWithSecondNumArray:(NSArray *)numArray;

/**
 *  将11/26 11/27 11/28 12/5 转成 11/26 至 11/28, 12/5 的格式
 *
 *  @param numArray 1970到现在的毫米数的NSNumber组成的数组
 *
 *  @return 11/26 至 11/28, 12/5格式的字符串
 */
+ (NSString *)dateRangeStrWithMicroSecondNumArray:(NSArray *)numArray;


/**
 *  将11/26 11/27 11/28 12/5 转成 11/26 至 11/28, 12/5 的格式
 *
 *  @param numArray NSdate组成的数组
 *
 *  @return 11/26 至 11/28, 12/5格式的字符串
 */
+ (NSString *)dateRangeStrWithDateArray:(NSArray *)dateArray;

/**
 *  获取开始日期0点到结束日期0点间的所有日期0点的日期(包含开始日期及结束日期)
 *
 *  @param beginDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 一组0点日期数组(数组内为NSDate对象)
 */
+ (NSArray *)dateRangeArrayBetweenBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;


/**
 *  将allDateArray中包含excludeDateArray的日期剔除
 *
 *  @param excludeDateArray 要剔除的日期数组
 *  @param allDateArray     总日期数组
 *
 *  @return 剔除后的日期数组(NSDate对象的数组)
 */
+ (NSArray *)excludeDateArray:(NSArray *)excludeDateArray fromDateArray:(NSArray *)allDateArray;



/**
 *  比较两个时间相差几年
 */
+ (NSInteger)compareYearsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 *  比较两个时间相差几年(相同年份算0)
 */

+ (int)compareAbsYearsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 *  dateStr 转 nsdate
 */
+ (NSDate *)getDateFromStr:(NSString *)dateStr formatter:(NSString *)formatter;

@end
