//
//  SYDatePicker.h
//  jianke
//
//  Created by fire on 15/11/5.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectdBlock)(NSDate *startTime, NSDate *endTime);

@interface SYDatePicker : UIView

- (void)showDatePickerWithStartTime:(NSDate *)aStartTime endTime:(NSDate *)aEndTime selectedBlock:(SelectdBlock)aBlock;
- (void)showDatePickerWithSelectedBlock:(SelectdBlock)aBlock;

@end
