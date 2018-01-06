//
//  SwitchIdentity_View.m
//  jianke
//
//  Created by xiaomk on 16/2/20.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SwitchIdentity_View.h"
#import "UserData.h"
#import "MKBlurView.h"

@interface SwitchIdentity_View(){
    NSString* _startImgName;
    NSString* _endImgName;
    NSString* _labString;
    UIColor* _labColor;
}

@property (nonatomic, strong) UIImageView* personImg;
@property (nonatomic, strong) UILabel* labText;
@end


@implementation SwitchIdentity_View

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        MKBlurView *blurView = [[MKBlurView alloc] initWithFrame:frame];
        [self addSubview:blurView];
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_panLeftEvent:)];
        [self addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_tapEvent:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)starAnimation{
    if (self.isToEP) {
        _startImgName = @"v260_img_jk_head";
        _endImgName = @"v260_img_ep_head";
        _labString = @"切换至雇主";
        _labColor = MKCOLOR_RGB(132, 187, 68);
    }else{
        _startImgName = @"v260_img_ep_head";
        _endImgName = @"v260_img_jk_head";
        _labString = @"切换至兼客";
        _labColor = MKCOLOR_RGB(56, 205, 252);
    }
    
    self.personImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_startImgName]];
    [self addSubview:self.personImg];
    
    self.labText = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labText.font = [UIFont systemFontOfSize:16];
    self.labText.text = _labString;
    self.labText.textColor = _labColor;
    self.labText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labText];
    
    WEAKSELF
    [self.personImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_top).offset(200);
    }];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.personImg.mas_bottom).offset(10);
    }];
    
    [UserData delayTask:0.4 onTimeEnd:^{
//        CABasicAnimation* rotationAnimation;
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI ];//* 2.0
//        rotationAnimation.duration = 1.0;
//        rotationAnimation.cumulative = YES;
//        rotationAnimation.repeatCount = 1;
//        [weakSelf.personImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//        [UserData delayTask:0.5 onTimeEnd:^{
//            weakSelf.personImg.image = [UIImage imageNamed:_endImgName];
//        }];
        [UIView beginAnimations:@"View Filp" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:weakSelf.personImg cache:NO];
        [UIView commitAnimations];
        weakSelf.personImg.image = [UIImage imageNamed:_endImgName];

        [UserData delayTask:1 onTimeEnd:^{
            [UIView transitionWithView:weakSelf.labText duration:0.5 options:0 animations:^{
                weakSelf.labText.alpha = 0;
                CGRect imgFrame = weakSelf.personImg.frame;
                imgFrame.origin.y += 20;
                weakSelf.personImg.frame = imgFrame;
            } completion:^(BOOL finished) {
                [UserData delayTask:0.3 onTimeEnd:^{
                    if (weakSelf.boolBlock) {
                        weakSelf.boolBlock(YES);
                    }
                }];
            }];
        }];
    }];
}

- (void)gesture_panLeftEvent:(UIPanGestureRecognizer*)recognizer{
    ELog("gesture_panLeftEvent");
}

- (void)gesture_tapEvent:(UITapGestureRecognizer*)recognizer{
    ELog("gesture_tapEvent");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
