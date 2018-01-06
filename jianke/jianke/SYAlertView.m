//
//  SYAlertView.m
//  jianke
//
//  Created by fire on 16/1/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SYAlertView.h"
#import "UIView+MKExtension.h"
#import "UIHelper.h"

@interface SYAlertView()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) SelectBlock block;

@end

@implementation SYAlertView

- (instancetype)initWithTitleArray:(NSArray *)aTitleArray selectBlock:(SelectBlock)block
{
    if (self = [super init]) {
        self.titleArray = aTitleArray;
        self.block = block;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
    
    CGFloat btnH = 52;
    CGFloat btnW = SCREEN_WIDTH - 52 * 2;
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    
    contentView.width = btnW;
    contentView.height = btnH * self.titleArray.count;
    contentView.center = self.center;
    contentView.backgroundColor = MKCOLOR_RGBA(255, 255, 255, 0.9);
    contentView.layer.cornerRadius = 10;
    
    [self.titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
       
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnH * idx, btnW, btnH)];
        btn.tag = idx;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:MKCOLOR_RGB(0, 179, 202) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
    }];
    
    NSInteger count = self.titleArray.count - 1;
    if (count < 1) {
        return;
    }
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, btnH, btnW, 0.5)];
        line.backgroundColor = MKCOLOR_RGB(200, 199, 204);
        [contentView addSubview:line];
    }
}


- (void)btnClick:(UIButton *)btn
{
    [self hide];
    
    if (!self.block) {
        return;
    }
    
    self.block(btn.tag);
}


- (void)hide
{    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0);

    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}


- (void)show
{
    UIWindow *window = [MKUIHelper getCurrentRootViewController].view.window;
    
    self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0);
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
    }];
}

+ (void)showAlertViewWithTitleArray:(NSArray *)aTitleArray selectBlock:(SelectBlock)block
{
    SYAlertView *alertView = [[self alloc] initWithTitleArray:aTitleArray selectBlock:block];
    
    [alertView show];    
}


@end
