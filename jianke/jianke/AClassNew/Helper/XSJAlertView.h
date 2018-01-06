//
//  XSJAlertView.h
//  jianke
//
//  Created by xiaomk on 16/8/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XSJAlertView;
typedef void(^XSJAlertViewBlock)(XSJAlertView* alertView, NSInteger buttonIndex);


@interface XSJAlertView : UIView

@property (nonatomic, copy) NSString *titleImageName;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, copy) NSString *btnImageName;

@property (nonatomic, assign) CGPoint directPoint;

@property (nonatomic, copy) XSJAlertViewBlock block;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)showWithBlock:(XSJAlertViewBlock)block;

@end
