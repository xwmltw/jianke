//
//  MyInfoCell_1.h
//  jianke
//
//  Created by xiaomk on 16/6/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoCell_1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labMoney;

@property (weak, nonatomic) IBOutlet UILabel *labAdvanceMoney;
@property (weak, nonatomic) IBOutlet UILabel *labRedPoint;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
