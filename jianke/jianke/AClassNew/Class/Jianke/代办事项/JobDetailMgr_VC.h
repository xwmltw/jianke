//
//  JobDetailMgr_VC.h
//  jianke
//
//  Created by fire on 15/12/28.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"
//#import "JobDetailFooterView.h"

//typedef void(^XZJobTypeBlock)(JobDetailFooterViewBtnType actionType);

@interface JobDetailMgr_VC : WDViewControllerBase

@property (nonatomic, copy) NSArray *jobIdArray;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, assign) NSInteger index;

//@property (nonatomic, copy) XZJobTypeBlock actionType;

@end
