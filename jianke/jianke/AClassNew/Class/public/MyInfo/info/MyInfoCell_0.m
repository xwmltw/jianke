//
//  MyInfoCell_0.m
//  jianke
//
//  Created by xiaomk on 16/6/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MyInfoCell_0.h"

@implementation MyInfoCell_0

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MyInfoCell_0";
    MyInfoCell_0 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        UINib *_nib = [UINib nibWithNibName:@"MyInfoCell_0" bundle:nil];
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
