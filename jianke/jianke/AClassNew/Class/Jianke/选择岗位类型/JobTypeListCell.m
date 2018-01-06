//
//  JobTypeListCell.m
//  jianke
//
//  Created by xiaomk on 16/4/19.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JobTypeListCell.h"
#import "WDConst.h"

@implementation JobTypeListCell

+ (instancetype)new{
    static UINib* _nib;
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JobTypeListCell" bundle:nil];
    }
    JobTypeListCell* cell;
    if (_nib) {
        cell = [[_nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.btn1 setTitleColor:[UIColor XSJColor_tGray] forState:UIControlStateNormal];
        [cell.btn1 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateHighlighted];
        [cell.btn1 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateSelected];
        
        [cell.btn2 setTitleColor:[UIColor XSJColor_tGray] forState:UIControlStateNormal];
        [cell.btn2 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateHighlighted];
        [cell.btn2 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateSelected];
        
        [cell.btn3 setTitleColor:[UIColor XSJColor_tGray] forState:UIControlStateNormal];
        [cell.btn3 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateHighlighted];
        [cell.btn3 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateSelected];
        
        [cell.btn4 setTitleColor:[UIColor XSJColor_tGray] forState:UIControlStateNormal];
        [cell.btn4 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateHighlighted];
        [cell.btn4 setTitleColor:MKCOLOR_RGB(251, 93, 96) forState:UIControlStateSelected];
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
