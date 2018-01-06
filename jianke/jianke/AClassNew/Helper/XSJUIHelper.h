//
//  XSJUIHelper.h
//  jianke
//
//  Created by xiaomk on 16/4/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLAVAlertView.h"

typedef void (^HHDatePickerAlertViewCompletionHandler)(DLAVAlertView *alertView, NSInteger buttonIndex, UIDatePicker* datePicker);


@interface XSJUIHelper : NSObject
+ (instancetype)sharedInstance;

#pragma mark - ***** JK EP 切换 ******

+ (void)showMainScene:(BOOL)isNewMethod block:(MKBlock)block;
+ (void)showMainScene;
+ (void)switchIsToEP:(BOOL)isToEP;
+ (void)switchRequestIsToEP:(BOOL)isToEP;


/** UIAlertView 一个按钮的 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message okBtnTitle:(NSString *)btnTitle;

/** 提示 */
+ (void)showToast:(NSString*)message;

/** 提示 手动增加指定的视图 added from v324 */
+ (void)showToast:(NSString *)message inView:(UIView *)view;

+ (void)showConfirmWithView:(UIView*)view msg:(NSString*)msg title:(NSString*)title cancelBtnTitle:(NSString*)cancelTitle okBtnTitle:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion;

+ (void)showDatePickerConfirmTitle:(NSString*)title msg:(NSString*)msg cancelBtnTitle:(NSString*)cancelTitle okBtnTitle:(NSString*)okTitle DPCompletion:(HHDatePickerAlertViewCompletionHandler)DPCompletion;

#pragma mark - ***** 显示 引导评价 弹窗 ******
- (void)showCommentAlertWithVC:(UIViewController *)rootVc;
- (void)showAppCommentAlertWithViewController:(UIViewController *)vc;
- (void)evaluateWithViewController:(UIViewController *)rootVc;

@end
