//
//  xwmAlertViewController.h
//  jianke
//
//  Created by yanqb on 2017/6/13.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xwmAlertViewController : UIViewController

//@property (nonatomic, copy) MKBlock blcok;

- (void)showTitle:(NSString *)title content:(NSString *)content cancel:(NSString *)cancel okBtn:(NSString *)okBtn cancelBlock:(MKBlock)cancelBlock okBlock:(MKBlock)okBlock controller:(MKBlock)block;

@end
