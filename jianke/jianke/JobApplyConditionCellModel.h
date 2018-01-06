//
//  JobApplyConditionCellModel.h
//  jianke
//
//  Created by fire on 15/11/21.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConditionType) {
    
    ConditionTypeSex = 1,
    ConditionTypeAge,
    ConditionTypeHeight,
    ConditionTypeRelNameVerify,
    ConditionTypeLifePhoto,
    ConditionTypeApplyJobDate,
    ConditionTypeHealthCer,
    ConditionTypeStuIdCard
};

typedef NS_ENUM(NSInteger, ConditionState) {
    
    ConditionStateFit = 1,
    ConditionStateUnFit,
    ConditionStateUnknow
    
};

@interface JobApplyConditionCellModel : NSObject

@property (nonatomic, assign) ConditionType cellType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) ConditionState state;

+ (instancetype)cellModelWithType:(ConditionType)aType title:(NSString *)aTitle state:(ConditionState)aState;

@end
