//
//  CitySelectController.h
//  jianke
//
//  Created by fire on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  城市选择控制器

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@interface CitySelectController : WDViewControllerBase

@property (nonatomic, copy) MKBlock didSelectCompleteBlock;
@property (nonatomic, assign, getter=isShowSubArea) BOOL showSubArea;
@property (nonatomic, assign, getter=isShowParentArea) BOOL showParentArea;
@property (nonatomic, assign) BOOL isPushAction;
@property (nonatomic, assign) BOOL isFromNewFeature;    /*!< 是否来自新特性页 */
//added by kizy from v1.1.5 与showParentArea功能类似，但是应用场景不太一样-发布岗位用
@property (nonatomic, assign) BOOL showCityWide;

@end



/**
 Usage
 CitySelectController *vc = [[CitySelectController alloc] init];
 vc.showSubArea = YES;
 vc.showParentArea = NO;
 vc.didSelectCompleteBlock = ^(CityModel *area){
 

 };
 MainNavigation_VC *nav = [[MainNavigation_VC alloc] initWithRootViewController:vc];
 [self.postJobCellModel.tableViewController presentViewController:nav animated:YES completion:nil];
 */
