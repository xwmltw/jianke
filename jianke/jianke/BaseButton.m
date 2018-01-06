//
//  BaseButton.m
//  jianke
//
//  Created by xuzhi on 16/8/4.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "BaseButton.h"
#import "UIView+MKExtension.h"

@interface BaseButton (){
    CGFloat _marginTitle;
    CGFloat _marginImg;
}

@end

@implementation BaseButton

- (void)setMarginForImg:(CGFloat)marginImg marginForTitle:(CGFloat)marginTitle{
    _marginImg = marginImg;
    _marginTitle = marginTitle;
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_marginTitle || _marginImg) {
        CGFloat width = self.width;
        if (_marginImg >= 0) {
            self.imageView.x = _marginImg;
        }else{
            self.imageView.x = width - self.imageView.width + _marginImg;
        }
        
        if (_marginTitle >= 0) {
            self.titleLabel.x = _marginTitle;
        }else{
            self.titleLabel.x = width - self.titleLabel.width + _marginTitle;
        }
    }
}

@end
