//
//  ZBHomeCell.m
//  jianke
//
//  Created by yanqb on 2016/12/9.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "ZBHomeCell.h"
#import "WDConst.h"
#import "ZhaiTaskModel.h"
#import "NSString+XZExtension.h"

@interface ZBHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubtitlke;
@property (weak, nonatomic) IBOutlet UILabel *LabMoney;
@property (weak, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UIImageView *imgHot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLabTitleLeftConstraint;


@end

@implementation ZBHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgHead setCornerValue:25.0f];
}

- (void)setModel:(ZhaiTaskModel *)model{
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:model.task_classify_img_url] placeholderImage:[UIHelper getDefaultImage]];
    
    self.labTitle.textColor = (model.isRead)? [UIColor XSJColor_tGrayDeepTransparent2]: [UIColor XSJColor_tGrayDeepTinge];
    self.imgHot.hidden = YES;
    self.layoutLabTitleLeftConstraint.constant = 8;
    if (model.show_hot_icon.integerValue == 1) {
        self.layoutLabTitleLeftConstraint.constant = 32;
        self.imgHot.hidden = NO;
        self.imgHot.image = [UIImage imageNamed:@"jk_home_hot"];
    }else if (model.show_fresh_icon.integerValue == 1){
        self.layoutLabTitleLeftConstraint.constant = 32;
        self.imgHot.hidden = NO;
        self.imgHot.image = [UIImage imageNamed:@"jk_home_new"];
    }
    
    self.labTitle.text = model.task_title.length ? model.task_title : @"";
    self.labSubtitlke.text = [NSString stringWithFormat:@"剩余%@次", model.task_left_can_apply_count];
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f", model.task_salary.floatValue * 0.01];
    moneyStr = [moneyStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.LabMoney.text = [NSString stringWithFormat:@"%@元/次", moneyStr];
    self.imgTag.hidden = (model.task_left_can_apply_count.integerValue > 0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
