//
//  MoneyBagPasswordManager.h
//  jianke
//
//  Created by xiaomk on 16/4/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyBagPasswordManager : NSObject

+ (instancetype)sharedInstance;

/** 设置钱袋子密码 */
- (void)setPasswordSuccess:(MKBlock)blockSetPwd;

- (void)setPasswordSuccess:(BOOL)isShowLoding block:(MKBlock)blockSetPwd;

/** 提交钱袋子密码 */
- (void)showCommitPassword:(MKBlock)blockCommitPwd;
@end
