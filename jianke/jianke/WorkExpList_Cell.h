//
//  WorkExpList_Cell.h
//  jianke
//
//  Created by yanqb on 2017/5/25.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class WorkExpList_Cell, ResumeExperienceModel;

@protocol WorkExpList_CellDelegate <NSObject>

- (void)WorkExpList_Cell:(WorkExpList_Cell *)cell actionType:(BtnOnClickActionType)actionType model:(ResumeExperienceModel *)model;

@end

@interface WorkExpList_Cell : UITableViewCell

@property (nonatomic, weak) id<WorkExpList_CellDelegate> delegate;
@property (nonatomic, strong) ResumeExperienceModel *model;

@end
