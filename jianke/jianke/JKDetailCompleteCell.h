//
//  JKDetailCompleteCell.h
//  jianke
//
//  Created by fire on 16/2/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKModel, SocialActivistCompleteModel;

@interface JKDetailCompleteCell : UITableViewCell

@property (nonatomic, strong) JKModel *model;

@property (nonatomic, strong) SocialActivistCompleteModel *completeModel;

@end
