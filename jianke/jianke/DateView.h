//
//  DateView.h
//  jianke
//
//  Created by fire on 15/11/27.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateView : UIView


- (instancetype)initWithParentView:(UIView *)parentView;
- (void)showDateViewWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate clickBlock:(MKBlock)block hideBlock:(MKBlock)hideBlock;
- (void)hide;
- (BOOL)isShow;

@end
