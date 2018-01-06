//
//  WDViewControllerBase.h
//  jianke
//
//  Created by xiaomk on 15/9/12.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDConst.h"

@interface WDViewControllerBase : UIViewController

@property (nonatomic, assign) BOOL isRootVC;
@property (nonatomic, assign) BOOL isUIRectEdgeAll;
@property (nonatomic, assign) BOOL isNotNeedLogin;  //默认为需要登录页面(影响无数据文案显示)
@property (nonatomic, strong) UIView *viewWithNoData;   //无数据 view
@property (nonatomic, strong) UIView *viewWithNoNetwork;//无网络 view
@property (nonatomic, weak, readonly) UIButton *btnWithNoData;  //无数据 button

/** 初始化无网络 无数据 view (带按钮)*/
- (void)initWithNoDataViewWithStr:(NSString *)str labColor:(UIColor*)labColor imgName:(NSString*)imgName button:(NSString *)btnTitle onView:(UIView *)view;
- (void)initWithNoDataViewWithLabColor:(UIColor*)labColor imgName:(NSString*)imgName onView:(UIView *)view strArgs:(NSString *)arg1,... NS_REQUIRES_NIL_TERMINATION;
/** 初始化无网络 无数据 view */
- (void)initWithNoDataViewWithStr:(NSString *)str labColor:(UIColor*)labColor imgName:(NSString*)imgName onView:(UIView *)view;
/** 初始化 无信号， 无数据 view str:设置的是无数据的 */
- (void)initWithNoDataViewWithStr:(NSString*)str onView:(UIView*)view;
/** 修改无数据的 laber  希望在不同情况显示不同 文字时可以使用 */
- (void)setNoDataViewText:(NSString*)text;

- (void)createCloseBtn;

- (void)noDataButtonAction:(UIButton *)sender;

/** 返回 事件 */
- (void)backToLastView; //需要特殊处理 返回事件，重写此方法

- (BOOL)gestureRecognizerShouldBegin;

@end
