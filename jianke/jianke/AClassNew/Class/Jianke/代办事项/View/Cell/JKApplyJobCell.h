//
//  JKApplyJobCell.h
//  ShiJianKe
//
//  Created by admin on 15/8/19.
//  Copyright (c) 2015年 lbwan. All rights reserved.
//  我的工作单元格cell

#import <UIKit/UIKit.h>
#import "JKApplyJobFrame.h"

@interface JKApplyJobCell : UITableViewCell

@property (nonatomic, strong) JKApplyJobFrame *applyJobF; /*!< 我的工作模型 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
