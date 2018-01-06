//
//  NewFeature_VC.h
//  jianke
//
//  Created by xiaomk on 15/9/9.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDViewControllerBase.h"

@interface NewFeature_VC : WDViewControllerBase

@property (nonatomic, assign) BOOL isFromeSetting;

@end


@interface NewFeatureTextView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end
