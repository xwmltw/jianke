//
//  JKApplyJobsCell.m
//  jianke
//
//  Created by xiaomk on 16/6/12.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKApplyJobsCell.h"

@implementation JKApplyJobsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"JKApplyJobsCell";
    JKApplyJobsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        UINib *_nib = [UINib nibWithNibName:@"JKApplyJobsCell" bundle:nil];
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
