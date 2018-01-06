//
//  EditResumeCell_Info.h
//  jianke
//
//  Created by yanqb on 2017/5/24.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEnum.h"

@class JKModel, ResumeExperienceModel;
@interface EditResumeCell_Info : UITableViewCell

@property (nonatomic, assign) EditResumeCellType cellType;
@property (nonatomic, strong) JKModel *jkModel;

@property (nonatomic, assign) postWorkExpCellType postCellType;
@property (nonatomic, strong) ResumeExperienceModel *model;

@end
