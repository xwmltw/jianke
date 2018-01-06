//
//  CitySearchBar.m
//  jianke
//
//  Created by fire on 15/9/12.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//  城市搜索框

#import "CitySearchBar.h"


@implementation CitySearchBar

+ (instancetype)searchBar
{
    CitySearchBar *searchBar = [[CitySearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    // 去除搜索框背景色
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    searchBar.backgroundColor = [UIColor whiteColor];
    
    // placeHold
    searchBar.placeholder = @"请输入城市名或首字母";
    return searchBar;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
