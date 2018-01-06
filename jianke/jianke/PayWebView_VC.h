//
//  PayWebView_VC.h
//  jianke
//
//  Created by xiaomk on 16/6/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface PayWebView_VC : WDViewControllerBase
@property (nonatomic, copy) NSString* fixednessTitle;   /*!< 固定不变的 title, 否则会根据 web 的显示 改变title */
@property (nonatomic, copy) NSString* url;              /*!< 访问的URL */

@property (nonatomic, assign) BOOL isFromPostJob;       /*!< 是否来自合伙人发布岗位 */
@property (nonatomic, copy) MKBlock block;
@end
