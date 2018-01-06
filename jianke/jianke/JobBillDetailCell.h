//
//  JobBillDetailCell.h
//  jianke
//
//  Created by 时现 on 15/12/15.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobBillDetailCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(id)data;

@end
