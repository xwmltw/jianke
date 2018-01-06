//
//  UIButton+Extension.h
//  jianke
//
//  Created by fire on 16/7/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+ (UIButton *)buttonWithTitle:(NSString *)title bgColor:(UIColor *)color image:(NSString *)image target:(id)target sector:(SEL)sector;

+ (UIButton *)creatBottomButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action;
@end
