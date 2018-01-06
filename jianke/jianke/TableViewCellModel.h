//
//  TableViewCellModel.h
//  jianke
//
//  Created by fire on 15/9/18.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewCellModel : NSObject

@property (nonatomic, strong) NSString *title; /*!< 标题 */
@property (nonatomic, assign, getter=isSelected) BOOL selected; /*!< 是否选中 */
@property (nonatomic, assign) NSUInteger index; /** 序号 */

@end
