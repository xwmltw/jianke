//
//  ClipLineView.m
//  jianke
//
//  Created by yanqb on 2016/11/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ClipLineView.h"
#import "WDConst.h"

@implementation ClipLineView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLines];
    }
    return self;
}

- (void)setupLines{
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor XSJColor_clipLineGray];
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor XSJColor_clipLineGray];
    
    [self addSubview:topLine];
    [self addSubview:bottomLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0.7);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@0.7);
    }];
}

@end
