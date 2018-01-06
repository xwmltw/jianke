//
//  VariousAlertView.m
//  jianke
//
//  Created by yanqb on 2017/6/2.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "VariousAlertView.h"
#import "WDConst.h"

@interface VariousAlertView ()<XWMAlertViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, weak) XWMAlertView *alertView;
@property (nonatomic, copy) MKIntegerBlock block;

@end

@implementation VariousAlertView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGes];
        self.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel commit:(NSString *)commit imageView:(NSString *)image block:(MKIntegerBlock)block{
    
    VariousAlertView *view = [[VariousAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.alertView.image = [UIImage imageNamed:image];
    view.alertView.title = title;
    view.alertView.subTitle = content;
    view.alertView.cancelStr = cancel;
    view.alertView.commitStr = commit;
    view.block = block;
    
    return view;
}

+ (void)showTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel commit:(NSString *)commit imageView:(NSString *)image block:(MKIntegerBlock)block{

    VariousAlertView *view = [[VariousAlertView alloc]initWithTitle:title content:content cancel:cancel commit:commit imageView:image block:block];
    
    [view show];

}

- (void)show{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevel_custom;
    [self.window addSubview:self];
    self.window.hidden = NO;

}

- (UIView *)alertView{
    if (!_alertView) {
        XWMAlertView *view = [[XWMAlertView alloc]init];
        view.delegate = self;
        [view setCornerValue:3.0f];
//        view.backgroundColor = [UIColor XSJColor_newWhite];
        _alertView = view;
        [self addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(SCREEN_WIDTH/8);
                make.right.equalTo(self).offset(-(SCREEN_WIDTH/8));
                make.top.equalTo(_alertView.imageView).offset(-12);
            }];

    }
    return _alertView;
}

- (void)tapAction:(UITapGestureRecognizer *)tapges{
    [self dismiss];

}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

-(void)xwmAlertView:(XWMAlertView *)alertView actionIndex:(NSInteger)actionIndex{
    
    [self dismiss];
    if (actionIndex != 3) {
        MKBlockExec(self.block,actionIndex);
    }
    

}
@end

@interface XWMAlertView ()

@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation XWMAlertView

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
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor XSJColor_newWhite];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.right.and.left.equalTo(self);
        make.bottom.equalTo(self);
    }];

   
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = MKCOLOR_RGB(34, 58, 80);
    self.titleLab.font = [UIFont systemFontOfSize:18.0f];
    self.titleLab.numberOfLines = 0;
    [self.titleLab setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLab];
    
    if (self.subTitleLab) {
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self.subTitleLab.mas_top).offset(-12);
        }];
    }else{
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self.cancelBtn.mas_top).offset(-12);
        }];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    
}

- (UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [self creatLab];
        [self addSubview:_subTitleLab];
        [_subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_titleLab.mas_bottom).offset(12);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self.cancelBtn.mas_top).offset(-12);
        }];
    }

    return _subTitleLab;
}

- (UILabel *)creatLab{
    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.textColor = [UIColor XSJColor_tGrayDeepTransparent32];
    subTitleLab.font = [UIFont systemFontOfSize:16.0f];
    subTitleLab.numberOfLines = 0;
    [subTitleLab setTextAlignment:NSTextAlignmentCenter];
    
    return subTitleLab;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [self creatImage];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self.titleLab.mas_top).offset(-12);
        }];
    }
    

    return _imageView;
}

- (UIImageView *)creatImage{
    UIImageView *imageview = [[UIImageView alloc]init];
    
    return imageview;
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
                make.centerX.equalTo(self);
//                make.right.equalTo(self).offset(-12);
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
    [button setCornerValue:16.0f];
    [button setBackgroundColor:MKCOLOR_RGB(0, 199, 225)];
    [button setTitleColor:[UIColor XSJColor_newWhite] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor XSJColor_newWhite] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)creatXBtn{

    UIButton *xBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xBtn setImage:[UIImage imageNamed:@"x_bg_icon"] forState:UIControlStateNormal];
    [xBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    xBtn.tag = 3;
    [self addSubview:xBtn];
    [xBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-12);
        make.width.and.height.equalTo(@20);
    }];
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(xwmAlertView:actionIndex:)]) {
        [self.delegate xwmAlertView:self actionIndex:sender.tag];
    }
}



#pragma  mark - 数据加载
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
    self.subTitleLab.text = subTitle;
}
- (void)setImage:(UIImage *)image{
    if (!image) {
        return;
    }
    _image = image;
    self.imageView.image = image;
    [self creatXBtn];
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
