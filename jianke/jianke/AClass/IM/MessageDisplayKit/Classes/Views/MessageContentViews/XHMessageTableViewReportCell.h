//
//  XHMessageTableViewReportCell.h
//  jianke
//
//  Created by fire on 15/10/29.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "XHBaseTableViewCell.h"

@class WdMessage;

@interface XHMessageTableViewReportCell : XHBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) WdMessage *message;

@end
