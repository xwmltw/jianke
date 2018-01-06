//
//  JobDetailCell_bus.h
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_bus : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnBus;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
