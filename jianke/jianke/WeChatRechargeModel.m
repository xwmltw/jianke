//
//  WeChatRechargeModel.m
//  jianke
//
//  Created by xiaomk on 15/9/23.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WeChatRechargeModel.h"

@implementation WeChatRechargeModel
@end

@implementation WeChatPayResultModel
@end

@implementation AlipayRechargeModel
@end

@implementation AlipayOredrModel
- (NSString *) description{
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller_id) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller_id];
    }
    if (self.out_trade_no) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.out_trade_no];
    }
    if (self.subject) {
        [discription appendFormat:@"&subject=\"%@\"", self.subject];
    }
    
    if (self.body) {
        [discription appendFormat:@"&body=\"%@\"", self.body];
    }
    if (self.total_fee) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.total_fee];
    }
    if (self.notify_url) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notify_url];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.payment_type) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.payment_type];//1
    }
    
    if (self._input_charset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self._input_charset];//utf-8
    }
    if (self.it_b_pay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.it_b_pay];//30m
    }
    if (self.show_url) {
        [discription appendFormat:@"&show_url=\"%@\"",self.show_url];//m.alipay.com
    }
    if (self.sign_date) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.sign_date];
    }
    if (self.app_id) {
        [discription appendFormat:@"&app_id=\"%@\"",self.app_id];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;

}

@end

@implementation PinganPayModel
@end
