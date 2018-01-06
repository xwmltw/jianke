//
//  QueryAccountMoneyModel.h
//  jianke
//
//  Created by xiaomk on 15/10/6.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryAccountMoneyModel : NSObject

@property (nonatomic, copy) NSNumber* total_amount;
@property (nonatomic, copy) NSNumber* available_amount;
@property (nonatomic, copy) NSNumber* frozen_amount;
@property (nonatomic, copy) NSNumber* money_bag_small_red_point;
@property (nonatomic, copy) NSNumber* has_set_bag_pwd;
@property (nonatomic, copy) NSNumber* id;
@end


@interface MoneyBagInfoModel : NSObject
@property (nonatomic, copy) NSNumber* alipay_sigle_withdraw_min_limit;
@property (nonatomic, strong) QueryAccountMoneyModel* account_money_info;
@end

//“total_amount”: <int> // 账户总额
//“available_amount”: <int> //账户可用余额
//“frozen_amount” <int> //账户冻结金额
//“money_bag_small_red_point”: //<int> 钱袋子小红点
//“has_set_bag_pwd” :<int> // 是否设置过钱袋子密码 1是0 否
