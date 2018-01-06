//
//  TwoScreenBase_VC.h
//  jianke
//
//  Created by xiaomk on 16/4/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface TwoScreenBase_VC : WDViewControllerBase{
    
}


- (void)initTopWithLeftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle;

- (void)setLeftTitle:(NSString*)title;
- (void)setRightTitle:(NSString*)title;

- (void)setLView:(UIView *)view;

- (void)setRView:(UIView *)view;
@end
