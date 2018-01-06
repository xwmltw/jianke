//
//  UIView+MKException.h
//  jianke
//
//  Created by xiaomk on 16/6/27.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

typedef enum {
//    BorderDirectionTypeNone = 0,    //不显示边框
    BorderDirectionTypeTop      = 1 << 0,   //显示上边框
    BorderDirectionTypeLeft     = 1 << 1,   //显示左边框
    BorderDirectionTypeBottom   = 1 << 2,   //显示下边框
    BorderDirectionTypeRight    = 1 << 3,   //显示右边框
    BorderDirectionTypeAll      = ~0UL
}BorderDirectionType;

#import <Foundation/Foundation.h>

@interface UIView(MKException)

//@property (nonatomic, strong) UIView *nodataView;
//@property (nonatomic, strong) UIView *noNetworkView;
//@property (nonatomic, strong) UIView *noLoginView;

- (void)addBorderInDirection:(BorderDirectionType)direction;
- (void)addBorderInDirection:(BorderDirectionType)direction borderWidth:(CGFloat)width borderColor:(UIColor *)color isConstraint:(Boolean)isConstraint;

- (void)setBorder;

@end
