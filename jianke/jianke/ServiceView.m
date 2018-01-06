//
//  ServiceView.m
//  jianke
//
//  Created by yanqb on 2016/11/14.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ServiceView.h"
#import "WDConst.h"

@implementation ServiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    UIButton *btnLady = [self addBtnWithImage:@"personal_service_lady" btnType:ServiceBtnType_lady];
    UIButton *btnModal = [self addBtnWithImage:@"personal_service_modal" btnType:ServiceBtnType_modal];
    UIButton *btnActor = [self addBtnWithImage:@"personal_service_actor" btnType:ServiceBtnType_actor];
//    UIButton *btnSaler = [self addBtnWithImage:@"personal_service_saler" btnType:ServiceBtnType_saler];
//    UIButton *btnModal = [self addBtnWithImage:@"personal_service_teacher" btnType:ServiceBtnType_teacher];
    UIButton *btnHost = [self addBtnWithImage:@"personal_service_host" btnType:ServiceBtnType_host];
    
    [self addSubview:btnLady];
//    [self addSubview:btnTeacher];
    [self addSubview:btnActor];
//    [self addSubview:btnSaler];
    [self addSubview:btnModal];
    [self addSubview:btnHost];
    
    [btnLady mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(btnHost.mas_left).offset(-4);
        make.width.equalTo(btnHost);
        make.height.equalTo(@81);
    }];
    
    [btnHost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(btnLady);
        make.right.equalTo(self).offset(-12);
    }];
    
    [btnModal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnLady.mas_bottom).offset(4);
        make.left.height.equalTo(btnLady);
        make.right.equalTo(btnActor.mas_left).offset(-4);
        make.width.equalTo(btnActor);
    }];
    
    [btnActor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(btnModal);
        make.right.equalTo(self).offset(-12);
    }];
    
}

- (UIButton *)addBtnWithImage:(NSString *)imageUrl btnType:(ServiceBtnType)btnType{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateHighlighted];
    button.tag = btnType;
    button.backgroundColor = MKCOLOR_RGB(246, 247, 248);
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)btnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(serviceView:actionType:)]) {
        [self.delegate serviceView:self actionType:sender.tag];
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
