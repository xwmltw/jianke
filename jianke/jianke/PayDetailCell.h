//
//  PayDetailCell.h
//  jianke
//
//  Created by xiaomk on 16/7/13.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

@class PayDetailModel;
@protocol PayDetailCellDelegate <NSObject>

- (void)sendMessage:(PayDetailModel *)model;

@end

#import <UIKit/UIKit.h>

@interface PayDetailCell : UITableViewCell

@property(nonatomic,weak)id<PayDetailCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)refreshWithData:(PayDetailModel *)model;

@end
