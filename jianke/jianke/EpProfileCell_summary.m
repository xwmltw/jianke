//
//  EpProfileCell_summary.m
//  JKHire
//
//  Created by fire on 16/11/7.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EpProfileCell_summary.h"
#import "WDConst.h"
#import "EPModel.h"

@interface EpProfileCell_summary ()

@property (weak, nonatomic) IBOutlet UILabel *labSummary;

@end

@implementation EpProfileCell_summary

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(EPModel *)epModel{
    epModel.cellHeight = 100.0f;
    if (epModel) {
        self.labSummary.text = epModel.desc.length ? epModel.desc : @"" ;
        epModel.cellHeight = [self.labSummary contentSizeWithWidth:SCREEN_WIDTH - 32].height + 56;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
