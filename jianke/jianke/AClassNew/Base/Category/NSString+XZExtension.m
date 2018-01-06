//
//  NSString+XZExtension.m
//  jianke
//
//  Created by xuzhi on 16/7/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "NSString+XZExtension.h"

@implementation NSString (XZExtension)

+ (BOOL)isBeginInChinese:(NSString *)text{
    unichar c = [text characterAtIndex:0];
    if (c >=0x4E00 && c <=0x9FFF){
        return YES;
    }
    return NO;
}

+ (NSString *)stringNoneNullFromValue:(id)value {
    
    if ([value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]]) {
        return [value description];
    }else{
        return [NSString stringWithFormat:@"%@",@""];
    }
}

/** 字符串size */
- (CGSize)contentSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                   //                                                    | NSStringDrawingTruncatesLastVisibleLine
                   //                                                    | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                          context:nil].size;
    
    return size;
}

@end
