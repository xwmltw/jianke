//
//  JKDetailCompleteTableHeaderView.m
//  jianke
//
//  Created by fire on 16/2/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKDetailCompleteTableHeaderView.h"

@implementation SocialActivistCompleteModel
@end


@interface JKDetailCompleteTableHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *jkCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;

@end



@implementation JKDetailCompleteTableHeaderView

+ (instancetype)headerView
{
    JKDetailCompleteTableHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
    
    headerView.bounds = CGRectMake(0, 0, 0, 92);
    
    return headerView;
}

- (void)setModel:(SocialActivistCompleteModel *)model
{
    _model = model;
    
    // 合计金额
    NSMutableAttributedString *totalMoneyStr = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"￥%.2f", model.allSocialActivistReward.integerValue / 100.0] stringByReplacingOccurrencesOfString:@".00" withString:@""]];
    [totalMoneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [totalMoneyStr addAttribute:NSForegroundColorAttributeName value:MKCOLOR_RGB(89, 89, 89) range:NSMakeRange(0, 1)];
    [totalMoneyStr addAttribute:NSBaselineOffsetAttributeName value:@4 range:NSMakeRange(0, 1)];
    self.totalMoneyLabel.attributedText = totalMoneyStr;
    
    
    NSMutableAttributedString *countStr;
    NSMutableAttributedString *moneyUnitStr;
    NSRange range;
    if (model.socialActivistReward_unit.integerValue == 1) { // 元/人
        
        // 人数
        countStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人", model.allCompleteNum]];
        
        // 单位
        moneyUnitStr = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"￥%.2f/人", model.socialActivistReward.integerValue / 100.0] stringByReplacingOccurrencesOfString:@".00" withString:@""]];
        range = NSMakeRange(moneyUnitStr.length - 2, 2);
        
        // 人数标题
        self.countTitleLabel.text = @"人数";
        
    } else { // 元/人/天
        
        // 天数
        countStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@天", model.allCompleteDayNum]];
        
        // 单位
        moneyUnitStr = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"￥%.2f/人/天", model.socialActivistReward.integerValue / 100.0] stringByReplacingOccurrencesOfString:@".00" withString:@""]];
        range = NSMakeRange(moneyUnitStr.length - 4, 4);
        
        // 天数标题
        self.countTitleLabel.text = @"完工天数";
        
    }
    
    // 人数 | 天数
    [moneyUnitStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [moneyUnitStr addAttribute:NSForegroundColorAttributeName value:MKCOLOR_RGB(89, 89, 89) range:NSMakeRange(0, 1)];
    [moneyUnitStr addAttribute:NSBaselineOffsetAttributeName value:@4 range:NSMakeRange(0, 1)];
    
    [moneyUnitStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
    [moneyUnitStr addAttribute:NSForegroundColorAttributeName value:MKCOLOR_RGB(89, 89, 89) range:range];
    [moneyUnitStr addAttribute:NSBaselineOffsetAttributeName value:@4 range:range];
    
    self.moneyUnitLabel.attributedText = moneyUnitStr;
    
    
    // 单位
    [countStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(countStr.length - 1, 1)];
    [countStr addAttribute:NSForegroundColorAttributeName value:MKCOLOR_RGB(89, 89, 89) range:NSMakeRange(countStr.length - 1, 1)];
    [countStr addAttribute:NSBaselineOffsetAttributeName value:@4 range:NSMakeRange(countStr.length - 1, 1)];
    self.jkCountLabel.attributedText = countStr;
    
}



@end
