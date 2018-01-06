//
//  JobDetailCell_manage.m
//  jianke
//
//  Created by xiaomk on 16/3/16.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobDetailCell_manage.h"

@implementation JobDetailCell_manage

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"JobDetailCell_manage";
    JobDetailCell_manage *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"JobDetailCell_manage" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
