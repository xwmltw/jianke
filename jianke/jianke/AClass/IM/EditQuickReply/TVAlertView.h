//
//  TVAlertView.h
//  jianke
//
//  Created by xiaomk on 16/1/5.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDConst.h"


typedef void (^TVAlertViewCompletion)(DLAVAlertView *alertView, NSInteger buttonIndex, NSString* content);

@interface TVAlertView : NSObject

+ (instancetype)sharedInstance;

- (void)showWithTitle:(NSString*)title placeholder:(NSString*)placeholder completion:(TVAlertViewCompletion)completion;
- (void)showWithTitle:(NSString*)title content:(NSString *)content placeholder:(NSString*)placeholder completion:(TVAlertViewCompletion)completion;

- (NSString*)getContentWithTextView;
@end
