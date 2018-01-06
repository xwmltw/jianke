//
//  UIButton+Extension.m
//  jianke
//
//  Created by fire on 16/7/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (UIButton *)buttonWithTitle:(NSString *)title bgColor:(UIColor *)color image:(NSString *)image target:(id)target sector:(SEL)sector{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (color) {
        [button setBackgroundColor:color];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [button addTarget:target action:sector forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}


+ (UIButton *)creatBottomButtonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_btn_login_0"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_btn_login_1"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"v3_public_btn_bg_2"] forState:UIControlStateDisabled];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
