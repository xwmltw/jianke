//
//  MKUIHelper.h
//  jianke
//
//  Created by xiaomk on 16/4/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKUIHelper : NSObject

/** 获取顶层 View*/
+ (UIView *)getTopView;

/** 获取当前 ViewController*/
+ (UIViewController *)getCurrentRootViewController;

/** 根据 windowLevel 获取当前 ViewController*/
+ (UIViewController *)getCurrentRootViewControllerWithWindowLevel:(CGFloat)windowLevel;

/** 获取当前屏幕中 present 出来的 viewcontroller */
+ (UIViewController *)getPresentedViewController;

/** 获取最顶层VC */
+ (UIViewController *)getTopViewController;

/** 获取最顶层VC的navigationCtrl */
+ (void)getTopNavigationCtrl:(MKBlock)block;

/** 绘制纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
