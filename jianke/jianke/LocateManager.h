//
//  LocateManager.h
//  jianke
//
//  Created by fire on 15/9/12.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocateManager : NSObject

+ (instancetype)sharedInstance;

- (void)locateWithBlock:(MKBlock)block;
- (void)locateIsShowLoading:(BOOL)isShowLonging block:(MKBlock)block;

@end
