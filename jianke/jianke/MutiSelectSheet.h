//
//  MutiSelectSheet.h
//  jianke
//
//  Created by fire on 15/12/25.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MutiSelectSheetItem.h"
#import "MutiSelectSheetCell.h"

@interface MutiSelectSheet : UIView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items selctedBlock:(MKBlock)block;
- (void)show;

@end
