//
//  BarButton.h
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  图片在上,标题在下的按钮.类似tabBar的按钮

#import <UIKit/UIKit.h>

@interface BarButton : UIButton

+ (instancetype)buttonWithNorImage:(NSString *)norImage SelImage:(NSString *)selImage target:(id)target action:(SEL)sel title:(NSString *)title;

@end
