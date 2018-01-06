//
//  ZBTopView.m
//  jianke
//
//  Created by yanqb on 2016/12/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ZBTopView.h"
#import "UILabel+MKExtension.h"
#import "WDConst.h"

@interface ZBTopView ()

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;

@end

@implementation ZBTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *leftView = [[UIView alloc] init];
    UIView *rightView = [[UIView alloc] init];
    
    _labLeft = [UILabel labelWithText:@"0" textColor:[UIColor XSJColor_base] fontSize:20.0f];
    UILabel *label1 = [UILabel labelWithText:@"/个进行中任务" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:11.0f];
    [_labLeft setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_labLeft setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    _labRight = [UILabel labelWithText:@"0" textColor:[UIColor XSJColor_middelRed] fontSize:20.0f];
    UILabel *label2 = [UILabel labelWithText:@"/任务收入" textColor:[UIColor XSJColor_tGrayDeepTransparent2] fontSize:11.0f];
    [_labRight setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_labRight setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor XSJColor_clipLineGray];
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.tag = BtnOnClickActionType_zhaiTaskApplying;
    [btnLeft addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.tag = BtnOnClickActionType_zhaiTaskSalary;
    [btnRight addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:_labLeft];
    [leftView addSubview:label1];
    
    [rightView addSubview:_labRight];
    [rightView addSubview:label2];
    
    [self addSubview:leftView];
    [self addSubview:rightView];
    [self addSubview:btnLeft];
    [self addSubview:btnRight];
    [self addSubview:line];
    [self addSubview:botLine];
     
    [_labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label1.mas_left);
        make.centerY.equalTo(leftView);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labLeft).offset(3);
        make.right.equalTo(leftView);
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_labLeft);
        make.centerX.equalTo(self).offset(-(SCREEN_WIDTH / 4));
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH / 2));
    }];
    
    [_labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label2.mas_left);
        make.centerY.equalTo(rightView);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labRight).offset(3);
        make.right.equalTo(rightView);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_labRight);
        make.centerX.equalTo(self).offset(SCREEN_WIDTH / 4);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH / 2));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@18);
        make.width.equalTo(@0.7);
    }];
    
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.7);
    }];
    
    [btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self);
        make.width.equalTo(btnRight);
        make.right.equalTo(btnRight.mas_left);
    }];
    
    [btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.height.equalTo(self);
        make.width.equalTo(btnLeft);
    }];
    
}

- (void)setModel:(JKModel *)model{
    self.labLeft.text = model.task_applying_count ? model.task_applying_count.description : @"0";
    self.labRight.text = [NSString stringWithFormat:@"￥%.2f", model.task_salary_sum.floatValue * 0.01];
    self.labRight.text = [self.labRight.text stringByReplacingOccurrencesOfString:@".00" withString:@""];
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(zbTopView:btnAction:)]) {
        [self.delegate zbTopView:self btnAction:sender.tag];
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
