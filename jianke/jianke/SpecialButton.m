//
//  SpecialButton.m
//  jianke
//
//  Created by xuzhi on 16/7/26.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "SpecialButton.h"
#import "UIView+MKExtension.h"

@implementation SpecialButton

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.x = (self.width-self.titleLabel.width)/2;
    self.imageView.x = self.width - self.imageView.width - 15;
}

@end
