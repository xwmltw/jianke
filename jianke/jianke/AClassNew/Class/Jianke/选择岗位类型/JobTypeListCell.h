//
//  JobTypeListCell.h
//  jianke
//
//  Created by xiaomk on 16/4/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKBaseTableViewCell.h"

@interface JobTypeListCell : MKBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

+ (instancetype)new;

@end
