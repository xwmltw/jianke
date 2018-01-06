//
//  JKDetailCompleteCell.m
//  jianke
//
//  Created by fire on 16/2/22.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "JKDetailCompleteCell.h"
#import "JKModel.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
#import "WDConst.h"
#import "JKDetailCompleteTableHeaderView.h"


@interface JKDetailCompleteCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@end


@implementation JKDetailCompleteCell



- (void)setModel:(JKModel *)model
{
    _model = model;
    
    // 头像
    self.headerImgView.layer.cornerRadius = 2;
    self.headerImgView.clipsToBounds = YES;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:model.user_profile_url] placeholderImage:[UIImage imageNamed:@"main_icon_avatar"]];
    
    // 用户名
    self.nameLabel.text = model.true_name;
    
    // 钱钱
    NSInteger money = self.completeModel.socialActivistReward.integerValue;
    if (self.completeModel.socialActivistReward_unit.integerValue == 2) {
        money = self.completeModel.socialActivistReward.integerValue * model.social_activist_complete_day_count.integerValue;
        self.daysLabel.hidden = NO;
        self.daysLabel.text = [NSString stringWithFormat:@" %@ 天  ", model.social_activist_complete_day_count];
        
    } else {
        self.daysLabel.hidden = YES;
    }
    
    
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"￥%.2f", money / 100.0] stringByReplacingOccurrencesOfString:@".00" withString:@""]];
    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    self.moneyLabel.attributedText = moneyStr;
    
    // 日期
    self.dateLabel.font = [UIFont fontWithName:kFont_RSR size:15];
    if (model.stu_work_time_type.integerValue == 2) { // 默认
        
        NSString *startDate = [DateHelper getDateWithNumber:model.stu_work_time.firstObject];
        NSString *endDate = [DateHelper getDateWithNumber:model.stu_work_time.lastObject];
        self.dateLabel.text = [NSString stringWithFormat:@"%@ 至 %@", startDate, endDate];
        
    } else { // 兼客选择
        self.dateLabel.text = [DateHelper dateRangeStrWithMicroSecondNumArray:model.stu_work_time];
    }
    
    CGFloat height = [self.dateLabel contentSizeWithWidth:SCREEN_WIDTH - 80].height +32 +24;
    model.cellHeight = height > 72 ? height : 72 ;
    
}

@end
