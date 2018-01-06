//
//  GuideMaskView.m
//  jianke
//
//  Created by yanqb on 2017/3/6.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "GuideMaskView.h"
#import "WDConst.h"

@interface GuideMaskView () <GuideMaskAlertViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, weak) GuideMaskAlertView *alertView;
@property (nonatomic, copy) MKIntegerBlock block;

@end

@implementation GuideMaskView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:ges];
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block{
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.alertView.title = title;
    maskView.alertView.subTitle = content;
    maskView.alertView.commitStr = commitStr;
    maskView.alertView.cancelStr = cancelStr;
    maskView.alertView.delegate = maskView;
    maskView.block = block;
    
    return maskView;
}

+ (void)showTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(MKIntegerBlock)block{
    GuideMaskView *maskView = [[GuideMaskView alloc] initWithTitle:title content:content cancel:cancelStr commit:commitStr block:block];
    [maskView show];
}

- (void)show{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevel_custom;
    [self.window addSubview:self];
    self.window.hidden = NO;
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    [self dismiss];
}

- (UIView *)alertView{
    if (!_alertView) {
        GuideMaskAlertView *view = [[GuideMaskAlertView alloc] init];
        [view setCornerValue:3.0f];
        view.backgroundColor = [UIColor XSJColor_newWhite];
        _alertView = view;
        [self addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset((SCREEN_WIDTH / 8));
            make.right.equalTo(self).offset(-(SCREEN_WIDTH / 8));
            make.top.equalTo(_alertView.titleLab).offset(-20);
        }];
    }
    return _alertView;
}


- (void)guideMaskAlertView:(GuideMaskAlertView *)alertView actionIndex:(NSInteger)actionIndex{
    [self dismiss];
    MKBlockExec(self.block, actionIndex);
}

@end

@interface GuideMaskAlertView ()

@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation GuideMaskAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:ges];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor XSJColor_tGrayDeepTinge];
    self.titleLab.font = [UIFont systemFontOfSize:20.0f];
    self.titleLab.numberOfLines = 0;
    
    self.subTitleLab = [[UILabel alloc] init];
    self.subTitleLab.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    self.subTitleLab.font = [UIFont systemFontOfSize:16.0f];
    self.subTitleLab.numberOfLines = 0;
    
    [self addSubview:self.titleLab];
    [self addSubview:self.subTitleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self.subTitleLab.mas_top).offset(-12);
    }];
    
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-68);
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [self createBtn];
        _commitBtn.tag = 1;
        [self addSubview:_commitBtn];
        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self).offset(-8);
            make.width.greaterThanOrEqualTo(@75);
            make.height.equalTo(@36);
        }];
    }
    return _commitBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [self createBtn];
        _cancelBtn.tag = 0;
        [self addSubview:_cancelBtn];
        if (_commitBtn) {
            [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_commitBtn.mas_left).offset(-10);
                make.bottom.equalTo(self).offset(-8);
                make.width.greaterThanOrEqualTo(@75);
                make.height.equalTo(@36);
            }];
        }else{
            [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-12);
                make.bottom.equalTo(self).offset(-8);
                make.width.greaterThanOrEqualTo(@75);
                make.height.equalTo(@36);
            }];
        }
    }
    return _cancelBtn;
}

- (UIButton *)createBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:[UIColor XSJColor_base] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor XSJColor_base] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(guideMaskAlertView:actionIndex:)]) {
        [self.delegate guideMaskAlertView:self actionIndex:sender.tag];
    }
}

#pragma mark - 数据加载
- (void)setTitle:(NSString *)title{
    if (!title) {
        return;
    }
    _title = title;
    self.titleLab.text = title;
}

- (void)setSubTitle:(NSString *)subTitle{
    if (!subTitle) {
        return;
    }
    _subTitle = subTitle;
    if (subTitle.length > 30) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:subTitle];
        [attribute addAttribute:NSForegroundColorAttributeName value:MKCOLOR_RGB(255, 97, 142) range:NSMakeRange(25, 5)];
        self.subTitleLab.attributedText = attribute;
    }else{
        self.subTitleLab.text = subTitle;
    }
   

    
    
}

- (void)setCancelStr:(NSString *)cancelStr{
    if (!cancelStr) {
        return;
    }
    _cancelStr = cancelStr;
    [self.cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
}

- (void)setCommitStr:(NSString *)commitStr{
    if (!commitStr) {
        return;
    }
    _commitStr = commitStr;
    [self.commitBtn setTitle:commitStr forState:UIControlStateNormal];
}

@end
