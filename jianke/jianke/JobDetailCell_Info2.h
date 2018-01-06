//
//  JobDetailCell_Info2.h
//  jianke
//
//  Created by yanqb on 2017/4/11.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobModel;
@interface JobDetailCell_Info2 : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JobModel *jobModel;

@end
