//
//  ScrollView_handleOtherTouch.h
//  jianke
//
//  Created by xiaomk on 15/10/16.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HandleOtherTouchDelegate <NSObject>

- (void)onTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface ScrollView_handleOtherTouch : UIScrollView

@property (assign, nonatomic) id<HandleOtherTouchDelegate> touch_delegate;

@end
