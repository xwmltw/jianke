//
//  EpProfile_VC.h
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface EpProfile_VC : WDViewControllerBase

@property (nonatomic, assign) BOOL isLookForJK; /*!< 是否是兼客视角 */
@property (nonatomic, strong) EPModel *epModel;
@property (nonatomic, assign) BOOL isFromGroupMembers;
@property (nonatomic, copy) NSString* accountId;
@property (nonatomic, assign) BOOL isfromIM;    /*!< 是否来自IM界面 */

@property (nonatomic, copy) NSString* enterpriseId;

@property (nonatomic, copy) MKBoolBlock block;

@end
