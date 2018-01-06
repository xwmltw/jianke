//
//  SYAlertView.h
//  jianke
//
//  Created by fire on 16/1/21.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectBlock)(NSUInteger selectIndex);

@interface SYAlertView : UIView

+ (void)showAlertViewWithTitleArray:(NSArray *)aTitleArray selectBlock:(SelectBlock)block;



@end
