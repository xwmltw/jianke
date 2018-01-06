//
//  MoneyBag_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/22.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@interface MoneyBag_VC : WDViewControllerBase

@property (nonatomic, assign) BOOL isFromWebView;
@property (nonatomic, assign) BOOL isFromPay;
@property (nonatomic, weak) UIViewController *popToVC;  /*!< pop返回页面 */

@end
