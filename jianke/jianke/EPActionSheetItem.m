//
//  EPActionSheetItem.m
//  jianke
//
//  Created by fire on 16/2/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EPActionSheetItem.h"
#import "UIView+MKExtension.h"

@implementation EPActionSheetItem

- (instancetype)initWithImgName:(NSString *)imgName title:(NSString *)title arg:(id)arg{
    if (self = [super init]) {
        self.imgName = imgName;
        self.title = title;
        self.arg = arg;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title arg:(id)arg{
    if (self = [super init]) {
        self.title = title;
        self.arg = arg;
    }
    return self;
}

@end
