//
//  ScrollView_handleOtherTouch.m
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "ScrollView_handleOtherTouch.h"

@implementation ScrollView_handleOtherTouch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    if (self.touch_delegate && [self.touch_delegate respondsToSelector:@selector(onTouchesBegan:withEvent:)]) {
        [self.touch_delegate onTouchesBegan:touches withEvent:event];
    }
}

@end
