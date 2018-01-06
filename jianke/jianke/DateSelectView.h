//
//  DateSelectView.h
//  jianke
//
//  Created by fire on 15/10/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  日期选择控件

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DateViewType) {
    
    DateViewTypeNormal      = 0,    // 默认
    DateViewTypePay         = 1,    // 支付
    DateViewTypeAdjust      = 2,    // 调整日期
    DateViewTypeInsurance   = 3,    // 保险
    DateViewType_makeCheck  = 4,    // 创建账单
};

@interface DateSelectView : UIView

@property (nonatomic, strong) NSMutableArray *datesSelected; /*!< 选中的日期 */
@property (nonatomic, strong) NSDate *startDate; /*!< 开始日期 */
@property (nonatomic, strong) NSDate *endDate; /*!< 结束日期 */

@property (nonatomic, strong) NSArray *canSelDateArray; /*!< 可以选择的日期 */
@property (nonatomic, copy) MKBlock didClickBlock; /*!< 选择日期后的回调 */


@property (nonatomic, assign) DateViewType type; /*!< 日期选择控件类型: DateViewTypeNormal, DateViewTypePay, DateViewTypeAdjust */

// DateViewTypeAdjust
@property (nonatomic, strong) NSMutableArray *datesAdd; /*!< 增加的日期 */
@property (nonatomic, strong) NSMutableArray *datesReduce; /*!< 减少的日期 */

// DateViewTypePay
@property (nonatomic, strong) NSArray *datesPay; /*!< 已支付的日期 */
@property (nonatomic, strong) NSArray *datesComplete; /*!< 已完工的日期 */
@property (nonatomic, strong) NSArray *datesAbsent; /*!< 未到岗的日期 */
@property (nonatomic, strong) NSMutableArray *datesApply; /*!< 已报名的日期 */

// DateViewType_makeCheck
@property (nonatomic, strong) NSDate *billStartDate;

/* DateViewTypeNormal 必传字段
    startDate endDate 与 canSelDateArray 二选一
 */


/* DateViewTypeAdjust 必传字段
 datesAdd
 datesReduce
 datesApply
 startDate endDate 与 canSelDateArray 二选一
 
 datesAdd + datesReduce 为调整后的报名日期
*/



/* DateViewTypePay 必传字段
 datesPay
 datesComplete
 datesAbsent
 datesApply
 
 datesSelected 为需要支付的日期
 */






@end
