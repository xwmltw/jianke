//
//  SeizeJobCell.h
//  jianke
//
//  Created by xiaomk on 15/9/10.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagView.h"
#import "JobModel.h"

@protocol SeizeJobDelegate <NSObject>

- (void)cell_didSelectRowAtIndex:(JobModel*)model;
- (void)cell_btnApplyOnclick:(JobModel*)model;
- (void)cell_applyListClick:(JobModel *)model;

@end

@interface SeizeJobCell : UITableViewCell

@property (nonatomic, weak) id <SeizeJobDelegate> delegate;

+ (instancetype)new;

- (void)refreshWithData:(id)data;

@end
