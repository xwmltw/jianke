//
//  MutiSelectSheetItem.h
//  jianke
//
//  Created by fire on 15/12/25.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MutiSelectSheetItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) id arg;

- (instancetype)initWithTitle:(NSString *)title selected:(BOOL)isSelected enable:(BOOL)isEnable arg:(id)arg;

@end
