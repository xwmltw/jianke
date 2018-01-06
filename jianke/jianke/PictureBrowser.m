//
//  PictureBrowser.m
//  jianke
//
//  Created by 时现 on 15/12/3.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "PictureBrowser.h"
#import "UIHelper.h"

static CGRect oldframe;

@implementation PictureBrowser


+ (void)showImage:(UIImageView *)imageView{
    if (!imageView || !imageView.image) {
        return;
    }
    
    //图片
    UIImage *image = imageView.image;
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;    
    UIWindow *window = [MKUIHelper getCurrentRootViewController].view.window;
    oldframe = [imageView convertRect:imageView.bounds toView:window];

    //背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:SCREEN_BOUNDS];
    //原来的frame
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    
    UIImageView *imageV =[[UIImageView alloc]initWithFrame:oldframe];
    imageV.image = image;
    imageV.tag = 1;
    [backgroundView addSubview:imageV];
    [window addSubview:backgroundView];
    //隐藏手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat width = image.size.width ? image.size.width : SCREEN_HEIGHT ;
        CGFloat imageH = image.size.height*SCREEN_WIDTH/width;
        imageV.frame = CGRectMake(0, (SCREEN_HEIGHT - imageH)/2, SCREEN_WIDTH, imageH);
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}

+ (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];

}


@end
