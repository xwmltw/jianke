//
//  XSJAlertView.m
//  jianke
//
//  Created by xiaomk on 16/8/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "XSJAlertView.h"
#import "XSJConst.h"


@interface XSJAlertView (){
    
}

@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UIImageView *titleImageViwe;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIButton *btnOK;


@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *pointView;

@end

@implementation XSJAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    if (self = [super init]) {
        self.titleString = title;
        self.contentString = message;
        [self initData];
    }
    return self;
}

- (void)initData{
    if (!_titleString) {
        _titleString = @"提示";
    }
    if (!_contentString) {
        _contentString = @"信息";
    }
    _titleImageName = @"v3_public_alertBg_1";
    _btnTitle = @"我知道了";
    _btnImageName = @"v3_public_btn_bg_orange";
}


- (void)showWithBlock:(XSJAlertViewBlock)block{
    self.block = block;
    [self show];
}

- (void)show{
    
    [self setupMainView];

    
    self.bgWindow.hidden = NO;
    [self.bgWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.shadeView setAlpha:0.3];
        [self.shadeView setUserInteractionEnabled:YES];
        self.alertView.alpha = 1;
    } completion:nil];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.shadeView setAlpha:0];
        [self.shadeView setUserInteractionEnabled:NO];
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.bgWindow.hidden = YES;
    }];

}

- (void)setupMainView{
    self.frame = MKSCREEN_BOUNDS;
    [self addSubview:self.shadeView];
    [self addSubview:self.alertView];
    
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
    
    self.titleImageViwe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.titleImageName]];
    [self.alertView addSubview:self.titleImageViwe];
    [self.titleImageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.alertView);
        make.height.mas_equalTo(95);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.titleString;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.alertView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleImageViwe);
        make.left.equalTo(self.titleImageViwe).offset(20);
        make.right.equalTo(self.titleImageViwe).offset(-20);
    }];
    
    self.contentLab = [[UILabel alloc] init];
    self.contentLab.text = self.contentString;
    self.contentLab.textColor = [UIColor XSJColor_tGrayDeep];
    self.contentLab.font = [UIFont systemFontOfSize:13];
    self.contentLab.textAlignment = NSTextAlignmentCenter;
    self.contentLab.numberOfLines = 0;
    [self.alertView addSubview:self.contentLab];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView).offset(20);
        make.right.equalTo(self.alertView).offset(-20);
        make.top.equalTo(self.titleImageViwe.mas_bottom).offset(20);
    }];
    
    
    self.btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnOK setTitle:self.btnTitle forState:UIControlStateNormal];
    [self.btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnOK.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.btnOK setBackgroundImage:[UIImage imageNamed:self.btnImageName] forState:UIControlStateNormal];
    [self.btnOK addTarget:self action:@selector(btnOKOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:self.btnOK];
    
    [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView).offset(24);
        make.right.equalTo(self.alertView).offset(-24);
        make.top.equalTo(self.contentLab.mas_bottom).offset(16);
        make.bottom.equalTo(self.alertView).offset(-22);
    }];
    
    [self.alertView setCornerValue:12];
    
    
    if (self.directPoint.x > 0) {
        [self addSubview:self.pointView];
        [self addSubview:self.lineView];
        
        self.pointView.frame = CGRectMake(self.directPoint.x-5, self.directPoint.y-5, 10, 10);
        [self.pointView setToCircle];
        
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(2);
            make.centerX.equalTo(self.pointView);
            make.top.equalTo(self.pointView);
            make.bottom.equalTo(self.alertView.mas_top);
        }];
    }
}

- (void)btnOKOnclick:(UIButton *)sender{
    [self dismiss];
    MKBlockExec(self.block, self, 0);
}

#pragma mark - ***** lazy ******
- (UIWindow *)bgWindow{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc] initWithFrame:MKSCREEN_BOUNDS];
        _bgWindow.windowLevel = UIWindowLevelStatusBar;
        _bgWindow.backgroundColor = [UIColor clearColor];
        _bgWindow.hidden = NO;
    }
    return _bgWindow;
}

- (UIView *)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc] init];
        [_shadeView setFrame:MKSCREEN_BOUNDS];
        [_shadeView setBackgroundColor:MKCOLOR_RGBA(0, 0, 0, 1)];
        [_shadeView setUserInteractionEnabled:NO];
        [_shadeView setAlpha:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_shadeView addGestureRecognizer:tap];
    }
    return _shadeView;
}

- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        [_alertView setBackgroundColor:[UIColor whiteColor]];
    }
    return _alertView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor whiteColor]];
    }
    return _lineView;
}

- (UIView *)pointView{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        [_pointView setBackgroundColor:[UIColor whiteColor]];
    }
    return _pointView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
