//
//  UIColor+Extension.h
//  jianke
//
//  Created by xiaomk on 15/9/11.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

#pragma mark - *********** 背景色
/** 透明灰色 (0, 0, 0, 0.3)*/
+ (UIColor*)XSJColor_shadeBg;

/** app基础色*/
+ (UIColor*)XSJColor_base;
+ (UIColor*)XSJColor_blackBase;

/** 灰色*/
+ (UIColor*)XSJColor_newGray;

/** 白色*/
+ (UIColor*)XSJColor_newWhite;

/** 深色文字 */
+ (UIColor *)XSJColor_tGrayDeepTinge;

/** 深色文字 */
+ (UIColor *)XSJColor_tGrayDeepTinge1;

/** 深色文字0.56透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent;

/** 深色文字0.64透明 */
+ (UIColor *)XSJColor_tGrayHistoyTransparent;
+ (UIColor *)XSJColor_tGrayHistoyTransparent64;

/** 深色文字0.48透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent2;
+ (UIColor *)XSJColor_tGrayDeepTransparent48;

/** 深色文字0.32透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent32;

/** 深色文字0.80透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent80;

/** 深色文字0.03透明 */
+ (UIColor *)XSJColor_tGrayDeepTransparent003;

/** 新特性红 */
+ (UIColor *)XSJColor_middelRed;

/** 分割线 */
+ (UIColor *)XSJColor_clipLineGray;

/** 白色*/
+ (UIColor*)XSJColor_white;
/** 深灰色 (240, 240, 240, 1)*/
+ (UIColor*)XSJColor_grayDeep;
/** 浅灰色 (250, 250, 250, 1)*/
+ (UIColor*)XSJColor_grayTinge;
/** 分割线灰色*/
+ (UIColor*)XSJColor_grayLine;
/** 白色文字，灰背景 (0, 0, 0, 0.5)*/
+ (UIColor*)XSJColor_grayBtnBg;
/** 白色文字，灰背景 (0, 0, 0, 0.15)*/
+ (UIColor*)XSJColor_grayLabBg;
/** 卡片风格背景色 (255, 255, 255, 1)*/
+ (UIColor*)XSJColor_cardBg;

#pragma mark - *********** 文字颜色
/** 红色*/
+ (UIColor*)XSJColor_tRed;

/** 点击文字蓝色*/
+ (UIColor*)XSJColor_tBlue;

/** 黑色文字 0.84 */
+ (UIColor*)XSJColor_tBlackTinge;

/** 深灰色文字 0.72 */
+ (UIColor*)XSJColor_tGrayDeep;

/** 灰色文字  0.56 */
+ (UIColor*)XSJColor_tGrayMiddle;

/** 灰色文字 0.44 */
+ (UIColor*)XSJColor_tGray;

/** 超浅灰色文字 0.28 */
+ (UIColor*)XSJColor_tGrayTinge;



@end
