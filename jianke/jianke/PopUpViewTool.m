//
//  PopUpViewTool.m
//  jianke
//
//  Created by yanqb on 2016/11/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "PopUpViewTool.h"
#import "MKBlurView.h"
#import "XSJConst.h"

@interface PopUpViewTool ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, weak) UIView *parentView;

@end

@implementation PopUpViewTool

+ (void)showWithView:(UIView *)view{
    PopUpViewTool *popUpTool = [[PopUpViewTool alloc] init];
    popUpTool.window =  [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    popUpTool.window.windowLevel = UIWindowLevel_custom;
    popUpTool.window.hidden = NO;
    
    UIView *parentView = [[UIView alloc] initWithFrame:popUpTool.window.bounds];
    popUpTool.parentView = parentView;
    MKBlurView *blueView = [[MKBlurView alloc] initWithFrame:popUpTool.window.bounds];
    
    [parentView addSubview:view];
    [parentView addSubview:blueView];
    [parentView sendSubviewToBack:blueView];
    
    [popUpTool.window addSubview:parentView];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    [parentView.layer addAnimation:transition forKey:@"animationKey"];
}

@end
