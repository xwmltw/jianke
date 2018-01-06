//
//  MoneyBagCell.h
//  jianke
//
//  Created by xiaomk on 15/9/22.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyBagCell : UITableViewCell


@property (nonatomic, assign) BOOL isToWeiXin;//取出到微信

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(id)data;



@end
