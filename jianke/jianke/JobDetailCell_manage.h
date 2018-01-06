//
//  JobDetailCell_manage.h
//  jianke
//
//  Created by xiaomk on 16/3/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_manage : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labDealTime;
@property (weak, nonatomic) IBOutlet UILabel *labLastLookTime;
@property (weak, nonatomic) IBOutlet UILabel *labPayWay;
@property (weak, nonatomic) IBOutlet UILabel *labPayTime;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
