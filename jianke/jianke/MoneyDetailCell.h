//
//  MoneyDetailCell.h
//  jianke
//
//  Created by 时现 on 15/11/18.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayDetailModel;

@interface MoneyDetailCell : UITableViewCell

@property (nonatomic, strong) PayDetailModel *model;

+ (instancetype)new;
- (void)refreshWithData:(id)data;

@end
