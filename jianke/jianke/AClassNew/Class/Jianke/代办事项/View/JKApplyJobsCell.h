//
//  JKApplyJobsCell.h
//  jianke
//
//  Created by xiaomk on 16/6/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKApplyJobsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon1;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon3;
@property (weak, nonatomic) IBOutlet UILabel *labTitle1;
@property (weak, nonatomic) IBOutlet UILabel *labTitle2;
@property (weak, nonatomic) IBOutlet UILabel *labTitle3;

@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelApply;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
