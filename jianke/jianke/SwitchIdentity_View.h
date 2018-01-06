//
//  SwitchIdentity_View.h
//  jianke
//
//  Created by xiaomk on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwitchIdentity_View : UIView

@property (nonatomic, copy) MKBoolBlock boolBlock;

@property (nonatomic, assign) BOOL isToEP;
- (void)starAnimation;

@end
