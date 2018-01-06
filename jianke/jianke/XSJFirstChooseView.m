//
//  XSJFirstChooseView.m
//  jianke
//
//  Created by xiaomk on 16/6/17.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJFirstChooseView.h"
#import "MKBlurView.h"
#import "XSJConst.h"

@interface XSJFirstChooseView()

@property (nonatomic, copy) MKIntegerBlock block;

@end

@implementation XSJFirstChooseView

+ (void)showViewWithBlock:(MKIntegerBlock)block{
    XSJFirstChooseView *chooseView = [[self alloc] initWithBlock:block];
    [chooseView show];
}


- (instancetype)initWithBlock:(MKIntegerBlock)block{
    if (self = [super init]) {
        self.block = block;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.frame = MKSCREEN_BOUNDS;
    MKBlurView *blueView = [[MKBlurView alloc] init];
    blueView.frame = self.frame;
    [self addSubview:blueView];
    
    UIButton *btnJK = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnJK setBackgroundImage:[UIImage imageNamed:@"v3_home_show_jk"] forState:UIControlStateNormal];
    btnJK.tag = 0;
    [btnJK addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnEP = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEP setBackgroundImage:[UIImage imageNamed:@"v3_home_show_ep"] forState:UIControlStateNormal];
    btnEP.tag = 1;
    [btnEP addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:btnJK];
    [self addSubview:btnEP];
    
    
    [btnJK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-60);
    }];
    
    [btnEP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(btnJK.mas_bottom).offset(16);
    }];
}

- (void)btnOnclick:(UIButton *)sender{
    [self hide];
    MKBlockExec(self.block, sender.tag);
}

- (void)show{
    UIWindow *window = [MKUIHelper getCurrentRootViewController].view.window;
    [window addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
