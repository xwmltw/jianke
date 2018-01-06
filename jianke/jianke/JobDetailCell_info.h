//
//  JobDetailCell_info.h
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_info : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labText;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgPush;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabTextToTop;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
