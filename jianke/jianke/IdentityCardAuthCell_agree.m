//
//  IdentityCardAuthCell_agree.m
//  jianke
//
//  Created by xiaomk on 16/4/28.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "IdentityCardAuthCell_agree.h"

@implementation IdentityCardAuthCell_agree

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"IdentityCardAuthCell_agree";
    IdentityCardAuthCell_agree *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        static UINib* _nib;
        if (!_nib) {
            _nib = [UINib nibWithNibName:@"IdentityCardAuthCell_agree" bundle:nil];
        }
        
        if (_nib) {
            cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
