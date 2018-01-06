//
//  MutiSelectSheetItem.m
//  jianke
//
//  Created by fire on 15/12/25.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "MutiSelectSheetItem.h"

@implementation MutiSelectSheetItem


- (instancetype)initWithTitle:(NSString *)title selected:(BOOL)isSelected enable:(BOOL)isEnable arg:(id)arg
{
    if (self = [super init]) {
        self.title = title;
        self.arg = arg;
        self.selected = isSelected;
        self.enable = isEnable;
    }
    
    return self;
}


@end
