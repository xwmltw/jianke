//
//  MKMessageComposeHelper.h
//  jianke
//
//  Created by xiaomk on 16/7/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKMessageComposeHelper : NSObject

+ (instancetype)sharedInstance;

- (void)showWithRecipientArray:(NSArray *)recipientArray body:(NSString *)body onViewController:(UIViewController *)vc block:(MKBlock)block;
- (void)showWithRecipientArray:(NSArray *)recipientArray onViewController:(UIViewController *)vc block:(MKBlock)block;

@end
