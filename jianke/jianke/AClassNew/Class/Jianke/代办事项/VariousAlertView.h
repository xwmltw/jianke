//
//  VariousAlertView.h
//  jianke
//
//  Created by yanqb on 2017/6/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariousAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel commit:(NSString *)commit imageView:(NSString *)image block:(MKIntegerBlock)block;

+ (void)showTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel commit:(NSString *)commit imageView:(NSString *)image block:(MKIntegerBlock)block;

- (void)show;

@end

@class XWMAlertView;
@protocol XWMAlertViewDelegate <NSObject>

- (void)xwmAlertView:(XWMAlertView *)alertView actionIndex:(NSInteger)actionIndex;

@end

@interface XWMAlertView : UIView

@property (nonatomic, weak)id<XWMAlertViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *commitStr;
@property (nonatomic, copy) NSString *cancelStr;

@end
