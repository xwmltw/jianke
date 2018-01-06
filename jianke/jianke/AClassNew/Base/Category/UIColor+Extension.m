//
//  UIColor+Extension.m
//  jianke
//
//  Created by xiaomk on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "UIColor+Extension.h"
#import "WDConst.h"

@implementation UIColor (Extension)

#pragma mark - *********** 背景色
/** 透明色*/
+ (UIColor*)XSJColor_shadeBg{
    return MKCOLOR_RGBA(0, 0, 0, 0.3);
}
/** app基础色*/
+ (UIColor*)XSJColor_base{
    return MKCOLOR_RGBA(0, 199, 225, 1);
}

/** 灰色*/
+ (UIColor*)XSJColor_newGray{
    return MKCOLOR_RGBA(248, 249, 250, 1);
}

/** 白色*/
+ (UIColor*)XSJColor_newWhite{
    return MKCOLOR_RGBA(253, 253, 254, 1);
}

/** 深色文字 */
+ (UIColor *)XSJColor_tGrayDeepTinge{
    return MKCOLOR_RGBA(34, 58, 80, 1);
}

/** 深色文字 */
+ (UIColor *)XSJColor_tGrayDeepTinge1{
    return MKCOLOR_RGBA(34, 58, 80, 1);
}

/** 深色文字0.56透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent{
    return MKCOLOR_RGBA(34, 58, 80, 0.56);
}

/** 深色文字0.64透明 */
+ (UIColor *)XSJColor_tGrayHistoyTransparent{
    return [self XSJColor_tGrayHistoyTransparent64];
}

/** 深色文字0.64透明 */
+ (UIColor *)XSJColor_tGrayHistoyTransparent64{
    return MKCOLOR_RGBA(34, 58, 80, 0.64);
}

/** 深色文字0.48透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent2{
    return MKCOLOR_RGBA(34, 58, 80, 0.48);
}

/** 深色文字0.48透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent48{
    return [self XSJColor_tGrayDeepTransparent2];
}

/** 深色文字0.32透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent32{
    return MKCOLOR_RGBA(34, 58, 80, 0.32);
}

/** 深色文字0.80透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent80{
    return MKCOLOR_RGBA(34, 58, 80, 0.80);
}

/** 深色文字0.03透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent003{
    return MKCOLOR_RGBA(34, 58, 80, 0.03);
}

/** 新特性红 */
+ (UIColor *)XSJColor_middelRed{
    return MKCOLOR_RGB(255, 97, 142);
}

/** 分割线 */
+ (UIColor *)XSJColor_clipLineGray{
    return MKCOLOR_RGB(233, 233, 233);
}

+ (UIColor*)XSJColor_blackBase{
    return MKCOLOR_RGBA(39, 39, 39, 0.94);
}

/** 白色*/
+ (UIColor*)XSJColor_white{
    return MKCOLOR_RGBA(255, 255, 255, 1);
}
/** 深灰色*/
+ (UIColor*)XSJColor_grayDeep{
    return MKCOLOR_RGBA(240, 240, 240, 1);
}
/** 浅灰色*/
+ (UIColor*)XSJColor_grayTinge{
    return MKCOLOR_RGBA(250, 250, 250, 1);
}
/** 分割线灰色*/
+ (UIColor*)XSJColor_grayLine{
    return MKCOLOR_RGBA(200, 199, 204, 1);
}
/** 白色文字，灰背景*/
+ (UIColor*)XSJColor_grayBtnBg{
    return MKCOLOR_RGBA(0, 0, 0, 0.5);
}
/** 白色文字，灰背景*/
+ (UIColor*)XSJColor_grayLabBg{
    return MKCOLOR_RGBA(0, 0, 0, 0.15);
}
/** 卡片风格背景色*/
+ (UIColor*)XSJColor_cardBg{
    return MKCOLOR_RGBA(255, 255, 255, 1);
}

#pragma mark - *********** 文字颜色
/** 红色*/
+ (UIColor*)XSJColor_tRed{
    return MKCOLOR_RGBA(255, 87, 34, 1);
}

/** 点击文字蓝色*/
+ (UIColor*)XSJColor_tBlue{
    return MKCOLOR_RGBA(0, 118, 255, 1);
}

/** 黑色色文字*/
+ (UIColor*)XSJColor_tBlackTinge{
    return MKCOLOR_RGBA(0, 0, 0, 0.88);
}

/** 黑色色文字 */
+ (UIColor*)XSJColor_tGrayDeep{
    return MKCOLOR_RGBA(0, 0, 0, 0.72);
}

/** 灰色文字 0.56 */
+ (UIColor*)XSJColor_tGrayMiddle{
    return MKCOLOR_RGBA(0, 0, 0, 0.56);
}

/** 灰色文字*/
+ (UIColor*)XSJColor_tGray{
    return MKCOLOR_RGBA(0, 0, 0, 0.44);
}

/** 超浅灰色文字*/
+ (UIColor*)XSJColor_tGrayTinge{
    return MKCOLOR_RGBA(0, 0, 0, 0.32);
}



@end
