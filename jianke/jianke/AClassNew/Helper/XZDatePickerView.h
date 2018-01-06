//
//  XZDatePickerView.h
//  jianke
//
//  Created by 徐智 on 2017/5/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XZDatePickerMode) {
    XZDatePickerMode_Year,
    XZDatePickerMode_YearMouth,
    XZDatePickerMode_YearMouthDay,
};

@interface XZDatePickerView : UIPickerView

@property (nonatomic, assign) XZDatePickerMode datePickerMode;

@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) MKBlock dateBlock;

@end
