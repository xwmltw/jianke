//
//  JobApplyConditionCellModel.m
//  jianke
//
//  Created by fire on 15/11/21.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "JobApplyConditionCellModel.h"

@implementation JobApplyConditionCellModel

+ (instancetype)cellModelWithType:(ConditionType)aType title:(NSString *)aTitle state:(ConditionState)aState
{
    JobApplyConditionCellModel *cellModel = [[JobApplyConditionCellModel alloc] init];
    
    cellModel.cellType = aType;
    cellModel.title = aTitle;
    cellModel.state = aState;
    
    return cellModel;
}


@end
