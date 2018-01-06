//
//  JobDetailCell_contact.h
//  jianke
//
//  Created by xiaomk on 16/3/15.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailCell_contact : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewColorBg;
@property (weak, nonatomic) IBOutlet UILabel *labPerson;

@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnIMMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnCallPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imgEpAuth;
@property (weak, nonatomic) IBOutlet UILabel *labEpName;
@property (weak, nonatomic) IBOutlet UIImageView *imgNext;
@property (weak, nonatomic) IBOutlet UIButton *btnShowEpInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutEpNameLeft;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
