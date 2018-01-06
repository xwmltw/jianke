//
//  WeChatRechargeModel.h
//  jianke
//
//  Created by xiaomk on 15/9/23.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatRechargeModel : NSObject

@property (nonatomic, copy) NSString* appid;
@property (nonatomic, copy) NSString* mch_key;
@property (nonatomic, copy) NSString* out_trade_no;
@property (nonatomic, copy) NSString* prepay_id;
@property (nonatomic, copy) NSString* mch_id;

@end


@interface WeChatPayResultModel : NSObject
@property (nonatomic, copy) NSNumber* order_status;
@property (nonatomic, copy) NSNumber* order_close_type;
@property (nonatomic, copy) NSString* wechat_result_code;
@property (nonatomic, copy) NSString* wechat_err_code;
@property (nonatomic, copy) NSString* wechat_err_msg;
@property (nonatomic, copy) NSNumber* n_acct_amount;  //服务端下发为 new_acct_amount 
@end

@interface AlipayRechargeModel : NSObject
@property (nonatomic, copy) NSString* recharge_title;
@property (nonatomic, copy) NSNumber* recharge_amount;
@property (nonatomic, copy) NSString* recharge_serail_id;
@property (nonatomic, copy) NSString* callback_url;
@property (nonatomic, copy) NSString* alipay_account;
@property (nonatomic, copy) NSString* alipay_partner;
@property (nonatomic, copy) NSString* alipay_public_key;
@property (nonatomic, copy) NSString* recharge_private_key;
@end
//“recharge_title”: <string> // 订单标题
//“recharge_amount”: // 充值金额，精确到分，不包含小数
//“recharge_serail_id”: <string> //服务端生成的订单号
//“callback_url” <string> // 支付宝回调服务端的地址
//“alipay_account” <string> // 支付宝账号
//“alipay_partner” <string> // 合作者id
//“alipay_public_key” <string> // 公钥
//“recharge_private_key” <string> // 私钥


@interface AlipayOredrModel : NSObject
@property (nonatomic, copy) NSString* partner;
@property (nonatomic, copy) NSString* seller_id;
@property (nonatomic, copy) NSString* out_trade_no;
@property (nonatomic, copy) NSString* subject;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, copy) NSString* total_fee;
@property (nonatomic, copy) NSString* notify_url;
@property (nonatomic, copy) NSString* service;
@property (nonatomic, copy) NSString* payment_type;
@property (nonatomic, copy) NSString* _input_charset;
@property (nonatomic, copy) NSString* it_b_pay;
@property (nonatomic, copy) NSString* show_url;
@property (nonatomic, copy) NSString* sign_date;
@property (nonatomic, copy) NSString* app_id;
@property(nonatomic, readonly) NSMutableDictionary * extraParams;
@end

@interface PinganPayModel : NSObject
@property (nonatomic, copy) NSString *submit_form;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *ping_an_pay_form_token;
@end
