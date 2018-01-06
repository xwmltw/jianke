//
//  GuideMaskView.h
//  jianke
//
//  Created by yanqb on 2017/3/6.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideMaskView : UIView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block;
+ (void)showTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block;

- (void)show;

@end

@class GuideMaskAlertView;
@protocol GuideMaskAlertViewDelegate <NSObject>

- (void)guideMaskAlertView:(GuideMaskAlertView *)alertView actionIndex:(NSInteger)actionIndex;

@end

@interface GuideMaskAlertView : UIView

@property (nonatomic, weak) id<GuideMaskAlertViewDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *commitStr;
@property (nonatomic, copy) NSString *cancelStr;

@end
