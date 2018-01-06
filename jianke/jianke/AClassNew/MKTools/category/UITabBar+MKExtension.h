//
//  UITabBar+MKExtension.h
//  jianke
//
//  Created by xiaomk on 16/6/24.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITabBar(MKExtension)

- (void)showSmallBadgeOnItemIndex:(int)index;    //显示小红点
- (void)hideSmallBadgeOnItemIndex:(int)index;    //隐藏小红点
- (void)clearAllSmallBadge;
@end
