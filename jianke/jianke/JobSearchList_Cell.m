//
//  JobSearchList_Cell.m
//  jianke
//
//  Created by 徐智 on 2017/5/18.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "JobSearchList_Cell.h"

@interface JobSearchList_Cell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;


@end

@implementation JobSearchList_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setStr:(NSString *)str{
    _str = str;
    self.labTitle.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
