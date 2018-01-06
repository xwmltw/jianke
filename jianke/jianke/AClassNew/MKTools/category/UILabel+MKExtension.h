//
//  UILabel+MKExtension.h
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel(MKExtension)

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)size;
- (CGSize)contentSizeWithWidth:(CGFloat)width;

@end
