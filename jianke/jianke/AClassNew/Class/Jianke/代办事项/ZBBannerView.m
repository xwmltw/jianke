//
//  ZBBannerView.m
//  jianke
//
//  Created by yanqb on 2016/12/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ZBBannerView.h"
#import "UIButton+WebCache.h"
#import "JKHomeModel.h"
#import "Masonry.h"

@interface ZBBannerView ()

@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;

@end

@implementation ZBBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{

    UIButton *button1 = [self createBtn];
    button1.tag = 0;
    UIButton *button2 = [self createBtn];
    button2.tag = 1;
    UIButton *button3 = [self createBtn];
    button3.tag = 2;
    UIButton *button4 = [self createBtn];
    button4.tag = 3;
    
    [self addSubview:button1];
    [self addSubview:button2];
    [self addSubview:button3];
    [self addSubview:button4];

    _button1 = button1;
    _button2 = button2;
    _button3 = button3;
    _button4 = button4;
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.bottom.equalTo(self);
        make.height.equalTo(@162);
        make.width.equalTo(button2);
        make.right.equalTo(button2.mas_left).offset(-4);
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.width.equalTo(button1);
        make.height.equalTo(button3);
        make.top.equalTo(button1);
        make.bottom.equalTo(button3.mas_top).offset(-4);
    }];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(button2);
        make.top.equalTo(button2.mas_bottom).offset(4);
        make.bottom.equalTo(self);
        make.width.equalTo(button4);
        make.right.equalTo(button4.mas_left).offset(-4);
    }];
    
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.height.bottom.equalTo(button3);
    }];
}

- (void)setModelArr:(NSArray *)arr{
    MenuBtnModel *model;
    for (NSInteger index= 0; index < arr.count; index++) {
        model = [arr objectAtIndex:index];
        if (index == 0) {
            [self.button1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateNormal];
            [self.button1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateHighlighted];
        }
        switch (index) {
            case 0:{
                [self.button1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateNormal];
                [self.button1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateHighlighted];
            }
                break;
            case 1:{
                [self.button2 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateNormal];
                [self.button2 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateHighlighted];
            }
                break;
            case 2:{
                [self.button3 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateNormal];
                [self.button3 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateHighlighted];
            }
                break;
            case 3:{
                [self.button4 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateNormal];
                [self.button4 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.special_entry_icon] forState:UIControlStateHighlighted];
            }
                break;
            default:
                break;
        }
    }
}

- (UIButton *)createBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button sd_setImageWithURL:[NSURL URLWithString:model.special_entry_url] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(zbBannerView:btnOnClick:)]) {
        [self.delegate zbBannerView:self btnOnClick:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
