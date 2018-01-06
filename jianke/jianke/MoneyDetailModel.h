//
//  MoneyDetailModel.h
//  jianke
//
//  Created by xiaomk on 15/9/22.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyDetailModel : NSObject
@property (nonatomic, copy) NSString* account_money_detail_list_id; //流水记录id
@property (nonatomic, copy) NSNumber* account_money_id;             //帐户id
@property (nonatomic, copy) NSNumber* money_detail_type;            //流水类型：
/**
    RECHARGE(1, "充值 "), //充值
	WITHDRAW_SUCCESS(2, "提现成功"), // 微信app提现
	GET_SALARY(3, "工资收入"),
	PAY_SALARY(4, "支付工资"),
	ORDER_BOND(5, "抢单保证金"),
	SOCIAL_ACTIVIST_REWARD(6, "人脉王补贴"),
	PAY_BILL(7,"支付账单"),
	SERVICE_FEE(8,"服务费"),
	LEADER_SALARY(9,"领队薪资"),
	ADMIN_RECHARGE(10, "后台充值"),// 微信app付款账户充值
	WITHDRAWING(11, "提现中"),// 微信app提现
	WITHDRAW_FAIL(12, "提现失败"), // 微信app提现
	INSURANCE_POLICY(13, "购买保险"),
	ALIPAY_WITHDRAW_ING(14, "支付宝提现中"), // 支付宝app提现
	ALIPAY_WITHDRAW_SUCCESS(15, "支付宝提现成功"), // 支付宝app提现
	ALIPAY_WITHDRAW_FAIL(16, "支付宝提现失败"), // 支付宝app提现
	WECHAT_PUBLIC_WITHDRAW_ING(17, "微信公众号提现中"), // 微信公众号提现
	WECHAT_PUBLIC_WITHDRAW_SUCCESS(18, "微信公众号提现成功"), // 微信公众号提现
	WECHAT_PUBLIC_WITHDRAW_FAIL(19, "微信公众号提现失败"), // 微信公众号提现
	TASK_ADVANCE_RECHARGE(20, "预付款账户充值"),
	TASK_ADVANCE_MONEY_BAG_RECHARGE(21, "钱袋子充值预付款"),
	TASK_ADVANCE_REFUND(22, "任务预付款退款"),
	GET_TASK_SALARY(23, "任务工资收入"),
	PAY_TASK_SALARY(24, "支付任务工资"),
	PAY_TASK_SERVICE_FEE(25, "支付任务服务费");
 */
@property (nonatomic, copy) NSString* money_detail_title;           //流水标题
@property (nonatomic, copy) NSNumber* create_time;                  //从1970年1月1日至今的秒数
@property (nonatomic, copy) NSNumber* update_time;                  //从1970年1月1日至今的秒数

@property (nonatomic, copy) NSNumber* job_id;                       //如果此明细与岗位有关，本字段不为空
@property (nonatomic, copy) NSNumber* job_type;                     //<int>岗位类型，1为普通岗位，2为抢单岗位
@property (nonatomic, copy) NSNumber* actual_amount;                //<int>明细产生的金额，单位为分，不包含小数
@property (nonatomic, copy) NSNumber* small_red_point;              // <int>是否呈现小红点，1表示是，0表示否
@property (nonatomic, copy) NSNumber* aggregation_number;           //流水的聚合次数
@property (nonatomic, copy) NSNumber* task_id;                      //宅任务
@end

//@interface MoneyDetailModel : NSObject
//
//@property (nonatomic, assign) NSNumber* acct_amount;
//@property (nonatomic, strong) MoneyDetailListModel* detail_list;

//@end


//“account_money_detail_list_id”: 流水记录id
//"account_money_id":,帐户id
//"money_detail_type": 流水类型：
//“money_detail_title”: <string>流水标题
//“aggregation_number”: <int>流水的聚合次数（仅对于企业为兼客支付工资有效，数字表示支付次数）
//“create_time”: <long> 从1970年1月1日至今的秒数
//“job_id”: <long>如果此明细与岗位有关，本字段不为空
//“job_type”: <int>岗位类型，1为普通岗位，2为抢单岗位
//“actual_amount”: <int>明细产生的金额，单位为分，不包含小数
//“small_red_point”: <int>是否呈现小红点，1表示是，0表示否
