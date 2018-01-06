//
//  EprofileCaseCell.m
//  JKHire
//
//  Created by yanqb on 16/11/8.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "EprofileCaseCell.h"
#import "ResponseInfo.h"

@interface EprofileCaseCell ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labRight;


@end

@implementation EprofileCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ServiceTeamApplyModel *)model{
    self.labTitle.text = model.service_classify_name;
    self.labRight.text = model.experience_count.description;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
