//
//  MenuTableViewCell.h
//  jianke
//
//  Created by fire on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellModel.h"

@interface MenuTableViewCell : UITableViewCell
@property (nonatomic, strong) TableViewCellModel *tableViewCellModel; /*!< 数据模型 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
