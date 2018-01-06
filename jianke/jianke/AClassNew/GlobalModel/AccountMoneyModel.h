//
//  AccountMoneyModel.h
//  jianke
//
//  Created by fire on 15/10/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "MKBaseModel.h"

@interface AccountMoneyModel : MKBaseModel

@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *total_amount;             /*!< 账户总额 */
@property (nonatomic, copy) NSNumber *available_amount;         /*!< 账户可用余额 */
@property (nonatomic, copy) NSNumber *frozen_amount;            /*!< 账户冻结金额 */
@property (nonatomic, copy) NSNumber *money_bag_small_red_point;/*!< 钱袋子小红点 */
@property (nonatomic, assign) BOOL has_set_bag_pwd;             /*!< 是否设置过钱袋子密码 1是0 否 */
@property (nonatomic, copy) NSNumber *recruitment_amount;       /*!< 招聘余额 */

@property (nonatomic, copy) NSString* alipay_user_true_name;
@property (nonatomic, copy) NSString* alipay_user_name;
@end



/**
 请求Service	shijianke_queryAccountMoney
 请求content	“content”:{
 }
 应答content	“content”:{
 “account_money_info” : {
 “total_amount”: <int> // 账户总额
 “available_amount”: <int> //账户可用余额
 “frozen_amount” <int> //账户冻结金额
 “money_bag_small_red_point”: //<int> 钱袋子小红点
 “has_set_bag_pwd” :<int> // 是否设置过钱袋子密码 1是0 否
 }
 }
 */