//
//  UIImage+MKExtension.h
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(MKExtension)

/** 返回九宫格图片 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
