//
//  DateView.m
//  jianke
//
//  Created by fire on 15/11/27.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "DateView.h"
#import "DateSelectView.h"
#import "UIView+MKExtension.h"


@interface DateView ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, weak) DateSelectView *dateSelectView;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, copy) MKBlock hideBlock;

@end


@implementation DateView

- (instancetype)initWithParentView:(UIView *)parentView;
{
    if (self = [super init]) {
        
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:parentView.bounds];
        bgBtn.backgroundColor = [UIColor clearColor];
        [bgBtn addTarget:self action:@selector(hideWithBlock:) forControlEvents:UIControlEventTouchUpInside];
        self.bgBtn = bgBtn;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, -(parentView.width + 20), parentView.width, parentView.width + 20)];
        containerView.backgroundColor = [UIColor whiteColor];
        [bgBtn addSubview:containerView];
        self.containerView = containerView;
        
        DateSelectView *dateSelectView = [[DateSelectView alloc] initWithFrame:CGRectMake(0, 20, parentView.width, parentView.width)];
        dateSelectView.backgroundColor = [UIColor whiteColor];
        self.dateSelectView = dateSelectView;
        [containerView addSubview:dateSelectView];
        
        self.parentView = parentView;
    }
    
    return self;
}


- (void)showDateViewWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate clickBlock:(MKBlock)block hideBlock:(MKBlock)hideBlock
{
    self.dateSelectView.startDate = startDate;
    self.dateSelectView.endDate = endDate;
    self.dateSelectView.didClickBlock = block;
    [self.dateSelectView.datesSelected removeAllObjects];
    self.hideBlock = hideBlock;
    [self.parentView addSubview:self.bgBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.containerView.y = 0;
    }];
}


- (void)hide
{
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
       
        weakSelf.containerView.y = -(self.parentView.width + 20);
        
    } completion:^(BOOL finished) {
    
        [weakSelf.bgBtn removeFromSuperview];
    }];
}


- (void)hideWithBlock:(MKBlock)block
{
    [self hide];
    
    if (self.hideBlock) {
        self.hideBlock(nil);
    }
}


- (BOOL)isShow
{
    if (self.containerView.y == 0) {
        return YES;
    } else{
        return NO;
    }
}

@end
