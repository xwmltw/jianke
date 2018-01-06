//
//  CitySelectCell.m
//  jianke
//
//  Created by fire on 15/9/14.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import "CitySelectCell.h"

@implementation CitySelectCell

+ (instancetype)cityCell
{
    CitySelectCell *cityCell = [[NSBundle mainBundle] loadNibNamed:@"CitySelectCell" owner:nil options:nil].firstObject;
     
    return cityCell;
}



- (void)awakeFromNib {
    // Initialization code
}





@end
