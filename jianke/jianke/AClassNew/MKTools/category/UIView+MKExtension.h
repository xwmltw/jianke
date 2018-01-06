//
//  UIView+MKExtension.h
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(MKExtension)

- (CGFloat)x;
- (CGFloat)y;

- (CGFloat)width;
- (CGFloat)height;

- (CGSize)size;
- (CGPoint)origin;

- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

- (void)setSize:(CGSize)size;

- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;

- (void)setCornerValue:(CGFloat)value;
- (void)setCorner;
- (void)setToCircle;
- (void)setCornerWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)size;

- (void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color;
- (void)setBorderColor:(UIColor*)color;

- (void)removeAllSubviews;
@end
