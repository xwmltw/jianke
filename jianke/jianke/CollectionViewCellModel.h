//
//  CollectionViewCellModel.h
//  jianke
//
//  Created by fire on 15/9/17.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"
#import "MJExtension.h"

typedef NS_ENUM(NSInteger, CollectionViewCellModelType) {
    
    CollectionViewCellModelTypeSubOption = 1, // 子区域
    CollectionViewCellModelTypeParentOption, // 全福州
    CollectionViewCellModelTypeDefault, // 附近
    CollectionViewCellModelTypeNone // 空白按钮
};


@interface CollectionViewCellModel : NSObject

@property (nonatomic, assign) CollectionViewCellModelType type; /*!< 模型类型 */
@property (nonatomic, strong) NSString *name; /** 显示文字 */
@property (nonatomic, assign, getter=isSelected) BOOL selected; /*!< 标记区域是否选中 */

@property (nonatomic, strong) id model; /*!< 区域模型/位置模型 */

/** 通过区域数组初始化 */
+ (NSMutableArray *)cellArrayWithAreaArray:(NSArray *)array;

/** 通过岗位类型数组初始化 */
+ (NSMutableArray *)cellArrayWithJobArray:(NSArray *)array;

@end
