//
//  WelcomeJoinJK_VC.h
//  jianke
//
//  Created by yanqb on 2016/12/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BottomViewControllerBase.h"

@interface WelcomeJoinJK_VC : BottomViewControllerBase

@property (nonatomic, assign) BOOL isFromNewFeature;    /*!< 是否来自新特性页 */
@property (nonatomic, assign) BOOL isNotShowJobTrends;  /*!< 是否不显示感兴趣工作页面, 默认:显示 */
@property (nonatomic, copy) MKBlock block;

@end
