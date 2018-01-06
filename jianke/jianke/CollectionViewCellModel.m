//
//  CollectionViewCellModel.m
//  jianke
//
//  Created by fire on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "CollectionViewCellModel.h"
#import "JobClassifierModel.h"

@implementation CollectionViewCellModel
MJCodingImplementation

/** 通过区域数组初始化 */
+ (NSMutableArray *)cellArrayWithAreaArray:(NSArray *)array
{
    NSMutableArray *cellArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(CityModel *obj, NSUInteger idx, BOOL *stop) {
        
        CollectionViewCellModel *model = [[CollectionViewCellModel alloc] init];
        model.name = obj.name;
        model.model = obj;
        model.selected = NO;
        model.type = CollectionViewCellModelTypeSubOption;
        
        [cellArray addObject:model];
    }];
    
    return cellArray;
}


/** 通过岗位类型数组初始化 */
+ (NSMutableArray *)cellArrayWithJobArray:(NSArray *)array
{
    NSMutableArray *cellArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(JobClassifierModel *obj, NSUInteger idx, BOOL *stop) {
        
        CollectionViewCellModel *model = [[CollectionViewCellModel alloc] init];
        model.name = obj.job_classfier_name;
        model.model = obj;
        model.selected = NO;
        model.type = CollectionViewCellModelTypeSubOption;
        
        [cellArray addObject:model];
    }];
    
    return cellArray;
}

@end
