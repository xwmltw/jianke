//
//  SortWorkExpModel.h
//  jianke
//
//  Created by fire on 15/10/5.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKWorkExpericeModel;
@interface SortWorkExpModel : NSObject

@property (nonatomic, strong) JKWorkExpericeModel *model;
@property (nonatomic, copy) NSString *yearStr;
@property (nonatomic, copy) NSString *monthStr;
@property (nonatomic, copy) NSString *yearAndMonthStr;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL isFirstBegin;


@end
