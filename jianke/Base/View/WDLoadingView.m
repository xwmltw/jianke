//
//  WDLoadingView.m
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "WDLoadingView.h"
#import "WDConst.h"

@interface WDLoadingView()

@property (nonatomic, strong)UILabel *lab1;

@end

static WDLoadingView *view;


@implementation WDLoadingView

- (void)setLabelText:(NSString *)labelText{
    _labelText = labelText;
    self.lab1.text = labelText;
}

+ (UIView *)initAnimation{
    
    view = [[WDLoadingView alloc] init];
    
    view.backgroundColor = [UIColor clearColor];
    CGSize viewSize = SCREEN_SIZE;
    CGRect viewFrame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    view.frame = viewFrame;
    
    CGRect tmpviewFrame;
    tmpviewFrame.size.height = 80;
    tmpviewFrame.size.width = 80;
    tmpviewFrame.origin.x = viewFrame.size.width/2-tmpviewFrame.size.width/2;
    tmpviewFrame.origin.y = viewFrame.size.height/2 - tmpviewFrame.size.height/2;
    
    UIView *backView = [[UIView alloc]initWithFrame:tmpviewFrame];
    backView.backgroundColor = MKCOLOR_RGBA(0, 0, 0, 0.4);
    
    [backView.layer setMasksToBounds:YES];
    [backView.layer setCornerRadius:tmpviewFrame.size.width/10];
    
    
    CGFloat number = 40;
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake((tmpviewFrame.size.width-number)/2, (tmpviewFrame.size.height-number)/2 - 6, number, number)];
    imgView.image = [UIImage imageNamed:@"loading_1"];
    [backView addSubview:imgView];
    
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 9999;
    
    [imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    
//    CGRect imgvFrame;
//    imgvFrame.size.height = 60;
//    imgvFrame.size.width = 60;
//    imgvFrame.origin.x = tmpviewFrame.size.width/2 - imgvFrame.size.width/2;
//    imgvFrame.origin.y = 14;
//    UIImageView *imgv = [[UIImageView alloc]init];
//    imgv.frame = imgvFrame;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, 80, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:12];
    
    
//    // 1.加载所有的动画图片
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 0; i < 4; i++) {
//        NSString *filename = [NSString stringWithFormat:@"loading_%d.png", i];
//        UIImage *image = [UIImage imageNamed:filename];
//        [images addObject:image];
//    }
//    imgv.animationImages = images;
//    
//    // 2.设置播放次数
//    imgv.animationRepeatCount = 9999;
//    
//    // 3.设置播放时间
//    imgv.animationDuration = 0.6;
//    
//    [imgv startAnimating];
//    
//    [backView addSubview:imgv];
    view.lab1 = lab;
    [backView addSubview:view.lab1];
    [view addSubview:backView];
    return view;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
