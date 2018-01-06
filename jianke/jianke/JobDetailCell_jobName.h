//
//  JobDetailCell_jobName.h
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_jobName : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSeize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSeize;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutDing;
@property (weak, nonatomic) IBOutlet UILabel *labJobTitle;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutImgSeizeRightEdge;

@property (weak, nonatomic) IBOutlet UILabel *labSeeTime;
@property (weak, nonatomic) IBOutlet UILabel *payUnit;
@property (weak, nonatomic) IBOutlet UIImageView *imgYouzhi;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaozhang;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutImgBaozhangLeft;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageHot;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
