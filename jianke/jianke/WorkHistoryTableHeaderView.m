//
//  WorkHistoryTableHeaderView.m
//  jianke
//
//  Created by fire on 16/2/23.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "WorkHistoryTableHeaderView.h"


@interface WorkHistoryTableHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;


@end

@implementation WorkHistoryTableHeaderView


+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


- (void)setYear:(NSString *)year
{
    _year = year;
    self.yearLabel.text = [NSString stringWithFormat:@"%@年", year];
}

@end
