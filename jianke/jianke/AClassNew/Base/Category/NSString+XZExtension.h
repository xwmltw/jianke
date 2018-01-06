//
//  NSString+XZExtension.h
//  jianke
//
//  Created by xuzhi on 16/7/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XZExtension)

/** 判断字符串是否是中文开头 */
+ (BOOL)isBeginInChinese:(NSString *)text;

/** null转@"" */
+ (NSString *)stringNoneNullFromValue:(id)value;

/** 字符串size */
- (CGSize)contentSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize;

@end
