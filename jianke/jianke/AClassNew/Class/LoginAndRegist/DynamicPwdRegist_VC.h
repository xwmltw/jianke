//
//  DynamicPwdRegist_VC.h
//  jianke
//
//  Created by xiaomk on 16/6/18.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface DynamicPwdRegist_VC : WDViewControllerBase

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *authNum;
@property (nonatomic, copy) MKBoolBlock boolBlock;
@end
