//
//  MyNewInfoLookMeCell.m
//  jianke
//
//  Created by yanqb on 2017/7/19.
//  Copyright © 2017年 xianshijian. All rights reserved.
//

#import "MyNewInfoLookMeCell.h"
#import "WDConst.h"

@implementation MyNewInfoLookMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(LookMeModel *)model{
    
    [self.imageHead sd_setImageWithURL:[NSURL URLWithString:model.profile_url] placeholderImage:[UIHelper getDefaultHeadRect]];

    self.labName.text = model.true_name;
    self.labCompay.text = model.ent_name;
    
    if (model.industry_name.length && model.ent_name.length) {
        self.labType.text = [NSString stringWithFormat:@"|  %@",model.industry_name];
    }else{
        self.labType.text = model.industry_name;
    }
    
    
    if (!model.ent_name.length) {
        self.layoutLeft.constant = 1;
    }
    [self setNeedsLayout];//
    [self layoutIfNeeded];
    
    if (self.labCompay.frame.size.width < 167){
        self.labType.hidden = NO;
    }else{
        self.labType.hidden = YES;
    }
   self.labTime.text =[NSString stringWithFormat:@"%@ 查看",[DateHelper getDateFromTimeNumber:model.view_time withFormat:@"yyyy/MM/dd HH:mm:ss"]] ;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
