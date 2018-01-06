//
//  WdTextFieldDelegate.m
//  ShiJianKe
//
//  Created by hlw on 15/4/1.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//

#import "WdTextFieldDelegate.h"
#import "WDConst.h"

@interface WdTextFieldDelegate()
{
    float _originBorderWidth;
    UIColor* _originColor;
}

@end

@implementation WdTextFieldDelegate

#pragma mark - delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    CGFloat keyboardHeight = 216.0f;
    UIViewController *vc = [UIHelper getCurrentRootViewController];
    
    if (vc.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
        CGFloat y = textField.frame.origin.y - (vc.view.frame.size.height - keyboardHeight - textField.frame.size.height - 5);
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        vc.view.frame = CGRectMake(vc.view.frame.origin.x, -y, vc.view.frame.size.width, vc.view.frame.size.height);
        [UIView commitAnimations];
        ELog(@"========textFieldDidBeginEditing");
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField; {
    [textField resignFirstResponder];
    return YES;
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIViewController *vc = [UIHelper getCurrentRootViewController];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    vc.view.frame = CGRectMake(vc.view.frame.origin.x, 0, vc.view.frame.size.width, vc.view.frame.size.height);
    [UIView commitAnimations];
    
    ELog(@"==========textFieldDidEndEditing");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {              // called when 'return' key pressed. return NO to ignore.
    [textField resignFirstResponder];
    return YES;
}
     
- (void) animateTextField:(UITextField *)textField up: (BOOL) up{

    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    [UIHelper getTopView].frame = CGRectOffset([UIHelper getTopView].frame, 0, movement);
    [UIView commitAnimations];
}


@end






