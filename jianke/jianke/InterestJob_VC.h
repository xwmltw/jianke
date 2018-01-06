//
//  InterestJob_VC.h
//  jianke
//
//  Created by xiaomk on 16/5/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewController.h"
#import "MKBaseModel.h"

@interface InterestJob_VC : MKBaseTableViewController

@property (nonatomic, assign) BOOL isFromResume;
@property (nonatomic, copy) MKBlock block;

@end
