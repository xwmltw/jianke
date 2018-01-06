//
//  MKAlertView.h
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MKAlertViewBlock)(UIAlertView* alertView, NSInteger buttonIndex);
typedef void(^MKAlertControllerBlock)(UIAlertAction *action, NSInteger buttonIndex);

#pragma mark - ***** MKAlertView ******

@interface MKAlertView : UIAlertView

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
    confirmButtonTitle:(NSString *)confirmButtonTitle
            completion:(MKAlertViewBlock)completion;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
    confirmButtonTitle:(NSString *)confirmButtonTitle
        viewController:(UIViewController *)vc
            completion:(MKAlertControllerBlock)completion;


- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmButtonTitle:(NSString *)confirmButtonTitle
                   completion:(MKAlertViewBlock)completion;
@end
