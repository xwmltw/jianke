//
//  Login_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/2.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@interface Login_VC : WDViewControllerBase

@property (nonatomic, assign) BOOL isFromNewFrature;
@property (nonatomic, assign) BOOL isToRegister;
@property (nonatomic, assign) BOOL isShowGuide; /*!< 是否显示引导注册页面 */

@property (nonatomic, copy) MKBlock blcok;

@end

