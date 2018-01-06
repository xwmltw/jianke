//
//  ConditionSheet.h
//  jianke
//
//  Created by fire on 15/11/19.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionSheetItem.h"
#import "ConditionSheetCell.h"


typedef void(^SelctedBlock)(NSInteger index, id arg);

@interface ConditionSheet : UIView

- (instancetype)initWithItems:(NSArray *)items complentBlock:(SelctedBlock)block;

- (void)showWithItems:(NSArray *)items complentBlock:(SelctedBlock)block;

- (void)show;


@end
