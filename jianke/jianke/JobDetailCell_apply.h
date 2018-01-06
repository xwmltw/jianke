//
//  JobDetailCell_apply.h
//  jianke
//
//  Created by xiaomk on 16/3/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_apply : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnApply;
//@property (weak, nonatomic) IBOutlet UIButton *btnComplainSuccess;
//@property (weak, nonatomic) IBOutlet UIButton *btnComplain;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
