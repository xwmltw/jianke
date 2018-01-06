//
//  JobDetailCell_listApply.h
//  jianke
//
//  Created by xiaomk on 16/3/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_listApply : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labApplyNum;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutpushWidthConstraint;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
