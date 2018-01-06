//
//  SalaryModel.h
//  jianke
//
//  Created by xiaomk on 15/9/16.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalaryModel : NSObject

@property (nonatomic, copy) NSNumber* value;                /*!< 工资 */
@property (nonatomic, copy) NSNumber* settlement;           /*!< 1当天计算, 2周末结算, 3月末结算, 4完工结算 */
@property (nonatomic, copy) NSString* settlement_value;     /*!< 工资结算方式描述 1当天计算, 2周末结算, 3月末结算, 4完工结算*/
@property (nonatomic, copy) NSNumber* unit;                 /*!< 结算方式 天小时月   // 工资计算方式：  按小时计算或者按天计算，具体定义与数据字典一致 */
@property (nonatomic, copy) NSString* unit_value;           /*!< 工资单位描述 */
@property (nonatomic, copy) NSNumber* pay_type;             /*!< 付款方式： 1在线支付 2 现金支付 */


//- (NSString*)getwantjobDesc;
//- (NSString*)getDesc;
//- (NSString*)getSimpleDesc;

#pragma mark - ***** 薪资单位 ******
- (NSString*)getTypeDesc;

#pragma mark - ***** 结算 ******
- (NSString*)getSettlementDesc;


@end


//工资计算方式:(t_parttime_job.salary_type unit)
//KEY		|			VALUE
//1		|			天
//2		|			小时
//3		|			月
//4     |           次
//
//-- --------------
//工资结算方式:(t_parttime_job.settlement_way)
//KEY	|			VALUE
//1		|			当天结算
//2		|			周末结算
//3		|			月末结算
//4     |           完工结算





