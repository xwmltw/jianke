//
//  BarButton.m
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  图片在上,标题在下的按钮.类似tabBar的按钮

#import "BarButton.h"
#import "UIView+MKExtension.h"

//static const CGFloat kPending = 2; /*!< Pending Between ImageView And TitleLabel */

@implementation BarButton

- (void)setHighlighted:(BOOL)highlighted
{
    
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    // 测试用,后续调整
//    self.imageView.width = self.width * 0.5;
//    self.imageView.height = self.height * 0.5;
//    self.titleLabel.width = self.width * 0.8;
//    self.titleLabel.height = self.height * 0.4;
//    self.titleLabel.font = [UIFont systemFontOfSize:12];
////    self.titleLabel.backgroundColor = [UIColor greenColor];
////    self.imageView.backgroundColor = [UIColor yellowColor];
//    
//    // 设置imageView位置
//    CGFloat imageViewX = (self.width - self.imageView.width) * 0.5;
//    CGFloat imageViewY = (self.height - self.imageView.height - self.titleLabel.height) * 0.5;
//    self.imageView.x = imageViewX;
//    self.imageView.y = imageViewY;
//    
//    // 设置titleLabel位置
//    CGFloat titleLabelX = (self.width - self.titleLabel.width) * 0.5;
//    CGFloat titleLabelY = imageViewY + self.imageView.height + kPending;
//    self.titleLabel.x = titleLabelX;
//    self.titleLabel.y = titleLabelY;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//}

+ (instancetype)buttonWithNorImage:(NSString *)norImage SelImage:(NSString *)selImage target:(id)target action:(SEL)sel title:(NSString *)title
{
    BarButton *btn = [[BarButton alloc] init];
    [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    return btn;
}

@end
