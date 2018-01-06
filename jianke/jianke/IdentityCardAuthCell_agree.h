//
//  IdentityCardAuthCell_agree.h
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewCell.h"

@interface IdentityCardAuthCell_agree : MKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIButton *btnAgreeText;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
