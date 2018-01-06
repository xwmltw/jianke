//
//  MyNewInfoLookMeCell.h
//  jianke
//
//  Created by yanqb on 2017/7/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookMeModel.h"

@interface MyNewInfoLookMeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labCompay;
@property (weak, nonatomic) IBOutlet UILabel *labType;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutRight;
@property (nonatomic, strong) LookMeModel *model;
@end
