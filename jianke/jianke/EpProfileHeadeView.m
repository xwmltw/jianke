//
//  EpProfileHeadeView.m
//  JKHire
//
//  Created by fire on 16/11/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EpProfileHeadeView.h"
#import "WDConst.h"

@interface EpProfileHeadeView ()

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIImageView *imghead;
@property (nonatomic, weak) UIImageView *authIconImg;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, strong) UIButton *indexBtn;
@property (nonatomic, strong) UIButton *jobBtn;
@property (nonatomic, strong) UIButton *Casebtn;
@property (nonatomic, weak) UIView *line;

@end

@implementation EpProfileHeadeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    // topview
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor XSJColor_blackBase];
    _topView = topView;
    
    UIImageView *imghead = [[UIImageView alloc] init];
    imghead.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imghead addGestureRecognizer:tapGes];
    [imghead setCornerValue:35.0f];
    _imghead = imghead;
    
    UILabel *labName = [[UILabel alloc] init];
    labName.font = [UIFont systemFontOfSize:17.0f];
    labName.textColor = [UIColor whiteColor];
    _labName = labName;
    
    UIImageView *authIconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_service_vertify"]];
    _authIconImg = authIconImg;
    
    [self addSubview:topView];
    [self addSubview:imghead];
    [self addSubview:labName];
    [self addSubview:authIconImg];
    
    [topView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@142);
    }];
    [imghead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.width.height.equalTo(@70);
        make.centerY.equalTo(topView);
    }];
    
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imghead.mas_right).offset(24);
        make.centerY.equalTo(topView);
    }];
    
    [authIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labName.mas_right);
        make.centerY.equalTo(topView);
        make.width.height.equalTo(@24);
    }];
}

- (void)setEpModel:(EPModel *)epModel{
    if (epModel) {
        [self setupToolBarWithEpModel:epModel];
        [self.imghead sd_setImageWithURL:[NSURL URLWithString:epModel.profile_url] placeholderImage:[UIHelper getDefaultHead]];
        self.labName.text = epModel.true_name.length ? epModel.true_name : @"";
        
        if (epModel.id_card_verify_status.integerValue == 3) {
            self.authIconImg.hidden = NO;
        }else{
            self.authIconImg.hidden = YES;
        }
        
    }

}

- (void)setupToolBarWithEpModel:(EPModel *)epModel{
    if (!self.toolBar) {
        UIView *view = [[UIView alloc] init];
        _toolBar = view;
        
        self.indexBtn = [self createToolBarBtn:@"主页"];
        self.indexBtn.tag = BtnOnClickActionType_epInfoIndex;
        [view addSubview:self.indexBtn];
        self.jobBtn = [self createToolBarBtn:@"岗位"];
        self.jobBtn.tag = BtnOnClickActionType_epInfoJob;
        [view addSubview:self.jobBtn];
        if (epModel.is_apply_service_team.integerValue == 1) {
            self.Casebtn = [self createToolBarBtn:@"案例"];
            self.Casebtn.tag = BtnOnClickActionType_epInfoCase;
            [view addSubview:self.Casebtn];
            
            UIView *horline2 = [[UIView alloc] init];
            horline2.backgroundColor = [UIColor XSJColor_clipLineGray];
            [view addSubview:horline2];
            [horline2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(self.Casebtn);
                make.width.equalTo(@0.7);
                make.height.equalTo(@14);
            }];
        }
        UIView *horline1 = [[UIView alloc] init];
        horline1.backgroundColor = [UIColor XSJColor_clipLineGray];
        [view addSubview:horline1];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor XSJColor_tGrayDeepTinge];
        _line = line;
        
        [self addSubview:view];
        [view addSubview:horline1];
        [view addSubview:line];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.bottom.right.equalTo(self);
        }];
        
        [self.indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(view);
            make.width.equalTo(self.jobBtn);
            make.right.equalTo(self.jobBtn.mas_left);
        }];
        
        [horline1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(self.indexBtn);
            make.width.equalTo(@0.7);
            make.height.equalTo(@14);
        }];
        
        if (epModel.is_apply_service_team.integerValue == 1) {
            
            [self.jobBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.equalTo(self.indexBtn);
                make.right.equalTo(self.Casebtn.mas_left);
                make.width.height.equalTo(self.indexBtn);
            }];
            
            [self.Casebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.equalTo(self.jobBtn);
                make.right.equalTo(view);
                make.width.height.equalTo(self.jobBtn);
            }];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view);
                make.height.equalTo(@1);
                make.centerX.equalTo(self.indexBtn);
                make.width.equalTo(@90);
            }];
        }else{
            
            [self.jobBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.equalTo(self.indexBtn);
                make.right.equalTo(view);
                make.width.height.equalTo(self.indexBtn);
            }];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view);
                make.height.equalTo(@1);
                make.centerX.equalTo(self.indexBtn);
                make.width.equalTo(@90);
            }];
        }
        
    }
    
    [self.jobBtn setTitle:[NSString stringWithFormat:@"岗位(%@)", epModel.history_publish_success_job_count.description] forState:UIControlStateNormal];
    if (epModel.is_apply_service_team.integerValue == 1) {
        [self.Casebtn setTitle:[NSString stringWithFormat:@"案例(%@)", epModel.service_team_experience_count.description] forState:UIControlStateNormal];
    }
}

- (UIButton *)createToolBarBtn:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor XSJColor_tGrayHistoyTransparent] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor XSJColor_tGrayDeepTinge] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(toolBarBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)toolBarBtnOnClick:(UIButton *)sender{
    [self setBtnsSelect:sender];
    [self showLineWithButton:sender];
    if ([self.delegate respondsToSelector:@selector(epProfileHeadeView:actionType:)]) {
        [self.delegate epProfileHeadeView:self actionType:sender.tag];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(viewHeadImg:)]) {
        [self.delegate viewHeadImg:self.imghead];
    }
}

- (void)setBtnsSelect:(UIButton *)sender{
    sender.selected = YES;
    NSArray *subViews = self.toolBar.subviews;
    for (UIView *view in subViews) {
        if ([view isMemberOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button setSelected:NO];
            if (view == sender) {
                [button setSelected:YES];
            }
        }
    }
}

- (void)showLineWithButton:(UIButton *)sender{
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolBar);
        make.height.equalTo(@1);
        make.centerX.equalTo(sender);;
        make.width.equalTo(@90);
    }];
}

@end
