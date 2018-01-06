//
//  PerfectInfo_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseInfo.h"
#import "WDViewControllerBase.h"

//typedef void (^ResBlock)(ResponseInfo* response);

@interface PerfectInfo_VC : WDViewControllerBase

@property (nonatomic, copy) MKBlock resBlock; /*!< 请求完成回调block */
@property (nonatomic, strong) NSString* oauth_id; /*!< 第三方账户ID */

@end
