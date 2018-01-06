//
//  LocationBtn.m
//  jianke
//
//  Created by fire on 15/11/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "LocationBtn.h"
#import "UIView+MKExtension.h"

@implementation LocationBtn


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.width += 20;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    bounds.size.width += 20;
    return bounds;
}

@end
