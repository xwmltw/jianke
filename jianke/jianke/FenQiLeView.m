//
//  FenQiLeView.m
//  jianke
//
//  Created by yanqb on 2016/11/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "FenQiLeView.h"
#import "WDConst.h"

@interface FenQiLeView ()

@property (nonatomic, strong) UIWindow *window;

@end

@implementation FenQiLeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        MKBlurView *blueView = [[MKBlurView alloc] initWithFrame:self.bounds];
        [self addSubview:blueView];
        [self sendSubviewToBack:blueView];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView setCornerValue:14.0f];
    
    UIImageView *imgLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fenqile_icon"]];
    
    UILabel *title = [UILabel labelWithText:@"兼客兼职携手分期乐推出预支工资" textColor:[UIColor XSJColor_tGrayDeepTransparent80] fontSize:17.0f];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 0;
    UILabel *subTitle = [UILabel labelWithText:@"分期乐是中国领先的互联网消费金融服务商，中国互联网金融协会首批理事会员单位，即日起凡兼客用户即可通过预支工资享受分期乐带来的便捷服务。" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:14.0f];
    subTitle.numberOfLines = 0;
    UIButton *comfirm = [UIButton buttonWithTitle:@"我知道了" bgColor:nil image:nil target:self sector:@selector(btnOnClick:)];
    [comfirm setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [comfirm setBorderWidth:1.0f andColor:[UIColor XSJColor_base]];
    [comfirm setCornerValue:22.0f];
    
    
    [self addSubview:contentView];
    [contentView addSubview:imgLeft];
    [contentView addSubview:title];
    [contentView addSubview:subTitle];
    [contentView addSubview:comfirm];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(310));
        make.height.equalTo(@(360));
    }];
    
    [imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(40);
        make.centerX.equalTo(contentView);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgLeft.mas_bottom).offset(24);
        make.left.equalTo(contentView).offset(12);
        make.right.equalTo(contentView).offset(-12);
    }];
    
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(12);
        make.left.equalTo(contentView).offset(12);
        make.right.equalTo(contentView).offset(-12);
    }];
    
    [comfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(12);
        make.bottom.equalTo(contentView).offset(-24);
        make.right.equalTo(contentView).offset(-12);
        make.height.equalTo(@(44));
    }];
}

- (void)show{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.windowLevel = UIWindowLevel_custom;
    [self.window addSubview:self];
    self.window.hidden = NO;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.layer addAnimation:transition forKey:@"animationKey"];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnOnClick:(UIButton *)sender{
    [self dismiss];
}

- (void)dealloc{
    ELog(@"dealloc");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
