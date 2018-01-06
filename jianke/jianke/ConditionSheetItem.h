//
//  ConditionSheetItem.h
//  jianke
//
//  Created by fire on 15/11/19.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConditionSheetItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) id arg;

- (instancetype)initWithTitle:(NSString *)title selected:(BOOL)isSelected enable:(BOOL)isEnable arg:(id)arg;

@end
